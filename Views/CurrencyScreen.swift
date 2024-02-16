//
//  CurrencyScreen.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 15/02/2024.
//

import SwiftUI

struct CurrencyScreen: View {
    
    let currencyList: [StringValue] = [StringValue(id: 0, string: "EUR", sign: "eurosign"), StringValue(id: 1, string: "DOLLARDS", sign: "dollarsign"), StringValue(id: 2, string: "LIVRES", sign: "sterlingsign"), StringValue(id: 3, string: "YEN", sign: "yensign"), StringValue(id: 4, string: "WON", sign: "wonsign")]
    @ObservedObject var bigModel: BigModel
    
    var body: some View {
        
        ZStack {
            
            Color(.lightGray)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                BackModel(color: Color.navyBlue, view: ViewEnum.CurrencyScreen)
                
                VStack(alignment: .leading, spacing: 30) {
                    
                    HStack {
                        Text("Currency")
                            .font(.system(size: 60, weight: .semibold))
                        .foregroundColor(Color.navyBlue)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(currencyList) { item in
                                ZStack {
                                    
                                    if item.string == bigModel.currentUser.currency {
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(height: 65)
                                            .foregroundStyle(Color(.navyBlue))
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color(.navyBlue), lineWidth: 1)
                                            .frame(height: 65)
                                    }
                                    
                                    HStack {
                                        ZStack {
                                            Rectangle()
                                                .foregroundStyle(Color.gray)
                                                .cornerRadius(15)
                                                .frame(width: 50, height: 50)
                                            Image(systemName: item.sign)
                                                .foregroundStyle(Color(.lightGray))
                                                .font(.system(size: 25))
                                        }
                                        Text(item.string)
                                            .font(.title3)
                                            .foregroundStyle(item.string == bigModel.currentUser.currency ? Color(.lightGray) : Color.navyBlue)
                                        Spacer()
                                    }.padding(.horizontal, 10)
                                }.onTapGesture {
                                    var user = bigModel.currentUser
                                    user.currency = item.string
                                    
                                }
                            }
                        }.padding(5)
                    }
                    
                }
                
                Spacer()
                
            }.padding(20)
            
        }
        
    }
}

struct StringValue: Identifiable {
    var id: Int
    var string: String
    var sign: String
}

#Preview {
    CurrencyScreen(bigModel: BigModel.mocked)
}
