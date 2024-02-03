//
//  FavoriteMealsScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 16/12/2023.
//

import SwiftUI
import Combine

struct FavoriteMealsScreen: View {
    
    @EnvironmentObject var bigModel: BigModel
    let meals = ["Nouilles sautées", "Omelette", "Rillettes de thon"]
    @State var testMealList: [BigModel.Meal] = []
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                    
                    Text("favourite-meals")
                        .foregroundStyle(Color.navyBlue)
                        .font(.system(size: 70))
                        .multilineTextAlignment(.center)
                    Circle()
                        .foregroundStyle(Color.navyBlue)
                    
                    VStack(alignment: .leading) {
                        Text("select-meal")
                            .foregroundStyle(Color.navyBlue)
                        
                        //if bigModel.isLoading {
                        
                        //}
                        
                        /*VStack(alignment: .leading, spacing: 10) {
                            List(bigModel.testMealList) { item in
                                Text(item.name)
                            }
                        }*/
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(bigModel.currentUser.favoriteMeals) { item in
                                    Text(item.recipe.recipeName)
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.navyBlue)
                                        .onTapGesture {
                                            bigModel.selectedMeal = item
                                            bigModel.currentView = .RecipeScreen
                                            bigModel.screenHistory.append(.FavoriteMealsScreen)
                                        }
                                    Rectangle().fill(Color.navyBlue).frame(height: 1)
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        if bigModel.isLoading {
                            ProgressView()
                                    .scaleEffect(1, anchor: .center)
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        }
                        Spacer()
                    }
                    
                }.padding(.leading)
                .padding(.trailing)
                .padding(.top)
                
            }
        }
    }

}

struct FavoriteMealsScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMealsScreen()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
