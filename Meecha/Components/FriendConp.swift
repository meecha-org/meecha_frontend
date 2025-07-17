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
    @State private var users: [Friend] = []
    var (friends, error) = getFriendList()
    var body: some View {
        VStack{
//            ForEach(friendsModel.friends){ i in
//                FriendCard(iconImage: i.iconImage, name: i.name)
//            }
            ForEach(users){ i in
                FriendCard(iconImage: "https://k8s-meecha.mattuu.com/auth/assets/\(i.id).png", name: i.name)
            }
        }
        .frame(width: 300)
        .padding(.top, 10)
        .onAppear {
            do {
                // フレンド一覧取得
                if let error = error {
                    print("エラーが発生しました: \(error.localizedDescription)")
                } else if let friends = friends {
                    print("フレンドリスト:")
                    
                    // 既存のフレンドリクエストを全て削除する
                    friendsModel.friends.removeAll()
                    
                    // フレンドを回す
                    for friend in friends {
                        print("- 名前: \(friend.name), ID: \(friend.id)")
                        
                        // フレンドデータを追加する
                        friendsModel.friends.append(FriendData(name: friend.name, coordinate: .ECC, iconImage: .iconSample, id:friend.id))
                    }
                }
            } catch {
                debugPrint(error)
            }
        }
    }   // body
}   // View

#Preview {
    FriendConp()
}

