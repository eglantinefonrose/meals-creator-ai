//
//  SeasonSelection.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 02/01/2024.
//

import SwiftUI

struct SeasonSelection: View {
    
    @ObservedObject var bigModel: BigModel
    @State var seasonTags: [String: Bool] = ["Hiver": false, "Printemps": false, "Été": false, "Automne": false]
    
    var body: some View {
        
        VStack {
            
            VStack {
                BackModel(color: .blue, view: .MealTypeView)
                
                Text("season")
                    .foregroundStyle(Color.blue)
                    .font(.largeTitle)
                
                HStack {
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Hiver"]! ? .blue : .gray)
                                .cornerRadius(20)
                            Text("winter")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = true
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = false
                            bigModel.selectedSeason = "hiver"
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Printemps"]! ? .blue : .gray)
                                .cornerRadius(20)
                            Text("spring")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = true
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = false
                            bigModel.selectedSeason = "printemps"
                        }
                    }
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Été"]! ? .blue : .gray)
                                .cornerRadius(20)
                            Text("summer")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = true
                            seasonTags["Automne"] = false
                            bigModel.selectedSeason = "été"
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Automne"]! ? .blue : .gray)
                                .cornerRadius(20)
                            Text("autumn")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = true
                            bigModel.selectedSeason = "automne"
                        }
                        
                    }
                    
                }
            }.padding(20)
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.blue)
                Text("validate")
                    .foregroundStyle(Color.white)
            }.onTapGesture {
                bigModel.currentView = .MealTypeView
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

#Preview {
    SeasonSelection(bigModel: BigModel.mocked)
}
