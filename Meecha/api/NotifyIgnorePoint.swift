import Foundation

// MARK: - Request Structure
struct NotifyIgnorePoint: Codable {
    let Latitude: Double
    let Longitude: Double
    let Size: Int
}

// MARK: - Response Structure
struct NotifyIgnoresResponse: Codable {
    // レスポンスはないため、空の構造体として定義
}

// MARK: - API Function
func updateNotifyIgnores(ignorePoints: [NotifyIgnorePoint]) -> ([NotifyIgnoresResponse], Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/notify/ignores") else {
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return ([], false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    
    // JSONエンコード
    do {
        let jsonData = try JSONEncoder().encode(ignorePoints)
        request.httpBody = jsonData
    } catch {
        return ([], false)
    }
    
    // 同期実行の実装
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([NotifyIgnoresResponse], Bool) = ([], false)
    
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
        if httpResponse.statusCode != 200 {
            return
        }
        
        // レスポンスにはデータがないため、成功時は空の配列を返す
        result = ([], true)
    }
    
    task.resume()
    semaphore.wait()
    return result
}