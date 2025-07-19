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

    @State var UserName: String = ""
    @State var UserID: String = ""
    
    var body: some View {
        if isDistance{ MapWrapperView(isDistance: $isDistance) }
        else{
            ZStack{
                VStack(spacing: 32) {
                    SettingAccountInfo(Myicon: .myicon, MyName: UserName, MyID: UserID)
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
                }.task {
                    do {
                        // 自身の情報取得
                        let response = try await FetchInfo()
                        debugPrint("userInfo: \(response)")
                        
                        // 情報を設定
                        UserName = response.name
                        UserID = response.userId
                    } catch {
                        debugPrint(error)
                    }
                }   // VStack
                if isDialog {
                    DistanceDialog(isDialog: $isDialog)
                }
            }
        }   // else
    }   // body
}   // View

#Preview {
    SettingView()
}
