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
    @ObservedObject var bigModel: BigModel

    var body: some View {
        ZStack {
            
            Color("navyBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.white, view: .timeScreen)
                    
                    //Spacer()
                    
                    //VStack(spacing: 75) {
                        
                        VStack(alignment: .leading) {
                            Text("spent-time-per-meal")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                        }
                    
                        Spacer()
                           
                        if time < 5 {
                            Image("clock000")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 5 && time < 10 {
                            Image("clock001")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 10 && time < 15 {
                            Image("clock002")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 15 && time < 20 {
                            Image("clock003")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 20 && time < 25 {
                            Image("clock004")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 25 && time < 30 {
                            Image("clock005")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 30 && time < 35 {
                            Image("clock006")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 35 && time < 40 {
                            Image("clock007")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 40 && time < 45 {
                            Image("clock008")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 45 && time < 50 {
                            Image("clock009")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 50 && time < 55 {
                            Image("clock010")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 55 && time < 60 {
                            Image("clock011")
                                .resizable()
                                .frame(width: 300, height: 300)
                        }
                        if time >= 60 {
                            Image("clock012")
                                .resizable()
                                .frame(width: 300, height: 300)
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
                                        if self.time - 10 > 0 {
                                            self.time -= 10
                                        }
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
                        
                    //}
                    
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
                            user.spendedTime = time
                            bigModel.storeCurrentUserInfoIntoDB(user: user)
                            
                            if bigModel.screenHistory.last == .UserView {
                                bigModel.currentView = .UserView
                                bigModel.screenHistory.append(.timeScreen)
                            } else {
                                if bigModel.currentUser.proposedMeals.count == 0 {
                                    bigModel.currentView = .SeasonSelectionView
                                    bigModel.screenHistory.append(.timeScreen)
                                } else {
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
        TimeScreen(bigModel: BigModel.mocked)
    }
}
