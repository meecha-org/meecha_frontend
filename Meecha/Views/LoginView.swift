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
    @Binding var loginButton: Bool
    @State var googleButton: Bool = false
    @State var IsLogin: Bool = false
    
    @State private var code: String?
    
    var body: some View {
        ZStack{
            Color.bg.ignoresSafeArea()
            
            VStack(alignment: .center){
                Image(.meechaLogo)  //ロゴ
                    .padding(.top, 96)
                
                Spacer()
                
                VStack(spacing: 40) {
                    //Googleログイン
                    Button(action:{
                        googleButton = true
                        // 画面を遷移する
                        print("Googleログイン")
                        
                    }){
                        Image(.iosNeutralSqSI)
                    }
                    .buttonStyle(.plain)
                    .fullScreenCover(isPresented: $googleButton) {
                        AuthSessionView { callbackURL,isSuccess in
                            self.code = getCode(callbackURL: callbackURL)
                            
                            if isSuccess {
                                print("Login success")
                                
                                Task {
                                    let userInfo = try await FetchInfo()
                                    
                                    if userInfo.userId != "" {
                                        // ログインに成功した時
                                        IsLogin = true
                                    }
                                }
                            } else {
                                print("Login failed")
                            }
                            
                            googleButton = false;
                        }
                    }
                    
                }   //VStack
                .frame(width: 300)
                Spacer()
            }   //VStack
            .ignoresSafeArea(.keyboard, edges: .bottom)
            
        }   //ZStack
    }   //body
    
    func getCode(callbackURL: URL) -> String? {
        print(callbackURL);
        guard let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems
        else {
            return nil
        }
        if let codeValue = queryItems.first(where: { $0.name == "token" })?.value {
            print("Code value: \(codeValue)")
            saveKeyChain(tag: "authToken", value: codeValue);
            return codeValue
        } else {
            return nil
        }
    }
    
}   //View
