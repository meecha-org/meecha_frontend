//
//  ApprovalData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/12.
//
//  承認前ユーザー_サンプル
import SwiftUI
import Foundation

// Identifiableプロトコル ⇨ 値が一意(ユニーク)であることを保証する
struct ApprovalData: Identifiable {
    let name: String    // 名前
    let iconImage: ImageResource
    let id = UUID()     // 識別するためのIDを生成
}

class ApprovalModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var Approvals: [ApprovalData] = []

    init(){
        //仮データ
        Approvals = [
            ApprovalData(name: "ECC太郎", iconImage: .iconSample6),
            ApprovalData(name: "りんりんご", iconImage: .iconSample7),
            ApprovalData(name: "みーちゃ", iconImage: .iconSample8)
        ]
    }
}

