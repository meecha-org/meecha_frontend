//
//  ErrorView.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/15.
//

import SwiftUI

// ErrorView.swift
struct ErrorView: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("エラーが発生しました")
                .padding()
        }
    }
}
