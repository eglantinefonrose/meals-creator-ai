//
//  ContentView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI

struct TastesView: View {
    
    //var preferenceList = ["Legumes", "Fruits", "Starchy foods", "Meat", "Seasonning", "Allergies", "Cooking tools"]
    @ObservedObject var bigModel: BigModel = BigModel.shared
    
    /*switch categorie {
     case "legumes":
         return "Legumes"
     case "fruits":
         return "Fruits"
     case "strachyFoods":
         return "Strachy foods"
     case "proteins":
         return "Proteins"
     case "seasonning":
         return "Seasonning"
     case "allergies":
         return "Allergies"
     case "cookingTools":
         return "Cooking tools"
 default:
     return ""
 }*/
    
    var preferenceList = [PreferenceItem(id: 0, name: "legumes"), PreferenceItem(id: 1, name: "fruits"), PreferenceItem(id: 2, name: "strachyFoods"), PreferenceItem(id: 3, name: "proteins"), PreferenceItem(id: 4, name: "seasonning"), PreferenceItem(id: 5, name: "allergies"), PreferenceItem(id: 6, name: "cookingTools")]
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.navyBlue, view: .TastesView)
                    
                    Text("tastes")
                        .textCase(.uppercase)
                        .foregroundStyle(Color.navyBlue)
                        .font(.system(size: 100))
                    Circle()
                        .foregroundStyle(Color.navyBlue)
                    
                    VStack(alignment: .leading) {
                        Text("select-preferences")
                            .foregroundStyle(Color.navyBlue)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(preferenceList) { preferenceList in
                                    
                                    VStack {
                                        
                                        HStack {
                                            Text(bigModel.categoryToName(categorie: preferenceList.name))
                                                .font(.largeTitle)
                                                .foregroundStyle(Color.navyBlue)
                                            Spacer()
                                        }
                                        
                                        HStack {
                                            if bigModel.currentUser.items.count != 0 {
                                                ScrollView(.horizontal) {
                                                   HStack {
                                                       ForEach(bigModel.currentUser.items) { item in
                                                           if (item.category == preferenceList.name) {
                                                               
                                                               if bigModel.images.count != 0 {
                                                                   if let index = bigModel.images.firstIndex(where: { $0.id == item.id }) {
                                                                       bigModel.images[index].image
                                                                           .resizable()
                                                                           .frame(width: 100, height: 100)
                                                                   }
                                                               }
                                                               
                                                               /*ForEach(bigModel.images) { image in
                                                                   if (item.id == image.id) {
                                                                       Image(uiImage: image)
                                                                           .resizable()
                                                                           .frame(width: 100, height: 100)
                                                                   }
                                                               }*/
                                                           }
                                                       }
                                                       
                                                       /*Image(uiImage: UIImage(named: "broccoli")!)
                                                           .resizable()
                                                           .frame(width: 100, height: 100)
                                                       
                                                       Image(uiImage: UIImage(named: "pasta")!)
                                                           .resizable()
                                                           .frame(width: 100, height: 100)*/
                                                       
                                                      //Image(UIImage(named: "Broccoli Tattoo"))
                                                   }
                                                }
                                            } else {
                                                Text("tell-us")
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }
                                        
                                        Rectangle().fill(Color.navyBlue).frame(height: 1)
                                    }.onTapGesture {
                                        bigModel.currentView = categoryNameToNextScreen(categorie: preferenceList)
                                        bigModel.screenHistory.append(.TastesView)
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                }.padding(.leading)
                .padding(.trailing)
                .padding(.top)
                            
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.navyBlue)
                    Text("validate")
                        .foregroundColor(.white)
                }.onTapGesture {
                    
                    //var user = bigModel.currentUser
                    
                    if (bigModel.screenHistory.last == .LegumeScreen || bigModel.screenHistory.last == .FruitsScreen || bigModel.screenHistory.last == .strachyFoodsScreen || bigModel.screenHistory.last == .proteinsScreen || bigModel.screenHistory.last == .seasonningScreen || bigModel.screenHistory.last == .allergiesScreen || bigModel.screenHistory.last == .cookingToolsScreen) {
                        bigModel.currentView = .UserView
                        bigModel.screenHistory.append(.TastesView)
                    } else {
                        bigModel.currentView = .preferencesSummary
                        bigModel.screenHistory.append(.TastesView)
                        print(bigModel.currentUser.items)
                    }
                    
                }
                
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

func categoryNameToNextScreen(categorie: PreferenceItem) -> ViewEnum {
    if categorie.id == 0 {
        return .LegumeScreen
    }
    if categorie.id == 1 {
        return .FruitsScreen
    }
    if categorie.id == 2 {
        return .strachyFoodsScreen
    }
    if categorie.id == 3 {
        return .proteinsScreen
    }
    if categorie.id == 4 {
        return .seasonningScreen
    }
    if categorie.id == 5 {
        return .allergiesScreen
    }
    if categorie.id == 6 {
        return .cookingToolsScreen
    }
    else {
        return .LegumeScreen
    }
}

struct PreferenceItem: Identifiable {
    var id: Int
    var name: String
}

extension Color {
    static let navyBlue = Color(red: 27 / 255, green: 44 / 255, blue: 137 / 255)
}

struct TastesView_Previews: PreviewProvider {
    static var previews: some View {
        TastesView()
    }
}
