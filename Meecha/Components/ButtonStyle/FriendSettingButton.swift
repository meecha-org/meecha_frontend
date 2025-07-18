//
//  FriendSettingButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/16.
//
//  フレンド設定ボタン
import  SwiftUI

struct FriendSettingButton: View {
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: 20, height: 20)
            // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.formBorder, lineWidth: 1)
                )
            Image(systemName: "ellipsis")
                .resizable()
                .foregroundStyle(Color.formBorder)
                .frame(width: 13, height: 3)
        }
    }
}

#Preview {
    FriendSettingButton()
}
