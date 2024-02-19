//
//  Budget_Screen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI

struct Budget_Screen: View {
    
    @State var budget = 0
    @State var budgetString = "0"
    @ObservedObject var bigModel: BigModel
    
    var body: some View {
        ZStack {
            
            Color("navyBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.white, view: .budgetScreen)
                    
                    VStack(spacing: 40) {
                        
                        VStack(alignment: .leading) {
                            Text("budget-per-week")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                        }
                        
                        HStack {
                            
                            Rectangle()
                                .foregroundColor(budget < 10 ? .gray : .white)
                                .onTapGesture {
                                    budget = 10
                                }
                            Rectangle()
                                .foregroundColor(budget < 20 ? .gray : .white)
                                .onTapGesture {
                                    budget = 20
                                }
                            Rectangle()
                                .foregroundColor(budget < 30 ? .gray : .white)
                                .onTapGesture {
                                    budget = 30
                                }
                            Rectangle()
                                .foregroundColor(budget < 40 ? .gray : .white)
                                .onTapGesture {
                                    budget = 40
                                }
                            Rectangle()
                                .foregroundColor(budget < 50 ? .gray : .white)
                                .onTapGesture {
                                    budget = 50
                                }
                            Rectangle()
                                .foregroundColor(budget < 60 ? .gray : .white)
                                .onTapGesture {
                                    budget = 60
                                }
                            Rectangle()
                                .foregroundColor(budget < 70 ? .gray : .white)
                                .onTapGesture {
                                    budget = 70
                                }
                            Rectangle()
                                .foregroundColor(budget < 80 ? .gray : .white)
                                .onTapGesture {
                                    budget = 80
                                }
                            Rectangle()
                                .foregroundColor(budget < 90 ? .gray : .white)
                                .onTapGesture {
                                    budget = 90
                                }
                            Rectangle()
                                .foregroundColor(budget < 100 ? .gray : .white)
                                .onTapGesture {
                                    budget = 100
                                }
                        }
                                                
                        VStack(spacing: 10) {
                            
                            HStack {
                                Text(bigModel.currentUser.currency == "" ? "EUR" : bigModel.currentUser.currency)
                                    .foregroundStyle(.white)
                                    .font(.title2)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.white)
                            }.onTapGesture {
                                bigModel.currentView = .CurrencyScreen
                                var user = bigModel.currentUser
                                user.budget = budget
                                bigModel.storeCurrentUserInfoIntoDB(user: user)
                            }
                            
                            ZStack {
                                Rectangle()
                                    .cornerRadius(30)
                                    .frame(height: 60)
                                    .foregroundStyle(Color.white)
                                HStack {
                                    Text("-")
                                        .foregroundStyle(Color.navyBlue)
                                        .onTapGesture {
                                            if self.budget-10>0 {
                                                self.budget -= 10
                                            }
                                        }
                                        .onChange(of: budget) { newValue in
                                            budgetString = String(budget)
                                        }
                                    
                                    Spacer()
                                    
                                    TextField("", text: $budgetString)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(Color.navyBlue)
                                        .font(.title)
                                        .keyboardType(.decimalPad)
                                        .onChange(of: budgetString) { newValue in
                                            if Int(budgetString) ?? 0 > 0 {
                                                budget = Int(budgetString) ?? 0
                                            } else {
                                                budget = 0
                                            }
                                        }
                                    
                                    Spacer()
                                                                    
                                    Text("+")
                                        .foregroundStyle(Color.navyBlue)
                                        .onTapGesture {
                                            self.budget += 10
                                        }
                                        .onChange(of: budget) { newValue in
                                            budgetString = String(budget)
                                        }
                                }.padding(.horizontal, 25)
                            }
                        }
                        
                    }
                    
                }.padding(20)
                
                VStack {
                    ZStack {
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.white)
                        Text("validate")
                            .foregroundStyle(Color.navyBlue)
                    }.onTapGesture {
                        Task {
                            var user = bigModel.currentUser
                            if user.currency == "" {
                                user.currency = "EUR"
                            }
                            user.budget = budget
                            bigModel.storeCurrentUserInfoIntoDB(user: user)
                            
                            if bigModel.screenHistory.last == .TastesView {
                                bigModel.currentView = .TastesView
                                bigModel.screenHistory.append(.budgetScreen)
                            }
                            if bigModel.screenHistory.last == .UserView {
                                bigModel.currentView = .UserView
                                bigModel.screenHistory.append(.budgetScreen)
                            }
                            else {
                                bigModel.currentView = .NumberOfPersonScreen
                                bigModel.screenHistory.append(.budgetScreen)
                            }
                            
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
                
            }.edgesIgnoringSafeArea(.bottom)
        }.onAppear {
            budget = bigModel.currentUser.budget
        }
    }
}

struct RectangleModel: View {
    var id: Int
    @State var rectangleBudget: Int
    var body: some View {
        Rectangle()
            .foregroundColor(rectangleBudget < id ? .gray : .white)
            .onTapGesture {
                rectangleBudget = id
            }
    }
}

struct Budget_Screen_Previews: PreviewProvider {
    static var previews: some View {
        Budget_Screen(bigModel: BigModel.mocked)
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}
