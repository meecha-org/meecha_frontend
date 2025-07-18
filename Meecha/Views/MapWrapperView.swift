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
    @State var isPinModeEnabled: Bool = false   // ピンを立てるモード
    @State var isDraging : Bool = false    // ピンドラッグモード

    
    var body: some View {
        ZStack {
            // 現在地が取得できたらマップを表示、それまでは読み込み中表示
            if let userLocation = locationManager.userLocation {
                TapToAddMapView(annotations: $annotations, userLocation: userLocation, isPinModeEnabled: isPinModeEnabled)
                    .edgesIgnoringSafeArea(.all) // マップを画面全体に表示
            } else {
                ProgressView("現在地を取得中…") // ローディング表示
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    // ピン設置モード切り替えボタン
                    Button(action: {
                        isPinModeEnabled.toggle()
                        isDraging.toggle()
                        print("ピン設置モード\(isPinModeEnabled)")
                        print("ピンドラッグモード\(isDraging)")

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
            VStack{
                Rectangle()
                    .fill(headerBg)
                    .frame(maxWidth: .infinity, maxHeight: 130)
                Spacer()
                Rectangle()
                    .fill(gradient)
                    .frame(maxWidth: .infinity, maxHeight: 130)
            }
        }   // ZStack
        .edgesIgnoringSafeArea(.all)
    }   // body
}   // View

// MARK: - プレビュー
#Preview {
    MapWrapperView()
}
