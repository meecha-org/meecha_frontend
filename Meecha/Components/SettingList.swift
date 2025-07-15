//
//  SettingList.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/15.
//
import SwiftUI

struct SettingList: View {
    var ListText: String = ""
    
    var body: some View {
            HStack{
                Text("\(ListText)")
                    .zenFont(.medium, size: 12, color: .font)
                Spacer()
                Image(systemName: "chevron.right")
                    .resizable()
                    .foregroundStyle(Color.formIcon)
                    .frame(width: 6, height: 11)
            }
            .frame(width: 270)
    }
}

#Preview {
    SettingList()
}
