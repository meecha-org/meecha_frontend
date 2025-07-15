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
    var body: some View {
        VStack{
            ForEach(approvalsModel.Approvals){ i in
                ApprovalCard(iconImage: i.iconImage, name: i.name)
                
            }
        }
        .frame(width: 300)
        .padding(.top, 10)

    }
}
#Preview {
    ApprovalComp()
}
