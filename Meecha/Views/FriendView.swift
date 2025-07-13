//
//  FriendView.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/08.
//
//　フレンド画面
import SwiftUI

struct FriendView: View {
    @State var selectedIndex = 0
    var body: some View {
        ZStack(){
            FriendTabTop(selectedIndex: $selectedIndex)
            
            VStack{
                ScrollView{
                    switch selectedIndex {
                    case 0:
                        FriendConp()
                    case 1:
                        ApprovalComp()
                    case 2:
                        RequestComp()
                    default:
                        MapView()
                    }
                }
            }
            .frame(height: 500)
            .padding(.top)
        }   // ZStack
    }   // body
}   // View
