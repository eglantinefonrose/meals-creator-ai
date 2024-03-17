//
//  OpenAIKeyScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 04/03/2024.
//

import SwiftUI
import KeychainAccess
import LocalAuthentication

struct OpenAIKeyScreen: View {
    
    @ObservedObject var bigModel: BigModel
    @State var openAIKey: String = ""
    
    var body: some View {
        
        ZStack {
            
            Color(.midGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack {
                    
                    BackModel(color: Color(.white), view: .OpenAIKeyScreen)
                    
                    Spacer()
                    
                    VStack(spacing: 50) {
                        
                        VStack(spacing: 10) {
                            Text("Your OpenAI key")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                            
                            Text("enter your key to generate meals using your OpenAI account")
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        HStack(spacing: 10) {
                            SecureInputView("Password", text: $openAIKey)
                                .disableAutocorrection(true)
                                .padding(10)
                                .autocapitalization(.none)
                                .background(Color.white)
                                .cornerRadius(15)
                        }
                        
                        Text("By connecting your OpenAI account to your MiamAI account, you can use your OpenAI tokens instead of MiamAI credits to generate yummy meals recipes.")
                            .multilineTextAlignment(.center)
                        
                    }
                    
                    Spacer()
                    
                }.padding(.horizontal, 20)
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(openAIKey == "" ? Color(.lightGray) : Color.gray)
                        .frame(height: 60)
                    Text("Save key")
                        .foregroundStyle(openAIKey == "" ? Color.gray : Color.white)
                        .fontWeight(.medium)
                }.onTapGesture {
                    bigModel.setSecretKey(secretKey: openAIKey)
                }
                
            }
            .padding(.top, 20)
            .edgesIgnoringSafeArea(.bottom)
        }.onAppear(perform: {
            if bigModel.currentUser.isUsingPersonnalKey {
                openAIKey  = bigModel.openAIKey
            }
        })
        
    }
    
}

struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private var title: String
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
    
    var body: some View {
        HStack {
            ZStack(alignment: .trailing) {
                Group {
                    if isSecured {
                        SecureField(title, text: $text)
                    } else {
                        TextField(title, text: $text, axis: .vertical)
                    }
                }.padding(.trailing, 32)
            }
            Button(action: {
                
                let context = LAContext()
                var error: NSError?

                // check whether biometric authentication is possible
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    // it's possible, so go ahead and use it
                    let reason = "We need to unlock your data."

                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                        // authentication has now completed
                        if success {
                            isSecured.toggle()
                        } else {
                            print("wrong face")
                        }
                    }
                } else {
                    // no biometrics
                }
                
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(.gray)
            }
        }
    }
}

#Preview {
    OpenAIKeyScreen(bigModel: BigModel.shared)
}
