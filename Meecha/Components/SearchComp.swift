//
//  SearchComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/18.
//
import SwiftUI

struct SearchComp: View {
    @StateObject private var userSearchDataModel = UserSearchDataModel()
    @State public var searchText: String;
    
    var body: some View {
        VStack{
            ForEach(userSearchDataModel.UserSearch){ i in
                SearchCard(iconUrl: i.ImageURL, name: i.targetName, UserId: i.id)
            }
        }.task {
            // フレンドを検索する
            let (result,success) = searchFriend(name: searchText)
            
            // 成功したかどうか
            if success {
                // 成功した場合
                // 全て削除する
                userSearchDataModel.UserSearch.removeAll()
                
                debugPrint(result)
                
                for resultUser in result {
                    // データを追加する
                    userSearchDataModel.UserSearch.append(UserSearchData(id: resultUser.userid, targetName: resultUser.name, ImageURL: "https://k8s-meecha.mattuu.com/auth/assets/\(resultUser.userid).png"))
                }
            }
        }
        .frame(width: 300)
        .padding(.top, 10)
    }
}
#Preview {
    SearchComp(searchText: "")
}

