//
//  MealsPropostion.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI
import Combine

@available(iOS 17.0, *)
struct MealsPropostion: View {
    
    @EnvironmentObject var bigModel: BigModel
    let meals = ["Nouilles sautées", "Omelette", "Rillettes de thon"]
    @State var tags: [BigModel.Meal: Bool] = [BigModel.Meal(id: "0", name: "E", type: "", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""):false, BigModel.Meal(id: "1", name: "E", type: "", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""):false]
    @State var type: String = "All"

    var body: some View {
        
        VStack {
            
            VStack(spacing: 10) {
                
                BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                
                Text("MEALS")
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 100))
                Circle()
                    .foregroundStyle(Color.navyBlue)
                
                VStack {
                    
                    Text("Select a meal to see the recipe")
                        .foregroundStyle(Color.navyBlue)
                    
                    HStack {
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(type == "All" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("All")
                                .foregroundColor(type == "All" ? Color.white : Color.black)
                        }.onTapGesture {
                            type = "All"
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(type == "Petit-déjeuner" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("Petit-déjeuner")
                                .foregroundColor(type == "Petit-déjeuner" ? Color.white : Color.black)
                        }.onTapGesture {
                            type = "Petit-déjeuner"
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(type == "Déjeuner" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("Déjeuner")
                                .foregroundColor(type == "Déjeuner" ? Color.white : Color.black)
                        }.onTapGesture {
                            type = "Déjeuner"
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(type == "Goûter" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("Goûter")
                                .foregroundColor(type == "Goûter" ? Color.white : Color.black)
                        }.onTapGesture {
                            type = "Goûter"
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(type == "Diner" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("Diner")
                                .foregroundColor(type == "Diner" ? Color.white : Color.black)
                        }.onTapGesture {
                            type = "Diner"
                        }
                        
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(bigModel.currentUserTags.keys.sorted(), id: \.self) { item in
                                
                                MealsViewModel(bigModel: BigModel.mocked, item: item, liked: self.binding(for: item), disliked: self.binding(for: item), type: type)
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
            }.onTapGesture {
                
            }
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            bigModel.currentUserTags = bigModel.generateTags(type: type)
        }
        .onChange(of: type, {
            bigModel.currentUserTags = bigModel.generateTags(type: type)
        })
        .alert(isPresented: $bigModel.didPreferencesChanged) {
            Alert(
                title: Text("You changed your tastes, do you want to regenerate meals ?"),
                primaryButton: .destructive(Text("Yes")) {
                    bigModel.didPreferencesChanged = false
                    bigModel.currentView = .MealTypeView
                    bigModel.screenHistory.append(.MealTypeView)
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


struct MealsViewModel : View {
    
    var bigModel: BigModel
    var item: BigModel.Meal
    @Binding var liked: Bool
    @Binding var disliked: Bool
    var type: String
    
    var body: some View {
        HStack {
            
            if item.type == type {
                
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
                    }
                
                Image(systemName: "hand.thumbsdown")
                    .foregroundColor(.navyBlue)
                    .onTapGesture {
                        bigModel.currentView = .BlankFile
                        bigModel.dislikedMeal = item
                    }
                
            }
            
            if type == "All" {
                
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
                    }
                
                Image(systemName: "hand.thumbsdown")
                    .foregroundColor(.navyBlue)
                    .onTapGesture {
                        bigModel.currentView = .BlankFile
                        bigModel.dislikedMeal = item
                    }
                
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

@available(iOS 17.0, *)
struct MealsPropostion_Previews: PreviewProvider {
    static var previews: some View {
        MealsPropostion()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
