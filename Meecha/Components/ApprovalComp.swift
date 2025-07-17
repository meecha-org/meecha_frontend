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
    var (friends, error) = getFriendReceiveRequest()

    var body: some View {
        VStack{
            ForEach(approvalsModel.Approvals){ i in
                ApprovalCard(iconImage: i.iconImage, name: i.name)
            }
//            ForEach(users){ i in
//                FriendCard(iconImage: "https://k8s-meecha.mattuu.com/auth/assets/\(i.target).png", name: i.targetName)
//            }
        }
        .frame(width: 300)
        .padding(.top, 10)

    }
}
#Preview {
    ApprovalComp()
}
