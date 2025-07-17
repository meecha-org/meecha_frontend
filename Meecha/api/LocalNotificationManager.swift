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
    
    private init() {}
    
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
    
    // 即座に通知を送信
    func sendImmediateNotification(title: String, body: String, identifier: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            }
        }
    }
    
    // 遅延通知を送信
    func sendDelayedNotification(title: String, body: String, delay: TimeInterval, identifier: String = UUID().uuidString) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
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
        
        sendImmediateNotification(title: title, body: body)
    }
    
    // 特定のユーザーに対する通知
    func notifySpecificUser(user: NearUser, message: String? = nil) {
        let title = "ユーザー通知"
        let body = message ?? "\(user.name)さんが近くにいます（距離: \(Int(user.Dist))m）"
        
        sendImmediateNotification(title: title, body: body)
    }
    
    // カスタム通知（アイコンやサウンドを指定）
    func sendCustomNotification(
        title: String,
        body: String,
        sound: UNNotificationSound = .default,
        badge: NSNumber? = 1,
        userInfo: [String: Any] = [:],
        identifier: String = UUID().uuidString
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = badge
        content.userInfo = userInfo
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("通知送信エラー: \(error)")
            }
        }
    }
    
    // 予定された通知をキャンセル
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // 全ての予定された通知をキャンセル
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 表示中の通知を削除
    func removeDeliveredNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // バッジの数字をリセット
    func resetBadge() {
        DispatchQueue.main.async {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
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

