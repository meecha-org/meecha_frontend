//
//  authbase.swift
//  auth-test
//
//  Created by mattuu0 on 2025/05/18.
//

import Foundation

struct UserProfile: Codable {
    let email: String
    let name: String
    let provCode: String
    let provUID: String // もし数値が大きすぎてIntに入らない場合はInt64などを検討
    let userId: String

    // JSONのキー名とSwiftのプロパティ名が異なる場合のマッピング
    enum CodingKeys: String, CodingKey {
        case email
        case name
        case provCode = "prov_code"
        case provUID = "prov_uid"
        case userId = "user_id"
    }
}

func FetchInfo() async throws -> UserProfile {
    var token = "";
    do {
        let getToken = getKeyChain(key: "authToken");
        
        debugPrint(getToken);
        
        if getToken == nil {
            return UserProfile(email: "", name: "", provCode: "", provUID: "0", userId: "");
        }
        
        token = getToken!
    } catch {
        debugPrint("failed to get token");
        return UserProfile(email: "", name: "", provCode: "", provUID: "0", userId: "");
    }
    
    do {
        debugPrint(token)
        let url = URL(string: "https://k8s-meecha.mattuu.com/auth/me")!
        var request = URLRequest(url: url)
        //            request.httpMethod = "POST"      // Postリクエストを送る(このコードがないとGetリクエストになる)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type");
        request.setValue(token, forHTTPHeaderField: "Authorization");
        
        let (response,error) = await try URLSession.shared.data(for: request);
        
        debugPrint(error);
        
        let decoder = JSONDecoder()
        let userProfile = try decoder.decode(UserProfile.self, from: response)
        print(userProfile)
        
        return userProfile
    } catch {
        debugPrint("failed to fetch")
        debugPrint(error)
        return UserProfile(email: "", name: "", provCode: "", provUID: "0", userId: "");
    }
}
