//
//  RequestData.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
// 申請中ユーザー_サンプル
import SwiftUI
import Foundation

// Identifiableプロトコル ⇨ 値が一意(ユニーク)であることを保証する
struct RequestData: Identifiable {
    let name: String    // 名前
    let iconImage: ImageResource
    let id = UUID()     // 識別するためのIDを生成
}

class RequestModel: ObservableObject {
    // Viewに通知するため @Published をつける
        @Published var requests: [RequestData] = []

    init(){
        //仮データ
        requests = [
            RequestData(name: "rinringogogo", iconImage: .iconSample9),
            RequestData(name: "ジェシカ", iconImage: .iconSample10),
            RequestData(name: "hanacoi", iconImage: .iconSample11)
        ]
    }
}
