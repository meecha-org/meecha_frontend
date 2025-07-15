//
//  MeechaApp.swift
//  Meecha
//
//  Created by 2230220 on 2025/06/29.
//
import SwiftUI

@main
struct MeechaApp: App {
    @State var loginState: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack{
                if(loginState){
                    CustomTabView()
                }else{
                    LoginView(loginButton: $loginState)
                }
            }
        }
    }
}
