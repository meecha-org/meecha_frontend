//
//  FriendMapPin.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/03.
//
import SwiftUI

struct FriendMapPin: View{
    var body: some View{
        
        ZStack(alignment: .center) {
            Image(.friendPin)
            VStack(alignment: .center) {
                Image(.iconSample)
                    .resizable()
                    .frame(width: 37, height: 37)
                    .cornerRadius(100)
                    .padding(.top, 2.5)
                    .padding(.trailing, 2)
                Spacer()
            }
        }
        .frame(width: 50, height: 50)
            
    }
}

#Preview {
    FriendMapPin()
}
