//
//  NumberOfPersonScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/12/2023.
//


import SwiftUI

struct NumberOfPersonScreen: View {
    
    @State var numberOfPerson = 4
    @State var numberOfPersonString = "0"
    @ObservedObject var bigModel: BigModel = BigModel.shared

    var body: some View {
        ZStack {
            
            Color("navyBlue")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack(spacing: 10) {
                    
                    BackModel(color: Color.white, view: .budgetScreen)
                    
                    VStack(spacing: 75) {
                        
                        VStack(alignment: .leading) {
                            Text("number-of-people")
                                .foregroundStyle(Color.white)
                                .font(.largeTitle)
                        }
                        
                        Spacer()
                        
                        VStack {
                            
                            HStack {
                                
                                Image(systemName: numberOfPerson < 1 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 1
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 2 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 2
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 3 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 3
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                            }
                            
                            HStack {
                                
                                Image(systemName: numberOfPerson < 4 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 4
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 5 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 5
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 6 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 6
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                            }
                            
                            HStack {
                                Image(systemName: numberOfPerson < 7 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 7
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 8 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 8
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                                
                                Image(systemName: numberOfPerson < 9 ? "person" : "person.fill")
                                    .onTapGesture {
                                        numberOfPerson = 9
                                    }
                                    .font(.system(size: 75))
                                    .foregroundColor(.white)
                            }
                            
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
                                        if self.numberOfPerson - 10 > 0 {
                                            self.numberOfPerson -= 10
                                        }
                                    }
                                    .onChange(of: numberOfPerson) { newValue in
                                        numberOfPersonString = String(numberOfPerson)
                                    }
                                
                                Spacer()
                                
                                TextField("", text: $numberOfPersonString)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.navyBlue)
                                    .font(.title)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: numberOfPersonString) { newValue in
                                        numberOfPerson = Int(numberOfPersonString) ?? 0
                                    }
                                
                                Spacer()
                                
                                Text("+")
                                    .foregroundStyle(Color.navyBlue)
                                    .onTapGesture {
                                        self.numberOfPerson += 1
                                    }
                                    .onChange(of: numberOfPerson) { newValue in
                                        numberOfPersonString = String(numberOfPerson)
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
                            .foregroundStyle(Color.navyBlue)
                    }.onTapGesture {
                        Task {
                            var user = bigModel.currentUser
                            user.numberOfPerson = numberOfPerson
                            
                            bigModel.storeCurrentUserInfoIntoDB(user: user)
                            
                            if bigModel.screenHistory.last == .UserView {
                                bigModel.currentView = .UserView
                                bigModel.screenHistory.append(.NumberOfPersonScreen)
                            } else {
                                bigModel.currentView = .timeScreen
                                bigModel.screenHistory.append(.NumberOfPersonScreen)
                            }
                            
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
                
            }.edgesIgnoringSafeArea(.bottom)
        }.onAppear {
            numberOfPerson = bigModel.currentUser.numberOfPerson
        }
    }
}

/*struct PersonModel: View {
    var id: Int
    @State var numberOfPerson: Int
    var body: some View {
        Image(systemName: numberOfPerson < id ? "person" : "person.fill")
            .onTapGesture {
                numberOfPerson = id
            }
    }
}*/

struct NumberOfPersonScreen_Previews: PreviewProvider {
    static var previews: some View {
        NumberOfPersonScreen()
            .environmentObject(BigModel(shouldInjectMockedData: true))
    }
}

