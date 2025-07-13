//
//  SettingAccountInfo.swift
//  Meecha
//
//  Created by 2230220 on 2025/07/13.
//
//  設定画面のアカウント情報
import SwiftUI

struct SettingAccountInfo: View {
    @State var Myicon: ImageResource
    @State var MyName: String = ""
    @State var MyID: String = ""
    // コピーテキスト
    @State var copyText: String = ""
    //アラート表示
    @State var alertOn = false
    
    var body: some View {
        HStack(spacing: 16){
            // アイコン
            Image(Myicon)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(75)
                // 角丸ボーダー
                .overlay(
                    RoundedRectangle(cornerRadius: 75)
                        .stroke(Color.main, lineWidth: 1)
                )
            
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
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.formBg)
                        .frame(width: 150, height: 25)
                    
                    HStack() {
                        Text("ID：\(MyID)")
                            .zenFont(.medium, size: 16, color: .font)
                            .padding(.leading, 8)
                        
                        Spacer()
                        Button(action: {
                            copyText = MyID
                            UIPasteboard.general.string = copyText
                            alertOn = true
                        }){
                            Image(systemName: "document.on.document.fill")
                                .resizable()
                                .foregroundStyle(Color.formIcon)
                                .frame(width: 15, height: 18)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(.plain)
                        .alert(isPresented: $alertOn) {
                                        Alert(title: Text("コピー"), message: Text("IDをクリップボードにコピーしました"), dismissButton: .default(Text("OK")))
                                    }
                    }
                    .frame(width: 150)
                }
                
            }
        }
    }
}

#Preview {
    SettingAccountInfo(Myicon: .myicon, MyName: "りんご", MyID: "1234567890")
}
