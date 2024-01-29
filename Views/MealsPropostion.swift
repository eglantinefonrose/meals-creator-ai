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
    @State var tags: [BigModel.Meal: Bool] = [BigModel.Meal(id: "0", recipe: BigModel.Recipe(id: "3045IEKORRE¨DF", recipeName: "Penne alla rabbiata", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))):true, BigModel.Meal(id: "1", recipe: BigModel.Recipe(id: "FJVRET4E0TÖGREKF", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))):false ]
    @State var type: String = "All"
    @State var season: String = "All"
    let columns = [GridItem(.adaptive(minimum: 150))]
    let types: [Type] = [Type(id: 0, typeName: "All", type: "All"), Type(id: 1, typeName: "Petit-déjeuner", type: "Petit-déjeuner"), Type(id: 2, typeName: "Déjeuner", type: "Déjeuner"), Type(id: 3, typeName: "Goûter", type: "Goûter"), Type(id: 4, typeName: "Diner", type: "Diner")]
    let seasons: [Season] = [Season(id: 0, seasonName: "All", season: "All"), Season(id: 1, seasonName: "Winter", season: "Winter"), Season(id: 2, seasonName: "Spring", season: "Spring"), Season(id: 3, seasonName: "Summer", season: "Summer"), Season(id: 4, seasonName: "Autumn", season: "Autumn")]
    //let typeNames: [String] = ["All", "Petit-déjeuner", "Déjeuner", "Goûter", "Diner"]

    var body: some View {
        
        VStack {
            
            VStack(spacing: 10) {
                
                BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                
                Text("MEALS")
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 100))
                    .onTapGesture {
                        print("")
                    }
                
                //Circle()
                    //.foregroundStyle(Color.navyBlue)
                
                VStack {
                    
                    Text("Select a meal to see the recipe")
                        .foregroundStyle(Color.navyBlue)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            
                            ForEach(seasons) { seasonValue in
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundColor(season == seasonValue.season ? Color.navyBlue : Color.gray)
                                        .frame(height: 50)
                                    Text(seasonValue.seasonName)
                                        .foregroundColor(season == seasonValue.season ? Color.white : Color.black)
                                        .padding()
                                }.onTapGesture {
                                    season = seasonValue.season
                            }
                            }
                            
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            
                            ForEach(types) { typeValue in
                                ZStack {
                                    Rectangle()
                                        .cornerRadius(10)
                                        .foregroundColor(type == typeValue.type ? Color.navyBlue : Color.gray)
                                        .frame(height: 50)
                                    Text(typeValue.typeName)
                                        .foregroundColor(type == typeValue.type ? Color.white : Color.black)
                                        .padding()
                                }.onTapGesture {
                                    type = typeValue.type
                            }
                            }
                            
                        }
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            
                            /*ForEach(bigModel.currentUserTags.keys.sorted(), id: \.self) { item in
                                
                                MealsViewModel(bigModel: BigModel.shared, item: item, liked: self.binding(for: item), type: type)
                                
                                if bigModel.currentUserTags[item] == true {
                                    Text("p")
                                } else {
                                    Text("false")
                                }
                                
                                Rectangle().fill(Color.navyBlue).frame(height: 1)
                                
                            }*/
                            
                            /*ForEach(tags.keys.sorted(), id: \.self) { item in
                                
                                MealsViewModel(bigModel: BigModel.shared, item: item, liked: self.binding(for: item), type: type)
                                
                                if tags[item] == true {
                                    Text("p")
                                } else {
                                    Text("false")
                                }
                                
                                Rectangle().fill(Color.navyBlue).frame(height: 1)
                                
                            }*/
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
                bigModel.currentView = .SeasonSelectionView
            }
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            //bigModel.currentUserTags = bigModel.generateTags(type: type, season: season)
            bigModel.currentUserTags = bigModel.generateTags(type: type, season: season)
        }
        .onChange(of: type, {
            //bigModel.currentUserTags = bigModel.generateTags(type: type, season: season)
            tags = bigModel.generateTags(type: type, season: season)
            print("type: \(type)")
        })
        .onChange(of: season, {
            bigModel.currentUserTags = bigModel.generateTags(type: type, season: season)
            print("season: \(season)")
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
            //get: { bigModel.currentUserTags[key, default: false] },
            //set: { bigModel.currentUserTags[key] = $0 })
            get: { self.tags[key, default: false] },
            set: { self.tags[key] = $0 })
    }

}

struct Type: Identifiable {
    var id: Int
    var typeName: String
    var type: String
}

struct Season: Identifiable {
    var id: Int
    var seasonName: String
    var season: String
}


/*struct MealsViewModel : View {
    
    var bigModel: BigModel
    var item: BigModel.Meal
    @Binding var liked: Bool
    var isLiked = true
    var type: String
    
    var body: some View {
        HStack {
            
            if item.recipe.mealType == type {
                
                Text(item.recipe.recipeName)
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
                        self.liked.toggle()
                    }
                
                /*Image(systemName: "hand.thumbsdown")
                    .foregroundColor(.navyBlue)
                    .onTapGesture {
                        bigModel.currentView = .BlankFile
                        bigModel.dislikedMeal = item
                    }*/
                
            }
            
            if type == "All" {
                
                Text(item.recipe.recipeName)
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
                        self.liked.toggle()
                        
                        /*Task {
                            liked.toggle()
                            if isMealInList(meal: item) && liked {
                                await addToFavourite(item: item)
                            }
                            if !liked {
                                var user = bigModel.currentUser
                                let mealsList = user.favoriteMeals
                                user.favoriteMeals = bigModel.removeMealFromList(meal: item, mealsList: mealsList)
                                bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                            }

                        }*/
                    }
                
                /*Image(systemName: "hand.thumbsdown")
                    .foregroundColor(.navyBlue)
                    .onTapGesture {
                        bigModel.currentView = .BlankFile
                        bigModel.dislikedMeal = item
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
    
}*/

@available(iOS 17.0, *)
struct MealsPropostion_Previews: PreviewProvider {
    static var previews: some View {
        MealsPropostion()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
