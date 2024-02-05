//
//  BigRootView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 27/11/2023.
//

import SwiftUI

struct BigRootView: View {
    
    @EnvironmentObject var bigModel: BigModel
    
    var body: some View {
        
        VStack {
            if bigModel.currentView == .TastesView {
                TastesView()
            }
            if bigModel.currentView == .LegumeScreen {
                PreferenceView(categorie: "legumes", nextScreenName: .FruitsScreen)
            }
            if bigModel.currentView == .FruitsScreen {
                PreferenceView(categorie: "fruits", nextScreenName: .strachyFoodsScreen)
            }
            if bigModel.currentView == .strachyFoodsScreen {
                PreferenceView(categorie: "strachyFoods", nextScreenName: .proteinsScreen)
            }
            if bigModel.currentView == .proteinsScreen {
                PreferenceView(categorie: "proteins", nextScreenName: .seasonningScreen)
            }
            if bigModel.currentView == .seasonningScreen {
                PreferenceView(categorie: "seasonning", nextScreenName: .allergiesScreen)
            }
            if bigModel.currentView == .allergiesScreen {
                PreferenceView(categorie: "allergies", nextScreenName: .cookingToolsScreen)
            }
            if bigModel.currentView == .cookingToolsScreen {
                PreferenceView(categorie: "cookingTools", nextScreenName: .preferencesSummary)
            }
            if bigModel.currentView == .preferencesSummary {
                PreferenceSummary()
            }
            if bigModel.currentView == .budgetScreen {
                Budget_Screen()
            }
        }
        
        VStack {
            
            if bigModel.currentView == .welcomeView {
                WelcomeView()
            }
            if bigModel.currentView == .signInView {
                SignIN()
            }
            if bigModel.currentView == .UserView {
                UserView()
            }
            if bigModel.currentView == .timeScreen {
                TimeScreen()
            }
            if bigModel.currentView == .mealsPropositionScreen {
                if #available(iOS 17.0, *) {
                    MealsPropostion()
                } else {
                    // Fallback on earlier versions
                }
            }
            if bigModel.currentView == .RecipeScreen {
                RecipeScreen(bigModel: BigModel.shared)
            }
            if bigModel.currentView == .FavoriteMealsScreen {
                if #available(iOS 17.0, *) {
                    FavoriteMealsScreen(bigModel: BigModel.shared)
                } else {
                    // Fallback on earlier versions
                }
            }
            if bigModel.currentView == .BlankFile {
                BlankFile()
            }
            if bigModel.currentView == .NumberOfPersonScreen {
                NumberOfPersonScreen()
            }
            if bigModel.currentView == .DailyCalendar {
                DailyCalendar()
            }
            
        }
        
        if bigModel.currentView == .MealTypeView {
            MealType()
        }
        
        if bigModel.currentView == .SeasonSelectionView {
            SeasonSelection()
        }
        
        
    }
}
//case legumes, fruits, strachyFoods, proteins, seasonning, allergies, cookingTools
enum ViewEnum: String {
    case TastesView
    case LegumeScreen
    case FruitsScreen
    case strachyFoodsScreen
    case proteinsScreen
    case seasonningScreen
    case allergiesScreen
    case cookingToolsScreen
    case preferencesSummary
    case budgetScreen
    case timeScreen
    case mealsPropositionScreen
    case signInView
    case welcomeView
    case UserView
    case RecipeScreen
    case FavoriteMealsScreen
    case BlankFile
    case NumberOfPersonScreen
    case DailyCalendar
    case MealTypeView
    case SeasonSelectionView
}
