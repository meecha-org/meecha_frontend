//
//  NextBackButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

//戻るボタン
struct BackButton: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.meechaRed)
                .frame(width: 54, height: 37)
            Text("戻る")
                .zenFont(.bold, size: 14, color: .white)
        }
    }
}

// 決定ボタン
struct NextButton: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.main)
                .frame(width: 54, height: 37)
            Text("決定")
                .zenFont(.bold, size: 14, color: .white)
        }
    }
}
#Preview {
    BackButton()
    NextButton()
}
