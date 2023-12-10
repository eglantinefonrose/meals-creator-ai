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
                                    let user = BigModel.User(firstName: newFirstName, lastName: newLastName, items: bigModel.currentUser?.items ?? [], tools: [], budget: bigModel.currentUser?.budget ?? 0, spendedTime: bigModel.currentUser?.spendedTime ?? 0, proposedMeals: bigModel.currentUser?.proposedMeals ?? [], favoriteMeals: bigModel.currentUser?.favoriteMeals ?? [])
                                    bigModel.updateCurrentUserInfoInDB(user: user)
                                    firstName = newFirstName
                                    lastName = newLastName
                                    isEditModeOn.toggle()
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
                    
                    if !(bigModel.currentUser?.items.count == 0 && bigModel.currentUser?.budget == 0 && bigModel.currentUser?.spendedTime == 0 && bigModel.currentUser?.favoriteMeals.count == 0) {
                        ScrollView {
                            VStack(alignment: .leading) {
                                
                                VStack(alignment: .leading) {
                                    Text("Tastes")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.navyBlue)
                                    HStack {
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(bigModel.currentUser?.items ?? []) { item in
                                                        Text(item.name)
                                                }
                                            }
                                        }
                                        Image(systemName: "arrow.right.circle")
                                            .foregroundColor(Color.navyBlue)
                                            .onTapGesture {
                                                bigModel.currentView = .TastesView
                                                bigModel.screenHistory.append(.UserView)
                                            }
                                    }
                                    Rectangle().fill(Color.navyBlue).frame(height: 1)
                                }
                                
                                Text("Budget")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.navyBlue)
                                HStack {
                                    
                                    if bigModel.currentUser?.budget != 0 {
                                        Text(String(bigModel.currentUser?.budget ?? 0))
                                    } else {
                                        Text("Tell us your budget per week")
                                            .foregroundColor(.gray)
                                    }
                                    
                                    
                                    Spacer()
                                    Image(systemName: "arrow.right.circle")
                                        .foregroundColor(Color.navyBlue)
                                        .onTapGesture {
                                            bigModel.currentView = .budgetScreen
                                        }
                                }
                                Rectangle().fill(Color.navyBlue).frame(height: 1)
                                
                                Text("Spended time")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.navyBlue)
                                HStack {
                                    if bigModel.currentUser?.budget != 0 {
                                        Text(String(bigModel.currentUser?.spendedTime ?? 0))
                                    } else {
                                        Text("Tell us the time your want to spend per meal")
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.right.circle")
                                        .foregroundColor(Color.navyBlue)
                                        .onTapGesture {
                                            bigModel.currentView = .timeScreen
                                        }
                                }
                                Rectangle().fill(Color.navyBlue).frame(height: 1)
                                
                                VStack(alignment: .leading) {
                                    Text("Proposed meals")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.navyBlue)
                                    HStack {
                                        
                                        if bigModel.currentUser?.proposedMeals.count != 0 {
                                            ScrollView(.horizontal) {
                                                HStack {
                                                    ForEach(bigModel.currentUser?.proposedMeals ?? []) { meal in
                                                        Text(meal.name)
                                                    }
                                                }
                                            }
                                        } else {
                                            HStack {
                                                Text("Fill the informations above to generate your suitable meals list")
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                        }
                                        
                                        Image(systemName: "arrow.right.circle")
                                            .foregroundColor(Color.navyBlue)
                                            .onTapGesture {
                                                bigModel.currentView = .mealsPropositionScreen
                                            }
                                    }
                                    Rectangle().fill(Color.navyBlue).frame(height: 1)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Favorite meals")
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.navyBlue)
                                    HStack {
                                        if bigModel.currentUser?.favoriteMeals.count != 0 {
                                            ScrollView(.horizontal) {
                                                HStack {
                                                    ForEach(bigModel.currentUser?.favoriteMeals ?? []) { meal in
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
                                            }
                                    }
                                    
                                }
                                
                            }
                        }
                    } else {
                        
                        VStack {
                            Spacer()
                            Text("Start selecting what you like")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    bigModel.currentView = .welcomeView
                                }
                            Spacer()
                        }
                        
                    }
                }.padding(.horizontal, 20)
                
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundStyle(Color.navyBlue)
                    Text("Log out")
                        .foregroundStyle(Color.white)
                        .bold()
                        .onTapGesture {
                            bigModel.currentUser = nil
                            bigModel.currentView = .signInView
                        }
                }
            }.edgesIgnoringSafeArea(.all)
            
        }.edgesIgnoringSafeArea(.bottom)
        .onAppear {
            newFirstName = bigModel.currentUser?.firstName ?? ""
            newLastName = bigModel.currentUser?.lastName ?? ""
            firstName = bigModel.currentUser?.firstName ?? ""
            lastName = bigModel.currentUser?.lastName ?? ""
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
