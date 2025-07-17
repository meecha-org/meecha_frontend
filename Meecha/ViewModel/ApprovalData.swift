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
    let id: String           // リクエストを識別するためのID
    let targetName: String    // 相手の名前
    let targetId: String    //相手のID
}

class ApprovalModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var Approvals: [ApprovalData] = []

    init(){
        //仮データ
        Approvals = [
//            ApprovalData(id: "aaa", targetName: "ECC太郎", targetId: "aaa"),
//            ApprovalData(id: "bbb", targetName: "りんりんご", targetId: "bbb"),
//            ApprovalData(id: "ccc", targetName: "みーちゃ", targetId: "ccc")
        ]
    }
}

