//
//  DistanceDialog.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

struct DistanceDialog: View {
    @State var selection = 50   // 選択された値
    var distance = [50, 200, 500, 1000, 3000, 5000]  // 距離の配列
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 250, height: 200)
            // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.main, lineWidth: 1.5)
                )
            
            VStack(spacing: 40){
                Text("範囲(半径m)を設定")
                    .zenFont(.medium, size: 12, color: .font)
                    .padding(.top, 24)
                Picker("フルーツを選択", selection: $selection) {
                    ForEach(0 ..< distance.count, id: \.self) { num in
                        Text("\(self.distance[num])")          // .tag()の指定は不要
                            .zenFont(.medium, size: 12, color: .font)
                    }
                }
                .pickerStyle(.menu)
                

                HStack{
                    // 戻るボタン
                    Button(action: {
                        print("戻る")
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.meechaRed)
                                .frame(width: 54, height: 37)
                            Text("戻る")
                                .zenFont(.bold, size: 14, color: .white)
                        }
                    }
                    Spacer()
                    // 決定ボタン
                    Button(action: {
                        print("決定")
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.main)
                                .frame(width: 54, height: 37)
                            Text("決定")
                                .zenFont(.bold, size: 14, color: .white)
                        }
                    }
                }
                .frame(width: 200)
                .padding(.bottom, 24)
            }
            
        }
        .frame(width: 250, height: 200)
    }
}

#Preview {
    DistanceDialog()
}
