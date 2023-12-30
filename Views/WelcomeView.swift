//
//  NewClientView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var bigModel: BigModel
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                
                BackModel(color: Color.navyBlue, view: .welcomeView)
                    .padding(20)
                
                /*HStack {
                    VStack(alignment: .leading) {
                        Text("Broccoli")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title)
                        Text("Apple")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title)
                        Text("Salmon")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title)
                        Text("Glucoside")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title)
                        Text("Zucchini")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title)
                    }
                    Spacer()
                }.padding(.horizontal, 20)*/
                
                Spacer()
                
                Text("TELL US WHAT YOU LIKE")
                    .font(.system(size: 75))
                    .multilineTextAlignment(.trailing)
                    .foregroundStyle(Color.navyBlue)
            }
            
            VStack {
                
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.gray)
                    Text("Start selecting")
                        .foregroundStyle(Color.white)
                }.onTapGesture {
                    bigModel.currentView = .LegumeScreen
                    bigModel.screenHistory.append(.welcomeView)
                }
            }
            
        }.edgesIgnoringSafeArea(.bottom)
        
    }
}

struct NewClientView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
