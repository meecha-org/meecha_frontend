//
//  FriendConp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/12.
//
//
import SwiftUI

struct FriendConp: View {
    @StateObject private var friendsModel = FriendModel()
    var body: some View {
        VStack{
            ForEach(friendsModel.friends){ i in
                FriendCard(iconImage: i.iconImage, name: i.name)
            }
        }
        .frame(width: 300)
        .padding(.top, 10)
    }
}

#Preview {
    FriendConp()
}

