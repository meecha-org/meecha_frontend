//
//  FriendMapPinImg.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
//　フレンドのアイコンピン

import SwiftUI

struct FriendMapPinImg: View{
    @State var FriendImg : String    //フレンドのアイコン
    var body: some View{
        
        ZStack(alignment: .center) {
            Image(.friendPin)
            VStack(alignment: .center) {
                AsyncImage(url: URL(string: FriendImg)) { resimage in
                    resimage.image?
                        .resizable()
                        .frame(width: 37, height: 37)
                        .cornerRadius(100)
                        .padding(.top, 2)
                        .padding(.trailing, 1)
                    Spacer()
                }
            }
        }
        .frame(width: 50, height: 50)
    }   //body
}   // View

#Preview {
    FriendMapPinImg(FriendImg: "https://k8s-meecha.mattuu.com/auth/assets/c87bb9f9-c224-4e88-9adb-849614275189.png")
}
