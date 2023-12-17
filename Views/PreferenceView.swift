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
    
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 5) {
                
                BackModel(color: Color.navyBlue, view: bigModel.categoryToScreenName(categorie: categorie))
                
                Text(bigModel.categoryName(categorie: categorie))
                    .foregroundStyle(Color.navyBlue)
                    .textCase(.uppercase)
                    .font(.system(size: 78))
                
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(tags.keys.sorted(), id: \.self) { k in
                        TagButton(selected: self.binding(for: k), txt: k.name)
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
                        .onTapGesture {
                            
                            var user = bigModel.currentUser
                            
                            if bigModel.screenHistory.last == .TastesView {
                                bigModel.currentView = .UserView
                                bigModel.screenHistory.append(bigModel.categoryToScreenName(categorie: categorie))
                            } else {
                                bigModel.currentView = nextScreenName
                            }
                            
                            user?.items = bigModel.updatedSelectedItemsList(dict: tags, categorie: categorie)
                            bigModel.updateCurrentUserInfoInDB(user: user!)
                            
                            print(bigModel.currentUser?.items ?? 0)
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
            bigModel.didPreferencesChanged = true
        }
    }

}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView(categorie: "legumes", nextScreenName: .FruitsScreen)
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
