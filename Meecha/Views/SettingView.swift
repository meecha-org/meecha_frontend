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

    public var UserName: String
    public var UserID: String
        
    // 通知距離を保持する変数
    @State var nowDistance: Int = 1000
    
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
                    DistanceDialog(selectDistance: $nowDistance, isDialog: $isDialog)
                }
            }.task {
                do {
                    // 現在の通離距離を取得する
                    let (distance,success) = getNotifyDistance()
                    
                    if success {
                        debugPrint("nowDistance: \(distance.distance)")
                        // 成功した時
                        nowDistance = distance.distance
                    }
                } catch {
                    debugPrint(error)
                }
            }
        }   // else
    }   // body
}   // View

#Preview {
    SettingView(UserName: "hello", UserID: "world")
}
