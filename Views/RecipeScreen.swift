//
//  RecipeScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 13/12/2023.
//

import SwiftUI

struct RecipeScreen: View {
    
    @EnvironmentObject var bigModel: BigModel
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        
        VStack {
            
             VStack {
                 
                 VStack(spacing: 10) {
                  
                  BackModel(color: Color.navyBlue, view: .mealsPropositionScreen)
                  
                  Text(bigModel.selectedMeal.name.uppercased())
                      .foregroundStyle(Color.navyBlue)
                      .font(.system(size: 70))
                     
                     ScrollView {
                         
                         VStack(alignment: .leading, spacing: 10) {
                             Text("Ingrédients")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                                 .onTapGesture {
                                    
                             }
                             Rectangle().fill(Color.navyBlue).frame(height: 1)
                         }
                         
                         LazyVGrid(columns: columns, spacing: 5) {
                             ForEach(bigModel.selectedMeal.itemsAndQ , id: \.self) { k in
                                 ZStack {
                                     Rectangle()
                                         .frame(minWidth: 150, minHeight: 150)
                                         .foregroundColor(.gray)
                                     HStack {
                                         VStack(alignment: .leading) {
                                             Spacer()
                                             Text(k.item.name)
                                                 .foregroundColor(.white)
                                             Text("\(k.quantity)")
                                                 .foregroundStyle(Color.navyBlue)
                                         }
                                         Spacer()
                                     }.padding(10)
                                 }
                             }
                         }
                         
                         HStack {
                             Text("Total time")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                             Text("\(bigModel.selectedMeal.spendedTime)")
                                 .foregroundStyle(Color.navyBlue)
                         }
                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                         
                         HStack {
                             Text("Average price")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                             Text("\(bigModel.selectedMeal.price)")
                                 .foregroundStyle(Color.navyBlue)
                         }
                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                         
                         HStack {
                             Text("Recipe")
                                 .font(.largeTitle)
                                 .foregroundStyle(Color.navyBlue)
                             Spacer()
                         }
                         //Rectangle().fill(Color.navyBlue).frame(height: 1)
                         Text(bigModel.selectedMeal.recipe)
                     }
                       
                }.padding(20)
                                  
                 Spacer()
                 
                 ZStack {
                     Rectangle()
                         .frame(height: 60)
                         .foregroundStyle(Color.navyBlue)
                     Text("Add to favourite")
                         .foregroundStyle(Color.white)
                         .onTapGesture {
                             bigModel.currentUser?.favoriteMeals.append(bigModel.selectedMeal)
                         }
                 }
                 
             }
             
         }.edgesIgnoringSafeArea(.bottom)
     }
}

struct RecipeScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecipeScreen()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
