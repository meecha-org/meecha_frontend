//
//  FriendCancelRequest.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation

// MARK: - Request Structure
struct FriendCancelRequest: Codable {
    let requestid: String
}

// MARK: - Response Structure (Empty response for this API)
struct FriendCancelResponse: Codable {
    // This API returns no response body
}

// MARK: - API Function
func cancelFriend(requestId: String) -> ([FriendCancelResponse], Bool) {
    print("=== Friend Cancel API Call Started ===")
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/cancel") else {
        print("❌ URL作成失敗")
        return ([], false)
    }
    print("🌐 URL: \(url.absoluteString)")
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("❌ アクセストークン取得失敗")
        return ([], false)
    }
    print("🔑 アクセストークン取得成功")
    
    // リクエストボディ作成
    let requestBody = FriendCancelRequest(requestid: requestId)
    
    // JSON エンコード
    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        print("❌ JSON エンコード失敗")
        return ([], false)
    }
    print("📦 リクエストボディ: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
    
    // HTTPリクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    // 同期実行の準備
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendCancelResponse], Bool) = ([], false)
    
    // API呼び出し
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーチェック
        if let error = error {
            print("❌ ネットワークエラー: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ HTTPレスポンス取得失敗")
            return
        }
        
        print("📊 HTTPステータスコード: \(httpResponse.statusCode)")
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("❌ HTTPステータスコードエラー: \(httpResponse.statusCode)")
            if let data = data {
                print("📄 エラーレスポンス: \(String(data: data, encoding: .utf8) ?? "nil")")
            }
            return
        }
        
        print("✅ API呼び出し成功")
        
        // このAPIはレスポンスボディが空なので、成功時は空の配列を返す
        if let data = data {
            print("📄 レスポンスデータ: \(String(data: data, encoding: .utf8) ?? "nil")")
        } else {
            print("📄 レスポンスデータなし（正常）")
        }
        
        result = ([], true)
    }
    
    task.resume()
    semaphore.wait()
    
    print("=== Friend Cancel API Call Finished ===")
    return result
}

// MARK: - Usage Example
/*
let (responses, success) = cancelFriend(requestId: "ff0facc0-4fe1-4ddb-a044-5a464d77b2ba")

if success {
    print("フレンドリクエストキャンセル成功")
} else {
    print("フレンドリクエストキャンセル失敗")
}
*/