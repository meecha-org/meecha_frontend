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
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ZStack{
                if isLoading {
                    LoadingView() // ローディング画面
                } else if hasError {
                    ErrorView() // エラー画面
                } else {
                    if loginState {
                        CustomTabView()
                    } else {
                        LoginView(loginButton: $loginState)
                    }
                }
//                MapWrapperView()
            }
            .task {
                await performInitialLoad()
                
                // 位置情報の監視を追加
                GlobalLocationMonitor.shared.startMonitoring()
                
                setupAndUseNotifications()
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

// MARK: - AppDelegateでの設定例
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 通知デリゲートを設定
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

// MARK: - 通知デリゲート
extension AppDelegate: UNUserNotificationCenterDelegate {
    // アプリがフォアグラウンドにいる時の通知表示
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // 通知をタップした時の処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("通知がタップされました: \(userInfo)")
        completionHandler()
    }
}
