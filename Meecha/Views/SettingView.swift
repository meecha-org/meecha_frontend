//
//  SettingView.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/08.
//

import SwiftUI

struct SettingView: View {
    @State var isDistance: Bool = false
    var body: some View {
        if isDistance{ MapWrapperView() }
        else{
            VStack(spacing: 32) {
                SettingAccountInfo(Myicon: .myicon, MyName: "りんご", MyID: "1234567890")
                    .padding(.top, 150)
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.font)
                    .frame(width: 320, height: 1)
                
                ZStack{
                    // 設定背景
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .frame(width: 300, height: 320)
                    // 角丸ボーダー
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.main, lineWidth: 1)
                        )
                    
                    SettingListsGroup(isDistance: $isDistance)
                }
                Spacer()
            }   // VStack
        }
    }   // body
}   // View

#Preview {
    SettingView()
}
