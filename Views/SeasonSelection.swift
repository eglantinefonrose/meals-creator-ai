//
//  SeasonSelection.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 02/01/2024.
//

import SwiftUI

struct SeasonSelection: View {
    
    @EnvironmentObject var bigModel: BigModel
    @State var seasonTags: [String: Bool] = ["Hiver": false, "Printemps": false, "Été": false, "Automne": false]
    
    var body: some View {
        
        VStack {
            
            VStack {
                BackModel(color: .navyBlue, view: .MealTypeView)
                
                Text("SEASON")
                    .foregroundStyle(Color.navyBlue)
                    .font(.largeTitle)
                
                HStack {
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Hiver"]! ? .navyBlue : .gray)
                                .cornerRadius(20)
                            Text("Hiver")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = true
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = false
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Printemps"]! ? .navyBlue : .gray)
                                .cornerRadius(20)
                            Text("Printemps")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = true
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = false
                        }
                    }
                    
                    VStack {
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Été"]! ? .navyBlue : .gray)
                                .cornerRadius(20)
                            Text("Été")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = true
                            seasonTags["Automne"] = false
                        }
                        
                        ZStack {
                            Rectangle()
                                .foregroundColor(seasonTags["Automne"]! ? .navyBlue : .gray)
                                .cornerRadius(20)
                            Text("Automne")
                                .foregroundStyle(Color.white)
                                .font(.title2)
                        }.onTapGesture {
                            seasonTags["Hiver"] = false
                            seasonTags["Printemps"] = false
                            seasonTags["Été"] = false
                            seasonTags["Automne"] = true
                        }
                        
                    }
                    
                }
            }.padding(20)
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.navyBlue)
                Text("Validate")
                    .foregroundStyle(Color.white)
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
}

#Preview {
    SeasonSelection()
}
