//
//  FieldComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
import SwiftUI
struct forms: Identifiable {
    var id = UUID()
    var title: String = ""
}

struct  FieldComp: View {
    @State var inputData: String = ""   // 状態変数としてTextFieldに紐付け
    var formTitles = [
        forms(title: "メールアドレス"),
        forms(title: "パスワード"),
        forms(title: "パスワード確認")
    ]
    var body: some View {
        
        VStack(spacing: 16) {
            ForEach(formTitles) { Forms in
                VStack(alignment: .leading, spacing: 4) {
                    Text(Forms.title)
                        .zenFont(.medium, size: 12)
                    TextField("", text: $inputData)
                        .zenFont(.regular, size: 12, color: .font)
                        .frame(width: 300, height: 45)
                        .textFieldStyle(.roundedBorder)
                }
            }
        }
        
        
        
    }   //body
}   //View

#Preview {
    FieldComp()
}
