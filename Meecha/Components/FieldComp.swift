//
//  FieldComp.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
import SwiftUI

struct  FieldComp: View {
    @State var inputData: String = ""   // 状態変数として紐付け
    
    var body: some View {
        
        TextField("", text: $inputData)
            .zenFont(.regular, size: 12, color: .font)
            .frame(width: 300, height: 45)
            .textFieldStyle(.roundedBorder)
            .onSubmit{
                print("\(inputData)")
            }
            
    }   //body
    
}   //View

#Preview {
    FieldComp(inputData: String())
}
