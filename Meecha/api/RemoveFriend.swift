//
//  RemoveFriend.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//
//  フレンド削除


import Foundation

// MARK: - Request Structure
struct RemoveFriendRequest: Codable {
    let userid: String
}

// MARK: - Response Structure
struct RemoveFriendResponse: Codable {
    // レスポンスが空なので、空の構造体を定義
}

// MARK: - API Client Function
func removeFriend(userid: String) -> ([RemoveFriendResponse], Bool) {
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/remove") else {
        print("❌ URL作成に失敗しました")
        return ([], false)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("❌ アクセストークンの取得に失敗しました")
        return ([], false)
    }
    
    // リクエストボディ作成
    let requestBody = RemoveFriendRequest(userid: userid)
    
    // JSONエンコード
    guard let jsonData = try? JSONEncoder().encode(requestBody) else {
        print("❌ JSONエンコードに失敗しました")
        return ([], false)
    }
    
    // HTTPリクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = jsonData
    
    // ヘッダー設定
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行のためのセマフォ
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([RemoveFriendResponse], Bool) = ([], false)
    
    // API呼び出し
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // エラーチェック
        if let error = error {
            print("❌ ネットワークエラー: \(error.localizedDescription)")
            return
        }
        
        // HTTPレスポンス確認
        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ HTTPレスポンスの取得に失敗しました")
            return
        }
        
        // ステータスコード確認（デバッグ用）
        print("ℹ️ HTTPステータスコード: \(httpResponse.statusCode)")
        
        // ステータスコードが200以外の場合
        if httpResponse.statusCode != 200 {
            print("❌ HTTPステータスコードが200以外です: \(httpResponse.statusCode)")
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("❌ レスポンスデータ: \(responseString)")
            }
            return
        }
        
        // レスポンスデータ確認（デバッグ用）
        if let data = data {
            print("ℹ️ レスポンスデータサイズ: \(data.count) bytes")
            if let responseString = String(data: data, encoding: .utf8) {
                print("ℹ️ レスポンス内容: \(responseString)")
            }
        }
        
        // レスポンスが空の場合（成功）
        if data?.isEmpty ?? true {
            print("✅ フレンド削除が成功しました")
            result = ([RemoveFriendResponse()], true)
        } else {
            // レスポンスが空でない場合もJSONデコードを試行
            do {
                let responseData = try JSONDecoder().decode([RemoveFriendResponse].self, from: data!)
                print("✅ フレンド削除が成功しました（レスポンス有り）")
                result = (responseData, true)
            } catch {
                print("❌ JSONデコードに失敗しました: \(error.localizedDescription)")
                // デコードに失敗してもHTTPステータスが200なら成功とみなす
                print("✅ フレンド削除が成功しました（デコードエラーを無視）")
                result = ([RemoveFriendResponse()], true)
            }
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}
