//
//  RequestComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
import SwiftUI

struct RequestComp: View {
    @StateObject private var requestsModel = RequestModel()
    var body: some View {
        VStack{
            ForEach(requestsModel.requests){ i in
                RequestCard(iconUrl:"https://k8s-meecha.mattuu.com/auth/assets/\(i.targetId).png", name: i.name,requestID: i.requestId)
                
            }
        }.task {
            do {
                // 全てを削除する
                requestsModel.requests.removeAll()
                
                // 送信済みリクエストを取得
                let (sentRequests, success) = getSentFriendRequests()
                
                // 成功したか
                if success {
                    for request in sentRequests {
                        // 追加する
                        requestsModel.requests.append(RequestData(name: request.targetName, targetId: request.target, requestId: request.id))
                        
                        print("ID: \(request.id)")
                        print("送信者: \(request.sender)")
                        print("対象: \(request.target)")
                    }
                } else {
                    print("取得に失敗しました")
                }
            } catch {
                debugPrint(error)
            }
        }
        .frame(width: 300)
        .padding(.top, 10)
    }
}
#Preview {
    RequestComp()
}
