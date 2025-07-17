//
//  NotifyDistanceRequest.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation

// MARK: - Request Structure
struct NotifyDistanceRequest: Codable {
    let Distance: Int
}

// MARK: - Response Structure

// MARK: - API Function
func updateNotifyDistance(distance: Int) -> (Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/notify/distance") else {
        return (false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return (false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    
    // リクエストボディ作成
    let requestBody = NotifyDistanceRequest(Distance: distance)
    
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
    } catch {
        return (false)
    }
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: (Bool) = (false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーチェック
        if let error = error {
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            return
        }
        
        // レスポンスがない場合でも成功とする
        result = (true)
    }
    
    task.resume()
    semaphore.wait()
    return result
}
