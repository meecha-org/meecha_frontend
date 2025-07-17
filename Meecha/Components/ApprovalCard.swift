//
//  ApprovalCard.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/12.
//

//フレンド画面各カード
import SwiftUI

struct ApprovalCard: View {
    @State var iconImage: ImageResource
    @State var name: String
    
    @State var YesButton: Bool = false  // 承認ボタン
    @State var NoButton: Bool = false   // 拒否ボタン
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
                
                // 名前・ボタン
                ZStack{
                    HStack{
                        //名前
                        Text("\(name)")
                            .zenFont(.medium, size: 14, color: .font)
                        Spacer()
                    }
                    .frame(width: 130, alignment: .leading)
                    
                    ApprovalButton(YesButton: $YesButton, NoButton: $NoButton)
                        .padding(.leading, 110)
                        .padding(.top, 30)
                }   // ZStack
                
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
    ApprovalCard(iconImage: .iconSample, name: "かれんこん")
}




