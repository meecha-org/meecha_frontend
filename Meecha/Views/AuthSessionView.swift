//
//  AuthSessionView.swift
//  auth-test
//
//  Created by mattuu0 on 2025/05/18.
//


import SwiftUI
import AuthenticationServices

struct AuthSessionView: UIViewControllerRepresentable {
    var callback: (URL, Bool) -> Void
    
    let authURL = "https://k8s-meecha.mattuu.com/auth/oauth/google?ismobile=1"
    
    let customURLScheme = "authbase"
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        guard let url = URL(string: authURL) else {
            return viewController
        }
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: customURLScheme) { callbackURL, error in
                if let callbackURL {
                    callback(callbackURL, true) // 成功
                } else if let error {
                    debugPrint(error.localizedDescription)
                    debugPrint("error")
                    callback(URL(filePath: "")!, false) // 失敗
                }
            }
        
        session.prefersEphemeralWebBrowserSession = false
        session.presentationContextProvider = context.coordinator
        
        session.start() // 認証セッション開始、アプリ内ブラウザ起動
        
     
        return viewController
    }
    
    func updateUIViewController(_: UIViewController, context _: Context) {}
}

class Coordinator: NSObject, ASWebAuthenticationPresentationContextProviding {
    var parent: AuthSessionView
    
    init(parent: AuthSessionView) {
        self.parent = parent
    }
    
    func presentationAnchor(for _: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else {
            fatalError("No windows in the application")
        }
        return window
    }
}

