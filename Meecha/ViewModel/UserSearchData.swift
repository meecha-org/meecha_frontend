//
//  UserSearchData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI
import Foundation

// Identifiableプロトコル ⇨ 値が一意(ユニーク)であることを保証する
struct UserSearchData: Identifiable {
    let id: String              // リクエストを識別するためのID
    let targetName: String      // 相手の名前
    let ImageURL: String        //アイコン
}

class UserSearchDataModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var UserSearch: [UserSearchData] = []

    init(){
        //仮データ
        UserSearch = [
            UserSearchData(id: "aaa", targetName: "ECC太郎", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png"),
            UserSearchData(id: "bbb", targetName: "りんりんご", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png"),
            UserSearchData(id: "ccc", targetName: "みーちゃ", ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png")
        ]
    }
}

