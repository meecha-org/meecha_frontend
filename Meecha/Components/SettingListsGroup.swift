//
//  SettingListsGroup.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/16.
//
import SwiftUI

struct SettingListsGroup: View {
    @State var notice: Bool = false
    @Binding var isDistance: Bool   // プライベート範囲画面
    @Binding var isDialog: Bool     // 通知する距離ダイアログ
    // App全体でログイン状態を記録
    @AppStorage("isLoggedState") var isLoggedState: Bool = false
    var body: some View {
        VStack(spacing: 20){
            // プライベート範囲
            Button(action:{
                isDistance = true
                print("プライベート範囲true")
            }){
                SettingList(ListText: "プライベート範囲")
            }
            .buttonStyle(.plain)
            // 通知する距離
            Button(action:{
                isDialog = true
            }){
                SettingList(ListText: "通知する距離（半径）")
            }
            .buttonStyle(.plain)

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.formBorder)
                .frame(width: 275, height: 1)
            
            // プロフィール
            Button(action:{
                
            }){
                SettingList(ListText: "プロフィール設定")
            }
            .buttonStyle(.plain)

            // メールアドレス
            Button(action:{
                
            }){
                SettingList(ListText: "メールアドレス変更")
            }
            .buttonStyle(.plain)

            // パスワード
            Button(action:{
                
            }){
                SettingList(ListText: "パスワード変更")
            }
            .buttonStyle(.plain)

            // 通知
            Toggle(isOn: $notice) {
                Text("通知設定")
                    .zenFont(.medium, size: 14, color: .font)
            }
            .frame(width: 270)
            .toggleStyle(NewToggleStyle())
            
            // パスワード
            Button(action:{
                // ログアウトボタンを押した時
                isLoggedState = false     // ログイン画面へ
                deleteKeyChain(tag: Config.rfTokenKey)      // キーチェーンから削除する
                AuthTokenManager.shared.refreshToken = ""   // リフレッシュトークンを削除
                AuthTokenManager.shared.clearTokenCache()   // アクセストークンのキャッシュを削除する
            }){
                Text("ログアウト")
                    .zenFont(.medium, size: 14, color: .meechaRed)
            }
            .frame(width: 270, alignment: .leading)
            .buttonStyle(.plain)
        }
    }   // body
}   // View
