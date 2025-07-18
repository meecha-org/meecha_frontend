//
//  RequestCard.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
//フレンド画面各カード
import SwiftUI

struct RequestCard: View {
    @State var iconUrl: String
    @State var name: String
    
    // リクエストID
    public var requestID: String
    
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
                AsyncImage(url:URL(string: iconUrl)) { response in
                    response.image?
                    .resizable()
                    .frame(width: 55, height: 55)
                    .cornerRadius(50)
                    // 角丸ボーダー
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.main, lineWidth: 1)
                    )
                    
                }
                
                Spacer()
                ZStack{
                    // 名前
                    HStack{
                        Text("\(name)")
                            .zenFont(.medium, size: 14, color: .font)
                        Spacer()
                    }
                    .frame(width: 130, alignment: .leading)
                    
                    NoButtonStyle(NoButton: $NoButton, userID: "", RequestId: requestID)
                        .padding(.leading, 110)
                        .padding(.top, 30)
                }   // ZStack
                
                Spacer()
            }   // HStack
            .frame(width: 250)
        }   // ZStack
    }   // body
}   // View

#Preview {
    RequestCard(iconUrl:"https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png", name: "かれんこん",requestID: "aaa")
}




