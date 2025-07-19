//
//  LocalNotificationManager.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//

import UserNotifications
import UIKit

class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    private init() {
        setupNotificationCategories()
    }
    
    // 通知カテゴリーを設定（アイコン表示を最適化）
    private func setupNotificationCategories() {
        let generalCategory = UNNotificationCategory(
            identifier: "GENERAL",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        let userCategory = UNNotificationCategory(
            identifier: "USER_NEARBY",
            actions: [],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([generalCategory, userCategory])
    }
    
    // 通知の許可を要求
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // 通知許可状態を確認
    func checkPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    // 基本通知コンテンツを作成（アプリアイコンを確実に使用）
    private func createBaseNotificationContent(title: String, body: String, categoryIdentifier: String = "GENERAL") -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        content.categoryIdentifier = categoryIdentifier
        
        // アプリ情報を通知に含める（アイコン表示の最適化）
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
                     Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Meecha"
        
        content.userInfo = [
            "app_name": appName,
            "app_identifier": Bundle.main.bundleIdentifier ?? "com.meecha.app"
        ]
        
        return content
    }
    
    // 即座に通知を送信
    func sendImmediateNotification(title: String, body: String, identifier: String = UUID().uuidString) {
        let content = createBaseNotificationContent(title: title, body: body)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            } else {
                print("通知が正常に送信されました - ID: \(identifier)")
            }
        }
    }
    
    // 遅延通知を送信
    func sendDelayedNotification(title: String, body: String, delay: TimeInterval, identifier: String = UUID().uuidString) {
        let content = createBaseNotificationContent(title: title, body: body)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            } else {
                print("遅延通知が正常にスケジュールされました - ID: \(identifier), 遅延: \(delay)秒")
            }
        }
    }
    
    // 新しいユーザーが追加された時の通知
    func notifyNewUsers(users: [NearUser]) {
        guard !users.isEmpty else { return }
        
        let title = "新しいユーザーが近くにいます"
        let body: String
        
        if users.count == 1 {
            body = "\(users[0].name)さんが近くにいます"
        } else {
            body = "\(users.count)人の新しいユーザーが近くにいます"
        }
        
        let content = createBaseNotificationContent(title: title, body: body, categoryIdentifier: "USER_NEARBY")
        
        // ユーザー情報を追加
        var userInfo = content.userInfo
        userInfo["notification_type"] = "new_users"
        userInfo["user_count"] = users.count
        if users.count == 1 {
            userInfo["user_name"] = users[0].name
            userInfo["user_distance"] = users[0].Dist
        }
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("新規ユーザー通知送信エラー: \(error)")
            } else {
                print("新規ユーザー通知が送信されました - \(users.count)人")
            }
        }
    }
    
    // 特定のユーザーに対する通知
    func notifySpecificUser(user: NearUser, message: String? = nil) {
        let title = "ユーザー通知"
        let body = message ?? "\(user.name)さんが近くにいます（距離: \(Int(user.Dist))m）"
        
        let content = createBaseNotificationContent(title: title, body: body, categoryIdentifier: "USER_NEARBY")
        
        // 特定のユーザー情報を追加
        var userInfo = content.userInfo
        userInfo["notification_type"] = "specific_user"
        userInfo["user_name"] = user.name
        userInfo["user_distance"] = user.Dist
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("特定ユーザー通知送信エラー: \(error)")
            } else {
                print("特定ユーザー通知が送信されました - \(user.name)")
            }
        }
    }
    
    // カスタム通知（アイコンやサウンドを指定）
    func sendCustomNotification(
        title: String,
        body: String,
        sound: UNNotificationSound = .default,
        badge: NSNumber? = nil,
        userInfo: [String: Any] = [:],
        categoryIdentifier: String = "GENERAL",
        identifier: String = UUID().uuidString
    ) {
        let content = createBaseNotificationContent(title: title, body: body, categoryIdentifier: categoryIdentifier)
        content.sound = sound
        
        // バッジ数の設定
        if let badge = badge {
            content.badge = badge
        }
        
        // カスタムユーザー情報を追加
        var combinedUserInfo = content.userInfo
        for (key, value) in userInfo {
            combinedUserInfo[key] = value
        }
        content.userInfo = combinedUserInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("カスタム通知送信エラー: \(error)")
            } else {
                print("カスタム通知が送信されました - ID: \(identifier)")
            }
        }
    }
    
    // 予定された通知をキャンセル
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("通知がキャンセルされました - ID: \(identifier)")
    }
    
    // 全ての予定された通知をキャンセル
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("全ての予定通知がキャンセルされました")
    }
    
    // 表示中の通知を削除
    func removeDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("表示中の通知が削除されました")
    }
    
    // バッジの数字をリセット
    func resetBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        print("バッジがリセットされました")
    }
    
    // バッジの数字を更新
    func updateBadge(count: Int) {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = count
        }
        print("バッジが更新されました: \(count)")
    }
}

// MARK: - 使用例とLocationDiffDetectorとの統合
extension LocalNotificationManager {
    // LocationDiffDetectorと統合した使用例
    func handleLocationUpdate(diff: LocationDiff, hasChanges: Bool) {
        guard hasChanges else { return }
        
        // 新しいユーザーが追加された場合の通知
        notifyNewUsers(users: diff.added)
    }
}

// MARK: - 使用例
func setupAndUseNotifications() {
    let notificationManager = LocalNotificationManager.shared
    let locationDetector = LocationDiffDetector()
    
    // 1. 通知の許可を要求
    notificationManager.requestPermission { granted in
        if granted {
            print("通知許可が与えられました")
            
//            // 許可が得られた場合、テスト通知を送信
//            notificationManager.sendImmediateNotification(
//                title: "Meecha",
//                body: "通知が正常に設定されました！"
//            )
        } else {
            print("通知許可が拒否されました")
        }
    }
    
    // 2. LocationDiffDetectorと組み合わせた使用例
    func handleNewLocationData(_ newResponse: LocationResponse?) {
        let (diff, hasChanges) = locationDetector.detectDifference(newResponse: newResponse)
        
        if hasChanges {
            // 新しいユーザーが追加された場合の通知
            notificationManager.notifyNewUsers(users: diff.added)
            
            // 個別に通知を送ることも可能
            for user in diff.added {
                notificationManager.notifySpecificUser(user: user)
            }
        }
    }
}
