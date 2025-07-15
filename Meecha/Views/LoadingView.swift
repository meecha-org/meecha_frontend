//
//  LoadingView.swift
//  Meecha
//
//  Created by mattuu0 on 2025/07/15.
//

import SwiftUI

// LoadingView.swift
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("読み込み中...")
                .padding(.top)
        }
    }
}
