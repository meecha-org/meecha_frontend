//
//  FirendListData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
//  フレンド一覧_サンプル
import SwiftUI
import Foundation

// Identifiableプロトコル ⇨ 値が一意(ユニーク)であることを保証する
struct FriendListData: Identifiable {
    let name: String    // 名前
    let ImageURL: String
    let id = UUID()     // 識別するためのIDを生成
}

class FriendListModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var friendList: [FriendListData] = []

    init(){
        //仮データ
        friendList = [
            FriendListData(name: "ECC太郎", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png"),
            FriendListData(name: "りんりんご", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png"),
            FriendListData(name: "みーちゃ", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png")
        ]
    }
}

