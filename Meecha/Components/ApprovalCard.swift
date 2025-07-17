//
//  ApprovalCard.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/12.
//

//フレンド画面各カード
import SwiftUI

struct ApprovalCard: View {
    @State var iconUrl: String
    @State var name: String
    
    @State var isSetting: Bool = false
    // リクエストID
    public var requestId: String
    
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
                AsyncImage(url: URL(string: iconUrl)) { response in
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
                
                // 名前・ボタン
                ZStack{
                    HStack{
                        //名前
                        Text("\(name)")
                            .zenFont(.medium, size: 14, color: .font)
                        Spacer()
                    }
                    .frame(width: 130, alignment: .leading)
                    
                    ApprovalButton(YesButton: $YesButton, NoButton: $NoButton,RequestId: requestId)
                        .padding(.leading, 110)
                        .padding(.top, 30)
                }   // ZStack
                
                Spacer()
            }   // HStack
            .frame(width: 250)
           
            //設定ボタン
            Button(action:{
                isSetting = true
            }){
                HStack {
                    Spacer()
                    FriendSettingButton()
                }
            }
            .padding(.bottom, 35)
            .frame(width: 260)
            if isSetting {
                HStack {
                    Spacer()
                    FriendSettingFrame()
                }
                .padding(.bottom, 50)
                .frame(width: 330)
            }
        }   // ZStack
        .frame(height: 90)
        .onTapGesture {
            isSetting = false
        }
    }   // body
}   // View

#Preview {
    ApprovalCard(iconUrl: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png", name: "かれんこん",requestId: "aaa")
}




