//
//  MealType.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 31/12/2023.
//

import SwiftUI

struct MealType: View {
    
    @EnvironmentObject var bigModel: BigModel
    
    var body: some View {
            
            VStack {
                
                BackModel(color: .navyBlue, view: .MealTypeView)
                
                Text("MEAL TYPE")
                    .foregroundStyle(Color.navyBlue)
                    .font(.largeTitle)
                
                HStack {
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.navyBlue)
                                .cornerRadius(20)
                            Text("Petit déjeuner")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            var user: BigModel.User = bigModel.currentUser
                            user.proposedMeals = []
                            user.favoriteMeals = []
                            bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                            Task {
                                bigModel.currentView = .mealsPropositionScreen
                                await bigModel.createMeals(mealType: "petit déjeuner")
                            }
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(.navyBlue)
                                .cornerRadius(20)
                            Text("Gouter")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                                .onTapGesture {
                                    var user: BigModel.User = bigModel.currentUser
                                    user.proposedMeals = []
                                    user.favoriteMeals = []
                                    bigModel.storeCurrentUserInfoIntoDB(user: user) {
                                        Task {
                                            await bigModel.createMeals(mealType: "goûter")
                                            bigModel.currentView = .mealsPropositionScreen
                                        }
                                    }
                                }
                        }
                    }
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.navyBlue)
                                .cornerRadius(20)
                            Text("Déjeuner")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                                .onTapGesture {
                                    var user: BigModel.User = bigModel.currentUser
                                    user.proposedMeals = []
                                    user.favoriteMeals = []
                                    bigModel.storeCurrentUserInfoIntoDB(user: user) {
                                        Task {
                                            await bigModel.createMeals(mealType: "déjeuner")
                                            bigModel.currentView = .mealsPropositionScreen
                                        }
                                    }
                                }
                        }
                        ZStack {
                            Rectangle()
                                .foregroundColor(.navyBlue)
                                .cornerRadius(20)
                            Text("Diner")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                                .onTapGesture {
                                    var user: BigModel.User = bigModel.currentUser
                                    user.proposedMeals = []
                                    user.favoriteMeals = []
                                    bigModel.storeCurrentUserInfoIntoDB(user: user) {
                                        Task {
                                            await bigModel.createMeals(mealType: "diner")
                                            bigModel.currentView = .mealsPropositionScreen
                                        }
                                    }
                                }
                        }
                    }
                    
                }
                
                Spacer()
                
            }.padding(20)
            
        
    }
}

#Preview {
    MealType()
}
