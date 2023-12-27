//
//  TimeScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI

struct TimeScreen: View {
    
    @State var time = 0
    @State var timeString = "0"
    @EnvironmentObject var bigModel: BigModel
    
    var body: some View {
        ZStack {
            
            Color("navyBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.white, view: .timeScreen)
                    
                    VStack(spacing: 75) {
                        
                        VStack(alignment: .leading) {
                            Text("SPENT")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                            Text("time per meal")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(30)
                                .frame(height: 60)
                                .foregroundStyle(Color.white)
                            HStack {
                                Text("-")
                                    .foregroundStyle(Color.navyBlue)
                                    .onTapGesture {
                                        self.time -= 10
                                    }
                                    .onChange(of: time) { newValue in
                                        timeString = String(time)
                                    }
                                
                                Spacer()
                                
                                TextField("", text: $timeString)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.navyBlue)
                                    .font(.title)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: timeString) { newValue in
                                        time = Int(timeString) ?? 0
                                    }
                                
                                Spacer()
                                
                                Text("+")
                                    .foregroundStyle(Color.navyBlue)
                                    .onTapGesture {
                                        self.time += 10
                                    }
                                    .onChange(of: time) { newValue in
                                        timeString = String(time)
                                    }
                            }.padding(.horizontal, 25)
                        }
                        
                    }
                    
                }.padding(20)
                
                VStack {
                    ZStack {
                        Rectangle()
                            .frame(height: 60)
                            .foregroundStyle(Color.white)
                        Text("Validate")
                            .foregroundStyle(Color.navyBlue)
                            .onTapGesture {
                               
                                Task {
                                    var user = bigModel.currentUser
                                    user.spendedTime = time
                                    await bigModel.storeCurrentUserInfoIntoDB(user: user)
                                    if bigModel.screenHistory.last == .UserView {
                                        bigModel.currentView = .UserView
                                        bigModel.screenHistory.append(.timeScreen)
                                    } else {
                                        Task {
                                            await bigModel.createMeals()
                                        }
                                        bigModel.currentView = .mealsPropositionScreen
                                        bigModel.screenHistory.append(.timeScreen)
                                    }
                                }
                                
                            }
                    }
                }.edgesIgnoringSafeArea(.all)
                
            }.edgesIgnoringSafeArea(.bottom)
        }.onAppear {
            time = bigModel.currentUser.spendedTime
        }
    }
}

struct TimeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TimeScreen()
    }
}
