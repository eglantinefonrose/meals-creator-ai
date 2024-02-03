//
//  PreferenceView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI

struct PreferenceView: View {
    
    @EnvironmentObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    @State var selectedItems: [BigModel.Item] = []
    @State var selectedTools: [BigModel.Item] = []
    @State var tags: [BigModel.Item: Bool] = [:]
    let categorie: String
    var nextScreenName: ViewEnum
    @State private var searchText = ""
    @State var season: String = "All"
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 5) {
                
                BackModel(color: Color.navyBlue, view: bigModel.categoryToScreenName(categorie: categorie))
                
                Text(bigModel.categoryName(categorie: categorie))
                    .foregroundStyle(Color.navyBlue)
                    .textCase(.uppercase)
                    .font(.system(size: 78))
                
                TextField("search", text: $searchText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                
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
                            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "All")
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
                            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "hiver")
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
                            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "printemps")
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
                            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "été")
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
                            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "automne")
                        }
                        
                    }
                }
                
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(searchResults, id: \.self) { k in
                            TagButton(selected: self.binding(for: k), txt: k.name)
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
                        
                        if (bigModel.currentView == .cookingToolsScreen) {
                            user.tools = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                        } else {
                            user.items = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                        }
                        
                        bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                        
                        print(bigModel.currentUser.items)
                        
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
            tags = bigModel.extractTagsPerCategorieAndSeason(categorie: categorie, season: "All")
            print("tags")
            print(tags)
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
    
}

struct TagButton: View {
    
    @EnvironmentObject var bigModel: BigModel
    @Binding var selected: Bool
    var txt: String
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .frame(minWidth: 150, minHeight: 150)
                .foregroundColor(selected ? .navyBlue : .gray)
            Text(txt)
                .foregroundColor(.white)
        }.onTapGesture {
            self.selected.toggle()
            if bigModel.currentUser.proposedMeals != [] {
                bigModel.didPreferencesChanged = true
            }
        }
    }

}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(categorie: "legumes", nextScreenName: .FruitsScreen)
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
