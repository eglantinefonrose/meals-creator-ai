//
//  MealType.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 31/12/2023.
//

import SwiftUI

struct MealType: View {
    
    @EnvironmentObject var bigModel: BigModel
    @State var selectedType: String = ""
    @State var seasonTags: [String: Bool] = ["Petit déjeuner": false, "Déjeuner": false, "Gouter": false, "Diner": false]
    
    var body: some View {
            
        VStack {
            VStack {
                    
                    BackModel(color: .navyBlue, view: .MealTypeView)
                    
                    Text("MEAL TYPE")
                        .foregroundStyle(Color.navyBlue)
                        .font(.largeTitle)
                    
                    HStack {
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(seasonTags["Petit déjeuner"]! ? .navyBlue : .gray)
                                    .cornerRadius(20)
                                Text("Petit déjeuner")
                                    .foregroundStyle(Color.white)
                                    .font(.title2)
                            }.onTapGesture {
                                selectedType = "Petit déjeuner"
                                seasonTags["Petit déjeuner"] = true
                                seasonTags["Gouter"] = false
                                seasonTags["Déjeuner"] = false
                                seasonTags["Diner"] = false
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(seasonTags["Gouter"]! ? .navyBlue : .gray)
                                    .cornerRadius(20)
                                Text("Gouter")
                                    .foregroundStyle(Color.white)
                                    .font(.title2)
                            }.onTapGesture {
                                selectedType = "Gouter"
                                seasonTags["Petit déjeuner"] = false
                                seasonTags["Gouter"] = true
                                seasonTags["Déjeuner"] = false
                                seasonTags["Diner"] = false
                            }
                        }
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(seasonTags["Déjeuner"]! ? .navyBlue : .gray)
                                    .cornerRadius(20)
                                Text("Déjeuner")
                                    .foregroundStyle(Color.white)
                                    .font(.title2)
                            }.onTapGesture {
                                selectedType = "Déjeuner"
                                seasonTags["Petit déjeuner"] = false
                                seasonTags["Gouter"] = false
                                seasonTags["Déjeuner"] = true
                                seasonTags["Diner"] = false
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(seasonTags["Diner"]! ? .navyBlue : .gray)
                                    .cornerRadius(20)
                                Text("Diner")
                                    .foregroundStyle(Color.white)
                                    .font(.title2)
                            }.onTapGesture {
                                selectedType = "Diner"
                                seasonTags["Petit déjeuner"] = false
                                seasonTags["Gouter"] = false
                                seasonTags["Déjeuner"] = false
                                seasonTags["Diner"] = true
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
            }.padding(20)
            
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.navyBlue)
                Text("Validate")
                    .foregroundStyle(Color.white)
                    .onTapGesture {
                        var user: BigModel.User = bigModel.currentUser
                        user.proposedMeals = []
                        user.favoriteMeals = []
                        bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                        Task {
                            bigModel.currentView = .mealsPropositionScreen
                            bigModel.screenHistory.append(.MealTypeView)
                            await bigModel.createMeals(mealType: selectedType)
                        }
                    }
            }
            
        }.edgesIgnoringSafeArea(.bottom)
        
    }
}

#Preview {
    MealType()
}
