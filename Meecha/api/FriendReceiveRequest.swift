//
//  FriendReceiveRequest.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//
//  承認前のフレンド一覧

import Foundation

// MARK: - API Response Structure
struct FriendReceiveRequestResponse: Codable {
    let id: String
    let sender: String  //送信元のID
    let senderName: String  //送信元の名前
    let target: String
    let targetName: String
}

// MARK: - API Function
func getFriendReceiveRequest() -> ([FriendReceiveRequestResponse], Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/recvrequest") else {
        print("Error: Failed to create URL")
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("Error: Failed to get access token")
        return ([], false)
    }
    
    // HTTPリクエストを作成
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // ヘッダーに設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendReceiveRequestResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーハンドリング
        if let error = error {
            print("Error: Network error - \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスをチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Error: Invalid response type")
            return
        }
        
        // デバッグ用にステータスコードを表示
        print("HTTP Status Code: \(httpResponse.statusCode)")
        
        // ステータスコードが200以外の場合
        if httpResponse.statusCode != 200 {
            print("Error: HTTP Status Code is not 200")
            return
        }
        
        // レスポンスデータをチェック
        guard let data = data else {
            print("Error: No response data")
            return
        }
        
        // デバッグ用にレスポンスデータを表示
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
        }
        
        // JSONデコード
        do {
            let decoder = JSONDecoder()
            let friendRequests = try decoder.decode([FriendReceiveRequestResponse].self, from: data)
            result = (friendRequests, true)
            print("Success: Decoded \(friendRequests.count) friend requests")
        } catch {
            print("Error: JSON decode failed - \(error.localizedDescription)")
            return
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}
