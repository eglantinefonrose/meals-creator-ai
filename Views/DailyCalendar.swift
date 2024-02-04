//
//  DailyCalendar.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 27/12/2023.
//

import SwiftUI

struct DailyCalendar: View {
    
    @EnvironmentObject var bigModel: BigModel
    let epochTime: TimeInterval = 0
    @State private var swipeDirection: SwipeGestureModifier.SwipeDirection? = nil
    @State var currentEvent: BigModel.Event = BigModel.Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
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
                                    print(self.selectedDate)
                                }
                            }
                        }
                        
                    }.onSwipe { direction in
                        withAnimation(.interactiveSpring) { // Ajout de l'animation lors du swipe
                            self.swipeDirection = direction
                            if (direction == .left) {
                                self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
                            }
                            if (direction == .right) {
                                self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate)!
                            }
                        }
                    }
                    
                    ScrollView {
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("breakfast")
                                    .font(.title3)
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
                                        Text("add-a-meal")
                                            .font(.title)
                                    }
                                } else {
                                    if currentEvent.breakfastMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.breakfastMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.breakfastMeal!.recipe.prepDuration) - \(currentEvent.breakfastMeal!.recipe.price)\(currentEvent.breakfastMeal!.recipe.currency)")
                                                    .font(.title3)
                                                Spacer()
                                            }
                                        }.padding(20)
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                            Text("add-a-meal")
                                                .font(.title)
                                        }
                                    }
                                }
                                
                            }.onTapGesture {
                                bigModel.selectedMealType = "Breakfast"
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                                print(selectedDate.timeIntervalSince1970)
                                bigModel.currentView = .mealsPropositionScreen
                                bigModel.screenHistory.append(.DailyCalendar)
                                
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("lunch")
                                    .font(.title3)
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
                                        Text("add-a-meal")
                                            .font(.title)
                                    }
                                } else {
                                    if currentEvent.lunchMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.lunchMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.lunchMeal!.recipe.prepDuration) - \(currentEvent.lunchMeal!.recipe.price)\(currentEvent.lunchMeal!.recipe.currency)")
                                                    .font(.title3)
                                                Spacer()
                                            }
                                        }.padding(20)
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                            Text("add-a-meal")
                                                .font(.title)
                                        }
                                    }
                                }
                                
                            }.onTapGesture {
                                bigModel.selectedMealType = "Lunch"
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                                print(selectedDate.timeIntervalSince1970)
                                bigModel.currentView = .mealsPropositionScreen
                                bigModel.screenHistory.append(.DailyCalendar)
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("snack")
                                    .font(.title3)
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
                                        Text("add-a-meal")
                                            .font(.title)
                                    }
                                } else {
                                    if currentEvent.snackMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.snackMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.snackMeal!.recipe.prepDuration) - \(currentEvent.snackMeal!.recipe.price)\(currentEvent.snackMeal!.recipe.currency)")
                                                    .font(.title3)
                                                Spacer()
                                            }
                                        }.padding(20)
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                            Text("add-a-meal")
                                                .font(.title)
                                        }
                                    }
                                }
                                
                            }.onTapGesture {
                                bigModel.selectedMealType = "Snack"
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                                print(selectedDate.timeIntervalSince1970)
                                bigModel.currentView = .mealsPropositionScreen
                                bigModel.screenHistory.append(.DailyCalendar)
                            }
                            
                        }
                        
                        VStack(spacing: 5) {
                            
                            HStack {
                                Text("dinner")
                                    .font(.title3)
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
                                        Text("add-a-meal")
                                            .font(.title)
                                    }
                                } else {
                                    if currentEvent.dinnerMeal != nil {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(currentEvent.dinnerMeal!.recipe.recipeName)
                                                    .font(.largeTitle)
                                                Spacer()
                                            }
                                            HStack {
                                                Text("\(currentEvent.dinnerMeal!.recipe.prepDuration) - \(currentEvent.dinnerMeal!.recipe.price)\(currentEvent.dinnerMeal!.recipe.currency)")
                                                    .font(.title3)
                                                Spacer()
                                            }
                                        }.padding(20)
                                    }
                                    else {
                                        VStack {
                                            Text("+")
                                                .font(.largeTitle)
                                            Text("add-a-meal")
                                                .font(.title)
                                        }
                                    }
                                }
                                
                            }.onTapGesture {
                                bigModel.selectedMealType = "Dinner"
                                bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
                                print(selectedDate.timeIntervalSince1970)
                                bigModel.currentView = .mealsPropositionScreen
                                bigModel.screenHistory.append(.DailyCalendar)
                            }
                            
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                }.padding(20)
            }.onAppear {
                self.currentEvent = tabEventWithValue()
            }
            
            .onChange(of: self.selectedDate) { oldValue, newValue in
                self.currentEvent = tabEventWithValue()
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
    
    func tabEventWithValue() -> BigModel.Event {
        
        bigModel.selectedTimeEpoch = selectedDate.timeIntervalSince1970
        print("[\(selectedDate.timeIntervalSince1970)]")
        
        if let index = bigModel.currentUser.events.firstIndex(where: {
            
            datesAreIdentical(date1: Date(timeIntervalSince1970: bigModel.selectedTimeEpoch), date2: Date(timeIntervalSince1970: $0.timeEpoch) )
            
        }) {
                return bigModel.currentUser.events[index]
        } else {
            return BigModel.Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
        }
        
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
    DailyCalendar()
        .environmentObject(BigModel.shared)
}
