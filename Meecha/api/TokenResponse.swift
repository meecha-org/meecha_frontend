//
//  TokenResponse.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/16.
//


import Foundation

// レスポンスの構造体
struct TokenResponse: Codable {
    let message: String
    let token: String
}

// エラーの定義
enum AuthError: Error {
    case invalidURL
    case noRefreshToken
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(String)
}

class AuthTokenManager {
    
    // シングルトンインスタンス
    static let shared = AuthTokenManager()
    
    private init() {}
    
    // キャッシュ用のプロパティ
    private var cachedToken: String?
    private var tokenCacheTime: Date?
    private let cacheValidityDuration: TimeInterval = 180 // 3分（180秒）
    
    // リフレッシュトークンを保存するプロパティ
    var refreshToken: String?
    
    // アクセストークンを同期的に取得する関数
    func getAccessToken() -> (token: String?, success: Bool) {
        
        // キャッシュされたトークンが有効かチェック
        if let cachedToken = cachedToken,
           let cacheTime = tokenCacheTime,
           Date().timeIntervalSince(cacheTime) < cacheValidityDuration {
            return (token: cachedToken, success: true)
        }
        
        // リフレッシュトークンがあるかチェック
        guard let refreshToken = refreshToken else {
            return (token: nil, success: false)
        }
        
        // APIリクエストを同期的に送信
        return fetchTokenFromAPISync(refreshToken: refreshToken)
    }
    
    // APIから同期的にトークンを取得する内部関数
    private func fetchTokenFromAPISync(refreshToken: String) -> (token: String?, success: Bool) {
        
        // URLの作成
        guard let url = URL(string: Config.apiBaseURL + "/auth/token") else {
            return (token: nil, success: false)
        }
        
        // リクエストの設定
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(refreshToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // セマフォを使用して同期処理を実現
        let semaphore = DispatchSemaphore(value: 0)
        var result: (token: String?, success: Bool) = (token: nil, success: false)
        
        // URLSessionでリクエスト実行
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { semaphore.signal() }
            
            // エラーハンドリング
            if let error = error {
                print("Network error: \(error)")
                return
            }
            
            // HTTPレスポンスのチェック
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            // ステータスコードのチェック
            guard httpResponse.statusCode == 200 else {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                return
            }
            
            // データの存在チェック
            guard let data = data else {
                print("No data received")
                return
            }
            
            // JSONをパース
            do {
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                // キャッシュを更新
                self?.cachedToken = tokenResponse.token
                self?.tokenCacheTime = Date()
                
                result = (token: tokenResponse.token, success: true)
                
            } catch {
                print("Decoding error: \(error)")
            }
            
        }.resume()
        
        // セマフォで待機（同期処理）
        semaphore.wait()
        
        return result
    }
    
    // キャッシュをクリアする関数
    func clearTokenCache() {
        cachedToken = nil
        tokenCacheTime = nil
    }
    
    // キャッシュが有効かチェックする関数
    func isCacheValid() -> Bool {
        guard let cacheTime = tokenCacheTime else { return false }
        return Date().timeIntervalSince(cacheTime) < cacheValidityDuration
    }
}
