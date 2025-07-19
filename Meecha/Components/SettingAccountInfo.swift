//
//  SettingAccountInfo.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
//  設定画面のアカウント情報
import SwiftUI

struct SettingAccountInfo: View {
    @State var MyName: String = ""
    @State var MyID: String = ""
    // コピーテキスト
    @State var copyText: String = ""
    //アラート表示
    @State var alertOn = false
    
    var body: some View {
        HStack(spacing: 16){
            // アイコン
            AsyncImage(url: URL(string: "https://k8s-meecha.mattuu.com/auth/assets/\(MyID).png")) {response in
                response.image?
                    .resizable()
                    .frame(width: 120, height: 120)
                    .cornerRadius(75)
                // 角丸ボーダー
                    .overlay(
                        RoundedRectangle(cornerRadius: 75)
                            .stroke(Color.main, lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading){
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .frame(width: 150, height: 45)
                        // 角丸ボーダー
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.main, lineWidth: 1)
                        )
                    Text(MyName)
                        .zenFont(.medium, size: 16, color: .font)
                }
            }
        }
    }
}

#Preview {
    SettingAccountInfo(MyName: "りんご", MyID: "1234567890")
}
