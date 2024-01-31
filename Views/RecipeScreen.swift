//
//  RecipeScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 13/12/2023.
//

import SwiftUI

struct RecipeScreen: View {
    
    @EnvironmentObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    @State var selected = false
    
    var body: some View {
        
        VStack {
            
             VStack {
                 
                 VStack(spacing: 10) {
                  
                  BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                  
                     HStack {
                         Text(bigModel.selectedMeal.recipe.recipeName.uppercased())
                          .foregroundStyle(Color.navyBlue)
                          .font(.system(size: 70))
                         Spacer()
                         Image(systemName: "hand.thumbsdown")
                             .foregroundColor(.navyBlue)
                             .onTapGesture {
                                 bigModel.currentView = .BlankFile
                                 bigModel.dislikedMeal = bigModel.selectedMeal
                             }
                         
                         Image(systemName: selected ? "heart.fill" : "heart")
                             .foregroundColor(.navyBlue)
                             .onTapGesture {
                                 
                                 
                                 /*Image(systemName: liked ? "heart.fill" : "heart")
                                  .foregroundColor(.navyBlue)
                                  .onTapGesture {
                                      Task {
                                          
                                          if !isMealInList(meal: item) && !selected {
                                              addToFavourite(item: item)
                                          }
                                          
                                          if liked {
                                              var user = bigModel.currentUser
                                              let mealsList = user.favoriteMeals
                                              user.favoriteMeals = bigModel.removeMealFromList(meal: item, mealsList: mealsList)
                                              bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                                          }
                                          
                                          self.liked.toggle()
                                          
                                      }
                                  }*/
                                 
                                 
                                 
                                 if !isMealInList(meal: bigModel.selectedMeal) && !selected {
                                     Task {
                                         await addToFavourite(item: bigModel.selectedMeal)
                                     }
                                 }
                                 if selected {
                                         var user = bigModel.currentUser
                                         let mealsList = user.favoriteMeals
                                         user.favoriteMeals = bigModel.removeMealFromList(meal: bigModel.selectedMeal, mealsList: mealsList)
                                         bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                                     
                                 }
                                 selected.toggle()
                                 
                             }
                     }
                     
                     ScrollView {
                         
                         VStack(alignment: .leading, spacing: 10) {
                             Text("Ingrédients")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                                 .onTapGesture {
                                    
                             }
                             Rectangle().fill(Color.navyBlue).frame(height: 1)
                         }
                         
                         LazyVGrid(columns: columns, spacing: 5) {
                             ForEach(bigModel.selectedMeal.recipe.ingredients , id: \.self) { k in
                                 ZStack {
                                     Rectangle()
                                         .frame(minWidth: 150, minHeight: 150)
                                         .foregroundColor(.gray)
                                     HStack {
                                         VStack(alignment: .leading) {
                                             Spacer()
                                             Text(k.name)
                                                 .foregroundColor(.white)
                                             Text("\(k.quantityWithUnit)")
                                                 .foregroundStyle(Color.navyBlue)
                                         }
                                         Spacer()
                                     }.padding(10)
                                 }
                             }
                         }
                         
                         HStack {
                             Text("Total time")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                             Text("\(bigModel.selectedMeal.recipe.totalDuration)")
                                 .foregroundStyle(Color.navyBlue)
                         }
                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                         
                         HStack {
                             Text("Average price")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                             Text(String(format: "%.1f", bigModel.selectedMeal.recipe.price))
                                 .foregroundStyle(Color.navyBlue)
                         }
                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                         
                         HStack {
                             Text("Recipe")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                         }
                         //Rectangle().fill(Color.navyBlue).frame(height: 1)
                         
                         VStack(alignment: .leading) {
                             Text(bigModel.selectedMeal.recipe.recipeDescription.introduction)
                             
                             List(bigModel.selectedMeal.recipe.recipeDescription.steps) { string in
                                Text(string)
                            }
                             
                             //Text("\(bigModel.selectedMeal.recipe.recipeDescription.steps.count)")
                             
                         }
                         
                     }
                       
                }.padding(20)
                                  
                 Spacer()
                 
                 ZStack {
                     Rectangle()
                         .frame(height: 60)
                         .foregroundStyle(Color.navyBlue)
                     Text("Add to favourite")
                         .foregroundStyle(Color.white)
                 }.onTapGesture {
                     bigModel.currentUser.favoriteMeals.append(bigModel.selectedMeal)
                 }
                 
             }
             
         }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if isMealInList(meal: bigModel.selectedMeal) {
                selected = true
            }
        }
     }
    
    private func addToFavourite(item: BigModel.Meal) async {
        var user = bigModel.currentUser
        user.favoriteMeals.append(item)
        bigModel.storeCurrentUserInfoIntoDB(user: user) {}
    }
    
    private func isMealInList(meal: BigModel.Meal) -> Bool {
        return bigModel.currentUser.favoriteMeals.contains { $0.recipe.recipeName == meal.recipe.recipeName }
    }
    
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
