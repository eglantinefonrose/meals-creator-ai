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
        var credits: Int
        var isUsingPersonnalKey: Bool
    }
    
    struct OpenAIResponseHandler {
        func decodeJson(jsonString: String) -> OpenAIResponse? {
            let json = jsonString.data(using: .utf8)!
            
            let decoder = JSONDecoder()
            do {
                let product = try decoder.decode(OpenAIResponse.self, from: json)
                
                return product
                
            } catch {
                print("Error decoding OpenAI API Response")
            }
            
            return nil
        }
    }
    
    struct OpenAIResponse: Codable{
        var id: String
        var object : String
        var created : Int
        var model : String
        var choices : [Choice]
    }
    
    struct Choice : Codable{
        var text : String
        var index : Int
        var logprobs: String?
        var finish_reason: String
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
        var prepDuration: String
        var totalDuration: String
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
    
    @Published var currentUser: User = User(id: "", firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func printHello() {
       
       do {
           
           let apiUrl = URL(string: "http://127.0.0.1:8080/hello")!

           // Création de la requête
           var request = URLRequest(url: apiUrl)
           request.httpMethod = "GET"

           // Création d'une tâche de session URLSession pour effectuer la requête
           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
               // Vérification des erreurs
               if let error = error {
                   print("Erreur lors de la requête : \(error.localizedDescription)")
                   return
               }
               
               // Vérification de la réponse HTTP
               guard let httpResponse = response as? HTTPURLResponse,
                     (200...299).contains(httpResponse.statusCode) else {
                   print("Réponse invalide du serveur")
                   return
               }
               
               // Vérification des données renvoyées
               guard let responseData = data,
                     let responseBody = String(data: responseData, encoding: .utf8) else {
                   print("Aucune donnée reçue ou impossible de la convertir en chaîne de caractères")
                   return
               }
               
               // Impression de la chaîne de caractères renvoyée par l'API
               print("Réponse de l'API : \(responseBody)")
           }

           // Lancement de la tâche
           task.resume()
           
       }

       // Démarrer la tâche
       
   }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
    // MARK: Fetch GCS items
    //
    //
    //
    
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
        
        let storageURL = URL(string: "https://firebasestorage.googleapis.com/v0/b/shop-planner-7533c.appspot.com/o/items-draw-ref.json?alt=media&token=ff88217e-4f0b-45b6-99f2-81324d6c4a15")!
        let task = URLSession.shared.dataTask(with: storageURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Une erreur est survenue : \(String(describing: error))")
                return
            }
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([String].self, from: data)
                
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
                
            } catch {
                //print("Une erreur est survenue lors de l'analyse JSON :  \(String(describing: error))")
            }
        }
        task.resume()
        
    }
    
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
            self.currentUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
                        
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
                        
                        if self.currentUser.isUsingPersonnalKey {
                            self.openAIKey = self.getSecretKey()!
                        }
                        
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
    
    func googleSignInUserUpdate() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        self.currentUser = user
                        self.currentView = .UserView
                        //self.screenHistory.append(.signInView)
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
    
    //
    //
    //
    // MARK: Infos fetching
    //
    //
    //
    
    
    func fetchUserInfoFromDB() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        self.currentUser = user
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
    
    //
    //
    //
    // MARK: Infos storing
    //
    //
    //
    
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
            
            if user.events.count != 0 {
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
            }
            
            user.proposedMeals = mealsList
            user.favoriteMeals = favoriteMealsList
            user.dislikedMeals.append(self.dislikedMeal)
            
            let _ = try self.db.collection("Users").document(id).setData(from: user) { _ in
                
                let docRef = self.db.collection("Users").document(id)
                let newUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
                
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
    
    private func removeMealFromList(mealsList: [Meal]) -> [BigModel.Meal] {
        
        var newMealsList = mealsList
        let meal = dislikedMeal
        var user = currentUser
        
        if let index = mealsList.firstIndex(where: { $0.id == meal.id }) {
            
            if user.events.count != 0 {
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
            }
            
            newMealsList.remove(at: index)
            print("Element retiré avec succès")
            return newMealsList
        } else {
            print("Element non trouvé dans la liste")
            return newMealsList
        }
        
    }
    
    @Published var dislikedMeal: Meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))
    
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
        let user = User(id: id, firstName: firstName, lastName: lastName, items: self.currentUser.items, tools: self.currentUser.tools, budget: self.currentUser.budget, currency: self.currentUser.currency, spendedTime: self.currentUser.spendedTime, numberOfPerson: 0, proposedMeals: self.currentUser.proposedMeals, favoriteMeals: self.currentUser.favoriteMeals, dislikedMeals: self.currentUser.dislikedMeals, events: self.currentUser.events, credits: 0, isUsingPersonnalKey: false)
        
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
    //MARK: Meals Generation
    //
    //
    //
    //
    //
    
    func getSecretKey() -> String?  {
        let keychain = Keychain(service: "net.proutechos.openai")
        let entry = keychain["key.teevity.dev001"]
        print("key : \(String(describing: entry))")
        
        return entry
    }
    
    let openAIURL = URL(string: "https://api.openai.com/v1/engines/gpt-3.5-turbo-instruct/completions")
    var openAIKey: String = ""
    
    func setSecretKey(secretKey: String) {
        let keychain = Keychain(service: "com.miamAI.openai")
        keychain["key.openai.miamAI"] = secretKey
    }
    
    
    func createMeal(mealType: String) {
        
        let apiUrl = URL(string: "http://127.0.0.1:8080/createMeal/currentUserID/\(String(describing: currentUser.id))/nbPersons/\(self.currentUser.numberOfPerson)/mealType/\(mealType)/ingredients/\(listToString(list: currentUser.items))/tools/\(listToString(list: currentUser.tools))")!
        
        let apiUrlWithPersonnalKey = URL(string: "http://127.0.0.1:8080/createMeal/\(openAIKey)/currentUserID/\(String(describing: currentUser.id))/nbPersons/\(self.currentUser.numberOfPerson)/mealType/\(mealType)/ingredients/\(listToString(list: currentUser.items))/tools/\(listToString(list: currentUser.tools))")!
        
        var request = URLRequest(url: self.currentUser.isUsingPersonnalKey ? apiUrlWithPersonnalKey : apiUrl)
        request.httpMethod = "GET"
        
        self.isLoading = true
        
        if (currentUser.credits > 0) {
            
            let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in

                DispatchQueue.main.async {

                    guard let responseData = data,
                    let responseBody = String(data: responseData, encoding: .utf8) else {
                    return
                    }

                    let recipe = self.jsonTest(jsonString: responseBody)

                    if recipe.id != "" {
                        let meal: Meal = Meal(id: UUID().uuidString, recipe: recipe)
                        self.currentUserTags[meal] = false
                        self.currentUser.proposedMeals.append(meal)
                        self.storeCurrentUserInfoIntoDB(user: self.currentUser)
                        
                        if !self.currentUser.isUsingPersonnalKey {
                            self.currentUser.credits-=1
                        }
                        
                    }

                    self.storeCurrentUserInfoIntoDB(user: self.currentUser)

                    self.isLoading = false
                }
                
            }
            
            task.resume()
        }
        
    }
    
    
    
    func capitalizeFirstLetter(input: String) -> String {
        guard let firstChar = input.first else {
            return input // Si la chaîne est vide, renvoie la même chaîne
        }
        return input.replacingCharacters(in: ..<input.index(after: input.startIndex), with: String(firstChar).capitalized)
    }
    

    enum APIError: Error {
        case decodingError
        case invalidStatusCode
    }


    
    @Published var isLoading = false
    @Published var testMealList: [Meal] = [Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))]
    @Published var selectedMeal: Meal = Meal(id: "erijorg", recipe: Recipe(id: "ijo", recipeName: "Riz au curry et aux crevettes", numberOfPersons: 0, mealType: "Main course", seasons: ["été", "hiver"], ingredients: [Ingredient(name: "curcuma", quantityWithUnit: "4 grammes"), Ingredient(name: "cura", quantityWithUnit: "4 grammes"), Ingredient(name: "possio", quantityWithUnit: "4 grammes"), Ingredient(name: "boeuf", quantityWithUnit: "4 grammes"), Ingredient(name: "zirojzr", quantityWithUnit: "4 grammes"), Ingredient(name: "hhhh", quantityWithUnit: "4 grammes")], price: "45", currency: "$", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "voici la recette", steps: ["erijofreogjrgpgrepg jr", "erijofrjnkl,lkeoif,ref ier gjrgpgrepg jr", "erijofhhhhhreoif,ref ier gjrgpgrepg jr", "erijofuihuihuireoif,ref ier gjrgpgrepg jr", "erijog jr"])))
    @Published var selectedSeason: String = ""
    
    @Published var currentUserTags: [Meal: Bool] = [:]
    @Published var currentUserFavMealTags: [Meal: Bool] = [:]
    @Published var didPreferencesChanged: Bool = false
        
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
        let meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "Brandade", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: [])))
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
                print(recipe.recipeName)
                return recipe
            } catch {
                //print("jsonString [\(jsonString)]")
                print("Erreur lors de la désérialisation JSON :", error)
                return BigModel.Recipe(id: "err", recipeName: "err", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))
            }
        } else {
            //print("jsonString [\(jsonString)]")
            print("Erreur lors de la conversion de la chaîne en données JSON")
            return BigModel.Recipe(id: "err", recipeName: "err", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))
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
        if currentUser.proposedMeals.count != 0 {
            for i in 0..<(currentUser.tools.count) {
                itemsString += "\(String(describing: currentUser.tools[i].name)), "
            }
        }
        return itemsString
    }
    
    func existingRecipes() -> String {
        var recipeString: String = ""
        
        if currentUser.proposedMeals.count != 0 {
            for i in 0..<(currentUser.proposedMeals.count) {
                recipeString += "\(String(describing: currentUser.proposedMeals[i].recipe.recipeName)), "
            }
        }
        
        return recipeString
    }
        
        //
        //
        //
        //MARK: CALENDAR
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
        
        let defaultEvent : Event = Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
        
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
                    let newUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, currency: "", spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
                    
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
                return BigModel.Event(id: "", timeEpoch: 0, breakfastMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), lunchMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), snackMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))), dinnerMeal: BigModel.Meal(id: "", recipe: BigModel.Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: BigModel.RecipeDescription(id: "", introduction: "", steps: []))))
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
            self.currentUser = User(id: "ozeifjeiofejfoi", firstName: "Mlo", lastName: "F",
                                    items: [Item(id: 0, category: "legumes", name: "Carotte", seasons: ["été"]),
                                            Item(id: 1, category: "legumes", name: "Poireaux", seasons: ["été"]),
                                            Item(id: 2, category: "legumes", name: "Courgette", seasons: ["été"]),
                                            Item(id: 3, category: "legumes", name: "Aubergine", seasons: ["été"]),
                                            Item(id: 4, category: "legumes", name: "Brocolli", seasons: ["été"]),
                                            Item(id: 5, category: "fruits", name: "Pomme", seasons: ["été"])],
                                    tools: [Item(id: 11, category: "cookingTools", name: "Casserolle", seasons: ["été"])],
                                    budget: 0, currency: "EUR", spendedTime: 0, numberOfPerson: 0,
                                    proposedMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "001", recipeName: "Nb", numberOfPersons: 4, mealType: "Main course", seasons: ["Summer", "Spring"], ingredients: [Ingredient(name: "boeuf", quantityWithUnit: "400 grammes")], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                    BigModel.Meal(id: "002222", recipe: Recipe(id: "022", recipeName: "Spaghetti à la bollo", numberOfPersons: 4, mealType: "Dessert", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                    BigModel.Meal(id: "05394939459", recipe: Recipe(id: "033333", recipeName: "Tartiflette", numberOfPersons: 4, mealType: "Dessert", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                    BigModel.Meal(id: "59T845958", recipe: Recipe(id: "UR339", recipeName: "Wok", numberOfPersons: 4, mealType: "Main course", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                    BigModel.Meal(id: "DFORUER9UE", recipe: Recipe(id: "04859TIRF", recipeName: "Brocolli", numberOfPersons: 4, mealType: "Starter", seasons: ["Summer", "Spring"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"]))),
                                                    BigModel.Meal(id: "IEFJEPFIO", recipe: Recipe(id: "SDOFUEF94", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Breakfast", seasons: ["Summer", "Spring"], ingredients: [Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes"), Ingredient(name: "poisson", quantityWithUnit: "4 têtes")], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: ["étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij", "étape1ejifeiofjezffij"])))] ,
                                    
                                    favoriteMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "340958IOKRFD", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))),
                                                    BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "EURF40ET0", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))),
                                                    BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "UEFE04RT4EJOR¨F", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: "", currency: "", prepDuration: "", totalDuration: "", recipeDescription: RecipeDescription(id: "", introduction: "", steps: []))) ],
                                    
                                    dislikedMeals: [], events: [], credits: 0, isUsingPersonnalKey: false)
            self.currentView = .UserView
        }
    
}

