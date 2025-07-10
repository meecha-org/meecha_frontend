//
//  FriendTabTop.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/09.
//
import SwiftUI

struct FriendTabTop: View {
    @State private var selectedIndex = 0
    let tabText = ["フレンド","承認前", "申請中"]//アイコン
    
    var body: some View {
        VStack(spacing: 0) {
//            Color.bg.ignoresSafeArea()
            VStack {
                ZStack(){
                    //緑のボーダー
                    Rectangle()
                        .fill(Color.main)
                        .frame(width: 322, height: 60)
                        .padding(.top, 34)
                    // ページ選択タブ上部
                    HStack() {
                        ForEach(0..<tabText.count, id: \.self) { i in
                            Spacer()
                            ZStack {
                                //緑のボーダー
                                Rectangle()
                                    .fill(Color.main)
                                    .frame(width: 102, height: 60)
                                    //一部角丸
                                    .clipShape(.rect(
                                        topLeadingRadius: 11,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 11
                                    ))
                                // ページ選択ボタン
                                Button(action: {
                                    selectedIndex = i
                                    print(selectedIndex)
                                }) {
                                    ZStack() {
                                        //選択されている画面のアイコンを変える
                                        if(selectedIndex == i){
                                            //白背景
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: 100, height: 50)
                                                .padding(.bottom, 8)
                                                //一部角丸
                                                .clipShape(.rect(
                                                    topLeadingRadius: 10,
                                                    bottomLeadingRadius: 0,
                                                    bottomTrailingRadius: 0,
                                                    topTrailingRadius: 10
                                                ))
                                            //ページタイトル
                                            Text(tabText[i])
                                                .zenFont(.bold, size: 14, color: .font)
                                                .padding(.bottom, 24)
                                        }else{
                                            //ページタイトル
                                            Text(tabText[i])
                                                .zenFont(.bold, size: 14, color: .white)
                                                .padding(.bottom, 24)
                                        }
                                    }   //ZStack
                                }   // Button
                                .buttonStyle(.plain)
                            }   // ZStack
                        }   // ForEach
                        Spacer()
                    }   // HStack
                    .padding(.bottom, 32)
                }   // ZStack
            }   // VStack
        }   // VStack
        .frame(width: 330)
    }   // body
}
