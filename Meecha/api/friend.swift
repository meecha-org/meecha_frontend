import Foundation

// フレンドのデータ構造
struct Friend: Identifiable {
    let name: String
    let id: String
}

extension Friend: Codable {}

// フレンドリスト一覧を取得する関数（同期）
func getFriendList() -> ([Friend]?, Error?) {
    guard let url = URL(string: Config.apiBaseURL + "/app/friend/list") else {
        return (nil, APIError.invalidURL)
    }
    
    // アクセストークン取得
    let accessToken = AuthTokenManager.shared.getAccessToken()
    
    // 取得できたか判定
    if accessToken.success == false {
        return (nil, APIError.httpError(401))
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue(accessToken.token, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // 同期実行のためのセマフォ
    let semaphore = DispatchSemaphore(value: 0)
    
    var result: ([Friend]?, Error?) = (nil, nil)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        
        if let error = error {
            result = (nil, error)
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            result = (nil, APIError.invalidResponse)
            return
        }
        
        guard httpResponse.statusCode == 200 else {
            result = (nil, APIError.httpError(httpResponse.statusCode))
            return
        }
        
        guard let data = data else {
            result = (nil, APIError.noData)
            return
        }
        
        do {
            let friends = try JSONDecoder().decode([Friend].self, from: data)
            result = (friends, nil)
        } catch {
            result = (nil, APIError.decodingError(error))
        }
    }
    
    task.resume()
    semaphore.wait()
    
    return result
}

// APIエラーの定義
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case httpError(Int)
    case decodingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "無効なURLです"
        case .invalidResponse:
            return "無効なレスポンスです"
        case .noData:
            return "データがありません"
        case .httpError(let statusCode):
            return "HTTPエラー: \(statusCode)"
        case .decodingError(let error):
            return "デコードエラー: \(error.localizedDescription)"
        }
    }
}

// 使用例
func example() {
    let (friends, error) = getFriendList()
    
    if let error = error {
        print("エラーが発生しました: \(error.localizedDescription)")
    } else if let friends = friends {
        print("フレンドリスト:")
        for friend in friends {
            print("- 名前: \(friend.name), ID: \(friend.id)")
        }
    }
}

//class FriendsData: ObservableObject{
//    // Viewに通知するため @Published をつける
//    @Published var frienddata: [Friend] = []
//    var (friends, error) = getFriendList()
//    
//    init(){
//        for i in friends {
//            //仮データ
//            frienddata = [
//                Friend(name: friend.name),
//            ]
//        }
//    }
//}
