//
//  MeechaApp.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
import SwiftUI

@main
struct MeechaApp: App {
    @State var loginState: Bool = false
    @State private var isLoading = true
    @State private var hasError = false
    
    var body: some Scene {
        WindowGroup {
            ZStack{
//                if isLoading {
//                    LoadingView() // ローディング画面
//                } else if hasError {
//                    ErrorView() // エラー画面
//                } else {
//                    if loginState {
//                        CustomTabView()
//                    } else {
//                        LoginView(loginButton: $loginState)
//                    }
//                }
                ContentView()
            }
            .task {
                await performInitialLoad()
                
                // 位置情報の監視を追加
                GlobalLocationMonitor.shared.startMonitoring()
            }
        }
    }
    
    private func performInitialLoad() async {
        do {
            // ユーザー情報を取得して成功したらステータスを更新する
            let userInfo = try await FetchInfo()
            isLoading = false
            
            if userInfo.userId == "" {
                // ログイン失敗にする
                loginState = false
                return
            }
            
            // トークンを設定
            AuthTokenManager.shared.refreshToken = getKeyChain(key: Config.rfTokenKey)
            loginState = true
        } catch {
            hasError = true
            isLoading = false
        }
    }
}
