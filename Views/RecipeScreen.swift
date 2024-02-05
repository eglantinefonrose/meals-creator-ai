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
    @State var circleSize: CGFloat = UIScreen.main.bounds.height/3
    @State var imageSize: CGFloat = UIScreen.main.bounds.height/4
    @State var fontSize: CGFloat = 50
    @State var selected = false
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                 VStack(spacing: 0) {
                     
                     VStack(spacing: 10) {
                         
                         BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                         
                         VStack {
                             
                             ZStack {
                                 Circle()
                                     .foregroundColor(.navyBlue)
                                     .frame(width: circleSize, height: circleSize)
                                 Image("Broccoli Tattoo")
                                     .resizable()
                                     .frame(width: imageSize, height: imageSize)
                             }
                             
                             HStack {
                                 ScrollView(.horizontal) {
                                     Text(bigModel.selectedMeal.recipe.recipeName)
                                         .foregroundStyle(Color.navyBlue)
                                         .font(.system(size: fontSize))
                                         .bold()
                                     
                                 }
                                 VStack(spacing: 5) {
                                     Image(systemName: "hand.thumbsdown")
                                         .foregroundColor(.navyBlue)
                                         .onTapGesture {
                                             bigModel.currentView = .BlankFile
                                             bigModel.dislikedMeal = bigModel.selectedMeal
                                         }
                                     
                                     Image(systemName: selected ? "heart.fill" : "heart")
                                         .foregroundColor(.navyBlue)
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
                                             .foregroundStyle(Color.navyBlue)
                                             .onTapGesture {
                                                 
                                             }
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
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
                                                             .foregroundStyle(Color(.navyBlue))
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
                                             .foregroundStyle(Color.navyBlue)
                                         Spacer()
                                         Text("\(bigModel.selectedMeal.recipe.totalDuration)")
                                             .foregroundStyle(Color.navyBlue)
                                     }
                                     Rectangle().fill(Color.navyBlue).frame(height: 1)
                                     
                                     HStack {
                                         Text("average-price")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         Spacer()
                                         Text(bigModel.selectedMeal.recipe.price)
                                             .foregroundStyle(Color.navyBlue)
                                         Text(bigModel.selectedMeal.recipe.currency)
                                             .foregroundStyle(Color.navyBlue)
                                     }
                                     Rectangle().fill(Color.navyBlue).frame(height: 1)
                                     
                                     HStack {
                                         Text("recipe")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         Spacer()
                                     }
                                     //Rectangle().fill(Color.navyBlue).frame(height: 1)
                                     
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
                                    
                                    if ((imageSize-$0) >= 100 && (imageSize-$0) <= UIScreen.main.bounds.height/4) {
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
                                 .foregroundStyle(Color.navyBlue)
                             Text("add-to-favs")
                                 .foregroundStyle(Color.white)
                         }.onTapGesture {
                             bigModel.currentUser.favoriteMeals.append(bigModel.selectedMeal)
                         }
                     }
                     
                 }
                 
             }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                if isMealInList(meal: bigModel.selectedMeal) {
                    selected = true
                }
        }
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
    
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
