//
//  CustomTabView.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex = 0
    
    let gradient = LinearGradient(gradient: Gradient(colors: [.clear, .bg]), startPoint: .top, endPoint: .center)
    let tabIcons = ["Users","MapPin", "UserCircle"] //アイコン

    var body: some View {
        ZStack {
            // メイン表示
            ZStack {
                switch selectedIndex {
                case 0:
                    MapView()
                default:
                    MapView()
                }
            }
            
            
            // カスタムタブバー
            VStack {
                Spacer()
                HStack(){
                    HStack(alignment: .bottom) {
                        ForEach(0..<tabIcons.count, id: \.self) { i in
                            Spacer()
                            Button(action: {
                                selectedIndex = i
                            }) {
                                VStack() {
                                    Image(tabIcons[i])
                                        .font(.system(size: 23))
                                        .foregroundColor(selectedIndex == i ? .main : .main) // 色切り替え
                                }
                            }
                            Spacer()
                        }
                    }
                    .frame(width: 360)
                    .padding(.top, 20)
                }   //HStack
                .frame(maxWidth: .infinity, maxHeight: 120)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .background(gradient)
            }
        }   // VStack
        .edgesIgnoringSafeArea(.bottom)
    }   //body
}   // View

#Preview {
    CustomTabView()
}
