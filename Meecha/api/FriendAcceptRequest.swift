//
//  FriendAcceptRequest.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//
//  承認する

import Foundation

// MARK: - Request Structure
struct FriendAcceptRequest: Codable {
    let requestid: String
}

// MARK: - Response Structure
struct FriendAcceptResponse: Codable {
    // レスポンスが空のため、空の構造体として定義
}

// MARK: - API Function
func acceptFriendRequest(requestId: String) -> ([FriendAcceptResponse], Bool) {
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("Failed to get access token")
        return ([], false)
    }
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/accept") else {
        print("Failed to create URL")
        return ([], false)
    }
    
    // リクエストボディ作成
    let requestBody = FriendAcceptRequest(requestid: requestId)
    
    // JSONエンコード
    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        print("Failed to encode request body to JSON")
        return ([], false)
    }
    
    // HTTPリクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    // 同期実行のためのセマフォ
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendAcceptResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーチェック
        if let error = error {
            print("Network error: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            return
        }
        
        print("HTTP Status Code: \(httpResponse.statusCode)")
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("HTTP error: Status code \(httpResponse.statusCode)")
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response body: \(responseString)")
            }
            return
        }
        
        // レスポンスデータのデバッグ表示
        if let data = data {
            print("Response data length: \(data.count) bytes")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response body: \(responseString)")
            }
        }
        
        // レスポンスが空の場合の処理
        if let data = data, data.isEmpty {
            // 空のレスポンスの場合、成功として扱う
            result = ([FriendAcceptResponse()], true)
            print("Empty response - treating as success")
        } else if let data = data {
            // データがある場合はJSONデコードを試行
            do {
                let decodedResponse = try JSONDecoder().decode(FriendAcceptResponse.self, from: data)
                result = ([decodedResponse], true)
                print("Successfully decoded response")
            } catch {
                print("Failed to decode JSON response: \(error)")
                // デコードに失敗した場合でも、ステータスコードが200なら成功とみなす
                result = ([FriendAcceptResponse()], true)
            }
        } else {
            // データが存在しない場合も成功として扱う
            result = ([FriendAcceptResponse()], true)
            print("No response data - treating as success")
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}
