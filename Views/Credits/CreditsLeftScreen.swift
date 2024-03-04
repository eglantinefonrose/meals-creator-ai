//
//  CreditsLeftScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 04/03/2024.
//

import SwiftUI

struct CreditsLeftScreen: View {
    
    @ObservedObject var bigModel: BigModel
    
    var body: some View {
        
        ZStack {
            
            Color(.navyBlue)
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                
                VStack {
                    
                    VStack(spacing: 0) {
                        Text("\(bigModel.currentUser.credits)")
                            .font(.system(size: 120))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                        
                        Text("credits left")
                            .font(.system(size: 50))
                            .foregroundStyle(Color(.midGray))
                            .fontWeight(.none)
                    }
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(20)
                            .foregroundColor(Color(.midGray))
                            .frame(width: 300, height: 50)
                        Text("Buy credits")
                            .font(.title3)
                            .foregroundStyle(Color(.navyBlue))
                    }
                    
                }
                
                VStack {
                    
                    BackModel(color: Color.white, view: .UserView)
                    
                    Spacer()
                    
                }.padding(20)
            }
        }
        
    }
}

#Preview {
    CreditsLeftScreen(bigModel: BigModel.shared)
}
