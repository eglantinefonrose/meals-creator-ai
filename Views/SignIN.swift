//
//  SignIN.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI
import Combine
import Firebase
import FirebaseAuth
import AuthenticationServices
import GoogleSignIn
import GoogleSignInSwift
import KeychainAccess

struct SignIN: View {
    
    @State var username = ""
    @State var password = ""
    @EnvironmentObject var bigModel: BigModel
    
    
    var body: some View {
        
        VStack {
            
            VStack {
                
                BackModel(color: Color.navyBlue, view: .signInView)
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("SIGN")
                            .foregroundStyle(Color.navyBlue)
                            .font(.system(size: 75))
                        Text("IN")
                            .foregroundStyle(Color.navyBlue)
                            .font(.system(size: 75))
                    }
                }
                
                Spacer()
                
                Circle()
                    .foregroundStyle(Color.navyBlue)
                    .onTapGesture {
                        let keychain = Keychain(service: "net.proutechos.openai")
                        keychain["key.teevity.dev001"] = "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"
                    }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        /*Text("Sign in with Apple")
                            .foregroundStyle(Color.navyBlue)
                            .font(.largeTitle)*/
                        
                        SignInWithAppleButton { (request) in
                            
                            bigModel.updateNonce()
                            request.requestedScopes = [.email,. fullName]
                            
                        } onCompletion: { (result) in
                            
                        switch result {
                            case .success(let user):
                                //print("success")
                                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                    print("error with firebase")
                                    return
                                }
                                bigModel.authentificateWithApple(credential: credential)
                            
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                            
                        }.clipShape(Capsule())
                        .frame(height: 60)

                        
                        Rectangle().fill(Color.navyBlue).frame(height: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        /*Text("Sign in with Google")
                            .foregroundStyle(Color.navyBlue)
                            .font(.largeTitle)*/
                        
                        GoogleSignInButton {
                            
                            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                            
                            // Create Google Sign In configuration object.
                            let config = GIDConfiguration(clientID: clientID)
                            GIDSignIn.sharedInstance.configuration = config
                            
                            // Start the sign in flow!
                            GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                                
                                guard error == nil else {
                                    return
                                }
                                                                
                                guard let user = result?.user,
                                      let idToken = user.idToken?.tokenString
                                
                                else {
                                    return
                                }
                                
                                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                                
                                Auth.auth().signIn(with: credential) { result, error in
                                    
                                    guard error == nil else {
                                        return
                                    }
                                    
                                    bigModel.googleSignInUserUpdate()
                                    
                                }
                            }
                        }
                    }
                }
                
            }.padding(20)
            
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

class KeyboardHeightHelper: ObservableObject {
    
    @Published var keyboardHeight: CGFloat = 0
    
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
           object: nil,
           queue: .main) { (notification) in
            guard let userInfo = notification.userInfo,
                let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            self.keyboardHeight = keyboardRect.height
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
           object: nil,
           queue: .main) { (notification) in
            self.keyboardHeight = 0
        }
    }
    
    init() {
        self.listenForKeyboardNotifications()
    }
    
}

struct SignIN_Previews: PreviewProvider {
    static var previews: some View {
        SignIN()
    }
}
