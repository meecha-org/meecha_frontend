//
//  FriendTabFrame.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/09.
//
//フレンド情報を表示する枠
import SwiftUI

struct FriendTabFrame: View {
    var body: some View {
        ZStack{
            VStack {
                FriendTabTop()
                Spacer()
            }
            ZStack {
                Rectangle()
                    .fill(Color.main)
                    .frame(width: 322, height: 551)
                    .padding(.top, 1)
                //一部角丸
                    .clipShape(.rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 16,
                        topTrailingRadius: 0
                    ))
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 320, height: 550)
                //一部角丸
                    .clipShape(.rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 15,
                        topTrailingRadius: 0
                    ))
            }   // ZStack
        }   // ZStack
        .frame(height: 620)
    }
}
