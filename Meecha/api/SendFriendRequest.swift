//
//
//
//  フレンドリクエストを送る関数

import Foundation

// MARK: - Request Structure
struct FriendRequestRequest: Codable {
    let userid: String
}

// MARK: - Response Structure
struct FriendRequestResponse: Codable {
    // レスポンスがない場合でも、将来的な拡張に備えて空の構造体を定義
}

// MARK: - API Function
func sendFriendRequest(userid: String) -> ([FriendRequestResponse], Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/request") else {
        print("🚨 [DEBUG] URL Creation Error: Invalid URL - \(Config.apiBaseURL + "/app/friend/request")")
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("🚨 [DEBUG] Access Token Error: Failed to get access token")
        return ([], false)
    }
    
    print("🔑 [DEBUG] Access Token: \(accessToken.token)")
    
    // URLRequest作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // ヘッダーに設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    
    print("🌐 [DEBUG] Request URL: \(url.absoluteString)")
    print("📋 [DEBUG] Request Method: POST")
    print("📋 [DEBUG] Request Headers: Content-Type: application/json, Authorization: \(accessToken.token)")
    
    // リクエストボディ作成
    let requestBody = FriendRequestRequest(userid: userid)
    
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
        
        // リクエストボディをデバッグ表示
        if let requestString = String(data: jsonData, encoding: .utf8) {
            print("📤 [DEBUG] Request Body: \(requestString)")
        }
    } catch {
        print("🚨 [DEBUG] JSON Encoding Error: \(error.localizedDescription)")
        return ([], false)
    }
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendRequestResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーチェック
        if let error = error {
            print("🚨 [DEBUG] Network Error: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("🚨 [DEBUG] Invalid HTTP Response")
            return
        }
        
        // ステータスコードをデバッグ表示
        print("📡 [DEBUG] HTTP Status Code: \(httpResponse.statusCode)")
        
        // レスポンスデータをデバッグ表示
        if let data = data {
            let dataSize = data.count
            print("📦 [DEBUG] Response Data Size: \(dataSize) bytes")
            
            if dataSize > 0 {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📄 [DEBUG] Response Body: \(responseString)")
                } else {
                    print("📄 [DEBUG] Response Body: (Binary data)")
                }
            } else {
                print("📄 [DEBUG] Response Body: (Empty)")
            }
        } else {
            print("📦 [DEBUG] No response data")
        }
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("🚨 [DEBUG] HTTP Status Code is not 200")
            return
        }
        
        // レスポンスがない場合は成功として扱う
        print("✅ [DEBUG] Friend request sent successfully")
        result = ([], true)
    }
    
    task.resume()
    semaphore.wait()
    return result
}
