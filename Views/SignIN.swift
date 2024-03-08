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
    @ObservedObject var bigModel: BigModel
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("sign-in")
                    .bold()
                    .foregroundStyle(Color(.navyBlue))
                
                Spacer()
                
                //VStack {
                                        
                    /*HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            Text("sign-in")
                                .textCase(.uppercase)
                                .foregroundStyle(Color.navyBlue)
                                .font(.system(size: 75))
                        }
                    }*/
                    
                    //Spacer()
                    
                    //Circle()
                        //.foregroundStyle(Color.navyBlue)
                        //
                        // IMPORTANT - Ce code ne sert qu'à insérer la clé OpenAI API dans le keychain du compte Apple
                        //             et ne devrait pas exister, mais on n'a pas trouvé comment mettre la clé dans la keychain
                        //             autrement.
                        //
                        //             On ne doit mettre la clé dans le code que de manière TRES TEMPORAIRE, juste le temps de
                        //             la stocker dans la keychain. Et ensuite on doit l'enlever pour éviter qu'elle se retrouve
                        //             sur Github
                        //
                        /*.onTapGesture {
                            //
                            let keychain = Keychain(service: "net.proutechos.openai")
                            keychain["key.teevity.dev001"] = "enter-your-key-here"
                        }*/
                    
                    //Spacer()
                    
                    VStack(alignment: .leading) {
                        
                        Image("Sans titre 40")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                bigModel.createMeals(mealType: "", mealsNumber: 0)
                            }
                        
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

                            //Rectangle().fill(Color.navyBlue).frame(height: 1)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            /*Text("Sign in with Google")
                                .foregroundStyle(Color.navyBlue)
                                .font(.largeTitle)*/
                            
                            ZStack {
                                Rectangle()
                                    .cornerRadius(60)
                                    .frame(height: 60)
                                HStack {
                                    Image("white-google-logo")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text("Sign in with Google")
                                        .foregroundStyle(Color.white)
                                }
                            }.overlay(content: {
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
                                }.blendMode(.overlay)
                            })
                        }
                        
                    }
                
                Spacer()
                
                Spacer()
                    
                //}.padding(20)
                
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

extension View {
    func getRootViewController () -> UIViewController {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
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
        SignIN(bigModel: BigModel.mocked)
    }
}
