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
            ZStack{
                VStack{
                    HStack {
                        Spacer()
                        FriendSearchButton()
                    }
                    .padding(.trailing, 30)
                    .padding(.top, 60)
                    
                    Spacer()
                }
                
                ZStack{
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
                }
                .padding(.top, 50)
        }
        .edgesIgnoringSafeArea(.all)
    }   // body
}   // View

#Preview {
    FriendView()
}
