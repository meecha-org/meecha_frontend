//
//  FriendSentRequestResponse.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation

// MARK: - Response Models
struct FriendSentRequestResponse: Codable {
    let id: String
    let sender: String
    let senderName: String
    let target: String
    let targetName: String
}

// MARK: - API Function
func getSentFriendRequests() -> ([FriendSentRequestResponse], Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/sentrequest") else {
        print("❌ URL作成失敗")
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("❌ アクセストークン取得失敗")
        return ([], false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendSentRequestResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // ネットワークエラーチェック
        if let error = error {
            print("❌ ネットワークエラー: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ HTTPレスポンス取得失敗")
            return
        }
        
        print("📡 HTTPステータスコード: \(httpResponse.statusCode)")
        
        // ステータスコードが200以外の場合
        guard httpResponse.statusCode == 200 else {
            print("❌ HTTPステータスコードエラー: \(httpResponse.statusCode)")
            return
        }
        
        // データ存在チェック
        guard let data = data else {
            print("❌ レスポンスデータが存在しません")
            return
        }
        
        print("📥 レスポンスデータサイズ: \(data.count) bytes")
        
        // デバッグ用：レスポンスの生データを表示
        if let responseString = String(data: data, encoding: .utf8) {
            print("📋 レスポンスデータ: \(responseString)")
        }
        
        // JSONデコード
        do {
            let decoder = JSONDecoder()
            let sentRequests = try decoder.decode([FriendSentRequestResponse].self, from: data)
            print("✅ デコード成功: \(sentRequests.count)件の送信済みリクエスト")
            result = (sentRequests, true)
        } catch {
            print("❌ JSONデコードエラー: \(error)")
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("📝 データ破損: \(context)")
                case .keyNotFound(let key, let context):
                    print("📝 キーが見つからない: \(key) - \(context)")
                case .typeMismatch(let type, let context):
                    print("📝 型不一致: \(type) - \(context)")
                case .valueNotFound(let type, let context):
                    print("📝 値が見つからない: \(type) - \(context)")
                @unknown default:
                    print("📝 不明なデコードエラー")
                }
            }
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}