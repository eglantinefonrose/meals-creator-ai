//
//  BigModel.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift
import AuthenticationServices
import Combine
import Alamofire
import KeychainAccess
import FirebaseStorage

class BigModel: ObservableObject {
    
    public static var shared = BigModel()
    public static var mocked: BigModel = BigModel(shouldInjectMockedData: true)
    
    @Published var currentView: ViewEnum = .signInView
    @Published var screenHistory: [ViewEnum] = []
    
    struct User: Identifiable, Codable, Equatable {
        @DocumentID var id: String?
        var firstName: String
        var lastName: String
        var items: [Item]
        var tools: [Item]
        var budget: Int
        var currency: String
        var spendedTime: Int
        var numberOfPerson: Int
        var proposedMeals: [Meal]
        var favoriteMeals: [Meal]
        var dislikedMeals: [Meal]
        var events: [Event]
    }
    
    struct Meal: Codable, Identifiable, Hashable, Comparable {
            
        static func < (lhs: Meal, rhs: Meal) -> Bool {
            lhs.id < rhs.id
        }
        
        static func == (lhs: Meal, rhs: Meal) -> Bool {
            lhs.id == rhs.id
        }
        
        var id: String
        var recipe: Recipe
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(recipe) // Include recipe in the hash
        }
        
    }

    struct Recipe: Codable, Hashable, Comparable, Identifiable {
        
        static func < (lhs: Recipe, rhs: Recipe) -> Bool {
            lhs.id < rhs.id
        }
        
        static func == (lhs: Recipe, rhs: Recipe) -> Bool {
            lhs.id == rhs.id
        }
        
        var id: String
        var recipeName: String
        var numberOfPersons: Int
        var mealType: String
        var seasons: [String]
        var ingredients: [Ingredient]
        var price: String
        var currency: String
        var prepDuration: Int
        var totalDuration: Int
        var recipeDescription: RecipeDescription
        
        // Hashable conformance
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(recipeName)
            hasher.combine(numberOfPersons)
            hasher.combine(mealType)
            hasher.combine(seasons)
            hasher.combine(ingredients)
            hasher.combine(price)
            hasher.combine(prepDuration)
            hasher.combine(totalDuration)
            hasher.combine(recipeDescription)
        }
        
    }

    struct Ingredient: Codable, Hashable {
        
        //let id: String
        let name: String
        let quantityWithUnit: String
        
        static func < (lhs: Ingredient, rhs: Ingredient) -> Bool {
            lhs.name < rhs.name
        }
        
        static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
            lhs.name == rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(quantityWithUnit)
        }
        
    }

    struct RecipeDescription: Codable, Hashable {
        
        let id: String
        let introduction: String
        let steps: [String]
        
        static func < (lhs: RecipeDescription, rhs: RecipeDescription) -> Bool {
            lhs.introduction < rhs.introduction
        }
        
        static func == (lhs: RecipeDescription, rhs: RecipeDescription) -> Bool {
            lhs.introduction == rhs.introduction
        }
        
        func hash(into hasher: inout Hasher) {
            //hasher.combine(id)
            hasher.combine(introduction)
            hasher.combine(steps)
        }
        
    }
    
    
    struct Item: Identifiable, Comparable, Hashable, Codable {
        static func < (lhs: Item, rhs: Item) -> Bool {
            lhs.name < rhs.name
        }
        
        var id: Int
        var category: String
        var name: String
        var seasons: [String]
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(category)
            hasher.combine(name)
            hasher.combine(seasons)
        }
        
    }
    
    struct ImageType: Identifiable {
        
        var id: Int
        var image: Image
        
    }
    
    //let images: [ImageType] = [ImageType(id: 1, image: UIImage(named: "leek")!), Image(id: 2, image: UIImage(named: "zucchini")!), Image(id: 4, image: UIImage(named: "broccoli")!), Image(id: 8, image: UIImage(named: "pasta")!), ImageType(id: 11, image: UIImage(named: "steak")!)]
    var images: [ImageType] = []
    
    struct Event: Identifiable, Codable, Equatable {
        var id: String
        var timeEpoch: Double
        var breakfastMeal: Meal?
        var lunchMeal: Meal?
        var snackMeal: Meal?
        var dinnerMeal: Meal?
    }
    
    @Published var currentUser: User = User(id: "", firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
    
    /*let items = [Item(id: 0, category: "legumes", name: "Carotte", seasons: ["été"]), Item(id: 1, category: "legumes", name: "Poireaux", seasons: ["automne", "été"]),Item(id: 2, category: "legumes", name: "Courgette", seasons: ["automne", "hiver"]),Item(id: 3, category: "legumes", name: "Aubergine", seasons: ["hiver"]),Item(id: 4, category: "legumes", name: "Brocolli", seasons: ["printemps"]),
                 Item(id: 5, category: "fruits", name: "Pomme", seasons: ["printemps"]), Item(id: 6, category: "fruits", name: "Poire", seasons: ["automne"]),
                 Item(id: 7, category: "strachyFoods", name: "Riz", seasons: ["été", "automne", "hiver", "printemps"]), Item(id: 8, category: "strachyFoods", name: "Pates", seasons: ["été", "automne", "hiver", "printemps"]),
                 Item(id: 9, category: "allergies", name: "Carbohydrate", seasons: ["été","automne","hiver","printemps"]), Item(id: 10, category: "allergies", name: "Lactose", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 11, category: "proteins", name: "Boeuf", seasons: ["été","automne","hiver","printemps"]), Item(id: 12, category: "proteins", name: "Poisson", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 13, category: "seasonning", name: "curry", seasons: ["été","automne","hiver","printemps"]), Item(id: 14, category: "seasonning", name: "curcuma", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 15, category: "cookingTools", name: "Stove", seasons: ["été","automne","hiver","printemps"]), Item(id: 16, category: "cookingTools", name: "pan", seasons: ["été","automne","hiver","printemps"]), Item(id: 17, category: "cookingTools", name: "oven", seasons: ["été","automne","hiver","printemps"])
    ]*/
    
    var items: [Item] = []
    var currentItems: [Item] = []
    
    func isInTheList(item: Item) -> Bool {
        
        if (self.currentUser.items.count) != 0 {
            for i in (0...(self.currentUser.items.count)-1) {
                if currentUser.items[i].id == item.id {
                    return true
                } else {
                    
                }
            }
        }
        return false
    }
    
    
    func compareLists() -> [Item: Bool] {
        var resultDictionary = [Item: Bool]()
        let list1 = currentUser.items
        
        // Crée un ensemble des noms d'items dans la liste1 pour une recherche plus efficace
        let setList1 = Set(list1.map { $0 })

        // Parcourt la liste2 et vérifie si chaque item est présent dans la liste1
        for item in self.items {
            resultDictionary[item] = setList1.contains(item)
        }

        return resultDictionary
    }
    
    func extractTagsPerCategorie(categorie: String) -> [Item:Bool] {
        var tags: [Item:Bool] = [:]
        let tagList = compareLists()
        
        for (key, value) in tagList {
            if key.category == categorie {
                tags[key] = value
            }
        }
        return tags
    }
    
    func extractTagsPerCategorieAndSeason(categorie: String, season: String) -> [Item:Bool] {
        var tags: [Item:Bool] = [:]
        let tagList = compareLists()
        
        for (key, value) in tagList {
            if key.category == categorie {
                if key.seasons.contains(season) {
                    tags[key] = value
                }
                if season == "All" {
                    tags[key] = value
                }
            }
        }
        return tags
    }
    
    func extractItemsPerCategorie(categorie: String) -> [Item] {
        
        var itemList: [Item] = []
        
        if categorie == "cookingTools" {
            if self.currentUser.tools != [] {
                for i in (0...(self.currentUser.tools.count)-1) {
                    if (self.currentUser.tools.count) >= 1 {
                        if self.currentUser.tools[i].category == categorie {
                            itemList.append(self.currentUser.tools[i])
                        } else {
                            
                        }
                    } else {
                        
                    }
                }
            }
        } else {
            if self.currentUser.items != [] {
                for i in (0...(self.currentUser.items.count)-1) {
                    if (self.currentUser.items.count) >= 1 {
                        if self.currentUser.items[i].category == categorie {
                            itemList.append(self.currentUser.items[i])
                        } else {
                            
                        }
                    } else {
                        
                    }
                }
            }
        }
        
        return itemList
        
    }
    
    func updatedSelectedItemsList(dict: [Item: Bool], categorie: String) -> [Item] {
        var array: [Item] = []
        for (key, value) in dict {
            if value == true {
                array.append(key)
            }
        }
        
        if categorie == "cookingTools" {
            array = array + (currentUser.tools)
        } else {
            array = array + (currentUser.items)
        }
        
        return Array(Set(array))
    }
    
    func updatedSelectedItemsList2(list: [Item], categorie: String) -> [Item] {
        
        var array: [Item] = []
        
        if categorie == "cookingTools" {
            array = currentUser.tools
        } else {
            array = currentUser.items
        }
        
        array = removeItemsWithCategorie(array: array, category: categorie)
        
        array = array + list
        return array
    }
    
    func removeItemsWithCategorie(array: [Item], category: String) -> [Item] {
        
        var newArray: [Item] = []
        
        if array != [] {
            for i in 0...(array.count-1) {
                if (array[i].category != category) {
                    newArray.append(array[i])
                }
            }
        }
        return newArray
    }
    
    func generateTags(type: String, season: String) -> [Meal: Bool] {
        
        var tagsDictionary = [Meal: Bool]()
        let favoriteMeals = self.currentUser.favoriteMeals
        
        for meal in currentUser.proposedMeals {
            tagsDictionary[meal] = favoriteMeals.contains { $0.id == meal.id }
        }

        return tagsDictionary
    }
    
    
    
    
    func categoryName(categorie: String) -> String {
        switch categorie {
        case "legumes":
            return "Legumes"
        case "fruits":
            return "Fruits"
        case "strachyFoods":
            return "Strachy Foods"
        case "proteins":
            return "Proteins"
        case "seasonning":
            return "Seasonning"
        case "allergies":
            return "Allergies"
        case "cookingTools":
            return "Cooking Tools"
        default:
            return "Fruits"
        }
    }
    
    func categoryToScreenName(categorie: String) -> ViewEnum {
        switch categorie {
            case "legumes":
                return .LegumeScreen
            case "fruits":
                return .FruitsScreen
            case "strachyFoods":
                return .strachyFoodsScreen
            case "proteins":
                return .proteinsScreen
            case "seasonning":
                return .seasonningScreen
            case "allergies":
                return .allergiesScreen
            case "cookingTools":
                return .cookingToolsScreen
        default:
            return .FruitsScreen
        }
    }
    
    func categoryToName(categorie: String) -> String {
        switch categorie {
            case "legumes":
                return "Legumes"
            case "fruits":
                return "Fruits"
            case "strachyFoods":
                return "Strachy foods"
            case "proteins":
                return "Proteins"
            case "seasonning":
                return "Seasonning"
            case "allergies":
                return "Allergies"
            case "cookingTools":
                return "Cooking tools"
        default:
            return ""
        }
    }
    
    struct CategoryName: Identifiable {
        var id: Int
        var name: String
    }
    
    let categoriesNameList: [CategoryName] = [CategoryName(id: 0, name: "legumes"), CategoryName(id: 1, name: "fruits"), CategoryName(id: 2, name: "strachyFoods"), CategoryName(id: 3, name: "proteins"), CategoryName(id: 4, name: "seasonning"), CategoryName(id: 5, name: "allergies"), CategoryName(id: 6, name: "cookingTools")]
    
    //
    //
    //
    //
    //
    //MARK: AUTH
    //
    //
    //
    //
    //
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }
    
    func updateNonce() {
        self.nonce = self.randomNonceString(length: 32)
    }

        
    
    let auth = Auth.auth()
    @Published var nonce = ""
    let db = Firestore.firestore()
    //@Published var isNewUser: Bool = false
    
    func authentificateWithApple(credential: ASAuthorizationAppleIDCredential) {
        
        guard let token = credential.identityToken else {
            print("error with firebase")
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with Token")
            return
        }
        
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            
            if let error = err {
                print(error.localizedDescription)
                return
            }
            // Userl Successfully Logged Into Firebase.
            print("Logged In Success")
            
            guard let id = self.auth.currentUser?.uid else { return }
            self.currentUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
                        
            let docRef = self.db.collection("Users").document(id)

            docRef.getDocument { (document, error) in
                
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document, document.exists
                    {
                    do {
                        print("id = \(id)")
                        self.currentUser = try document.data(as: User.self)
                        self.currentView = .UserView
                        self.screenHistory.append(.signInView)
                        //print("Document data: \(String(describing: document.data()))")
                    }
                    catch {
                      print("Apple login error : \(error)")
                    }
                  } else {
                      self.currentView = .UserView
                      //self.screenHistory.append(.signInView)
                  }
                }
            }
            
        }
    }
    
    func fetchUserInfoFromDB() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        self.currentUser.firstName = ""
                        let user = try document.data(as: User.self)
                        self.currentUser = user
                        
                       // print("Document data: \(String(describing: document.data()))")
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                } else {
                    do {
                        let _ = try self.db.collection("Users").document(id).setData(from: newUser)
                    } catch {
                        
                    }
                }
            }
        }
        
    }
    
    func fetchItemsInfos() {
        let storageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/shop-planner-7533c.appspot.com/o/data-items.json?alt=media&token=e88fd1ed-8689-43ed-bafd-98d83e1909c7")!
        let task = URLSession.shared.dataTask(with: storageURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Une erreur est survenue : \(String(describing: error))")
                return
            }
            do {
                let decoder = JSONDecoder()
                let newItems = try decoder.decode([Item].self, from: data)
                self.items = newItems
            } catch {
                //print("Une erreur est survenue lors de l'analyse JSON :  \(String(describing: error))")
            }
        }
        task.resume()
    }
    
    @Published var links: [String] = []
    
    func fetchImage(url: String) async throws -> Image {
        
        let storage = Storage.storage()
        let gcsReference = storage.reference(forURL: url)

        let imageData = try await gcsReference.data(maxSize: 10 * 1024 * 1024)

        guard let uiImage = UIImage(data: imageData) else {
            throw NSError(domain: "MyApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Error converting image data to UIImage."])
        }

        return Image(uiImage: uiImage)
        
    }
    
    func fetchAllImages() {
        
        do {
        
           // creating a path from the main bundle and getting data object from the path
           if let bundlePath = Bundle.main.path(forResource: "items-draw-ref", ofType: "json"),
           let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                 
              // Decoding the Product type from JSON data using JSONDecoder() class.
              let array = try JSONDecoder().decode([String].self, from: jsonData)
              //print(array)
               
               for i in (0...17) {
                   if i == 0 {
                       Task {
                           do {
                               let image = try await self.fetchImage(url: array[i])
                               self.images.append(ImageType(id: i, image: image))
                           } catch {
                               print(error.localizedDescription)
                           }
                       }
                   }
                   if i<10 {
                       Task {
                           do {
                               let image = try await self.fetchImage(url: array[i])
                               self.images.append(ImageType(id: i, image: image))
                           } catch {
                               print(error.localizedDescription)
                           }
                       }
                   } else {
                       Task {
                           do {
                               let image = try await self.fetchImage(url: array[i])
                               self.images.append(ImageType(id: i, image: image))
                           } catch {
                               print(error.localizedDescription)
                           }
                       }
                   }
               }
               
           }
        } catch {
           print(error)
            let product: [String] = []
        }
        
    }
    
    func googleSignInUserUpdate() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        self.currentUser = user
                        self.currentView = .UserView
                        //self.screenHistory.append(.signInView)
                        print("Document data: \(String(describing: document.data()))")
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                } else {
                    do {
                        let _ = try self.db.collection("Users").document(id).setData(from: newUser)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func storeCurrentUserInfoIntoDB(user: User) {
                
        do {
            // Update the UserInfo inside the Firebase DB
            guard let id = self.auth.currentUser?.uid else { return }
            let _ = try self.db.collection("Users").document(id).setData(from: user)
            // Refresh the BigModel from the DB
            fetchUserInfoFromDB()
            print("done")
        } catch {
            print("ERR001[updateCurrentUserInfoInDB]=\(error)")
        }
        
    }
    
    func storeInDBAndFetchNewProposedMealsList() {
                
        do {
            // Update the UserInfo inside the Firebase DB
            var user = currentUser
            guard let id = self.auth.currentUser?.uid else { return }
            
            let mealsList = removeMealFromList(mealsList: currentUser.proposedMeals)
            let favoriteMealsList = removeMealFromList(mealsList: currentUser.favoriteMeals)
            
            for i in (0...((user.events.count)-1)) {
                if user.events[i].breakfastMeal == dislikedMeal {
                    user.events[i].breakfastMeal = nil
                }
                if user.events[i].lunchMeal == dislikedMeal {
                    user.events[i].lunchMeal = nil
                }
                if user.events[i].snackMeal == dislikedMeal {
                    user.events[i].snackMeal = nil
                }
                if user.events[i].dinnerMeal == dislikedMeal {
                    user.events[i].dinnerMeal = nil
                }
            }
            
            user.proposedMeals = mealsList
            user.favoriteMeals = favoriteMealsList
            user.dislikedMeals.append(self.dislikedMeal)
            
            let _ = try self.db.collection("Users").document(id).setData(from: user) { _ in
                
                let docRef = self.db.collection("Users").document(id)
                let newUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
                
                docRef.getDocument { (document, error) in
                    
                    if let document = document {
                        if document.exists {
                            do {
                                self.currentUser.firstName = ""
                                let user = try document.data(as: User.self)
                                self.currentUser = user
                                if self.currentUser.proposedMeals == mealsList {
                                    self.currentView = .mealsPropositionScreen
                                }
                                
                                print("Document data: \(String(describing: document.data()))")
                                
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            do {
                                let _ = try self.db.collection("Users").document(id).setData(from: newUser)
                            } catch {
                                
                            }
                        }
                    }
                }
                
            }
            // Refresh the BigModel from the DB
            
            print("done")
        } catch {
            print("ERR001[updateCurrentUserInfoInDB]=\(error)")
        }
        
    }
    
    private func removeMealFromList(mealsList: [Meal]) -> [BigModel.Meal] {
        
        var newMealsList = mealsList
        let meal = dislikedMeal
        var user = currentUser
        
        if let index = mealsList.firstIndex(where: { $0.id == meal.id }) {
            
            for i in (0...((user.events.count)-1)) {
                if user.events[i].breakfastMeal == dislikedMeal {
                    user.events[i].breakfastMeal = nil
                }
                if user.events[i].lunchMeal == dislikedMeal {
                    user.events[i].lunchMeal = nil
                }
                if user.events[i].snackMeal == dislikedMeal {
                    user.events[i].snackMeal = nil
                }
                if user.events[i].dinnerMeal == dislikedMeal {
                    user.events[i].dinnerMeal = nil
                }
            }
            
            newMealsList.remove(at: index)
            print("Element retiré avec succès")
            return newMealsList
        } else {
            print("Element non trouvé dans la liste")
            return newMealsList
        }
        
    }
    
    @Published var dislikedMeal: Meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))
    
    func removeMealFromList(meal: Meal, mealsList: [Meal]) -> [Meal] {
        
        var newMealsList = mealsList
        
        if let index = mealsList.firstIndex(where: { $0.id == meal.id }) {
            newMealsList.remove(at: index)
            print("Element retiré avec succès")
            return newMealsList
        } else {
            print("Element non trouvé dans la liste")
            return newMealsList
        }
    }
    
    
    
    
    func updateUserNames(firstName: String, lastName: String) {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let user = User(id: id, firstName: firstName, lastName: lastName, items: self.currentUser.items, tools: self.currentUser.tools, budget: self.currentUser.budget, currency: self.currentUser.currency, spendedTime: self.currentUser.spendedTime, numberOfPerson: 0, proposedMeals: self.currentUser.proposedMeals, favoriteMeals: self.currentUser.favoriteMeals, dislikedMeals: self.currentUser.dislikedMeals, events: self.currentUser.events)
        
        docRef.getDocument { (document, error) in
            do {
                let _ = try self.db.collection("Users").document(id).setData(from: user)
            } catch {
                
            }
        }
        
    }
    
    //
    //
    //
    //
    //MARK: MEALS GENERATION
    //
    //
    //
    //
    //
    
    struct OpenAICompletionsBody: Encodable {
        let model: String // The language model
        let prompt: String // The message we want to send
        let temperature: Float?
        let max_tokens: Int?
    }

    struct OpenAICompletionsResponse: Decodable {
        let id: String
        let choices: [OpenAICompetionsChoice]
    }

    struct OpenAICompetionsChoice: Decodable {
        let text: String
    }
    
    struct ChatMessage {
        let id: String
        let content: String
        let dateCreated: Date
        let sender: MessageSender
    }

    enum MessageSender {
        case me
        case gpt
    }
    
    let baseUrl = "https://api.openai.com/v1/"
    
    func getSecretKey() -> String?  {
        let keychain = Keychain(service: "net.proutechos.openai")
        let entry = keychain["key.teevity.dev001"]
        
        return entry
    }
    
    let openAIURL = URL(string: "https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct/completions")
    var openAIKey: String {
        return getSecretKey() ?? "GrosMinetnil"
    }
    
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        })
        task.resume()
        
        // Handle async with semaphores. Max wait of 10 seconds
        let timeout = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
    
    
    public func processPrompt(prompt: String) -> String {
            
            var request = URLRequest(url: self.openAIURL!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
            let httpBody: [String: Any] = [
                "prompt" : prompt,
                "max_tokens" : 2000
            ]
            
            var httpBodyJson: Data
            
            do {
                httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            } catch {
                print("Unable to convert to JSON \(error)")
                return ""
            }
            request.httpBody = httpBodyJson
            
            do {
                if let requestData = executeRequest(request: request, withSessionConfig: nil) {
                    print("Bearer \(openAIKey)")
                    let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    ///
                    //MARK: I know there\"s an error below, but we\"ll fix it later on in the article, so make sure not to change anything
                    ///
                    let responseHandler = OpenAIResponseHandler()
                    
                    //print("jsonStr : [\(jsonStr)]")
                    let jsonString = (responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].text) ?? ""
                    
                    return (jsonString)
                    
                }
            } catch {
                print(error)
            }
        
        return("error")
            
        }
    
    func createMealsNameList(mealType: String) -> [String] {
        
        //let prompt1 = "Voici mon modèle d\"ingredients en swift : struct Item: Identifiable, Comparable, Hashable, Codable { var id: Int var category: String var name: String var seasons: [String] }. Voici mon modèle d\"ItemAndQtty en swift : struct ItemAndQtty: Codable, Identifiable { var id: String var item: Item var quantity: Int } Le type Categories est une enum : enum Categories: CaseIterable, Codable { case legumes, fruits, strachyFoods, proteins, seasonning, allergies, cookingTools }. La variable \"category\" doit être écrit de la forme .nomdelacategorie. Voici mon modèle de menu en swift : struct Meal: Codable, Identifiable { var id: String var name: String var type: String = \(mealType) var season: String = \(selectedSeason) var itemsAndQ: [ItemAndQtty] var price: Int var spendedTime: Int var recipe: String }. Peux tu me donner la recette de "
        //var meals: [Meal] = []
        var mealsNameList: [String] = []
        
        let response = processPrompt(prompt: "Peux tu me proposer une liste de 5 plats de type \(mealType) d\"\(selectedSeason) pour une personne qui aime \(listToString(list: self.currentUser.items)) et qui a \(listToString(list: self.currentUser.tools)). Cette personne a un budget de \(currentUser.budget), veut y consacrer maximum \(currentUser.spendedTime) et pour \(currentUser.numberOfPerson). Formate le résultat de la manière suivante : \" nomDuRepas1 - nomDuRepas2 - nomDuRepas3 - nomDuRepas4 - nomDuRepas5 \".")
        //Donne moi des meals avec des ID distincts et différents entre eux pour chaque meals.
        mealsNameList = splitStringWithDash(inputString: response)
        
        //let response2 = processPrompt(prompt: "\(prompt1) \(mealsNameList[0])")
        //print("response2 \(response2)")
        //meals.append(jsonTest(jsonString: response2) ?? Meal(id: "", name: "", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""))
        
        guard mealsNameList.count >= 5 else {
                return mealsNameList
            }
        return Array(mealsNameList[..<5])
        
    }
    
    @Published var isLoading = false
    @Published var testMealList: [Meal] = [Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))]
    @Published var selectedMeal: Meal = Meal(id: "erijorg", recipe: Recipe(id: "ijo", recipeName: "Riz au curry et aux crevettes", numberOfPersons: 0, mealType: "Main course", seasons: ["été", "hiver"], ingredients: [Ingredient(name: "curcuma", quantityWithUnit: "4 grammes"), Ingredient(name: "cura", quantityWithUnit: "4 grammes"), Ingredient(name: "possio", quantityWithUnit: "4 grammes"), Ingredient(name: "boeuf", quantityWithUnit: "4 grammes"), Ingredient(name: "zirojzr", quantityWithUnit: "4 grammes"), Ingredient(name: "hhhh", quantityWithUnit: "4 grammes")], price: "45", currency: "$", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "voici la recette", steps: ["erijofreogjrgpgrepg jr", "erijofrjnkl,lkeoif,ref ier gjrgpgrepg jr", "erijofhhhhhreoif,ref ier gjrgpgrepg jr", "erijofuihuihuireoif,ref ier gjrgpgrepg jr", "erijog jr"])))
    @Published var selectedSeason: String = ""
    
    @Published var currentUserTags: [Meal: Bool] = [:]
    @Published var currentUserFavMealTags: [Meal: Bool] = [:]
    @Published var didPreferencesChanged: Bool = false
    
    func createMeals(mealType: String) async {
        
        DispatchQueue.main.async {
            self.isLoading = true
            //self.currentUserTags = [:]
        }
        
        let mealsNameList: [String] = self.createMealsNameList(mealType: mealType)
        
        print("mealsNameList.count \(mealsNameList.count)")
        print(mealsNameList)
        
        for i in 0..<(mealsNameList.count-1) {
                        
            let response = processPrompt(prompt: "Donne moi les informations suivantes pour réaliser la recette de \(mealsNameList[i]) :  - id: l'identifiant de la recette - seasons : saison(s) pour laquelle la recette est adaptée (les valeurs possibles sont \"Summer\", \"Spring\", \"Winter\", \"Autumn\")  - ingredients : liste des ingrédients et quantité nécessaire pour \(currentUser.numberOfPerson) personnes - price : prix indicatif pour l\"ensemble des ingrédients (sans avoir le détail par ingrédient) - prepDuration : durée de préparation - totalDuration : durée totale - type : le type de repas  (les valeurs possibles sont \"main course\", \"breakfast\", \"dessert\", \"starter\") - recipe : description textuelle de la recette. Formate le résultat de la manière suivante : { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"recipeName\":\"\(mealsNameList[i])\", \"numberOfPersons\":3, \"mealType\":\"\(mealType)\", \"seasons\": [\"saison1\", \"saison2\"], \"ingredients\": [ {\"name\":\"ingrédient1\",  \"quantityWithUnit\":\"x grammes\"}, {\"name\":\"ingrédient2\",  \"quantityWithUnit\":\"y litres\"}], \"price\": \"4.75\", \"currency\": \"euros\", \"prepDuration\": 15, \"totalDuration\": 240, \"recipeDescription\": { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"introduction\": \"recipe high level description\", \"steps\": [ \"text for step 1\", \"text for step 2\", ] } }")
            //let response = processPrompt(prompt: "Donne moi les informations suivantes pour réaliser la recette de \(mealsNameList[i]) :  - id: l'identifiant de la recette - seasons : saison(s) pour laquelle la recette est adaptée (les valeurs possibles sont \"Summer\", \"Spring\", \"Winter\", \"Autumn\")  - ingredients : liste des ingrédients et quantité nécessaire pour \(currentUser.numberOfPerson) personnes - price : prix indicatif pour l\"ensemble des ingrédients (sans avoir le détail par ingrédient) - prepDuration : durée de préparation - totalDuration : durée totale - type : le type de repas  (les valeurs possibles sont \"main course\", \"breakfast\", \"dessert\", \"starter\") - recipe : description textuelle de la recette. Formate le résultat de la manière suivante : { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"recipeName\":\"\(mealsNameList[i])\", \"numberOfPersons\":3, \"mealType\":\"\(mealType)\", \"seasons\": [\"saison1\", \"saison2\"], \"ingredients\": [ {\"name\":\"ingrédient1\",  \"quantityWithUnit\":\"x grammes\"}, {\"name\":\"ingrédient2\",  \"quantityWithUnit\":\"y litres\"}], \"price\": \"4.75\", \"currency\": \"euros\", \"prepDuration\": 15, \"totalDuration\": 240, \"recipeDescription\": { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"introduction\": \"recipe high level description\", \"steps\": [ \"text for step 1\", \"text for step 2\", ] } }")
        
        //let response = processPrompt(prompt: "Donne moi les informations suivantes pour réaliser la recette de \(mealsNameList[i]) :  - id: l'identifiant de la recette - seasons : saison(s) pour laquelle la recette est adaptée (les valeurs possibles sont \"Summer\", \"Spring\", \"Winter\", \"Autumn\")  - ingredients : liste des ingrédients et quantité nécessaire pour 4 personnes - price : prix indicatif pour l\"ensemble des ingrédients (sans avoir le détail par ingrédient) - prepDuration : durée de préparation - totalDuration : durée totale - type : le type de repas  (les valeurs possibles sont \"main course\", \"breakfast\", \"dessert\", \"starter\") - recipe : description textuelle de la recette. Formate le résultat de la manière suivante : { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"recipeName\":\"\(mealsNameList[i])\", \"numberOfPersons\":3, \"mealType\":\"\(mealType)\", \"seasons\": [\"saison1\", \"saison2\"], \"ingredients\": [ {\"name\":\"ingrédient1\",  \"quantityWithUnit\":\"x grammes\"}, {\"name\":\"ingrédient2\",  \"quantityWithUnit\":\"y litres\"}], \"price\": \"4.75\", \"currency\": \"euros\", \"prepDuration\": 15, \"totalDuration\": 240, \"recipeDescription\": { \"id\":\"\(Int(Date().timeIntervalSince1970))\", \"introduction\": \"recipe high level description\", \"steps\": [ \"text for step 1\", \"text for step 2\", ] } }")
        
            let formattedResponse: String = "\(response)"
            print("formattedResponse : \(formattedResponse)")
            
            let meal = BigModel.Meal(id: UUID().uuidString, recipe: self.jsonTest(jsonString: formattedResponse) )
            //?? BigModel.Recipe(id: "", recipeName: "gaga", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))))
            print("UUID = \(meal.id)")
            
            if (meal.recipe.recipeName != "err") && !isDisliked(mealName: meal.recipe.recipeName) && existeRepasAvecNom(nomRecherche: meal.recipe.recipeName) {
                 self.currentUserTags[meal] = false
                 self.currentUser.proposedMeals.append(meal)
                 self.storeCurrentUserInfoIntoDB(user: currentUser)
             }
             print(meal.recipe.recipeName)
            
        }
             
        DispatchQueue.main.async {
            self.isLoading = false
        }
        print("done")
        
    }
    
    func existeRepasAvecNom(nomRecherche: String) -> Bool {
        for repas in currentUser.proposedMeals {
            if repas.recipe.recipeName == nomRecherche {
                return true
            }
        }
        return false
    }
    
    
    func extractTextBetweenBraces(input: String) -> String {
        guard let firstOpenBraceRange = input.range(of: "{"),
              let lastCloseBraceRange = input.range(of: "}", options: .backwards),
              firstOpenBraceRange.upperBound < lastCloseBraceRange.lowerBound else {
            return ""
        }
        
        let startIndex = input.index(after: firstOpenBraceRange.lowerBound)
        let endIndex = input.index(before: lastCloseBraceRange.upperBound)
        
        return String(input[startIndex..<endIndex])
    }
    
    func isDisliked(mealName: String) -> Bool {
        // Parcourt la liste des repas
        for repasCourant in currentUser.dislikedMeals {
            // Vérifie si le nomRecherche correspond à l\"attribut "nom" de l\"objet Repas
            if repasCourant.recipe.recipeName == mealName {
                return true
            }
        }
        // Aucune correspondance trouvée
        return false
    }
    
    func updateList() async {
        // Modifiez votre liste ici comme vous le souhaitez
        print("à")
        //for i in 0...10 {
        let meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "Brandade", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))
            if meal.id != "" {
                do {
                    try await Task.sleep(nanoseconds: 1000000000)
                    self.testMealList.append(meal)
                }
                catch {
                    
                }
            }
        //}
        print("done")
    }
    
    func jsonTest(jsonString: String) -> Recipe {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                //print("jsonString [\(jsonString)]")
                let recipe = try JSONDecoder().decode(Recipe.self, from: jsonData)
                return recipe
            } catch {
                print("jsonString [\(jsonString)]")
                print("Erreur lors de la désérialisation JSON :", error)
                return BigModel.Recipe(id: "err", recipeName: "err", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))
            }
        } else {
            print("jsonString [\(jsonString)]")
            print("Erreur lors de la conversion de la chaîne en données JSON")
            return BigModel.Recipe(id: "err", recipeName: "err", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))
        }
    }
    
    func splitStringWithDash(inputString: String) -> [String] {
        let separatedStrings = inputString.components(separatedBy: " - ")
        return separatedStrings
    }
    
    func listToString(list: [Item]) -> String {
        var itemsString: String = ""
        for i in 0..<list.count {
            
            if list[i].seasons.contains(selectedSeason) {
                itemsString += "\(String(describing: list[i])), "
            }
            
        }
        return itemsString
    }
    
    func toolsStringList() -> String {
        var itemsString: String = ""
        for i in 0...(currentUser.tools.count) {
            itemsString += "\(String(describing: currentUser.tools[i].name)), "
        }
        return itemsString
    }
    
    //
    //
    //
    //MARK:
    //
    //
    //
    //
    
    var selectedTimeEpoch: Double = Date().timeIntervalSince1970
    var selectedMealType: String = ""
    
    func datesAreIdentical(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date2)
        
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day
    }
    
    let defaultEvent : Event = Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
    
    func addMealToCalendar(mealType: String, meal: Meal, dateTime: Double) {
        
        do {
            // Update the UserInfo inside the Firebase DB
            var user = currentUser
            guard let id = self.auth.currentUser?.uid else { return }
                                
            if let index = self.currentUser.events.firstIndex(where: { datesAreIdentical(date1: Date(timeIntervalSince1970: dateTime), date2: Date(timeIntervalSince1970: $0.timeEpoch) ) }) {
                            
                if mealType == "Breakfast" {
                    user.events[index].breakfastMeal = meal
                    self.currentUser.events[index].breakfastMeal = nil
                }
                if mealType == "Lunch" {
                    user.events[index].lunchMeal = meal
                    self.currentUser.events[index].lunchMeal = nil
                }
                if mealType == "Snack" {
                    user.events[index].snackMeal = meal
                    self.currentUser.events[index].snackMeal = nil
                }
                if mealType == "Dinner" {
                    user.events[index].dinnerMeal = meal
                    self.currentUser.events[index].dinnerMeal = nil
                }
                
            } else {
                
                if mealType == "Breakfast" {
                    user.events.append(Event(id: "\(dateTime)", timeEpoch: dateTime, breakfastMeal: meal))
                }
                if mealType == "Lunch" {
                    user.events.append(Event(id: "\(dateTime)", timeEpoch: dateTime, lunchMeal: meal))
                }
                if mealType == "Snack" {
                    user.events.append(Event(id: "\(dateTime)", timeEpoch: dateTime, snackMeal: meal))
                }
                if mealType == "Dinner" {
                    user.events.append(Event(id: "\(dateTime)", timeEpoch: dateTime, dinnerMeal: meal))
                }
                
            }
            
            let _ = try self.db.collection("Users").document(id).setData(from: user) { _ in
                
                let docRef = self.db.collection("Users").document(id)
                let newUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [])
                
                docRef.getDocument { (document, error) in
                    
                    if let document = document {
                        if document.exists {
                            do {
                                self.currentUser.firstName = ""
                                let user = try document.data(as: User.self)
                                self.currentUser = user
                                let tabElement = self.tabEventWithValue(selectedDate: Date(timeIntervalSince1970: dateTime))
                                
                                //tests pour savoir si le model a bien été updaté
                                
                                if mealType == "Breakfast" {
                                    if tabElement.breakfastMeal != nil {
                                        print("🧛🏼‍♀️")
                                        self.currentView = .DailyCalendar
                                    }
                                }
                                if mealType == "Lunch" {
                                    if tabElement.lunchMeal != nil {
                                        print("🧛🏼‍♀️")
                                        self.currentView = .DailyCalendar
                                    }
                                }
                                if mealType == "Snack" {
                                    if tabElement.snackMeal != nil {
                                        print("🧛🏼‍♀️")
                                        self.currentView = .DailyCalendar
                                    }
                                }
                                if mealType == "Dinner" {
                                    if tabElement.dinnerMeal != nil {
                                        print("🧛🏼‍♀️")
                                        self.currentView = .DailyCalendar
                                    }
                                }
                                
                                //print("Document data: \(String(describing: document.data()))")
                                
                            }
                            catch {
                                print(error.localizedDescription)
                            }
                        } else {
                            do {
                                let _ = try self.db.collection("Users").document(id).setData(from: newUser)
                            } catch {
                                
                            }
                        }
                    }
                }
                
            }
            // Refresh the BigModel from the DB
            
            print("done")
        } catch {
            print("ERR001[updateCurrentUserInfoInDB]=\(error)")
        }
        
    }
    
    @Published var isUserTryingAddNewMealToCalendar: Bool = false
    
    func tabEventWithValue(selectedDate: Date) -> BigModel.Event {
        
        if let index = self.currentUser.events.firstIndex(where: {
            
            datesAreIdentical(date1: Date(timeIntervalSince1970: self.selectedTimeEpoch), date2: Date(timeIntervalSince1970: $0.timeEpoch) )
            
        }) {
            return currentUser.events[index]
        } else {
            return BigModel.Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
        }
        
   }
    
    
    func removeMealFromEvent(mealType: String) {
        
        var user: User = currentUser
                
        if let index = self.currentUser.events.firstIndex(where: { datesAreIdentical(date1: Date(timeIntervalSince1970: self.selectedTimeEpoch), date2: Date(timeIntervalSince1970: $0.timeEpoch) ) }) {
                        
            if mealType == "Breakfast" {
                user.events[index].breakfastMeal = nil
            }
            if mealType == "Lunch" {
                user.events[index].lunchMeal = nil
            }
            if mealType == "Snack" {
                user.events[index].snackMeal = nil
            }
            if mealType == "Dinner" {
                user.events[index].dinnerMeal = nil
            }
            
        } else {
            
            
        }
        
        self.storeCurrentUserInfoIntoDB(user: user)
        
    }
    
    
    //
    //
    //
    //
    //
    
    init() {
        self.fetchItemsInfos()
    }
    
    init(shouldInjectMockedData: Bool) {
        self.currentUser = User(id: "ozeifjeiofejfoi", firstName: "", lastName: "",
                                items: [Item(id: 0, category: "legumes", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "fruits", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "strachyFoods", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "proteins", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "seasonning", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "allergies", name: "Poireaux", seasons: ["été"])],
                                tools: [Item(id: 0, category: "cookingTools", name: "Casserolle", seasons: ["été"])],
                                budget: 0, currency: "EUR", spendedTime: 0, numberOfPerson: 0,
                                proposedMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "001", recipeName: "Nb", numberOfPersons: 4, mealType: "Main course", seasons: ["Summer", "Spring"], ingredients: [Ingredient(name: "boeuf", quantityWithUnit: "400 grammes")], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                BigModel.Meal(id: "002222", recipe: Recipe(id: "022", recipeName: "Spaghetti à la bollo", numberOfPersons: 4, mealType: "Dessert", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                BigModel.Meal(id: "05394939459", recipe: Recipe(id: "033333", recipeName: "Tartiflette", numberOfPersons: 4, mealType: "Dessert", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                BigModel.Meal(id: "59T845958", recipe: Recipe(id: "UR339", recipeName: "Wok", numberOfPersons: 4, mealType: "Main course", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                BigModel.Meal(id: "DFORUER9UE", recipe: Recipe(id: "04859TIRF", recipeName: "Brocolli", numberOfPersons: 4, mealType: "Starter", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                BigModel.Meal(id: "IEFJEPFIO", recipe: Recipe(id: "SDOFUEF94", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Breakfast", seasons: ["Summer", "Spring"], ingredients: [Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes")], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"])))] ,
                                
                                favoriteMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "340958IOKRFD", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))),
                                                BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "EURF40ET0", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))),
                                                BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "UEFE04RT4EJOR¨F", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))) ],
                                
                                dislikedMeals: [], events: [])
        self.currentView = .UserView
    }
    
}

extension View {
    func getRootViewController () -> UIViewController {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
