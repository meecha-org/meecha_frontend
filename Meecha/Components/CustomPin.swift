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
    @AppStorage("distanceSize") var distanceSize: Int = 50
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

    init() {
        self.hostingController = UIHostingController(rootView: SwiftUIPinView())
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
    @Binding var annotations: [MKPointAnnotation] // ピンの状態（SwiftUIと同期
    
    @Binding var selectedAnnotation: MKPointAnnotation?
    @Binding var showDeleteAlert: Bool
    var userLocation: CLLocationCoordinate2D?     // 初期表示に使う座標
    @Binding var isPinModeEnabled: Bool // 設置モード
    @Binding var isDraging: Bool    // ドラッグモード

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
        uiView.addAnnotations(annotations)
        context.coordinator.isPinModeEnabled = isPinModeEnabled
    }
    // ジェスチャー処理・デリゲートのためのCoordinatorを作成
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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
            guard self.isPinModeEnabled else { return } // ← ここ
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            
            // ピンが既に1つある場合は追加しない
                       guard parent.annotations.count == 0 else { return }
            
            // タップされた場所(ビュー内の座標)を取得
            let point = gestureRecognizer.location(in: mapView)
            // 地図上の緯度・経度に変換
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            print("\(coordinate)")
            
            // ピンを作成して追加
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.annotations.append(annotation)
            
            // ピン設置後に設置モードを解除
            parent.isPinModeEnabled = false
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            let identifier = "SwiftUIPin"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
                annotationView?.isDraggable = true      // ピンドラッグ


                // Render SwiftUI view to image
                let hostingView = HostingPinView()
                UIGraphicsBeginImageContextWithOptions(hostingView.bounds.size, false, 0)
                hostingView.drawHierarchy(in: hostingView.bounds, afterScreenUpdates: true)
                let img = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                annotationView?.image = img
                annotationView?.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // ピン設置モード中（ドラッグモード）のときは削除不可
            guard isPinModeEnabled || isDraging else { return }
            if let annotation = view.annotation as? MKPointAnnotation {
                parent.selectedAnnotation = annotation
                parent.showDeleteAlert = true
            }
        }
    }
}

#Preview {
    SwiftUIPinView()
}
