//
//  InformationsScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 03/03/2024.
//

import SwiftUI

struct CreditsInformationsScreen: View {
    
    @ObservedObject var bigModel: BigModel
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                BackModel(color: Color.navyBlue, view: .UserView)
                
                //Text("Credits informatiions")
                    //.font(.largeTitle)
                    //.foregroundStyle(Color.navyBlue)
                
                ZStack {
                    Rectangle()
                        .cornerRadius(25)
                        .foregroundStyle(Color.navyBlue)
                    VStack {
                        VStack {
                            
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(.white)
                                Text("Add credits")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            
                            Text("a credit allows you to generate one meal")
                                .foregroundStyle(Color.gray)
                                .font(.footnote)
                        }
                        Spacer()
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(bigModel.currentUser.credits)")
                                    .font(.system(size: 80))
                                    .foregroundStyle(.white)
                                Text("credits left")
                                    .font(.title)
                                    .foregroundStyle(Color.gray)
                            }
                            Spacer()
                        }
                    }.padding(20)
                    
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(25)
                        .foregroundStyle(Color.gray)
                    VStack {
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Image(systemName: "key.horizontal.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(Color.black)
                                Text("Your OpenAI Key")
                                    .font(.title)
                                    .foregroundStyle(Color.black)
                            }
                            Spacer()
                        }
                    }.padding(20)
                    .onTapGesture {
                        bigModel.currentView = .OpenAIKeyScreen
                    }
                    
                }
                
            }.padding(20)
        }
        
    }
}

#Preview {
    CreditsInformationsScreen(bigModel: BigModel.shared)
}
