//
//  ContentView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI

struct TastesView: View {
    
    //var preferenceList = ["Legumes", "Fruits", "Starchy foods", "Meat", "Seasonning", "Allergies", "Cooking tools"]
    @EnvironmentObject var bigModel: BigModel
    var preferenceList = [PreferenceItem(id: 0, name: "Legumes"), PreferenceItem(id: 1, name: "Fruits"), PreferenceItem(id: 2, name: "Starchy foods"), PreferenceItem(id: 3, name: "Meat"), PreferenceItem(id: 4, name: "Seasonning"), PreferenceItem(id: 5, name: "Allergies"), PreferenceItem(id: 6, name: "Cooking tools")]
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 10) {
                
                BackModel(color: Color.navyBlue, view: .TastesView)
                
                Text("TASTES")
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 100))
                Circle()
                    .foregroundStyle(Color.navyBlue)
                
                VStack(alignment: .leading) {
                    Text("Select your preferences in each categories")
                        .foregroundStyle(Color.navyBlue)
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(preferenceList) { preferenceList in
                                Text(preferenceList.name)
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.navyBlue)
                                    .onTapGesture {
                                        bigModel.currentView = categoryNameToNextScreen(categorie: preferenceList)
                                        bigModel.screenHistory.append(.TastesView)
                                    }
                                Rectangle().fill(Color.navyBlue).frame(height: 1)
                            }
                        }
                    }
                }
                
            }.padding(.leading)
            .padding(.trailing)
            .padding(.top)
                        
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.navyBlue)
                Text("Validate")
                    .foregroundColor(.white)
            }.onTapGesture {
                var user = bigModel.currentUser
                bigModel.currentView = .UserView
                bigModel.screenHistory.append(.TastesView)
                print(bigModel.currentUser.items)
            }
            
        }.edgesIgnoringSafeArea(.bottom)
    }
}

func categoryNameToNextScreen(categorie: PreferenceItem) -> ViewEnum {
    if categorie.id == 0 {
        return .LegumeScreen
    }
    if categorie.id == 1 {
        return .FruitsScreen
    }
    if categorie.id == 2 {
        return .strachyFoodsScreen
    }
    if categorie.id == 3 {
        return .proteinsScreen
    }
    if categorie.id == 4 {
        return .seasonningScreen
    }
    if categorie.id == 5 {
        return .allergiesScreen
    }
    if categorie.id == 6 {
        return .cookingToolsScreen
    }
    else {
        return .LegumeScreen
    }
}

struct PreferenceItem: Identifiable {
    var id: Int
    var name: String
}

extension Color {
    static let navyBlue = Color(red: 27 / 255, green: 44 / 255, blue: 137 / 255)
}

struct TastesView_Previews: PreviewProvider {
    static var previews: some View {
        TastesView()
    }
}
