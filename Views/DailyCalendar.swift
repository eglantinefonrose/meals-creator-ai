//
//  DailyCalendar.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 27/12/2023.
//

import SwiftUI

struct DailyCalendar: View {
    
    @ObservedObject var bigModel: BigModel
    let epochTime: TimeInterval = 0
    @State private var swipeDirection: SwipeGestureModifier.SwipeDirection? = nil
    @State var currentEvent: BigModel.Event = BigModel.Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
    @State var selectedDate: Date = Date.now
    
    var body: some View {
        
        if #available(iOS 17.0, *) {
            
            ZStack {
                
                Color(.lightGray)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    BackModel(color: Color.navyBlue, view: .DailyCalendar)
                    
                    
                    HStack(spacing: 30) {
                        
                        ForEach(-2...2, id: \.self) { dayDelay in
                            ZStack {
                                if dayDelay == 0 {
                                    Circle()
                                        .foregroundColor(.navyBlue)
                                        .frame(width: 75, height: 75)
                                }
                                VStack {
                                    //Text("\(getDateNumber(timeEpoch: Calendar.current.date(byAdding: .day, value: dayDelay, to: Date(timeIntervalSince1970: bigModel.selectedTimeEpoch ))!))")
                                    
                                    Text("\(getDateNumber(date: Calendar.current.date(byAdding: .day, value: dayDelay, to: self.selectedDate)!))")
                                        .font(.title)
                                        .foregroundColor(dayDelay == 0 ? .white : .navyBlue)
                                    Text("\(getDateMonth(date: Calendar.current.date(byAdding: .day, value: dayDelay, to: self.selectedDate)!))")
                                        .font(.headline)
                                        .textCase(.lowercase)
                                        .foregroundColor(dayDelay == 0 ? .white : .navyBlue)
                                }
                            }.onTapGesture {
                                withAnimation(.interactiveSpring) { // Ajout de l'animation lors du clic
                                    self.selectedDate = Calendar.current.date(byAdding: .day, value: dayDelay, to: self.selectedDate)!
                                    bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                                    print(self.selectedDate)
                                }
                            }
                        }
                        
                    }.onSwipe { direction in
                        withAnimation(.interactiveSpring) { // Ajout de l'animation lors du swipe
                            self.swipeDirection = direction
                            if (direction == .left) {
                                self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                            }
                            if (direction == .right) {
                                self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate)!
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                            }
                        }
                    }
                    
                    ScrollView {
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("breakfast")
                                    .font(.title3)
                                    .foregroundStyle(Color(.navyBlue))
                                Spacer()
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(20)
                                    .frame(minHeight: 200)
                                
                                if currentEvent.id == "" {
                                    VStack {
                                        Text("+")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(.navyBlue))
                                        Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                            .font(.title)
                                            .foregroundStyle(Color(.navyBlue))
                                    }.onTapGesture {
                                        
                                        if bigModel.isUserTryingAddNewMealToCalendar {
                                            bigModel.selectedMealType = "Breakfast"
                                            bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            bigModel.isUserTryingAddNewMealToCalendar.toggle()
                                        } else {
                                            bigModel.selectedMealType = "Breakfast"
                                            print(selectedDate.timeIntervalSince1970)
                                            bigModel.currentView = .mealsPropositionScreen
                                            bigModel.screenHistory.append(.DailyCalendar)
                                        }
                                        
                                    }
                                } else {
                                    if currentEvent.breakfastMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.breakfastMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.breakfastMeal!.recipe.prepDuration) min - \(currentEvent.breakfastMeal!.recipe.price)\(currentEvent.breakfastMeal!.recipe.currency)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                                Image(systemName: "trash")
                                                    .foregroundStyle(Color(.navyBlue))
                                                    .onTapGesture {
                                                        bigModel.removeMealFromEvent(mealType: "Breakfast")
                                                    }
                                            }
                                        }.padding(20)
                                        .onTapGesture {
                                            bigModel.selectedMeal = currentEvent.breakfastMeal!
                                            bigModel.screenHistory.append(.DailyCalendar)
                                            bigModel.currentView = .RecipeScreen
                                        }
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color(.navyBlue))
                                            Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                                .font(.title)
                                                .foregroundStyle(Color(.navyBlue))
                                        }.onTapGesture {
                                            
                                            if bigModel.screenHistory.last == .RecipeScreen {
                                                bigModel.selectedMealType = "Breakfast"
                                                bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            } else {
                                                bigModel.selectedMealType = "Breakfast"
                                                print(selectedDate.timeIntervalSince1970)
                                                bigModel.currentView = .mealsPropositionScreen
                                                bigModel.screenHistory.append(.DailyCalendar)
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("lunch")
                                    .font(.title3)
                                    .foregroundStyle(Color(.navyBlue))
                                Spacer()
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(20)
                                    .frame(minHeight: 200)
                                
                                if currentEvent.id == "" {
                                    VStack {
                                        Text("+")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(.navyBlue))
                                        Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                            .font(.title)
                                            .foregroundStyle(Color(.navyBlue))
                                    }.onTapGesture {
                                        
                                        if bigModel.isUserTryingAddNewMealToCalendar {
                                            bigModel.selectedMealType = "Lunch"
                                            bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            bigModel.isUserTryingAddNewMealToCalendar.toggle()
                                        } else {
                                            bigModel.selectedMealType = "Lunch"
                                            print(selectedDate.timeIntervalSince1970)
                                            bigModel.currentView = .mealsPropositionScreen
                                            bigModel.screenHistory.append(.DailyCalendar)
                                        }
                                        
                                    }
                                } else {
                                    if currentEvent.lunchMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.lunchMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.lunchMeal!.recipe.prepDuration) min - \(currentEvent.lunchMeal!.recipe.price)\(currentEvent.lunchMeal!.recipe.currency)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                                Image(systemName: "trash")
                                                    .foregroundStyle(Color(.navyBlue))
                                                    .onTapGesture {
                                                        bigModel.removeMealFromEvent(mealType: "Lunch")
                                                    }
                                            }
                                        }.padding(20)
                                        .onTapGesture {
                                            bigModel.selectedMeal = currentEvent.lunchMeal!
                                            bigModel.screenHistory.append(.DailyCalendar)
                                            bigModel.currentView = .RecipeScreen
                                        }
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color(.navyBlue))
                                            Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                                .font(.title)
                                                .foregroundStyle(Color(.navyBlue))
                                        }.onTapGesture {
                                            
                                            if bigModel.screenHistory.last == .RecipeScreen {
                                                bigModel.selectedMealType = "Lunch"
                                                bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            } else {
                                                bigModel.selectedMealType = "Lunch"
                                                print(selectedDate.timeIntervalSince1970)
                                                bigModel.currentView = .mealsPropositionScreen
                                                bigModel.screenHistory.append(.DailyCalendar)
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("snack")
                                    .font(.title3)
                                    .foregroundStyle(Color(.navyBlue))
                                Spacer()
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(20)
                                    .frame(minHeight: 200)
                                
                                if currentEvent.id == "" {
                                    VStack {
                                        Text("+")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(.navyBlue))
                                        Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                            .font(.title)
                                            .foregroundStyle(Color(.navyBlue))
                                    }.onTapGesture {
                                        
                                        if bigModel.isUserTryingAddNewMealToCalendar {
                                            bigModel.selectedMealType = "Snack"
                                            bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            bigModel.isUserTryingAddNewMealToCalendar.toggle()
                                        } else {
                                            bigModel.selectedMealType = "Snack"
                                            print(selectedDate.timeIntervalSince1970)
                                            bigModel.currentView = .mealsPropositionScreen
                                            bigModel.screenHistory.append(.DailyCalendar)
                                        }
                                        
                                    }
                                } else {
                                    if currentEvent.snackMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.snackMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.snackMeal!.recipe.prepDuration) min - \(currentEvent.snackMeal!.recipe.price)\(currentEvent.snackMeal!.recipe.currency)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                                Image(systemName: "trash")
                                                    .foregroundStyle(Color(.navyBlue))
                                                    .onTapGesture {
                                                        bigModel.removeMealFromEvent(mealType: "Snack")
                                                    }
                                            }
                                        }.padding(20)
                                        .onTapGesture {
                                            bigModel.selectedMeal = currentEvent.breakfastMeal!
                                            bigModel.screenHistory.append(.DailyCalendar)
                                            bigModel.currentView = .RecipeScreen
                                        }
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color(.navyBlue))
                                            Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                                .font(.title)
                                                .foregroundStyle(Color(.navyBlue))
                                        }.onTapGesture {
                                            
                                            if bigModel.screenHistory.last == .RecipeScreen {
                                                bigModel.selectedMealType = "Snack"
                                                bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            } else {
                                                bigModel.selectedMealType = "Snack"
                                                print(selectedDate.timeIntervalSince1970)
                                                bigModel.currentView = .mealsPropositionScreen
                                                bigModel.screenHistory.append(.DailyCalendar)
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("dinner")
                                    .font(.title3)
                                    .foregroundStyle(Color(.navyBlue))
                                Spacer()
                            }
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(20)
                                    .frame(minHeight: 200)
                                
                                if currentEvent.id == "" {
                                    VStack {
                                        Text("+")
                                            .font(.largeTitle)
                                            .foregroundStyle(Color(.navyBlue))
                                        Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                            .font(.title)
                                            .foregroundStyle(Color(.navyBlue))
                                    }.onTapGesture {
                                        
                                        if bigModel.isUserTryingAddNewMealToCalendar {
                                            bigModel.selectedMealType = "Dinner"
                                            bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            bigModel.isUserTryingAddNewMealToCalendar.toggle()
                                        } else {
                                            bigModel.selectedMealType = "Dinner"
                                            print(selectedDate.timeIntervalSince1970)
                                            bigModel.currentView = .mealsPropositionScreen
                                            bigModel.screenHistory.append(.DailyCalendar)
                                        }
                                        
                                    }
                                } else {
                                    if currentEvent.dinnerMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.dinnerMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.dinnerMeal!.recipe.prepDuration) min - \(currentEvent.dinnerMeal!.recipe.price)\(currentEvent.dinnerMeal!.recipe.currency)")
                                                    .font(.title3)
                                                    .foregroundStyle(Color(.navyBlue))
                                                Spacer()
                                                Image(systemName: "trash")
                                                    .foregroundStyle(Color(.navyBlue))
                                                    .onTapGesture {
                                                        bigModel.removeMealFromEvent(mealType: "Dinner")
                                                    }
                                            }
                                        }.padding(20)
                                        .onTapGesture {
                                            bigModel.selectedMeal = currentEvent.dinnerMeal!
                                            bigModel.screenHistory.append(.DailyCalendar)
                                            bigModel.currentView = .RecipeScreen
                                        }
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                                .foregroundStyle(Color(.navyBlue))
                                            Text(bigModel.isUserTryingAddNewMealToCalendar ? "click-to-add" : "add-a-meal")
                                                .font(.title)
                                                .foregroundStyle(Color(.navyBlue))
                                        }.onTapGesture {
                                            
                                            if bigModel.screenHistory.last == .RecipeScreen {
                                                bigModel.selectedMealType = "Dinner"
                                                bigModel.addMealToCalendar(mealType: bigModel.selectedMealType, meal: bigModel.selectedMeal, dateTime: bigModel.selectedTimeEpoch)
                                            } else {
                                                bigModel.selectedMealType = "Dinner"
                                                print(selectedDate.timeIntervalSince1970)
                                                bigModel.currentView = .mealsPropositionScreen
                                                bigModel.screenHistory.append(.DailyCalendar)
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                }.padding(.top, 20)
                .padding(.horizontal, 20)
                .edgesIgnoringSafeArea(.bottom)
                
            }.edgesIgnoringSafeArea(.bottom)
            
            .onAppear {
                self.currentEvent = bigModel.tabEventWithValue(selectedDate: selectedDate)
                self.selectedDate = Date(timeIntervalSince1970: bigModel.selectedTimeEpoch)
            }
            .onChange(of: bigModel.currentUser) {
                self.currentEvent = bigModel.tabEventWithValue(selectedDate: selectedDate)
            }
            .onChange(of: self.selectedDate) { oldValue, newValue in
                self.currentEvent = bigModel.tabEventWithValue(selectedDate: selectedDate)
            }
            
            
        } else {
            // Fallback on earlier versions
        }
        
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
    
    func datesAreIdentical(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
    
}

struct SwipeGestureModifier: ViewModifier {
    enum SwipeDirection {
        case left, right
    }
    
    let onSwipe: (SwipeDirection) -> Void
    
    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { gesture in
                        if gesture.translation.width > 0 {
                            self.onSwipe(.right)
                        } else {
                            self.onSwipe(.left)
                        }
                    }
            )
    }
}

extension View {
    func onSwipe(perform action: @escaping (SwipeGestureModifier.SwipeDirection) -> Void) -> some View {
        self.modifier(SwipeGestureModifier(onSwipe: action))
    }
}


#Preview {
    DailyCalendar(bigModel: BigModel.mocked)
        .environmentObject(BigModel.shared)
}
