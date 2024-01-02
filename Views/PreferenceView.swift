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
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 5) {
                
                BackModel(color: Color.navyBlue, view: bigModel.categoryToScreenName(categorie: categorie))
                
                Text(bigModel.categoryName(categorie: categorie))
                    .foregroundStyle(Color.navyBlue)
                    .textCase(.uppercase)
                    .font(.system(size: 78))
                
                TextField("Search", text: $searchText)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
                
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(searchResults, id: \.self) { k in
                            TagButton(selected: self.binding(for: k), txt: k.name)
                        }
                    }
                }
                
                Spacer()
                
            }.padding(15)
            
            VStack {
                Spacer()
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.navyBlue)
                    Text("Validate")
                        .foregroundColor(.white)
                }.onTapGesture {
                    
                    Task {
                        var user = bigModel.currentUser
                        
                        if bigModel.screenHistory.last == .TastesView {
                            bigModel.currentView = .TastesView
                            bigModel.screenHistory.append(bigModel.categoryToScreenName(categorie: categorie))
                        }
                        else {
                            bigModel.currentView = nextScreenName
                        }
                        
                        user.items = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                        bigModel.storeCurrentUserInfoIntoDB(user: user) {}
                        
                        print(bigModel.currentUser.items)
                    }
                    
                }
            }.edgesIgnoringSafeArea(.all)
        }.onAppear {
            tags = bigModel.extractTagsPerCategorie(categorie: categorie)
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
            return tags.keys.sorted().filter { $0.name.contains(searchText) }
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
