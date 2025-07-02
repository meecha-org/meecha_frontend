//
//  LoginView.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
import SwiftUI
struct LoginView: View {
    @State var inputMail: String = ""
    @State var inputPass: String = ""
    @State var inputPassConf: String = ""
//        forms(title: "メールアドレス"),
//        forms(title: "パスワード"),
//        forms(title: "パスワード確認")
    
    var body: some View {
        ZStack{
            Color.bg
                .ignoresSafeArea()
            
            VStack(alignment: .center){
                Image(.meechaLogo)  //ロゴ
                    .padding(.top, 100)
    
                Spacer()
                //ログインフォーム
                VStack(alignment: .center, spacing: 40){
                    //メールアドレス
                    VStack(alignment: .leading, spacing: 0){
                        Text("メールアドレス")
                            .zenFont(.medium, size: 12)
                        TextField("", text: $inputMail)
                            .zenFont(.regular, size: 12, color: .font)
                            .frame(width: 300, height: 45)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .onSubmit{
                                print("\(inputMail)")
                            }
                            
                    }
                    //パスワード
                    VStack(alignment: .leading, spacing: 0){
                        Text("パスワード")
                            .zenFont(.medium, size: 12)
                        TextField("", text: $inputPass)
                            .zenFont(.regular, size: 12, color: .font)
                            .background(Color.clear)
                            .frame(width: 300, height: 45)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numbersAndPunctuation)
                            .onSubmit{
                                print("\(inputPass)")
                            }
                        HStack {
                            Spacer()
                            Text("パスワードを忘れた方はこちら")
                                .zenFont(.medium, size: 10, color: .formFont)
                        }
                    }
                }   //VStack
                .frame(width: 300)
                Spacer()
            }   //VStack
        }   //ZStack
    }   //body
}   //View

#Preview {
    LoginView()
}
