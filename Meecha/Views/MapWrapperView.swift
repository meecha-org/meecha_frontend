//
//  MapWrapperView.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
import SwiftUI
import MapKit

// MARK: - SwiftUI画面本体
// ピンと現在地の状態を保持して、マップビューに反映
struct MapWrapperView: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [.clear, .bg]), startPoint: .top, endPoint: .center)   // フッター背景
    let headerBg = LinearGradient(gradient: Gradient(colors: [.bg, .clear]), startPoint: .center, endPoint: .bottom)    //ヘッダー背景
    
    @StateObject private var locationManager = LocationManager() // 現在地の取得
    @StateObject private var pins = PrivatePinModel()
    @State private var selectedPin: Pin? = nil
    @State private var showDeleteAlert = false
    @Binding var isDistance: Bool               // プライベート範囲画面
    @State var PlusBtton : Bool = true          // プラスボタン
    @State var isNextBackButton: Bool = false   // ピン追加中のボタン
    @State var isPinModeEnabled: Bool = false   // ピンを立てるモード
    @State var isDraging : Bool = false         // ピンドラッグモード
    @State var isDialog: Bool = false           // 範囲選択ダイアログ
    
    
    func PostIgnores() {
        var addDatas: [NotifyIgnorePoint] = []
        
        // ピンの情報を表示
        for pin in pins.pins {
            print("ピンID: \(pin.id)")
            print("　座標: 緯度 \(pin.coordinate.latitude), 経度 \(pin.coordinate.longitude)")
            print("size: \(pin.selectSize)")
            addDatas.append(NotifyIgnorePoint(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude, size: pin.selectSize))
        }
        
        // データを送信
        let result = updateNotifyIgnores(ignorePoints: addDatas)
        
        // 成功したか
        if result {
            debugPrint("更新成功")
        } else {
            debugPrint("更新失敗")
        }
    }
    
    var body: some View {
        ZStack {
            // 現在地が取得できたらマップを表示、それまでは読み込み中表示
            if let userLocation = locationManager.userLocation {
                TapToAddMapView(pins: $pins.pins,
                                selectedPin: $selectedPin,
                                showDeleteAlert: $showDeleteAlert,
                                userLocation: locationManager.userLocation,
                                isPinModeEnabled: $isPinModeEnabled,
                                isDraging: $isDraging )
                    .edgesIgnoringSafeArea(.all) // マップを画面全体に表示
            } else {
                ProgressView("現在地を取得中…") // ローディング表示
            }
            VStack{
                Spacer()
                // ピン追加ボタン
                if PlusBtton{
                    HStack{
                        Spacer()
                        // ピン設置モード切り替えボタン
                        Button(action: {
                            isDialog = true     // ダイアログ表示
                            PlusBtton = false   // プラスボタン非表示
                        }) {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 60, height: 60)
                                    // 角丸ボーダー
                                    .overlay(
                                        Circle()
                                            .stroke(Color.main, lineWidth: 1)
                                    )
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                    .foregroundStyle(Color.icon)
                            }
                        }
                        .padding(.trailing, 30)
                    }
                    .padding(.bottom, 120)
                }
            }   // ピン追加ボタン
            VStack{
                Rectangle()
                    .fill(headerBg)
                    .frame(maxWidth: .infinity, maxHeight: 130)
                Spacer()
                Rectangle()
                    .fill(gradient)
                    .frame(maxWidth: .infinity, maxHeight: 130)
            }
            VStack{
                Spacer()
                if isNextBackButton{
                    // 決定・戻るボタン
                    HStack{
                        // 戻るボタン
                        Button(action: {
                            print("🔙 戻るボタンが押されました")
                            isPinModeEnabled = false
                            isDraging = false
                            PlusBtton = true
                            isNextBackButton = false

                        }) {
                            BackButton()
                        }
                        Spacer()
                        // 決定ボタン
                        Button(action: {
                            print("✅ 決定ボタンが押されました")
                            // ピンの情報を表示
                            for pin in pins.pins {
                                print("ピンID: \(pin.id)")
                                print("　座標: 緯度 \(pin.coordinate.latitude), 経度 \(pin.coordinate.longitude)")
                                print("size: \(pin.selectSize)")
                            }
                            
                            // 情報更新
                            PostIgnores()
                            
                            isPinModeEnabled = false
                            isDraging = false
                            PlusBtton = true
                            isNextBackButton = false
                        }) {
                            NextButton()
                        }
                    }
                    .frame(width: 300)
                    .padding(.bottom, 130)
                }else if PlusBtton{
                    // 戻るボタン
                    Button(action: {
                        // 情報更新
                        PostIgnores()
                        
                        isDistance = false
                    }) {
                        BackButton()
                    }
                    .padding(.bottom, 130)
                }   // else if
            }
            if isDialog{
                PrivateDailog(isDialog: $isDialog, isDraging: $isDraging, isPinModeEnabled: $isPinModeEnabled,isNextBackButton: $isNextBackButton, PlusBtton: $PlusBtton)
            }
        }.task {
            // 除外ポイントの設定を取得
            let (response,success) = getNotifyIgnores()
            
            debugPrint("ignore point response: \(response)")
            
            if success {
                // 全てを削除する
                pins.pins.removeAll()
                
                // 成功した時
                for ignorePoint in response {
                    var distanceSize = 20
                    switch ignorePoint.size {
                    case 50:      distanceSize = 20
                    case 200:     distanceSize = 50
                    case 500:     distanceSize = 100
                    case 1000:    distanceSize = 150
                    case 3000:    distanceSize = 250
                    case 5000:    distanceSize = 300
                    default :
                        distanceSize = 20
                    }
                    
                    debugPrint("ignore Pin: \(ignorePoint)")
                    // 除外ポイントを追加する
                    pins.pins.append(Pin(coordinate: CLLocationCoordinate2D(latitude: ignorePoint.latitude, longitude: ignorePoint.longitude), size: distanceSize, selectSize: ignorePoint.size))
                }
            }
        }   // ZStack
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("ピンを削除しますか？"),
                message: Text("このピンを削除してもよろしいですか？"),
                primaryButton: .destructive(Text("削除")) {
                    if let selected = selectedPin {
                        pins.pins.removeAll { $0.id == selected.id }
                        selectedPin = nil
                    }
                },
                secondaryButton: .cancel {
                    selectedPin = nil
                }
            )
        }
    }   // body
}   // View

