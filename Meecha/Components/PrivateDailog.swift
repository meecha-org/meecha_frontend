//
//  PrivateDailog.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

struct PrivateDailog: View {
    @State var selection = 0   // 選択された値
    var distance = [50, 200, 500, 1000, 3000, 5000]  // 距離の配列
    @State var selectDistance: Int = 50
    @AppStorage("distanceSize") var distanceSize: Int = 50

    @Binding var isDialog: Bool             // 範囲選択ダイアログ
    @Binding var isDraging : Bool           // ピンドラッグモード
    @Binding var isPinModeEnabled: Bool     // ピンを立てるモード
    @Binding var isNextBackButton: Bool     // ピン追加中のボタン

    @Binding var PlusBtton: Bool
    var body: some View {
        ZStack{
            // 背景タップ領域
            Color.black.opacity(0.5)
                   .contentShape(Rectangle())
                   .onTapGesture {
                       isDialog = false
                       PlusBtton = true
                       isNextBackButton = false
                   }
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 250, height: 200)
            // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.main, lineWidth: 1.5)
                )
            
            VStack(spacing: 40){
                Text("範囲(半径m)を選択してください")
                    .zenFont(.medium, size: 12, color: .font)
                    .padding(.top, 24)
                Picker("", selection: $selection) {
                    ForEach(0 ..< distance.count, id: \.self) { num in
                        Text("\(self.distance[num])")          // .tag()の指定は不要
                            .zenFont(.medium, size: 12, color: .font)
                    }
                }
                .pickerStyle(.menu)                

                // 決定・戻るボタン
                HStack{
                    // 戻るボタン
                    Button(action: {
                        print("戻る")
                        isDialog = false
                        PlusBtton = true
                        isNextBackButton = false
                    }) {
                       BackButton()
                    }
                    Spacer()
                    // 決定ボタン
                    Button(action: {
                        print("決定")
                        selectDistance = distance[selection]
                        distanceSize = selectDistance
                        print("\(selectDistance)")
                        isDialog = false            // ダイアログ閉じる
                        isNextBackButton = true
                        isPinModeEnabled = true   //ピン設置モード
                        isDraging = true          //ピンドラッグモード
                        print("ピン設置モード\(isPinModeEnabled)")
                        print("ピンドラッグモード\(isDraging)")
                        
                        switch selectDistance {
                        case 50:      distanceSize = 20
                        case 200:     distanceSize = 50
                        case 500:     distanceSize = 100
                        case 1000:    distanceSize = 150
                        case 3000:    distanceSize = 250
                        case 5000:    distanceSize = 300
                        default :
                            distanceSize = 20
                        }

                    }) {
                        NextButton()
                    }
                }
                .frame(width: 200)
                .padding(.bottom, 24)
            }
            .frame(width: 250, height: 200)
        }
        .edgesIgnoringSafeArea(.all)
    }   // body
}   // View

