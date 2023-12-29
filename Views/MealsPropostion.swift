//
//  MealsPropostion.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI
import Combine

struct MealsPropostion: View {
    
    @EnvironmentObject var bigModel: BigModel
    let meals = ["Nouilles sautées", "Omelette", "Rillettes de thon"]
    @State var tags: [BigModel.Meal: Bool] = [BigModel.Meal(id: "0", name: "E", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""):false, BigModel.Meal(id: "1", name: "E", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""):false]
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 10) {
                
                BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                
                Text("MEALS")
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 100))
                Circle()
                    .foregroundStyle(Color.navyBlue)
                
                VStack(alignment: .leading) {
                    Text("Select a meal to see the recipe")
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
                            ForEach(bigModel.currentUserTags.keys.sorted(), id: \.self) { item in
                                
                                MealsViewModel(bigModel: BigModel.mocked, item: item, liked: self.binding(for: item), disliked: self.binding(for: item))
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
            
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.navyBlue)
                Text("Generate new meals")
                    .foregroundStyle(Color.white)
                    .onTapGesture {
                        
                            var user: BigModel.User = bigModel.currentUser
                            user.proposedMeals = []
                            user.favoriteMeals = []
                            bigModel.storeCurrentUserInfoIntoDB(user: user) {
                                Task {
                                    await bigModel.createMeals()
                                }
                            }
                            
                        
                        
                    }
            }
            
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            bigModel.currentUserTags = bigModel.generateTags()
        }
        .alert(isPresented: $bigModel.didPreferencesChanged) {
            Alert(
                title: Text("You changed your tastes, do you want to regenerate meals ?"),
                primaryButton: .destructive(Text("Yes")) {
                    bigModel.didPreferencesChanged = false
                    Task {
                        await bigModel.createMeals()
                    }
                },
                secondaryButton: .destructive(Text("No"))
            )
        }
    }
    
    private func binding(for key: BigModel.Meal) -> Binding<Bool> {
        return .init(
            get: { bigModel.currentUserTags[key, default: false] },
            set: { bigModel.currentUserTags[key] = $0 })
    }

}


struct MealsViewModel: View {
    
    var bigModel: BigModel
    var item: BigModel.Meal
    @Binding var liked: Bool
    @Binding var disliked: Bool
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.largeTitle)
                .foregroundStyle(Color.navyBlue)
                .onTapGesture {
                    bigModel.currentView = .RecipeScreen
                    bigModel.screenHistory.append(.mealsPropositionScreen)
                    bigModel.selectedMeal = item
                }
            Spacer()
            Image(systemName: liked ? "heart.fill" : "heart")
                .foregroundColor(.navyBlue)
                .onTapGesture {
                    bigModel.currentView = .BlankFile
                    /*Task {
                        liked.toggle()
                        if isMealInList(meal: item) && liked {
                            await addToFavourite(item: item)
                        }
                        if !liked {
                            var user = bigModel.currentUser
                            let mealsList = user.favoriteMeals
                            user.favoriteMeals = bigModel.removeMealFromList(meal: item, mealsList: mealsList)
                            bigModel.storeCurrentUserInfoIntoDB(user: user)
                        }
                    }*/
                    
                }
            Image(systemName: "hand.thumbsdown")
                .foregroundColor(.navyBlue)
                .onTapGesture {
                    //disliked.toggle()
                    //if isMealInList(meal: item) && disliked {
                    bigModel.currentView = .BlankFile
                    bigModel.dislikedMeal = item
                    //}
                    /*if !disliked {
                        var user = bigModel.currentUser
                        let mealsList = user.dislikedMeals
                        user.dislikedMeals = bigModel.removeMealFromList(meal: item, mealsList: mealsList)
                        bigModel.storeCurrentUserInfoIntoDB(user: user)
                    }*/
                }
        }
    }
    
    private func addToFavourite(item: BigModel.Meal) async {
        var user = bigModel.currentUser
        user.favoriteMeals.append(item)
        await bigModel.storeCurrentUserInfoIntoDB(user: user) {}
    }
    
    private func isMealInList(meal: BigModel.Meal) -> Bool {
        return (bigModel.currentUser.favoriteMeals.contains { $0.id == meal.id })
    }
    
}

struct MealsPropostion_Previews: PreviewProvider {
    static var previews: some View {
        MealsPropostion()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
