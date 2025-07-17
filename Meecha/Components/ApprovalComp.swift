//
//  ApprovalComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/12.
//
//  フレンド画面　承認ページ
import SwiftUI

struct ApprovalComp: View {
    @StateObject private var approvalsModel = ApprovalModel()
    @State private var users: [FriendReceiveRequestResponse] = []
    var (response, success) = getFriendReceiveRequest()
    
    

    var body: some View {
        VStack{
            
            
            ForEach(approvalsModel.Approvals){ i in
                ApprovalCard(iconUrl:"https://k8s-meecha.mattuu.com/auth/assets/\(i.targetId).png", name: i.targetName,requestId: i.id)
            }
//            ForEach(users){ i in
//                FriendCard(iconImage: "https://k8s-meecha.mattuu.com/auth/assets/\(i.target).png", name: i.targetName)
//            }
        }.task {
            do {
                // 既存の全てを削除する
                approvalsModel.Approvals.removeAll()
                
                // 受信済み取得
                let (response, success) = getFriendReceiveRequest()
                if success, let response = response {
                    for request in response.requests {
                        approvalsModel.Approvals.append(ApprovalData(id: request.id, targetName: request.targetName, targetId: request.target))
//                        print("ID: \(request.id)")
//                        print("送信者: \(request.sender)")
//                        print("対象: \(request.target)")
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
    ApprovalComp()
}
