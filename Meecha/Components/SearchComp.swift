//
//  SearchComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

struct SearchComp: View {
    @StateObject private var userSearchDataModel = UserSearchDataModel()
    var body: some View {
        VStack{
            ForEach(userSearchDataModel.UserSearch){ i in
                SearchCard(iconUrl: i.ImageURL, name: i.targetName, UserId: i.id)
                
            }
        }
//        .task {
//            do {
//                // 全てを削除する
//                requestsModel.requests.removeAll()
//                
//                // 送信済みリクエストを取得
//                let (sentRequests, success) = getSentFriendRequests()
//                
//                // 成功したか
//                if success {
//                    for request in sentRequests {
//                        // 追加する
//                        requestsModel.requests.append(RequestData(name: request.targetName, targetId: request.target, requestId: request.id))
//                        
//                        print("ID: \(request.id)")
//                        print("送信者: \(request.sender)")
//                        print("対象: \(request.target)")
//                    }
//                } else {
//                    print("取得に失敗しました")
//                }
//            } catch {
//                debugPrint(error)
//            }
//        }
        .frame(width: 300)
        .padding(.top, 10)
    }
}
#Preview {
    SearchComp()
}

