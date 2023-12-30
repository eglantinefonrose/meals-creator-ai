//
//  BackModel.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 30/11/2023.
//

import SwiftUI

struct BackModel: View {
    
    @EnvironmentObject var bigModel: BigModel
    var color: Color
    var view: ViewEnum
    
    var body: some View {
        HStack {
            Text("Back")
                .foregroundStyle(color)
                .bold()
                .onTapGesture {
                    bigModel.currentView = bigModel.screenHistory.last ?? .FruitsScreen
                    if bigModel.screenHistory.count > 0 {
                        self.bigModel.screenHistory.removeLast()
                    }
                }
            Spacer()
            Image(systemName: "person.circle")
                .foregroundStyle(color)
                .onTapGesture {
                    bigModel.currentView = .UserView
                    bigModel.screenHistory.append(view)
                }
        }
    }
}

struct BackModel_Previews: PreviewProvider {
    static var previews: some View {
        BackModel(color: Color.navyBlue, view: .FruitsScreen)
    }
}
