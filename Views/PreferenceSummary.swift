//
//  PreferenceSummary.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 28/11/2023.
//

import SwiftUI

struct PreferenceSummary: View {
    
    @EnvironmentObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        
        VStack {
            
            BackModel(color: Color.white, view: .preferencesSummary)
            
            VStack {
                ScrollView {
                    ForEach(Categories.allCases, id: \.self) { category in
                        
                        VStack(alignment: .leading) {
                            Text(bigModel.categoryName(categorie: category))
                                .font(.largeTitle)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(bigModel.extractItemsPerCategorie(categorie: category)) { item in
                                        ZStack {
                                            Rectangle()
                                                .frame(minWidth: 75, minHeight: 75)
                                                .foregroundColor(.gray)
                                            Text(item.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            ZStack {
                Rectangle()
                    .frame(height: 60)
                    .foregroundStyle(Color.navyBlue)
                Text("Validate")
                    .foregroundColor(.white)
                    .onTapGesture {
                        bigModel.screenHistory.append(.preferencesSummary)
                        bigModel.currentView = .budgetScreen
                    }
            }
            
            Spacer()
            
        }.padding(10)
        
    }
}

/*struct PreferenceSummary_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceSummary()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}*/
