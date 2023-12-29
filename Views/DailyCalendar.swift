//
//  DailyCalendar.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 27/12/2023.
//

import SwiftUI

struct DailyCalendar: View {
    
    @EnvironmentObject var bigModel: BigModel
    //let epochTime: TimeInterval
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            BackModel(color: Color.navyBlue, view: .DailyCalendar)
            
            
            HStack(spacing: 30) {
                   
                ForEach(-2...2, id: \.self) { day in
                    ZStack {
                        if day == 0 {
                            Circle()
                                .foregroundColor(.navyBlue)
                                .frame(width: 75, height: 75)
                        }
                        VStack {
                            /*Text("\(getDateNumber(date: Calendar.current.date(byAdding: .day, value: day, to: currentDate)!))")
                                .font(.title)
                                .foregroundColor(day == 0 ? .white : .navyBlue)
                            Text("\(getDateMonth(date: Calendar.current.date(byAdding: .day, value: day, to: currentDate)!))")
                                .font(.headline)
                                .textCase(.lowercase)
                                .foregroundColor(day == 0 ? .white : .navyBlue)*/
                        }
                    }
                }
                                
            }
            
            
            
            Spacer()

        }.padding(20)
                
    }
    
    func getDateNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let dayNumber = calendar.component(.day, from: date)
        return dayNumber
    }
    func getDateMonth(date: Date) -> String {
        let calendar = Calendar.current
        let dayMonth = calendar.component(.month, from: date)
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let abbreviatedMonth = monthFormatter.string(from: date)
        
        return abbreviatedMonth
    }
    
}

#Preview {
    DailyCalendar()
}
