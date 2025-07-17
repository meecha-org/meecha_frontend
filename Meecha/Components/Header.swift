//
//  Header.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/07.
//
//  ヘッダー
import SwiftUI

struct Header: View {
    let gradient = LinearGradient(gradient: Gradient(colors: [.bg, .clear]), startPoint: .center, endPoint: .bottom)
    var body: some View {
            HStack{
                Image(.logoSmall)
            }
            .padding(.top, 60)
    }
}
#Preview {
    Header()
}
