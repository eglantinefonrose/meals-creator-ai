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
                                    Text("\(getDateNumber(date: Calendar.current.date(byAdding: .day, value: dayDelay, to: bigModel.selectedDate)!))")
                                        .font(.title)
                                        .foregroundColor(dayDelay == 0 ? .white : .navyBlue)
                                    Text("\(getDateMonth(date: Calendar.current.date(byAdding: .day, value: dayDelay, to: bigModel.selectedDate)!))")
                                        .font(.headline)
                                        .textCase(.lowercase)
                                        .foregroundColor(dayDelay == 0 ? .white : .navyBlue)
                                }
                            }.onTapGesture {
                                withAnimation(.interactiveSpring) { // Ajout de l'animation lors du clic
                                    bigModel.selectedDate = Calendar.current.date(byAdding: .day, value: dayDelay, to: bigModel.selectedDate)!
                                    print(bigModel.selectedDate)
                                }
                            }
                        }
                        
                    }.onSwipe { direction in
                        withAnimation(.interactiveSpring) { // Ajout de l'animation lors du swipe
                            self.swipeDirection = direction
                            if (direction == .left) {
                                bigModel.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: bigModel.selectedDate)!
                            }
                            if (direction == .right) {
                                bigModel.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: bigModel.selectedDate)!
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
                                bigModel.selectedMealType = "Breakfast"
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
                                bigModel.selectedMealType = "Lunch"
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
                                bigModel.selectedMealType = "Snack"
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
            
            .onChange(of: bigModel.selectedDate) { oldValue, newValue in
                
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
    
    func tabEventWithValue() -> BigModel.Event {
        
        if let index = bigModel.currentUser.events.firstIndex(where: { Date(timeIntervalSince1970: TimeInterval($0.timeEpoch)) == bigModel.selectedDate }) {
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
}
