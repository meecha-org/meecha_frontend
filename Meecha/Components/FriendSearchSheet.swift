//
//  FriendSearchSheet.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
import SwiftUI

struct FriendSearchSheet: View {
    @State var isSearchText: String = ""
    @State var isSearchButton: Bool = false
    @State var searchText : String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Text("ユーザー検索")
                .zenFont(.medium, size: 14, color: .font)
                .padding(.top, 24)
            HStack(spacing: 4){
                // 検索フィールド
                ZStack{
                    TextField("ユーザーネーム", text: $isSearchText)
                        .zenFont(.regular, size: 12, color: .font)
                        .frame(width: 200)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)    //キーボードの種類指定
                        .onSubmit{
//                            print("\(isSearchText)")
                            // 検索を実装する
                            searchText = isSearchText
                        }
                        // 角丸ボーダー
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.main, lineWidth: 1)
                        )
                    HStack{
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.icon)
                    }
                    .frame(width: 180)
                }   // 検索フィールド
                
                // 検索ボタン
                Button(action:{
                    print("\(isSearchText)")
                    isSearchButton = true
                    searchText = isSearchText
                }){
                    ZStack{
                        if isSearchText.isEmpty {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 40, height: 35)
                                .foregroundStyle(Color.formFont)
                        } else{
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 40, height: 35)
                                .foregroundStyle(Color.main)
                        }
                        Text("検索")
                            .zenFont(.bold, size: 10, color: .white)
                    }
                }   // 検索ボタン
            }   // HStack
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .frame(width: 330, height: 350)
                // 角丸ボーダー
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.main, lineWidth: 1)
                    )
                
                ScrollView{
                    if isSearchButton {
                        SearchComp(searchText: searchText)
                    }
                }
            }
            Spacer()
        }   // VStack
        .frame(height: 450)
    }   // body
}   // View

#Preview {
    FriendSearchSheet()
}
