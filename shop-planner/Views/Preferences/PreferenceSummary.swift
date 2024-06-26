//
//  PreferenceSummary.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 28/11/2023.
//

import SwiftUI

struct PreferenceSummary: View {
    
    @ObservedObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ZStack {
            
            Color("navyBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.white, view: .budgetScreen)
                    
                    VStack {
                        
                        Text("preferences")
                            .foregroundStyle(Color.white)
                            .font(.largeTitle)
                        
                        VStack {
                            
                            ScrollView(.vertical) {
                                VStack {
                                    
                                    ForEach(bigModel.categoriesNameList) { category in
                                        HStack {
                                            Text(bigModel.categoryToName(categorie: category.name))
                                                .foregroundStyle(Color.white)
                                                .font(.title)
                                            Spacer()
                                        }
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(bigModel.extractItemsPerCategorie(categorie: category.name)) { item in
                                                    ZStack {
                                                        Rectangle()
                                                            .foregroundColor(.white)
                                                            .frame(width: 150, height: 150)
                                                        VStack {
                                                            Spacer()
                                                            HStack {
                                                                Text(item.name)
                                                                    .foregroundStyle(Color.blue)
                                                                Spacer()
                                                            }
                                                        }.padding(10)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(bigModel.currentUser.tools) { item in
                                                ZStack {
                                                    Rectangle()
                                                        .foregroundColor(.white)
                                                        .frame(width: 150, height: 150)
                                                    VStack {
                                                        Spacer()
                                                        HStack {
                                                            Text(item.name)
                                                                .foregroundStyle(Color.blue)
                                                            Spacer()
                                                        }
                                                    }.padding(10)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                }.padding(20)
                
                VStack(spacing: 0) {
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.gray)
                        Text("edit")
                            .foregroundStyle(Color.white)
                    }.onTapGesture {
                        bigModel.screenHistory.append(.preferencesSummary)
                        bigModel.currentView = .TastesView
                    }
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.white)
                        Text("validate")
                            .foregroundStyle(Color.blue)
                    }.onTapGesture {
                        bigModel.screenHistory.append(.preferencesSummary)
                        bigModel.currentView = .budgetScreen
                        //bigModel.isNewUser = false
                    }
                }.edgesIgnoringSafeArea(.all)
                
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct PreferenceSummary_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceSummary(bigModel: BigModel.mocked)
            .environmentObject(BigModel.mocked)
    }
}
