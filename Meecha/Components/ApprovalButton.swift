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
    var body: some View {
        // 削除ボタン
        Button(action: {
            NoButton = true
            print("削除ボタン\(NoButton)")
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
            YesButtonStyle(YesButton: $YesButton)
            
            // 拒否ボタン
            NoButtonStyle(NoButton: $NoButton)
            
        }   // VStack
    }   // body
}   // View

