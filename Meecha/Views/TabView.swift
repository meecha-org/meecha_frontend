////
////  TabView.swift
////  Meecha
////
////  Created by 2230220 on 2025/06/29.
////
//
//import SwiftUI
//
//struct TabView: View {
//    @State private var selectedIndex = 0
//
//    let tabIcons = ["crown", "gift", "house", "heart.text.clipboard", "person.circle"]
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // メイン表示
//            ZStack {
////                switch selectedIndex {
////                case 0:
////                    
////                case 1:
////                    
////                case 2:
////                    
////                case 3:
////                    
////                case 4:
////                    
////                case 5:
////                    
////                default:
////
////                }
//            }
//
//            // カスタムタブバー
//            HStack{
//                HStack {
//                    ForEach(0..<tabIcons.count, id: \.self) { i in
//                        Spacer()
//                        Button(action: {
//                            selectedIndex = i
//                        }) {
//                            VStack {
//                                Image(systemName: tabIcons[i])
//                                    .font(.system(size: 23))
//                                    .foregroundColor(selectedIndex == i ? .baseSky : .white) // 色切り替え
//                            }
//                        }
//                        Spacer()
//                    }
//                }
//                .frame(width: 360)
//            }
//            .frame(maxWidth: .infinity, maxHeight: 70)
//            .padding(.top, 10)
//            .padding(.bottom, 20)
//            .background(Color.navy.shadow(radius: 2))
//        }
//        .edgesIgnoringSafeArea(.bottom)
//    }
//}
//
//#Preview {
//    TabView()
//}
