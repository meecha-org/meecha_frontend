//
//  FriendMapPinImg.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
//　フレンドのアイコンピン
import SwiftUI

struct FriendMapPinImg: View{
    @State var FriendImg : ImageResource    //フレンドのアイコン
    var body: some View{
        
        ZStack(alignment: .center) {
            Image(.friendPin)
            VStack(alignment: .center) {
                Image(FriendImg)
                    .resizable()
                    .frame(width: 37, height: 37)
                    .cornerRadius(100)
                    .padding(.top, 2.5)
                    .padding(.trailing, 2)
                Spacer()
            }
        }
        .frame(width: 50, height: 50)
    }   //body
}   // View
