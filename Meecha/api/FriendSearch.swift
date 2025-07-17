//
//  FriendSearch.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//
//  ユーザ検索

import Foundation

// レスポンス用の構造体
struct FriendSearchResponse: Codable {
    let userid: String
    let name: String
}

// リクエスト用の構造体
struct FriendSearchRequest: Codable {
    let name: String
}

func searchFriend(name: String) -> ([FriendSearchResponse], Bool) {
    // URL作成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/search") else {
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return ([], false)
    }
    
    // リクエスト設定
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // リクエストボディ作成
    let requestBody = FriendSearchRequest(name: name)
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
    } catch {
        return ([], false)
    }
    
    // 同期的にAPIを実行
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendSearchResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
            result = ([], false)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            result = ([], false)
            return
        }
        
        // ステータスコードチェック
        if httpResponse.statusCode != 200 {
            result = ([], false)
            return
        }
        
        guard let data = data else {
            result = ([], false)
            return
        }
        
        // レスポンスをデコード
        do {
            let friendSearchResponse = try JSONDecoder().decode([FriendSearchResponse].self, from: data)
            result = (friendSearchResponse, true)
        } catch {
            result = ([], false)
        }
    }
    
    task.resume()
    semaphore.wait()
    
    return result
}
