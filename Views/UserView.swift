//
//  UserView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 30/11/2023.
//

import SwiftUI

struct UserView: View {
    
    let preferences = [Preference(id: 0, name: "Tastes", nextScreen: .TastesView), Preference(id: 1, name: "Budget", nextScreen: .budgetScreen), Preference(id: 2, name: "Spended time", nextScreen: .timeScreen), Preference(id: 3, name: "Proposed meals", nextScreen: .mealsPropositionScreen), Preference(id: 4, name: "Favorite meals", nextScreen: .mealsPropositionScreen)]
    @EnvironmentObject var bigModel: BigModel
    @State var newFirstName: String = ""
    @State var newLastName: String = ""
    @State var isEditModeOn = false
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        
        VStack {
            
            VStack {
                VStack(spacing: 30) {
                    
                    HStack {
                        Text("Back")
                            .foregroundStyle(.white)
                            .bold()
                        Spacer()
                    }
                    
                    Circle()
                        .frame(width: 150)
                        .foregroundColor(.gray)
                    HStack {
                        VStack(alignment: .leading) {
                            
                            if !isEditModeOn {
                                Text(firstName)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                
                                Text(lastName)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            
                            if isEditModeOn {
                                TextField("", text: $newFirstName)
                                    .multilineTextAlignment(.leading)
                                    .font(.largeTitle)
                                .foregroundColor(.white)
                                
                                TextField("", text: $newLastName)
                                    .multilineTextAlignment(.leading)
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                
                            }
                            
                        }
                        Spacer()
                        Image(systemName: isEditModeOn ? "checkmark.circle" : "pencil.and.outline")
                            .foregroundColor(.white)
                            .bold()
                            .onTapGesture {
                                
                                if isEditModeOn {
                                    //bigModel.updateUserNames(firstName: newFirstName, lastName: newLastName)
                                    Task {
                                        var user = bigModel.currentUser
                                        user.firstName = newFirstName
                                        user.lastName = newLastName
                                        await bigModel.storeCurrentUserInfoIntoDB(user: user)
                                        firstName = newFirstName
                                        lastName = newLastName
                                        isEditModeOn.toggle()
                                    }
                                } else {
                                    isEditModeOn.toggle()
                                }
                                
                            }
                    }
                }.padding(20)
            }.background(Color.navyBlue)
                        
            VStack(spacing: 0) {
                
                VStack() {
                    HStack {
                        Text("Your preferences")
                            .foregroundStyle(Color.navyBlue)
                            .font(.title3)
                        Spacer()
                    }
                    
                     if (bigModel.currentUser.items.count == 0 && bigModel.currentUser.budget == 0 && bigModel.currentUser.spendedTime == 0 && bigModel.currentUser.favoriteMeals.count == 0) {
                        
                        VStack {
                            Spacer()
                            Text("Start selecting what you like")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    bigModel.currentView = .welcomeView
                                    bigModel.screenHistory.append(.UserView)
                                }
                            Spacer()
                        }
                        
                     } else {
                             ScrollView {
                                 VStack(alignment: .leading) {
                                     
                                     VStack(alignment: .leading) {
                                         Text("Tastes")
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
                                                 Text("Tell us what you like")
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
                                         Text("Tools")
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
                                                 Text("Tell us which tools you want to use")
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
                                     
                                     Text("Budget")
                                         .font(.largeTitle)
                                         .foregroundStyle(Color.navyBlue)
                                     HStack {
                                         
                                         if bigModel.currentUser.budget != 0 {
                                             Text(String(bigModel.currentUser.budget))
                                         } else {
                                             Text("Tell us your budget per week")
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
                                     
                                     Text("Number of person")
                                         .font(.largeTitle)
                                         .foregroundStyle(Color.navyBlue)
                                 
                                     HStack {
                                             if bigModel.currentUser.numberOfPerson != 0 {
                                                 Text(String(bigModel.currentUser.numberOfPerson))
                                             } else {
                                                 Text("Tell us how many people you want to cook for")
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
                                     
                                     Text("Spent time")
                                         .font(.largeTitle)
                                         .foregroundStyle(Color.navyBlue)
                                     HStack {
                                         if bigModel.currentUser.budget != 0 {
                                             Text(String(bigModel.currentUser.spendedTime))
                                         } else {
                                             Text("Tell us the time your want to spend per meal")
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
                                         Text("Proposed meals")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         HStack {
                                             
                                             /*if bigModel.currentUser.items.count != 0 && bigModel.currentUser.tools.count != 0 && bigModel.currentUser.numberOfPerson != 0 && bigModel.currentUser.budget != 0 && bigModel.currentUser.spendedTime != 0 {
                                                 HStack {
                                                     Text("Click here to propose meals according to your tastes")
                                                         .foregroundColor(.gray)
                                                     Spacer()
                                                 }
                                             }*/
                                             
                                             if bigModel.currentUser.proposedMeals.count != 0 {
                                                 ScrollView(.horizontal) {
                                                     HStack {
                                                         ForEach(bigModel.currentUser.proposedMeals) { meal in
                                                             Text(meal.name)
                                                         }
                                                     }
                                                 }
                                             } else {
                                                 if bigModel.currentUser.items.count != 0 && bigModel.currentUser.tools.count != 0 && bigModel.currentUser.numberOfPerson != 0 && bigModel.currentUser.budget != 0 && bigModel.currentUser.spendedTime != 0 {
                                                     HStack {
                                                         Text("Click here to propose meals according to your tastes")
                                                             .foregroundColor(.gray)
                                                         Spacer()
                                                     }
                                                 } else {
                                                     HStack {
                                                         Text("Fill the informations above to generate your suitable meals list")
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
                                                         Task {
                                                             await bigModel.createMeals()
                                                         }
                                                     }
                                                 }
                                         }
                                         Rectangle().fill(Color.navyBlue).frame(height: 1)
                                     }
                                     
                                     VStack(alignment: .leading) {
                                         Text("Favorite meals")
                                             .font(.largeTitle)
                                             .foregroundStyle(Color.navyBlue)
                                         HStack {
                                             if bigModel.currentUser.favoriteMeals.count != 0 {
                                                 ScrollView(.horizontal) {
                                                     HStack {
                                                         ForEach(bigModel.currentUser.favoriteMeals) { meal in
                                                             Text(meal.name)
                                                         }
                                                     }
                                                 }
                                             } else {
                                                 HStack {
                                                     Text("Fill the informations above to generate your favorite meals list")
                                                         .foregroundColor(.gray)
                                                     Spacer()
                                                 }
                                             }
                                             Image(systemName: "arrow.right.circle")
                                                 .foregroundColor(Color.navyBlue)
                                                 .onTapGesture {
                                                     bigModel.currentView = .mealsPropositionScreen
                                                     bigModel.screenHistory.append(.UserView)
                                                 }
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
                    Text("Log out")
                        .foregroundStyle(Color.white)
                        .bold()
                        .onTapGesture {
                            bigModel.currentView = .signInView
                        }
                }
            }.edgesIgnoringSafeArea(.all)
            
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            newFirstName = bigModel.currentUser.firstName
            newLastName = bigModel.currentUser.lastName
            firstName = bigModel.currentUser.firstName
            lastName = bigModel.currentUser.lastName
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
