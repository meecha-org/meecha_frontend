//
//  NotifyIgnorePoint.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/19.
//


import Foundation

// MARK: - Response Structure
struct NotifyIgnorePoint: Codable {
    let latitude: Double
    let longitude: Double
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
        case size = "Size"
    }
}

// MARK: - API Functions
func getNotifyIgnores() -> ([NotifyIgnorePoint], Bool) {
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return ([], false)
    }
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/notify/ignores") else {
        return ([], false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // ヘッダーに設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([NotifyIgnorePoint], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // ネットワークエラーチェック
        if let error = error {
            print("Network error: \(error)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            return
        }
        
        // HTTPステータスコードチェック
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
            let ignorePoints = try JSONDecoder().decode([NotifyIgnorePoint].self, from: data)
            result = (ignorePoints, true)
        } catch {
            print("JSON decode error: \(error)")
            return
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}

func updateNotifyIgnores(ignorePoints: [NotifyIgnorePoint]) -> Bool {
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return false
    }
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/notify/ignores") else {
        return false
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    // ヘッダーに設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // JSONエンコード
    do {
        let jsonData = try JSONEncoder().encode(ignorePoints)
        request.httpBody = jsonData
    } catch {
        print("JSON encode error: \(error)")
        return false
    }
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: Bool = false
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // ネットワークエラーチェック
        if let error = error {
            print("Network error: \(error)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response type")
            return
        }
        
        // HTTPステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("HTTP error: \(httpResponse.statusCode)")
            return
        }
        
        result = true
    }
    
    task.resume()
    semaphore.wait()
    return result
}
