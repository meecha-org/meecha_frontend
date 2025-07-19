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
    @State private var annotations: [MKPointAnnotation] = []     // ピンの一覧
    @State private var selectedAnnotation: MKPointAnnotation? = nil
    @State private var showDeleteAlert = false
    @Binding var isDistance: Bool               // プライベート範囲画面
    @State var PlusBtton : Bool = true          // プラスボタン
    @State var isNextBackButton: Bool = false   // ピン追加中のボタン
    @State var isPinModeEnabled: Bool = false   // ピンを立てるモード
    @State var isDraging : Bool = false         // ピンドラッグモード
    @State var isDialog: Bool = false           // 範囲選択ダイアログ
    

    
    var body: some View {
        ZStack {
            // 現在地が取得できたらマップを表示、それまでは読み込み中表示
            if let userLocation = locationManager.userLocation {
                TapToAddMapView(annotations: $annotations, selectedAnnotation: $selectedAnnotation,showDeleteAlert: $showDeleteAlert,  userLocation: userLocation, isPinModeEnabled: $isPinModeEnabled, isDraging: $isDraging )
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
        }   // ZStack
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("ピンを削除しますか？"),
                message: Text("このピンを削除してもよろしいですか？"),
                primaryButton: .destructive(Text("削除")) {
                    if let selected = selectedAnnotation {
                        annotations.removeAll { $0 == selected }
                        selectedAnnotation = nil
                    }
                },
                secondaryButton: .cancel {
                    selectedAnnotation = nil
                }
            )
        }
    }   // body
}   // View

