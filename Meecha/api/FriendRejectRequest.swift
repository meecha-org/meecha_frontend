//
//  FriendRejectRequest.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation

// MARK: - Request Structure
struct FriendRejectRequest: Codable {
    let requestid: String
}

// MARK: - Response Structure
struct FriendRejectResponse: Codable {
    // レスポンスが空のため、プレースホルダーとして定義
    // 実際のAPIレスポンスに応じて調整してください
}

// MARK: - API Function
func rejectFriend(requestId: String) -> ([FriendRejectResponse], Bool) {
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        print("DEBUG: アクセストークンの取得に失敗しました")
        return ([], false)
    }
    
    // URL生成
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/reject") else {
        print("DEBUG: URL作成に失敗しました")
        return ([], false)
    }
    
    // リクエスト作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // リクエストボディ作成
    let requestBody = FriendRejectRequest(requestid: requestId)
    
    do {
        let jsonData = try JSONEncoder().encode(requestBody)
        request.httpBody = jsonData
        
        // デバッグ用：リクエストボディ表示
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("DEBUG: リクエストボディ: \(jsonString)")
        }
    } catch {
        print("DEBUG: JSONエンコードに失敗しました - \(error)")
        return ([], false)
    }
    
    // 同期実行のためのセマフォ
    let semaphore = DispatchSemaphore(value: 0)
    var result: ([FriendRejectResponse], Bool) = ([], false)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        // ネットワークエラーチェック
        if let error = error {
            print("DEBUG: ネットワークエラー - \(error)")
            return
        }
        
        // HTTPレスポンスチェック
        guard let httpResponse = response as? HTTPURLResponse else {
            print("DEBUG: HTTPレスポンスの取得に失敗しました")
            return
        }
        
        // デバッグ用：ステータスコード表示
        print("DEBUG: HTTPステータスコード: \(httpResponse.statusCode)")
        
        // ステータスコードチェック
        guard httpResponse.statusCode == 200 else {
            print("DEBUG: HTTPステータスコードが200以外です - \(httpResponse.statusCode)")
            return
        }
        
        // レスポンスデータの処理
        if let data = data {
            // デバッグ用：レスポンスデータ表示
            if let responseString = String(data: data, encoding: .utf8) {
                print("DEBUG: レスポンスデータ: \(responseString)")
            }
            
            // レスポンスが空の場合の処理
            if data.isEmpty {
                print("DEBUG: レスポンスが空です（成功）")
                result = ([], true)
                return
            }
            
            // JSONデコード（レスポンスが存在する場合）
            do {
                let decodedResponse = try JSONDecoder().decode([FriendRejectResponse].self, from: data)
                result = (decodedResponse, true)
                print("DEBUG: JSONデコード成功")
            } catch {
                // 単一オブジェクトとしてデコードを試行
                do {
                    let singleResponse = try JSONDecoder().decode(FriendRejectResponse.self, from: data)
                    result = ([singleResponse], true)
                    print("DEBUG: 単一レスポンスとしてJSONデコード成功")
                } catch {
                    print("DEBUG: JSONデコードに失敗しました - \(error)")
                    // レスポンスが空の場合は成功として扱う
                    result = ([], true)
                }
            }
        } else {
            print("DEBUG: レスポンスデータがありません（成功）")
            result = ([], true)
        }
    }
    
    task.resume()
    semaphore.wait()
    return result
}