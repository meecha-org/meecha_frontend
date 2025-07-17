//
//  RequestButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

// 申請
struct  RequestButton: View {
    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.main)
                    .frame(width: 44, height: 22)
                Text("申請")
                    .zenFont(.medium, size: 12, color: .white)
            }
    }   //body
}   // View
