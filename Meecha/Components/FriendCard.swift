//
//  FriendCard.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/10.
//
//フレンド画面各カード
import SwiftUI

struct FriendCard: View {
    @State var iconImage: String
    @State var name: String
    var body: some View {
        ZStack{
            // カード背景
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 280, height: 70)
                // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.formBorder, lineWidth: 1)
                )
            
            HStack{
                //アイコン
                AsyncImage(url: URL(string: iconImage)) { resimage in
                    resimage.image?
                        .resizable()
                        .frame(width: 55, height: 55)
                        .cornerRadius(50)
                    // 角丸ボーダー
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.formBorder, lineWidth: 1.5)
                        )
                }   // AsyncImage
                
                Spacer()
                VStack{
                    HStack(spacing: 2){
                        Circle()
                            .fill(Color.formFont)
                            .frame(width: 8, height: 8)
                        Text("どこにいるかわからない")
                            .zenFont(.medium, size: 9, color: .formFont)
                        Spacer()
                    }
                    HStack{
                        //名前
                        Text("\(name)")
                            .zenFont(.medium, size: 14, color: .font)
                        Spacer()
                    }
                }   // VStack
                .frame(width: 130, alignment: .leading)
                
                Spacer()
            }   // HStack
            .frame(width: 250)
            
            //設定ボタン
            Button(action:{
                
            }){
                HStack {
                    Spacer()
                    FriendSettingButton()
                }
            }
            .padding(.bottom, 35)
            .frame(width: 260)
        }   // ZStack
    }   // body
}   // View

#Preview {
    FriendCard(iconImage: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png", name: "かれんこん")
}



