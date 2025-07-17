//
//  NotifyDistanceResponse.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation

// MARK: - Response Structure
struct NotifyDistanceResponse: Codable {
    let distance: Int
    
    enum CodingKeys: String, CodingKey {
        case distance = "Distance"
    }
}

// MARK: - API Function
func getNotifyDistance() -> ([NotifyDistanceResponse], Bool) {
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return ([], false)
    }
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/notify/distance") else {
        return ([], false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // ヘッダー設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([NotifyDistanceResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // ネットワークエラーチェック
        if let error = error {
            print("Network error: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            return
        }
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("HTTP error: \(httpResponse.statusCode)")
            return
        }
        
        // データ存在チェック
        guard let data = data else {
            print("No data received")
            return
        }
        
        // JSONデコード
        do {
            let response = try JSONDecoder().decode(NotifyDistanceResponse.self, from: data)
            result = ([response], true)
        } catch {
            print("JSON decode error: \(error.localizedDescription)")
            return
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}
