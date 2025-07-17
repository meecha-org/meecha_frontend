//
//  FriendSearchButton.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/17.
//
import SwiftUI

struct FriendSearchButton: View {
    @State private var showModalSheet = false   // ハーフシート表示
    var body: some View {
        Button(action:{
            showModalSheet = true
        }){
            Image(systemName: "person.badge.plus")
                .resizable()
                .frame(width: 34, height: 32)
                .foregroundStyle(Color.icon)       
        }
        .sheet(isPresented: $showModalSheet) {
            VStack{
                
            }
            .presentationDetents([.height(500)])

        }
        
    }
}

#Preview {
    FriendSearchButton()
}
