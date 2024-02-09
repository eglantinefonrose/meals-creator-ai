//
//  UserView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 30/11/2023.
//

import SwiftUI

struct UserView: View {
    
    let preferences = [Preference(id: 0, name: "Tastes", nextScreen: .TastesView), Preference(id: 1, name: "Budget", nextScreen: .budgetScreen), Preference(id: 2, name: "Spended time", nextScreen: .timeScreen), Preference(id: 3, name: "Proposed meals", nextScreen: .mealsPropositionScreen), Preference(id: 4, name: "Favorite meals", nextScreen: .mealsPropositionScreen)]
    @ObservedObject var bigModel: BigModel = BigModel.shared
    @State var newFirstName: String = ""
    @State var newLastName: String = ""
    @State var isEditModeOn = false
    @State var firstName = ""
    @State var lastName = ""
    @FocusState var focused1: Bool?
    @FocusState var focused2: Bool?
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack {
                    VStack(spacing: 30) {
                        
                        HStack {
                            Text("back")
                                .foregroundStyle(.white)
                                .bold()
                            Spacer()
                        }
                        
                        ZStack {
                            Circle()
                                .frame(width: 150)
                                .foregroundColor(.gray)
                            Text("\(String(bigModel.currentUser.firstName.prefix(1) ))\(String(bigModel.currentUser.lastName.prefix(1) ))")
                                .font(.title)
                                .bold()
                                .foregroundColor(.white)
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                
                                if !isEditModeOn {
                                    Text(firstName)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            isEditModeOn.toggle()
                                        }
                                    
                                    Text(lastName)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            isEditModeOn.toggle()
                                        }
                                }
                                
                                if isEditModeOn {
                                    TextField("", text: $newFirstName)
                                        .multilineTextAlignment(.leading)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .focused($focused1, equals: true)
                                        .onAppear {
                                          DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            self.focused1 = true
                                          }
                                        }
                                    
                                    TextField("", text: $newLastName)
                                        .multilineTextAlignment(.leading)
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .focused($focused2, equals: true)
                                        .onAppear {
                                          DispatchQueue.main.asyncAfter(deadline: .now()) {
                                            self.focused2 = true
                                          }
                                        }
                                }
                                
                            }
                            Spacer()
                            
                            if !isEditModeOn {
                                Text("edit")
                                    .foregroundColor(.white)
                                    .bold()
                                    .onTapGesture {
                                        isEditModeOn.toggle()
                                    }
                            } else {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .bold()
                                    .onTapGesture {
                                        
                                        if isEditModeOn {
                                            //bigModel.updateUserNames(firstName: newFirstName, lastName: newLastName)
                                            Task {
                                                var user = bigModel.currentUser
                                                user.firstName = newFirstName
                                                user.lastName = newLastName
                                                bigModel.storeCurrentUserInfoIntoDB(user: user)
                                                firstName = newFirstName
                                                lastName = newLastName
                                                isEditModeOn.toggle()
                                            }
                                        } else {
                                            isEditModeOn.toggle()
                                        }
                                        
                                    }
                            }
                            
                        }
                    }.padding(20)
                }.background(Color.navyBlue)
                            
                VStack(spacing: 0) {
                    
                    VStack() {
                        HStack {
                            Text("pref")
                                .foregroundStyle(Color.navyBlue)
                                .font(.title3)
                            Spacer()
                        }
                        
                         if (bigModel.currentUser.items.count == 0 && bigModel.currentUser.budget == 0 && bigModel.currentUser.spendedTime == 0 && bigModel.currentUser.favoriteMeals.count == 0) {
                            
                            VStack {
                                Spacer()
                                Text("start-selecting")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        bigModel.currentView = .TastesView
                                        bigModel.screenHistory.append(.UserView)
                                    }
                                Spacer()
                            }
                            
                         } else {
                                 ScrollView {
                                     VStack(alignment: .leading) {
                                         
                                         VStack(alignment: .leading) {
                                             Text("tastes")
                                                 .font(.largeTitle)
                                                 .foregroundStyle(Color.navyBlue)
                                             HStack {
                                                 if bigModel.currentUser.items.count != 0 {
                                                     ScrollView(.horizontal) {
                                                        HStack {
                                                            ForEach(bigModel.currentUser.items) { item in
                                                                Text(item.name)
                                                            }
                                                        }
                                                     }
                                                 } else {
                                                     Text("tell-us")
                                                         .foregroundColor(.gray)
                                                 }
                                                 Spacer()
                                                 Image(systemName: "arrow.right.circle")
                                                     .foregroundColor(Color.navyBlue)
                                                     .onTapGesture {
                                                         bigModel.currentView = .TastesView
                                                         bigModel.screenHistory.append(.UserView)
                                                     }
                                             }
                                             Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         }
                                         
                                         VStack(alignment: .leading) {
                                             Text("tools")
                                                 .font(.largeTitle)
                                                 .foregroundStyle(Color.navyBlue)
                                             HStack {
                                                 if bigModel.currentUser.tools.count != 0 {
                                                     ScrollView(.horizontal) {
                                                         HStack {
                                                             ForEach(bigModel.currentUser.tools) { item in
                                                                     Text(item.name)
                                                             }
                                                         }
                                                     }
                                                 } else {
                                                     Text("tellus-1")
                                                         .foregroundColor(.gray)
                                                 }
                                                 Spacer()
                                                 Image(systemName: "arrow.right.circle")
                                                     .foregroundColor(Color.navyBlue)
                                                     .onTapGesture {
                                                         bigModel.currentView = .cookingToolsScreen
                                                         bigModel.screenHistory.append(.UserView)
                                                     }
                                             }
                                             Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         }
                                         
                                         Text("budget")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         
                                         HStack {
                                             if bigModel.currentUser.budget != 0 {
                                                 Text(String(bigModel.currentUser.budget))
                                             } else {
                                                 Text("tellus-2")
                                                     .foregroundColor(.gray)
                                             }
                                             Spacer()
                                             Image(systemName: "arrow.right.circle")
                                                 .foregroundColor(Color.navyBlue)
                                                 .onTapGesture {
                                                     bigModel.currentView = .budgetScreen
                                                     bigModel.screenHistory.append(.UserView)
                                                 }
                                         }
                                         
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         
                                         Text("number-of-person")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                     
                                         HStack {
                                                 if bigModel.currentUser.numberOfPerson != 0 {
                                                     Text(String(bigModel.currentUser.numberOfPerson))
                                                 } else {
                                                     Text("tellus-3")
                                                         .foregroundColor(.gray)
                                                 }
                                                 Spacer()
                                                 Image(systemName: "arrow.right.circle")
                                                     .foregroundColor(Color.navyBlue)
                                                     .onTapGesture {
                                                         bigModel.currentView = .NumberOfPersonScreen
                                                         bigModel.screenHistory.append(.UserView)
                                                     }
                                         }
                                     
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         
                                         Text("spent-time")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         
                                         HStack {
                                             if bigModel.currentUser.budget != 0 {
                                                 Text(String(bigModel.currentUser.spendedTime))
                                             } else {
                                                 Text("tellus-4")
                                                     .foregroundColor(.gray)
                                             }
                                             Spacer()
                                             Image(systemName: "arrow.right.circle")
                                                 .foregroundColor(Color.navyBlue)
                                                 .onTapGesture {
                                                     bigModel.currentView = .timeScreen
                                                     bigModel.screenHistory.append(.UserView)
                                                 }
                                         }
                                         
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         
                                         VStack(alignment: .leading) {
                                             Text("proposed-meals")
                                                 .font(.largeTitle)
                                                 .foregroundStyle(Color.navyBlue)
                                             HStack {
                                                 
                                                 if bigModel.currentUser.proposedMeals.count != 0 {
                                                     ScrollView(.horizontal) {
                                                         HStack {
                                                             ForEach(bigModel.currentUser.proposedMeals) { meal in
                                                                 Text(meal.recipe.recipeName)
                                                             }
                                                         }
                                                     }
                                                 } else {
                                                     if bigModel.currentUser.items.count != 0 && bigModel.currentUser.tools.count != 0 && bigModel.currentUser.numberOfPerson != 0 && bigModel.currentUser.budget != 0 && bigModel.currentUser.spendedTime != 0 {
                                                         HStack {
                                                             Text("click-here")
                                                                 .foregroundColor(.gray)
                                                             Spacer()
                                                         }
                                                     } else {
                                                         HStack {
                                                             Text("fill-infos")
                                                                 .foregroundColor(.gray)
                                                             Spacer()
                                                         }
                                                                                                     }
                                                    }
                                                 
                                                 Image(systemName: "arrow.right.circle")
                                                     .foregroundColor(Color.navyBlue)
                                                     .onTapGesture {
                                                         bigModel.currentView = .mealsPropositionScreen
                                                         bigModel.screenHistory.append(.UserView)
                                                         if bigModel.currentUser.proposedMeals.count == 0 {
                                                             bigModel.currentView = .SeasonSelectionView
                                                         }
                                                     }
                                             }
                                             Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         }
                                         
                                         VStack(alignment: .leading) {
                                             Text("fav-meals")
                                                 .font(.largeTitle)
                                                 .foregroundStyle(Color.navyBlue)
                                             HStack {
                                                 if bigModel.currentUser.favoriteMeals.count != 0 {
                                                     ScrollView(.horizontal) {
                                                         HStack {
                                                             ForEach(bigModel.currentUser.favoriteMeals) { meal in
                                                                 Text(meal.recipe.recipeName)
                                                             }
                                                         }
                                                     }
                                                 } else {
                                                     HStack {
                                                         Text("fill-infos2")
                                                             .foregroundColor(.gray)
                                                         Spacer()
                                                     }
                                                 }
                                                 Image(systemName: "arrow.right.circle")
                                                     .foregroundColor(Color.navyBlue)
                                                     .onTapGesture {
                                                         if bigModel.currentUser.items.count != 0 && bigModel.currentUser.budget != 0 && bigModel.currentUser.numberOfPerson != 0 && bigModel.currentUser.spendedTime != 0 {
                                                             bigModel.currentView = .FavoriteMealsScreen
                                                         }
                                                     }
                                             }
                                             
                                         }
                                         
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                                         
                                         Text("your-meal-planner")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         
                                         HStack {
                                             if bigModel.currentUser.events != [] {
                                                 Text("click-here-events")
                                             } else {
                                                 Text("tellus-5")
                                                     .foregroundColor(.gray)
                                             }
                                             Spacer()
                                             Image(systemName: "arrow.right.circle")
                                                 .foregroundColor(Color.navyBlue)
                                                 .onTapGesture {
                                                     bigModel.currentView = .DailyCalendar
                                                     bigModel.screenHistory.append(.UserView)
                                                 }
                                         }
                                         
                                     }
                                 }
                             }
                         }
                        
                        
                        
                    }.padding(.horizontal, 20)
                    
     
                
                VStack {
                    ZStack {
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.navyBlue)
                        Text("log-out")
                            .foregroundStyle(Color.white)
                            .bold()
                            .onTapGesture {
                                bigModel.currentView = .signInView
                                bigModel.screenHistory.append(.UserView)
                            }
                    }
                }.edgesIgnoringSafeArea(.all)
                
            }.edgesIgnoringSafeArea(.bottom)
            .onAppear {
                
                if bigModel.currentUser.firstName == "" {
                    newFirstName = "ur-first-name"
                    firstName = "enter-ur-first-name"
                } else {
                    newFirstName = bigModel.currentUser.firstName
                    firstName = bigModel.currentUser.firstName
                }
                
                if bigModel.currentUser.lastName == "" {
                    newLastName = "ur-last-name"
                    lastName = "enter-ur-last-name"
                } else {
                    newLastName = bigModel.currentUser.lastName
                    lastName = bigModel.currentUser.lastName
                }
                
            }
        }.onAppear {
            Task {
                await bigModel.fetchAllImages()
            }
        }
        
    }
    
}

struct Preference: Identifiable {
    var id: Int
    var name: String
    var nextScreen: ViewEnum
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
