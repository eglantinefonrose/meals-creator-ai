//
//  PreferenceView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI

struct PreferenceView: View {
    
    @ObservedObject var bigModel: BigModel = BigModel.shared
    let columns = [GridItem(.adaptive(minimum: 150))]
    @State var selectedItems: [BigModel.Item] = []
    @State var selectedTools: [BigModel.Item] = []
    @State var tags: [BigModel.Item: Bool] = [:]
    let categorie: String
    var nextScreenName: ViewEnum
    @State private var searchText = ""
    @State var season: String = "All"
    
    var body: some View {
        
        if #available(iOS 17.0, *) {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                
                BackModel(color: Color.navyBlue, view: bigModel.categoryToScreenName(categorie: categorie))
                
                Text(bigModel.categoryName(categorie: categorie))
                    .foregroundStyle(Color.navyBlue)
                    .font(.system(size: 78))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .frame(height: 40)
                    TextField("search", text: $searchText)
                        .disableAutocorrection(true)
                        .padding(10)
                    .autocapitalization(.none)
                }
                
                ScrollView(.horizontal) {
                   
                    HStack {
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(season == "All" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("all")
                                .foregroundColor(season == "All" ? Color.white : Color.black)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            season = "All"
                            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentItems), categorie: categorie, season: "All")
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(season == "Hiver" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("winter")
                                .foregroundColor(season == "Hiver" ? Color.white : Color.black)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            season = "Hiver"
                            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentItems), categorie: categorie, season: "hiver")
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(season == "Printemps" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("spring")
                                .foregroundColor(season == "Printemps" ? Color.white : Color.black)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            season = "Printemps"
                            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentItems), categorie: categorie, season: "printemps")
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(season == "Été" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("summer")
                                .foregroundColor(season == "Été" ? Color.white : Color.black)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            season = "Été"
                            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentItems), categorie: categorie, season: "été")
                        }
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(10)
                                .foregroundColor(season == "Automne" ? Color.navyBlue : Color.gray)
                                .frame(height: 50)
                            Text("autumn")
                                .foregroundColor(season == "Automne" ? Color.white : Color.black)
                                .padding(.horizontal, 20)
                        }.onTapGesture {
                            season = "Automne"
                            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentItems), categorie: categorie, season: "automne")
                        }
                        
                    }
                }
                
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(searchResults, id: \.self) { k in
                            
                            TagButton(selected: self.binding(for: k), txt: k.name, item: k)
                            
                        }
                    }
                }.padding(.vertical, 10)
                
                Spacer()
                
            }.padding(15)
            
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.navyBlue)
                    Text("validate")
                        .foregroundColor(.white)
                }.onTapGesture {
                    
                    Task {
                        
                        var user = bigModel.currentUser
                        
                        /*if (bigModel.currentView == .cookingToolsScreen) {
                            user.tools = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                        } else {
                            user.items = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                        }*/
                        
                        if (bigModel.currentView == .cookingToolsScreen) {
                            user.tools = bigModel.updatedSelectedItemsList2(list: bigModel.currentItems, categorie: categorie)
                        } else {
                            user.items = bigModel.updatedSelectedItemsList2(list: bigModel.currentItems, categorie: categorie)
                        }
                        
                        bigModel.storeCurrentUserInfoIntoDB(user: user)
                        
                        //print(bigModel.currentUser.items)
                        
                        if bigModel.screenHistory.last == .TastesView {
                            bigModel.currentView = .TastesView
                            bigModel.screenHistory.append(bigModel.categoryToScreenName(categorie: categorie))
                        }
                        else {
                            bigModel.currentView = nextScreenName
                        }
                    }
                    
                }
            }.edgesIgnoringSafeArea(.all)
        }.onAppear {
            bigModel.currentItems = []
            tags = extractTagsPerCategorieAndSeason(tagList: compareLists(list1: bigModel.currentUser.items), categorie: categorie, season: "All")
            print("tags")
            print(tags)
        }
    } else {
        // Fallback on earlier versions
    }
        
    }
        
    
    
    private func binding(for key: BigModel.Item) -> Binding<Bool> {
        
        return .init(
            get: { self.tags[key, default: false] },
            set: { self.tags[key] = $0 })
    }
    
    var searchResults: [BigModel.Item] {
        if searchText.isEmpty {
            return tags.keys.sorted()
        } else {
            return tags.keys.sorted().filter { $0.name.capitalized.contains(searchText.capitalized) }
        }
    }
    
    func compareLists(list1: [BigModel.Item]) -> [BigModel.Item: Bool] {
        var resultDictionary = [BigModel.Item: Bool]()
        
        // Crée un ensemble des noms d'items dans la liste1 pour une recherche plus efficace
        let setList1 = Set(list1.map { $0 })

        // Parcourt la liste2 et vérifie si chaque item est présent dans la liste1
        for item in bigModel.items {
            resultDictionary[item] = setList1.contains(item)
        }

        return resultDictionary
    }
    
    private func extractTagsPerCategorieAndSeason(tagList: [BigModel.Item: Bool], categorie: String, season: String) -> [BigModel.Item:Bool] {
        var tags: [BigModel.Item:Bool] = [:]
        
        for (key, value) in tagList {
            if key.category == categorie {
                if key.seasons.contains(season) {
                    tags[key] = value
                }
                if season == "All" {
                    tags[key] = value
                }
            }
        }
        return tags
    }
    
    private func removeFromList(list: [BigModel.Item], item: BigModel.Item) -> [BigModel.Item] {
        var newList: [BigModel.Item] = list
        if let index = list.firstIndex(where: { $0.id == item.id }) {
            newList.remove(at: index)
        }
        return newList
    }
    
}

struct TagButton: View {
    
    @EnvironmentObject var bigModel: BigModel
    @Binding var selected: Bool
    var txt: String
    var item: BigModel.Item
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .frame(minWidth: 150, minHeight: 150)
                .foregroundColor(selected ? .navyBlue : .gray)
            Text(txt)
                .foregroundColor(.white)
        }.onTapGesture {
            self.selected.toggle()
            if selected == false {
                bigModel.currentItems = removeFromList(list: bigModel.currentItems, item: item)
            } else {
                bigModel.currentItems.append(item)
            }
            //if bigModel.currentUser.proposedMeals != [] {
                //bigModel.didPreferencesChanged = true
            //}
        }
        
    }
    
    private func removeFromList(list: [BigModel.Item], item: BigModel.Item) -> [BigModel.Item] {
        var newList: [BigModel.Item] = list
        if let index = list.firstIndex(where: { $0.id == item.id }) {
            newList.remove(at: index)
        }
        return newList
    }

}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(categorie: "legumes", nextScreenName: .FruitsScreen)
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
