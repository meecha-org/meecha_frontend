//
//  ToggleStyle.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/16.
//

import SwiftUI

struct NewToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        // トグルのUIコンポーネント
        HStack {
            
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 38, height: 26, alignment: .center)
                .overlay((
                    Circle()
                        .foregroundColor(Color(.systemBackground))
                        .padding(3.5)
                        .offset(x: configuration.isOn ? 7 : -7, y: 0)
                        .animation(.spring)
                ))
                .foregroundColor(configuration.isOn ? .main : .gray)
                .onTapGesture(perform: {
                    configuration.isOn.toggle()
                })
            
        }
    }
    
}

