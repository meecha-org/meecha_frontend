//
//  NearUser.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/17.
//


import Foundation


// 差分結果を表す構造体
struct LocationDiff {
    let added: [NearUser]      // 新しく追加されたユーザー
    
    var hasChanges: Bool {
        return !added.isEmpty
    }
}

class LocationDiffDetector {
    private var previousResponse: LocationResponse?
    
    // メイン関数：差分を検出する
    func detectDifference(newResponse: LocationResponse?) -> (diff: LocationDiff, hasChanges: Bool) {
        // 新しいデータがnilの場合
        guard let newResponse = newResponse else {
            let diff = LocationDiff(added: [])
            return (diff, false)
        }
        
        // 前回のデータがない場合（初回）
        guard let previousResponse = previousResponse else {
            self.previousResponse = newResponse
            let diff = LocationDiff(
                added: newResponse.near,
            )
            return (diff, !newResponse.near.isEmpty)
        }
        
        // 差分を計算
        let added = getAddedUsers(previous: previousResponse, new: newResponse)
        let diff = LocationDiff(added: added)
        
        // 新しいデータを保存
        self.previousResponse = newResponse
        
        return (diff, diff.hasChanges)
    }
    
    // 追加されたユーザーのみを検出
    private func getAddedUsers(previous: LocationResponse, new: LocationResponse) -> [NearUser] {
        let previousUserIds = Set(previous.near.map { $0.userid })
        let newUsers = new.near
        
        // 前回のデータに存在しないユーザーIDを持つユーザーを返す
        return newUsers.filter { newUser in
            !previousUserIds.contains(newUser.userid)
        }
    }
    
    // 差分結果を分かりやすく表示する補助関数
    func printDifference(_ diff: LocationDiff) {
        if !diff.hasChanges {
            print("新しいユーザーなし")
            return
        }
        
        print("新しく追加されたユーザー:")
        for user in diff.added {
            print("  - \(user.name) (ID: \(user.userid))")
        }
    }
}
