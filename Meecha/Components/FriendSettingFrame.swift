//
//  FriendSettingFrame.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
//  フレンド設定フレーム
import SwiftUI

struct FriendSettingFrame: View {
    @State var isBlockd: Bool = false
    var body: some View {
        // 灰色ボーダー
        VStack{
            // 白背景
            VStack{
                // ボタンリスト
                VStack{
                    Button("ブロック", action:{
                        isBlockd = true
                        print("ブロックボタン")
                    })
                    .zenFont(.medium, size: 9, color: .meechaRed)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
            }
            .frame(width: 63)
            .background(Color.white)
            //一部角丸
            .clipShape(.rect(
                topLeadingRadius: 5,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 5,
                topTrailingRadius: 5
            ))
            .padding(.top, 1)
            .padding(.bottom, 1)

        }
        .frame(width: 65)
        .background(Color.formBorder)
        //一部角丸
        .clipShape(.rect(
            topLeadingRadius: 6,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 6,
            topTrailingRadius: 6
        ))
    }
}

#Preview {
    FriendSettingFrame()
}
