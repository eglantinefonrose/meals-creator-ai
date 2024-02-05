//
//  BindingTest.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/01/2024.
//

import SwiftUI

struct BindingTest: View {
    
    @ObservedObject var bigModel: BigModel = BigModel.shared
    let meal1: BigModel.Meal = BigModel.Meal(id: "0", recipe: BigModel.Recipe(id: "3045IEKORRE¨DF", recipeName: "Penne alla rabbiata", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: [])))
    @State var tags: [BigModel.Meal: Int] = [BigModel.Meal(id: "0", recipe: BigModel.Recipe(id: "3045IEKORRE¨DF", recipeName: "Penne alla rabbiata", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))) : 0]
    @State var tags2: [String: Bool] = ["a": true, "b": false]
    @State var tags3 : [Meal: Int] = [Meal(id: "fijmgiorjg", recipe: Recipe(id: "fjiovofjr", recipeName: "Pate carbo", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "0", introduction: "", steps: []))): 0,
                                      Meal(id: "sefijefezjjef", recipe: Recipe(id: "uhluhj", recipeName: "Pate carbo", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "edfihejfeo", introduction: "", steps: []))): 1]
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                Text(" \( tags[meal1] ?? 2 ) ")
            }
        }
            
    }
    
}

struct Meal: Codable, Identifiable, Hashable, Comparable {
        
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    var recipe: Recipe
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(recipe) // Include recipe in the hash
    }
    
}

struct Recipe: Codable, Hashable, Comparable, Identifiable {
    
    static func < (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String
    var recipeName: String
    var numberOfPersons: Int
    var mealType: String
    var seasons: [String]
    var ingredients: [Ingredient]
    var price: String
    var currency: String
    var prepDuration: Int
    var totalDuration: Int
    var recipeDescription: RecipeDescription
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(recipeName)
        hasher.combine(numberOfPersons)
        hasher.combine(mealType)
        hasher.combine(seasons)
        hasher.combine(ingredients)
        hasher.combine(price)
        hasher.combine(prepDuration)
        hasher.combine(totalDuration)
        hasher.combine(recipeDescription)
    }
    
}

struct Ingredient: Codable, Hashable, Identifiable {
    
    let id: String
    let name: String
    let quantityWithUnit: String
    
    static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(quantityWithUnit)
    }
    
}

struct RecipeDescription: Codable, Hashable, Identifiable {
    
    let id: String
    let introduction: String
    let steps: [String]
    
    static func < (lhs: RecipeDescription, rhs: RecipeDescription) -> Bool {
        lhs.id < rhs.id
    }
    
    static func == (lhs: RecipeDescription, rhs: RecipeDescription) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(introduction)
        hasher.combine(steps)
    }
    
}

struct ButtonBinding: View {
    
    @State var selected: Int
    let meal: BigModel.Meal
    
    var body: some View {
        Button(action: {
            self.selected = 1
        }) {
            if selected == 1 {
                Text(meal.recipe.recipeName)
            }
            if selected == 0 {
                Text(meal.recipe.recipeName)
            }
        }
        .padding()
    }
}

struct ButtonBinding2: View {
    
    @Binding var selected: Bool
    let txt: String
    
    var body: some View {
        Button(action: {
            self.selected.toggle()
        }) {
            if selected {
                Text(txt)
                    .underline()
            } else {
                Text(txt)
            }
        }
        .padding()
    }
}


struct BindingTest_Previews: PreviewProvider {
    static var previews: some View {
        BindingTest()
    }
}
