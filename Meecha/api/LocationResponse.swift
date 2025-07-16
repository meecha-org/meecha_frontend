import Foundation

// レスポンスデータ構造
struct LocationResponse: Codable {
    let removed: [String]
    let near: [NearUser]
}

struct NearUser: Codable {
    let userid: String
    let latitude: Double
    let longitude: Double
    let Dist: Double
}

// リクエストボディ構造
struct LocationRequest: Codable {
    let lat: Double
    let lng: Double
}

func updateLocation(accessToken: String, latitude: Double, longitude: Double) -> (LocationResponse?, Bool) {
        
    guard let url = URL(string: Config.apiBaseURL + "/location/update") else {
            return (nil, false)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // ヘッダーの設定
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // リクエストボディの作成
        let requestBody = LocationRequest(lat: latitude, lng: longitude)
        
        do {
            let jsonData = try JSONEncoder().encode(requestBody)
            request.httpBody = jsonData
        } catch {
            return (nil, false)
        }
        
        // 同期的にリクエストを送信
        let semaphore = DispatchSemaphore(value: 0)
        var result: (LocationResponse?, Bool) = (nil, false)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            if let error = error {
                print("ネットワークエラー: \(error.localizedDescription)")
                result = (nil, false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("無効なレスポンス")
                result = (nil, false)
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("HTTPエラー: ステータスコード \(httpResponse.statusCode)")
                result = (nil, false)
                return
            }
            
            guard let data = data else {
                print("データが受信されませんでした")
                result = (nil, false)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(LocationResponse.self, from: data)
                result = (response, true)
            } catch {
                print("JSONデコードエラー: \(error.localizedDescription)")
                result = (nil, false)
            }
        }.resume()
        
        semaphore.wait()
        return result
}

