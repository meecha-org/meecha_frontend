//
//  LoginView.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
//  ログイン画面
import SwiftUI
struct LoginView: View {
    @State var inputMail: String = ""
    @State var inputPass: String = ""
    @State var inputPassConf: String = ""
    
    //ボタン
    @State var googleButton: Bool = false
//    @State var IsLogin: Bool = false
    @AppStorage("isLoggedState") var isLoggedState: Bool = false

    @State private var code: String?
    
    var body: some View {
        if isLoggedState {
            CustomTabView()
        } else {
            ZStack{
                Color.bg.ignoresSafeArea()
                
                VStack(alignment: .center){
                    Image(.meechaLogo)  //ロゴ
                        .padding(.top, 96)
                    
                    Spacer()
                    
                    VStack(spacing: 40) {
                        //ログインフォーム
                        VStack(alignment: .center, spacing: 32){
                            //メールアドレス
                            VStack(alignment: .leading, spacing: 0){
                                Text("メールアドレス")
                                    .zenFont(.medium, size: 12)
                                TextField("", text: $inputMail)
                                    .zenFont(.regular, size: 12, color: .font)
                                    .frame(width: 300)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.emailAddress)    //キーボードの種類指定
                                    .onSubmit{
                                        print("\(inputMail)")
                                    }
                            }   // VStack メールアドレス
                            
                            //パスワード
                            VStack(alignment: .leading, spacing: 0){
                                Text("パスワード")
                                    .zenFont(.medium, size: 12)
                                TextField("", text: $inputPass)
                                    .zenFont(.regular, size: 12, color: .font)
                                    .background(Color.white)
                                    .frame(width: 300)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.asciiCapable)
                                    .onSubmit{
                                        print("\(inputPass)")
                                    }
                                HStack {
                                    Spacer()
                                    Text("パスワードを忘れた方はこちら")
                                        .zenFont(.medium, size: 10, color: .formFont)
                                }   // HStack
                            }   // VStack パスワード
                        }   // VStack ログインフォーム
                        
                        //Googleログイン
                        Button(action:{
                            googleButton = true
                            // 画面を遷移する
                            print("Googleログイン")
                            
                        }){
                            Image(.iosNeutralSqSI)
                        }   // Googleログインボタン
                        .buttonStyle(.plain)
                        .fullScreenCover(isPresented: $googleButton) {
                            AuthSessionView { callbackURL,isSuccess in
                                self.code = getCode(callbackURL: callbackURL)
                                
                                if isSuccess {
                                    print("Login success")
                                    
                                    Task {
                                        let userInfo = try await FetchInfo()
                                        
                                        if userInfo.userId != "" {
                                            // トークンを設定する
                                            AuthTokenManager.shared.refreshToken = getKeyChain(key: Config.rfTokenKey)
                                            
                                            // ログインに成功した時
                                            isLoggedState = true
                                            
                                        }
                                    }
                                } else {
                                    print("Login failed")
                                }
                                
                                googleButton = false;
                            }
                        }   // else
                    }   //VStack
                    .frame(width: 300)
                    
                    //ログインボタン
                    Button(action: {
                        isLoggedState = true
                        print("ログイン: mail: \(inputMail), pass: \(inputPass)")
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.main)
                                .frame(width: 95, height: 45)
                                .shadow(radius: 2, x: 0, y: 4)
                            Text("ログイン")
                                .zenFont(.bold, size: 16, color: .white)
                        }   //ZStack
                    }   //Button
                    .buttonStyle(.plain)
                    .padding(.top, 64)
                    
                    Spacer()
                }   //VStack
                .ignoresSafeArea(.keyboard, edges: .bottom)
                
            }   //ZStack
        }
    }   //body
}   //View
