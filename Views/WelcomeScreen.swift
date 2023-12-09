//
//  WelcomeScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 30/11/2023.
//

import SwiftUI

struct WelcomeScreen: View {
    
    @EnvironmentObject var bigModel: BigModel
    
    var body: some View {
        VStack {
            Text("SHOP")
            Text("PLANNER")
            
            ZStack {
                Text("Log in")
                    .foregroundColor(Color.navyBlue)
                    .onTapGesture {
                        bigModel.currentView = .signInView
                        bigModel.screenHistory.append(ViewEnum.welcomeView)
                    }
            }

        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
