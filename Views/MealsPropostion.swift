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
    @State var testMealList: [BigModel.Meal] = []
    
    var body: some View {
        
        VStack {
            
            VStack(spacing: 10) {
                
                BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                
                Text("MEALS")
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 100))
                Circle()
                    .foregroundStyle(Color.navyBlue)
                    .onTapGesture {
                        Task {
                            await bigModel.createMeals()
                        }
                    }
                
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
                            ForEach(bigModel.currentUser?.proposedMeals ?? []) { item in
                                Text(item.name)
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.navyBlue)
                                    .onTapGesture {
                                       
                                    }
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
            
        }//.edgesIgnoringSafeArea(.bottom)
    }

}
