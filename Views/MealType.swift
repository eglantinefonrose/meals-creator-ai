//
//  MealType.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 31/12/2023.
//

import SwiftUI

struct MealType: View {
    
    @ObservedObject var bigModel: BigModel
    @State var selectedType: String = ""
    @State var seasonTags: [String: Bool] = ["Breakfast": false, "Main course": false, "Dessert": false, "Starter": false]
    
    var body: some View {
            
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                        
                        BackModel(color: .navyBlue, view: .MealTypeView)
                        
                        Text("meal-type")
                            .foregroundStyle(Color.navyBlue)
                            .font(.largeTitle)
                        
                        HStack {
                            
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(seasonTags["Breakfast"]! ? .navyBlue : .gray)
                                        .cornerRadius(20)
                                    Text("breakfast")
                                        .foregroundStyle(Color.white)
                                        .font(.title2)
                                }.onTapGesture {
                                    selectedType = "Breakfast"
                                    seasonTags["Breakfast"] = true
                                    seasonTags["Dessert"] = false
                                    seasonTags["Main course"] = false
                                    seasonTags["Starter"] = false
                                }
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(seasonTags["Dessert"]! ? .navyBlue : .gray)
                                        .cornerRadius(20)
                                    Text("dessert")
                                        .foregroundStyle(Color.white)
                                        .font(.title2)
                                }.onTapGesture {
                                    selectedType = "Dessert"
                                    seasonTags["Breakfast"] = false
                                    seasonTags["Dessert"] = true
                                    seasonTags["Main course"] = false
                                    seasonTags["Starter"] = false
                                }
                            }
                            
                            VStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(seasonTags["Main course"]! ? .navyBlue : .gray)
                                        .cornerRadius(20)
                                    Text("main-course")
                                        .foregroundStyle(Color.white)
                                        .font(.title2)
                                }.onTapGesture {
                                    selectedType = "Main course"
                                    seasonTags["Breakfast"] = false
                                    seasonTags["Dessert"] = false
                                    seasonTags["Main course"] = true
                                    seasonTags["Starter"] = false
                                }
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(seasonTags["Starter"]! ? .navyBlue : .gray)
                                        .cornerRadius(20)
                                    Text("starter")
                                        .foregroundStyle(Color.white)
                                        .font(.title2)
                                }.onTapGesture {
                                    selectedType = "Starter"
                                    seasonTags["Breakfast"] = false
                                    seasonTags["Dessert"] = false
                                    seasonTags["Main course"] = false
                                    seasonTags["Starter"] = true
                                }
                            }
                            
                        }
                        
                        Spacer()
                        
                }.padding(20)
                
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.navyBlue)
                    Text("validate")
                        .foregroundStyle(Color.white)
                        .onTapGesture {
                            //var user: BigModel.User = bigModel.currentUser
                            //user.proposedMeals = []
                            //user.favoriteMeals = []
                            //bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                            Task {
                                bigModel.currentView = .mealsPropositionScreen
                                bigModel.screenHistory.append(.MealTypeView)
                                try await bigModel.createMeals(mealType: selectedType)
                            }
                        }
                }
                
            }.edgesIgnoringSafeArea(.bottom)
        }
        
    }
}

#Preview {
    MealType(bigModel: BigModel.mocked)
}
