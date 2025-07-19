//
//  SettingView.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/08.
//

import SwiftUI

struct SettingView: View {
    @State var isDistance: Bool = false     //プライベート範囲画面
    @State var isDialog: Bool = false

    @State var UserName: String
    @State var UserID: String
    
    var body: some View {
        if isDistance{ MapWrapperView(isDistance: $isDistance) }
        else{
            ZStack{
                VStack(spacing: 32) {
                    SettingAccountInfo(MyName: UserName, MyID: UserID)
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
                        
                        SettingListsGroup(isDistance: $isDistance, isDialog: $isDialog )
                    }
                    Spacer()
                }   // VStack
                if isDialog {
                    DistanceDialog(isDialog: $isDialog)
                }
            }
        }   // else
    }   // body
}   // View

#Preview {
    SettingView(UserName: "hello", UserID: "world")
}
