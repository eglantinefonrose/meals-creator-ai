//
//  RecipeScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 13/12/2023.
//

import SwiftUI

struct RecipeScreen: View {
    
    @ObservedObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    @State var circleSize: CGFloat = UIScreen.main.bounds.height/3
    @State var imageSize: CGFloat = UIScreen.main.bounds.height/5
    @State var fontSize: CGFloat = 50
    @State var selected = false
    @State var image: Image = Image("", label: Text(""))
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                 VStack(spacing: 0) {
                     
                     VStack(spacing: 10) {
                         
                         BackModel(color: Color.blue, view: .RecipeScreen)
                         
                         VStack {
                             
                             ZStack {
                                 Circle()
                                     .foregroundColor(.blue)
                                     .frame(width: circleSize, height: circleSize)
                                 image
                                     .resizable()
                                     .frame(width: imageSize, height: imageSize)
                             }
                             
                             HStack {
                                 ScrollView(.horizontal) {
                                     Text(bigModel.selectedMeal.recipe.recipeName)
                                         .foregroundStyle(Color.blue)
                                         .font(.system(size: fontSize))
                                         .bold()
                                     
                                 }
                                 VStack(spacing: 5) {
                                     Image(systemName: "hand.thumbsdown")
                                         .foregroundColor(.blue)
                                         .onTapGesture {
                                             bigModel.currentView = .BlankFile
                                             bigModel.dislikedMeal = bigModel.selectedMeal
                                         }
                                     
                                     Image(systemName: selected ? "heart.fill" : "heart")
                                         .foregroundColor(.blue)
                                         .onTapGesture {
                                             if !isMealInList(meal: bigModel.selectedMeal) && !selected {
                                                 Task {
                                                     await addToFavourite(item: bigModel.selectedMeal)
                                                 }
                                             }
                                             if selected {
                                                 var user = bigModel.currentUser
                                                 let mealsList = user.favoriteMeals
                                                 user.favoriteMeals = bigModel.removeMealFromList(meal: bigModel.selectedMeal, mealsList: mealsList)
                                                 bigModel.storeCurrentUserInfoIntoDB(user: user)
                                             }
                                             selected.toggle()
                                             
                                         }
                                 }
                             }
                             
                             ScrollView {
                                 
                                 VStack {
                                 
                                     VStack(alignment: .leading, spacing: 10) {
                                         Text("ingredients")
                                             .font(.title2)
                                             .foregroundStyle(Color.blue)
                                             .onTapGesture {
                                                 
                                             }
                                         Rectangle().fill(Color.blue).frame(height: 1)
                                     }
                                     
                                     LazyVGrid(columns: columns, spacing: 5) {
                                         ForEach(bigModel.selectedMeal.recipe.ingredients , id: \.self) { k in
                                             ZStack {
                                                 Rectangle()
                                                     .cornerRadius(10)
                                                     .frame(minWidth: 150, minHeight: 150)
                                                     .foregroundColor(.white)
                                                 HStack {
                                                     VStack(alignment: .leading) {
                                                         Spacer()
                                                         Text(k.name)
                                                             .foregroundStyle(Color.blue)
                                                         Text("\(k.quantityWithUnit)")
                                                             .foregroundStyle(Color.gray)
                                                     }
                                                     Spacer()
                                                 }.padding(10)
                                             }
                                         }
                                     }
                                     
                                     HStack {
                                         Text("total-time")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.blue)
                                         Spacer()
                                         Text("\(bigModel.selectedMeal.recipe.totalDuration)")
                                             .foregroundStyle(Color.blue)
                                     }
                                     Rectangle().fill(Color.blue).frame(height: 1)
                                     
                                     HStack {
                                         Text("average-price")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.blue)
                                         Spacer()
                                         Text(bigModel.selectedMeal.recipe.price)
                                             .foregroundStyle(Color.blue)
                                         Text(bigModel.selectedMeal.recipe.currency)
                                             .foregroundStyle(Color.blue)
                                     }
                                     Rectangle().fill(Color.blue).frame(height: 1)
                                     
                                     HStack {
                                         Text("recipe")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.blue)
                                         Spacer()
                                     }
                                     //Rectangle().fill(Color.blue).frame(height: 1)
                                     
                                     Spacer()
                                     
                                     HStack {
                                         VStack(alignment: .leading, spacing: 10) {
                                             
                                             Text(bigModel.selectedMeal.recipe.recipeDescription.introduction)
                                             
                                             ForEach(bigModel.selectedMeal.recipe.recipeDescription.steps, id: \.self) { txt in
                                                 Text("- \(txt)")
                                             }
                                             
                                         }
                                         Spacer()
                                     }
                                     
                                     Spacer()
                                         .frame(height: 20)
                                 
                                }.background(GeometryReader {
                                    Color.clear.preference(key: ViewOffsetKey.self,
                                        value: -$0.frame(in: .named("scroll")).origin.y)
                                })
                                .onPreferenceChange(ViewOffsetKey.self) { print("offset >> \($0)")
                                    
                                    if ((fontSize-$0) >= 20 && (fontSize-$0) <= 50) {
                                        fontSize = fontSize-$0
                                    }
                                    
                                    if ((circleSize-$0) >= 120 && (circleSize-$0) <= UIScreen.main.bounds.height/3) {
                                        circleSize = circleSize-$0
                                    }
                                    
                                    if ((imageSize-$0) >= UIScreen.main.bounds.height/10 && (imageSize-$0) <= UIScreen.main.bounds.height/5) {
                                        imageSize = imageSize-$0
                                        print("[\(imageSize)]")
                                    }
                                }
                                 
                             }.coordinateSpace(name: "scroll")
                             
                         }
                           
                     }.padding(.top, 20)
                     .padding(.horizontal, 20)
                                      
                     //Spacer()
                     
                     VStack {
                         //Spacer()
                         ZStack {
                             Rectangle()
                                 .frame(height: 60)
                                 .foregroundStyle(Color.blue)
                             Text("save-in-planner")
                                 .foregroundStyle(Color.white)
                         }.onTapGesture {
                             bigModel.isUserTryingAddNewMealToCalendar = true
                             bigModel.currentView = .DailyCalendar
                             bigModel.screenHistory.append(.RecipeScreen)
                         }
                     }
                     
                 }
                 
             }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                if isMealInList(meal: bigModel.selectedMeal) {
                    selected = true
                }
            }
        }.onAppear {
            self.image = findStringContainingSubstring()
        }
     }
    
    private func addToFavourite(item: BigModel.Meal) async {
        var user = bigModel.currentUser
        user.favoriteMeals.append(item)
        bigModel.storeCurrentUserInfoIntoDB(user: user)
    }
    
    private func isMealInList(meal: BigModel.Meal) -> Bool {
        return bigModel.currentUser.favoriteMeals.contains { $0.recipe.recipeName == meal.recipe.recipeName }
    }
    
    func findStringContainingSubstring() -> Image {
        
        let array1: [BigModel.Ingredient] = bigModel.selectedMeal.recipe.ingredients
        let array2 = bigModel.items
        
        for ingredient in array1 {
            for item in array2 {
                if (ingredient.name.uppercased()).contains(item.name.uppercased()) {
                    if let index = bigModel.images.firstIndex(where: { $0.id == item.id }) {
                        
                        if item.category != "seasonning" && item.category != "allergies" {
                            print(item.name)
                            return bigModel.images[index].image
                        }
                        
                    }
                }
            }
        }
        return Image("cook-hat", label: Text(""))
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen(bigModel: BigModel.mocked)
    }
}
