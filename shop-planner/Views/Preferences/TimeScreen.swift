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
                    
                    VStack {
                        
                        VStack(alignment: .center) {
                            Text("spent-time-per-meal")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                            Text("in-minutes")
                                .foregroundStyle(Color.gray)
                                .font(.title3)
                                
                        }
                    
                        Spacer()
                           
                        ZStack {
                            
                            if (time%60) < 5 && (time < 60) {
                                Image("clock000")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 5 && (time%60) < 10 {
                                Image("clock001")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 10 && (time%60) < 15 {
                                Image("clock002")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 15 && (time%60) < 20 {
                                Image("clock003")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 20 && (time%60) < 25 {
                                Image("clock004")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 25 && (time%60) < 30 {
                                Image("clock005")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 30 && (time%60) < 35 {
                                Image("clock006")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 35 && (time%60) < 40 {
                                Image("clock007")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 40 && (time%60) < 45 {
                                Image("clock008")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 45 && (time%60) < 50 {
                                Image("clock009")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 50 && (time%60) < 55 {
                                Image("clock010")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) >= 55 && (time%60) < 60 {
                                Image("clock011")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            if (time%60) < 5 && (time >= 60) {
                                Image("clock012")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                            }
                            
                            Text(timeString)
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                            
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(30)
                                .frame(height: 60)
                                .foregroundStyle(Color.white)
                            HStack {
                                Text("-")
                                    .foregroundStyle(Color.blue)
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
                                    .foregroundStyle(Color.blue)
                                    .font(.title)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: timeString) { newValue in
                                        time = Int(timeString) ?? 0
                                    }
                                
                                Spacer()
                                
                                Text("+")
                                    .foregroundStyle(Color.blue)
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
                        Text("validate")
                            .foregroundStyle(Color.blue)
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
