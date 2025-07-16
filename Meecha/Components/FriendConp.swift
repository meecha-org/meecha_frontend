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
        .task {
            do {
                // フレンド一覧取得
                let (friends, error) = getFriendList()
                
                if let error = error {
                    print("エラーが発生しました: \(error.localizedDescription)")
                } else if let friends = friends {
                    print("フレンドリスト:")
                    
                    for friend in friends {
                        print("- 名前: \(friend.name), ID: \(friend.id)")
                    }
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}

#Preview {
    FriendConp()
}

