//
//  CustomTabView.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex = 1
    let tabIcons = ["Users","MapPin", "UserCircle"] //アイコン
    let tabIconFill = ["UsersFill","MapPinFill","UserCircleFill"]
    
    // App全体でログイン状態を記録
    @AppStorage("isLoggedState") var isLoggedState: Bool = false

    var body: some View {
        if !isLoggedState {
            LoginView()
        }
        ZStack {
            Color.bg.ignoresSafeArea()
            // 表示する画面
            ZStack {
                switch selectedIndex {
                case 0:
                    FriendView()
                case 1:
                    MapView()
                case 2:
                    SettingView()
                default:
                    MapView()
                }
            }
            
            
            // カスタムタブバー
            VStack {
                Header()
                Spacer()
                
                ZStack {
                   
                    HStack(){
                        HStack(alignment: .bottom) {
                            ForEach(0..<tabIcons.count, id: \.self) { i in
                                Spacer()
                                Button(action: {
                                    selectedIndex = i
                                }) {
                                    VStack() {
                                        //選択されている画面のアイコンを変える
                                        if(selectedIndex == i){
                                            Image(tabIconFill[i])
                                                .font(.system(size: 23))
                                                .foregroundColor(selectedIndex == i ? .main : .main) // 色切り替え
                                        }else{
                                            Image(tabIcons[i])
                                                .font(.system(size: 23))
                                                .foregroundColor(selectedIndex == i ? .main : .main) // 色切り替え
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        .frame(width: 360)
                        .padding(.top, 20)
                    }   //HStack
                    .padding(.top, 10)
                    .padding(.bottom, 50)
                }
            }
        }   // VStack
        .edgesIgnoringSafeArea(.all)
    }   //body
}   // View

#Preview {
    CustomTabView()
}
