//
//  TextStyleModifier.swift
//  ACHIM-frontend
//
//  Created by 請関花恋 on 2025/06/29.
//

import SwiftUI

struct CustomFontStyle: ViewModifier {
    let name: String
    let size: CGFloat
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
            .foregroundColor(color)
    }
}

extension View {
    func zenFont(_ weight: ZenFontWeight, size: CGFloat, color: Color = .font) -> some View {
        self.modifier(CustomFontStyle(name: weight.fontName, size: size, color: color))
    }
}

enum ZenFontWeight {
    case regular
    case medium
    case bold
    case black
    
    var fontName: String {
        switch self {
        case .regular:
            return "ZenMaruGothic-Regular"
        case .medium:
            return "ZenMaruGothic-Medium"
        case .bold:
            return "ZenMaruGothic-Bold"
        case .black:
            return "ZenMaruGothic-Black"
        }
    }
}
