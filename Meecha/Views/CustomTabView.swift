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
    
    // ユーザーのプロフィール設定
    @State private var UserName: String = ""
    @State private var UserID: String = ""
    
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
                    SettingView(UserName: UserName, UserID: UserID)
                default:
                    MapView()
                }
            }.task {
                do {
                    // 自身の情報取得
                    let response = try await FetchInfo()
                    debugPrint("userInfo: \(response)")
                    
                    // 情報を設定
                    UserName = response.name
                    UserID = response.userId
                } catch {
                    debugPrint(error)
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
        }.task {
            do {
                // 自身の情報取得
                let response = try await FetchInfo()

                debugPrint("name:\(response.name) userId:\(response.userId) ")
                
                // 情報を設定
                UserName = response.name
                UserID = response.userId
            } catch {
                debugPrint(error)
            }
        }   // VStack
        .edgesIgnoringSafeArea(.all)
    }   //body
}   // View

#Preview {
    CustomTabView()
}
