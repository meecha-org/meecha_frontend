//
//  ApprovalButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
import SwiftUI

// 承認ボタン
struct  YesButtonStyle: View {
    @Binding var YesButton: Bool
    var body: some View {
        // 承認ボタン
        Button(action: {
            YesButton = true
            print("承認ボタン\(YesButton)")
        }){
            ZStack {
                Circle()
                    .fill(Color.bg)
                    .frame(width: 24, height: 24)
                Image(systemName: "checkmark")
                    .resizable()
                    .foregroundStyle(Color.main)
                    .frame(width: 11, height: 8)
            }
        }   // Button
    }   //body
}   // View

// 拒否ボタン
struct NoButtonStyle : View {
    @Binding var NoButton: Bool
    
    // ユーザーID
    public var userID: String
    
    // フレンド削除ボタンか
    public var isDelete: Bool = false
    
    // リクエストID
    public var RequestId: String
    
    var body: some View {
        // 削除ボタン
        Button(action: {
            NoButton = true
            
            debugPrint("リクエストをキャンセルします:\(RequestId)")
            
            if !isDelete {
                // キャンセルの時
                // リクエストをキャンセルする
                cancelFriend(requestId: RequestId)
                return
            }
            
            // 削除する
            removeFriend(userid: userID)
        }){
            ZStack {
                Circle()
                    .fill(Color.redBg)
                    .frame(width: 24, height: 24)
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundStyle(Color.meechaRed)
                    .frame(width: 9, height: 9)
            }
        }   // Button
    }   // body
}   // View

// 承認・拒否ボタン
struct ApprovalButton: View {
    @Binding var YesButton: Bool
    @Binding var NoButton: Bool
    public var RequestId: String

    var body: some View {
        HStack(spacing: 8) {
            // 承認ボタン
            Button(action: {
                YesButton = true
                print("承認ボタン\(YesButton)")
                print("requestId:\(RequestId)")
                // リクエストを承認する
                acceptFriendRequest(requestId: RequestId)
            }){
                ZStack {
                    Circle()
                        .fill(Color.bg)
                        .frame(width: 24, height: 24)
                    Image(systemName: "checkmark")
                        .resizable()
                        .foregroundStyle(Color.main)
                        .frame(width: 11, height: 8)
                }
            }   // Button
            // 削除ボタン
            Button(action: {
                NoButton = true
                print("削除ボタン\(NoButton)")
                
                //リクエストを拒否する
                rejectFriend(requestId: RequestId)
            }){
                ZStack {
                    Circle()
                        .fill(Color.redBg)
                        .frame(width: 24, height: 24)
                    Image(systemName: "xmark")
                        .resizable()
                        .foregroundStyle(Color.meechaRed)
                        .frame(width: 9, height: 9)
                }
            }   // Button
        }   // VStack
    }   // body
}   // View

