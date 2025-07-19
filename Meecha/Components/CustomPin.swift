//
//  CustomPin.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
//  プライベート範囲のカスタムピン
import SwiftUI
import MapKit
import CoreLocation


struct SwiftUIPinView: View {
    @State var distanceSize: Int
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .opacity(0.75)
                .frame(width: CGFloat(distanceSize), height: CGFloat(distanceSize))
            //角丸ボーダー
                .overlay(
                    Circle()
                        .stroke(Color.main, lineWidth: 1)
                )
            Image(.lockKey)
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

class HostingPinView: UIView {
    private let hostingController: UIHostingController<SwiftUIPinView>
    
    init(distanceSize: Int) {
            self.hostingController = UIHostingController(rootView: SwiftUIPinView(distanceSize: distanceSize))
            super.init(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            self.hostingController.view.frame = self.bounds
            self.hostingController.view.backgroundColor = .clear
            self.addSubview(hostingController.view)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 当たり判定を拡大
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let hitFrame = self.bounds.insetBy(dx: -30, dy: -30)
        return hitFrame.contains(point)
    }
}

// MARK: - 現在地取得用の LocationManager クラス
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    // 現在地を保持するPublished変数（SwiftUIに通知される）
    @Published var userLocation: CLLocationCoordinate2D? = nil
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 高精度
        locationManager.requestWhenInUseAuthorization() // ユーザーに使用許可をリクエスト
        locationManager.startUpdatingLocation() // 現在地の取得を開始
    }
    
    // 位置情報が更新されたときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最初の位置情報だけ使う（最新の位置）
        if let coordinate = locations.first?.coordinate {
            userLocation = coordinate
        }
    }
}

// MARK: - SwiftUI → UIKitへのラッパー：MKMapViewを表示
struct TapToAddMapView: UIViewRepresentable {
    @Binding var pins: [Pin]
    @Binding var selectedPin: Pin?
    @Binding var showDeleteAlert: Bool
    var userLocation: CLLocationCoordinate2D?
    @Binding var isPinModeEnabled: Bool
    @Binding var isDraging: Bool
    
    // UIView（MKMapView）を生成
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // タップジェスチャーを追加（マップ上をタップすると呼ばれる）
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        mapView.addGestureRecognizer(tapGesture)
        
        // ユーザーの現在地を中心にマップ表示
        if let location = userLocation {
            let region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView.setRegion(region, animated: false)
        }
        
        return mapView
    }
    
    // SwiftUI側のピン状態が変わったらUIViewを更新
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)

        let annotations = pins.map { CustomAnnotation(pin: $0) }
        uiView.addAnnotations(annotations)
        
        context.coordinator.isPinModeEnabled = isPinModeEnabled
        context.coordinator.isDraging = isDraging
    }
    
    // ジェスチャー処理・デリゲートのためのCoordinatorを作成
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class CustomAnnotation: MKPointAnnotation {
        let id: UUID
        var distanceSize: Int
        
        init(pin: Pin) {
                self.id = pin.id
                self.distanceSize = pin.size
                super.init()
                self.coordinate = pin.coordinate
            }
    }
    
    // MARK: - Coordinatorクラス：ジェスチャーとマップ処理を担当
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: TapToAddMapView
        var isPinModeEnabled: Bool = false
        var isDraging: Bool = false
        
        init(_ parent: TapToAddMapView) {
            self.parent = parent
        }
        
        // タップでピン設置
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard isPinModeEnabled,
                  let mapView = gestureRecognizer.view as? MKMapView else { return }

            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let size = UserDefaults.standard.integer(forKey: "distanceSize")

            let newPin = Pin(coordinate: coordinate, size: size)
            parent.pins.append(newPin)
            parent.isPinModeEnabled = false
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let customAnnotation = annotation as? CustomAnnotation else { return nil }

            let identifier = "SwiftUIPin"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.isDraggable = true      // ピンドラッグ
            } else {
                annotationView?.annotation = annotation
            }
            
            // 個別の距離サイズを使用
                let hostingView = HostingPinView(distanceSize: customAnnotation.distanceSize)
                UIGraphicsBeginImageContextWithOptions(hostingView.bounds.size, false, 0)
                hostingView.drawHierarchy(in: hostingView.bounds, afterScreenUpdates: true)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                annotationView?.image = img
                annotationView?.frame = CGRect(x: 0, y: 0, width: 500, height: 500)

            
            return annotationView
        }
        
        // ピン選択時の処理（削除のために）
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            print("ピンが選択されました")
            print("設置モード: \(isPinModeEnabled), ドラッグモード: \(isDraging)")
            
            guard !isPinModeEnabled && !isDraging else { return }

               if let annotation = view.annotation as? CustomAnnotation {
                   if let foundPin = parent.pins.first(where: { $0.id == annotation.id }) {
                       parent.selectedPin = foundPin
                       parent.showDeleteAlert = true
                   }
               }
        }
        
        // ピンドラッグ開始時
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            switch newState {
            case .starting:
                print("ドラッグ開始\(parent.isDraging)")
                parent.isDraging = true
            case .ending:
                print("ドラッグ終了\(parent.isDraging)")
            case .canceling:
                print("ドラッグモード終了\(parent.isDraging)")
                parent.isDraging = false
            default:
                break
            }
        }
    }
}

