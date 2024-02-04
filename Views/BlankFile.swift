//
//  BlankFile.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 25/12/2023.
//

import SwiftUI

struct BlankFile: View {
    
    @EnvironmentObject var bigModel: BigModel
    @State var show: Bool = true
    
    var body: some View {
        Text("Go to meals")
            .onTapGesture {
                bigModel.currentView = .mealsPropositionScreen
            }
            .alert(isPresented: $show) {
                
                /*Alert(title: Text("Are you sure you want to dislike this meal ?"),
                      message: Text("It will be deleted from your proposed meals list."),
                      primaryButton: .destructive(Text("No")) {
                        
                        }
                }, secondaryButton: .destructive(Text("Yes")) {
                    bigModel.didPreferencesChanged = false
                    Task {
                        var user = bigModel.currentUser
                        let mealsList = user.proposedMeals
                        user.proposedMeals = bigModel.removeMealFromList(meal: bigModel.dislikedMeal, mealsList: mealsList)
                        bigModel.storeCurrentUserInfoIntoDB(user: user)
                        addToDisliked(item: bigModel.dislikedMeal)
                        bigModel.currentView = .mealsPropositionScreen
                })*/
                
                    Alert(title: Text("dislike-meal"),
                          message: Text("dislike-meal-2"),
                          primaryButton: .destructive(Text("no")) {},
                          secondaryButton: .destructive(Text("yes")) {
                            
                            bigModel.storeInDBAndFetchNewProposedMealsList()
                            
                })
                
            }
    }
    
    
    
    private func addToDisliked(item: BigModel.Meal) {
        var user = bigModel.currentUser
        user.proposedMeals = bigModel.removeMealFromList(meal: item, mealsList: bigModel.currentUser.proposedMeals)
        bigModel.storeCurrentUserInfoIntoDB(user: user)
        user.dislikedMeals.append(item)
        bigModel.storeCurrentUserInfoIntoDB(user: user)
    }
    
}
