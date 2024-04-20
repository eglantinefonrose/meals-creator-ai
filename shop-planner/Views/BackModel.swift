//
//  BackModel.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 30/11/2023.
//

import SwiftUI

struct BackModel: View {
    
    @ObservedObject var bigModel: BigModel = BigModel.shared
    var color: Color
    var view: ViewEnum
    
    var body: some View {
        HStack {
            Text("back")
                .foregroundStyle(color)
                .bold()
                .onTapGesture {
                    bigModel.currentView = NextView(view: view)
                    //bigModel.currentView = .mealsPropositionScreen
                    if bigModel.screenHistory.count > 0 {
                        self.bigModel.screenHistory.removeLast()
                    }
                }
            Spacer()
            Image(systemName: "house")
                .foregroundStyle(color)
                .onTapGesture {
                    bigModel.currentView = .UserView
                    bigModel.screenHistory.append(view)
                }
        }
    }
    
    func NextView(view: ViewEnum) -> ViewEnum {
        
        switch view {
            
        case .TastesView:
            return .UserView
            
        case .preferencesSummary:
            return .UserView
            
        case .LegumeScreen:
            return .TastesView
            
        case .FruitsScreen:
            return .TastesView
            
        case .strachyFoodsScreen:
            return .TastesView
            
        case .proteinsScreen:
            return .TastesView
            
        case .seasonningScreen:
            return .TastesView
            
        case .allergiesScreen:
            return .TastesView
            
        case .cookingToolsScreen:
            return .TastesView
            
        case .budgetScreen:
            return .UserView
            
        case .timeScreen:
            return .UserView
            
        case .mealsPropositionScreen:
            return .UserView
            
        case .signInView:
            return .signInView
            
        case .welcomeView:
            return .welcomeView
            
        case .UserView:
            return .UserView
            
        case .RecipeScreen:
            return bigModel.screenHistory.last!
            
        case .FavoriteMealsScreen:
            return bigModel.screenHistory.last!
            
        case .BlankFile:
            return .BlankFile
            
        case .NumberOfPersonScreen:
            return .UserView
            
        case .DailyCalendar:
            return bigModel.screenHistory.last!
            
        case .MealTypeView:
            return .seasonningScreen
            
        case .SeasonSelectionView:
            return .MealTypeView
            
        case .CurrencyScreen:
            return .budgetScreen
            
            
        case .InformationsScreen:
            return .UserView
            
        case .OpenAIKeyScreen:
            return .UserView
            
        }
    }
    
}

struct BackModel_Previews: PreviewProvider {
    static var previews: some View {
        BackModel(color: Color.blue, view: .FruitsScreen)
    }
}
