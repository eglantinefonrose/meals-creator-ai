//
//  BigRootView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 27/11/2023.
//

import SwiftUI

struct BigRootView: View {
    
    @ObservedObject var bigModel: BigModel
    var mocked: Bool
    
    var body: some View {
        
        if mocked {
            
            VStack {
                if bigModel.currentView == .TastesView {
                    TastesView(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .LegumeScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "legumes", nextScreenName: .FruitsScreen)
                }
                if bigModel.currentView == .FruitsScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "fruits", nextScreenName: .strachyFoodsScreen)
                }
                if bigModel.currentView == .strachyFoodsScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "strachyFoods", nextScreenName: .proteinsScreen)
                }
                if bigModel.currentView == .proteinsScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "proteins", nextScreenName: .seasonningScreen)
                }
                if bigModel.currentView == .seasonningScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "seasonning", nextScreenName: .allergiesScreen)
                }
                if bigModel.currentView == .allergiesScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "allergies", nextScreenName: .cookingToolsScreen)
                }
                if bigModel.currentView == .cookingToolsScreen {
                    PreferenceView(bigModel: BigModel.mocked, categorie: "cookingTools", nextScreenName: .preferencesSummary)
                }
                if bigModel.currentView == .preferencesSummary {
                    PreferenceSummary(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .budgetScreen {
                    Budget_Screen(bigModel: BigModel.mocked)
                }
            }
            
            VStack {
                
                /*if bigModel.currentView == .welcomeView {
                    WelcomeView(bigModel: BigModel.mocked)
                }*/
                if bigModel.currentView == .signInView {
                    SignIN(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .UserView {
                    UserView(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .timeScreen {
                    TimeScreen(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .mealsPropositionScreen {
                    if #available(iOS 17.0, *) {
                        MealsPropostion(bigModel: BigModel.mocked)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                if bigModel.currentView == .RecipeScreen {
                    RecipeScreen(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .FavoriteMealsScreen {
                    if #available(iOS 17.0, *) {
                        FavoriteMealsScreen(bigModel: BigModel.mocked)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                if bigModel.currentView == .BlankFile {
                    BlankFile(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .NumberOfPersonScreen {
                    NumberOfPersonScreen(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .DailyCalendar {
                    DailyCalendar(bigModel: BigModel.mocked)
                }
                if bigModel.currentView == .InformationsScreen {
                    InformationsScreen(bigModel: BigModel.mocked)
                }
                
            }
            
            if bigModel.currentView == .MealTypeView {
                MealType(bigModel: BigModel.mocked)
            }
            
            if bigModel.currentView == .SeasonSelectionView {
                SeasonSelection(bigModel: BigModel.mocked)
            }
            
        } else {
            
            VStack {
                if bigModel.currentView == .TastesView {
                    TastesView(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .LegumeScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "legumes", nextScreenName: .FruitsScreen)
                }
                if bigModel.currentView == .FruitsScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "fruits", nextScreenName: .strachyFoodsScreen)
                }
                if bigModel.currentView == .strachyFoodsScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "strachyFoods", nextScreenName: .proteinsScreen)
                }
                if bigModel.currentView == .proteinsScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "proteins", nextScreenName: .seasonningScreen)
                }
                if bigModel.currentView == .seasonningScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "seasonning", nextScreenName: .allergiesScreen)
                }
                if bigModel.currentView == .allergiesScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "allergies", nextScreenName: .cookingToolsScreen)
                }
                if bigModel.currentView == .cookingToolsScreen {
                    PreferenceView(bigModel: BigModel.shared, categorie: "cookingTools", nextScreenName: .preferencesSummary)
                }
                if bigModel.currentView == .preferencesSummary {
                    PreferenceSummary(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .budgetScreen {
                    Budget_Screen(bigModel: BigModel.shared)
                }
            }
            
            VStack {
                
                if bigModel.currentView == .signInView {
                    SignIN(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .UserView {
                    UserView(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .timeScreen {
                    TimeScreen(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .mealsPropositionScreen {
                    if #available(iOS 17.0, *) {
                        MealsPropostion(bigModel: BigModel.shared)
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
                    BlankFile(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .NumberOfPersonScreen {
                    NumberOfPersonScreen(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .DailyCalendar {
                    DailyCalendar(bigModel: BigModel.shared)
                }
                if bigModel.currentView == .InformationsScreen {
                    InformationsScreen(bigModel: BigModel.shared)
                }
                
            }
            
            if bigModel.currentView == .MealTypeView {
                MealType(bigModel: BigModel.shared)
            }
            
            if bigModel.currentView == .SeasonSelectionView {
                SeasonSelection(bigModel: BigModel.shared)
            }
            
            if bigModel.currentView == .CurrencyScreen {
                CurrencyScreen(bigModel: BigModel.shared)
            }
            
            if bigModel.currentView == .OpenAIKeyScreen {
                OpenAIKeyScreen(bigModel: BigModel.shared)
            }
            
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
    case CurrencyScreen
    case InformationsScreen
    case OpenAIKeyScreen
}
