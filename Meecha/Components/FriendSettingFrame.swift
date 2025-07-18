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
                VStack(spacing: 4){
                    Button("ブロック", action:{
//                        isBlockd = true
//                        print("ブロックボタン")
                        
                    })
                    .zenFont(.medium, size: 9, color: .meechaRed)
                }
                .padding(.all, 10)
            }

            .background(Color.white)
            //一部角丸
            .clipShape(.rect(
                topLeadingRadius: 5,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 5,
                topTrailingRadius: 5
            ))
            .padding(.all, 1)
        }
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
