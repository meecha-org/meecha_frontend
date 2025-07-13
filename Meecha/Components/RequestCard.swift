//
//  RequestCard.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
//フレンド画面各カード
import SwiftUI

struct RequestCard: View {
    @State var iconImage: ImageResource
    @State var name: String
    
    @State var YesButton: Bool = false
    @State var NoButton: Bool = false
    var body: some View {
        ZStack{
            // カード背景
            RoundedRectangle(cornerRadius: 9)
                .fill(Color.white)
                .frame(width: 280, height: 70)
                // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.main, lineWidth: 1.5)
                )
            
            // カードコンテンツ
            HStack{
                //アイコン
                Image(iconImage)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .cornerRadius(50)
                // 角丸ボーダー
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.main, lineWidth: 1)
                    )
                
                Spacer()
                
                // 名前
                HStack{
                    Text("\(name)")
                        .zenFont(.medium, size: 14, color: .font)
                    Spacer()
                }
                .frame(width: 130, alignment: .leading)
                
                Spacer()
            }   // HStack
            .frame(width: 250)
        }
    }
}

#Preview {
    RequestCard(iconImage: .iconSample, name: "かれんこん")
}




