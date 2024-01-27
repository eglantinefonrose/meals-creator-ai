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
import FirebaseFirestore
import FirebaseFirestoreSwift
import AuthenticationServices
import Combine
import Alamofire
import KeychainAccess

class BigModel: ObservableObject {
    
    public static var shared = BigModel()
    public static var mocked: BigModel = BigModel(shouldInjectMockedData: true)
    
    @Published var currentView: ViewEnum = .signInView
    @Published var screenHistory: [ViewEnum] = []
    
    struct User: Identifiable, Codable {
        @DocumentID var id: String?
        var firstName: String
        var lastName: String
        var items: [Item]
        var tools: [Item]
        var budget: Int
        var spendedTime: Int
        var numberOfPerson: Int
        var proposedMeals: [Meal]
        var favoriteMeals: [Meal]
        var dislikedMeals: [Meal]
    }
    
    struct Recipe: Codable, Identifiable, Hashable, Comparable {
        
        static func < (lhs: BigModel.Recipe, rhs: BigModel.Recipe) -> Bool {
            lhs.recipeName < rhs.recipeName
        }
        
        static func == (lhs: BigModel.Recipe, rhs: BigModel.Recipe) -> Bool {
            lhs.recipeName < rhs.recipeName
        }
        
        var id: String
        var recipeName: String
        var numberOfPersons: Int
        var mealType: String
        var seasons: [String]
        var ingredients: [Ingredient]
        var price: Int
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
        let name: String
        let quantityWithUnit: String
    }

    struct RecipeDescription: Codable, Hashable {
        let introduction: String
        let steps: [String]
    }
    
    struct Item: Identifiable, Comparable, Hashable, Codable {
        static func < (lhs: Item, rhs: Item) -> Bool {
            lhs.name < rhs.name
        }
        
        var id: Int
        var category: String
        var name: String
        var seasons: [String]
    }
    
    struct Meal: Codable, Identifiable, Hashable, Comparable {
        
        static func < (lhs: BigModel.Meal, rhs: BigModel.Meal) -> Bool {
            lhs.recipe.recipeName < rhs.recipe.recipeName
        }
        
        static func == (lhs: BigModel.Meal, rhs: BigModel.Meal) -> Bool {
            lhs.recipe.recipeName < rhs.recipe.recipeName
        }
        
        var id: String
        var recipe: Recipe
        
    }
    
    struct ItemAndQtty: Codable, Identifiable, Hashable {
        var id: String
        var item: Item
        var quantity: Int
    }
    
    @Published var currentUser: User = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [])
    
    let items = [Item(id: 0, category: "legumes", name: "Carotte", seasons: ["été"]), Item(id: 1, category: "legumes", name: "Poireaux", seasons: ["automne", "été"]),Item(id: 2, category: "legumes", name: "Courgette", seasons: ["automne", "hiver"]),Item(id: 3, category: "legumes", name: "Aubergine", seasons: ["hiver"]),Item(id: 4, category: "legumes", name: "Brocolli", seasons: ["printemps"]),/*,Item(id: 5, category: "legumes", name: "Aubergine", seasons: ["été"]),Item(id: 6, category: "legumes", name: "Brocolli"),Item(id: 7, category: "legumes", name: "Aubergine"),Item(id: 8, category: "legumes", name: "Brocolli", seasons: []),Item(id: 9, category: "legumes", name: "Aubergine"),Item(id: 10, category: "legumes", name: "Brocolli"),*/
                 Item(id: 5, category: "fruits", name: "Pomme", seasons: ["printemps"]), Item(id: 6, category: "fruits", name: "Poire", seasons: ["automne"]),
                 Item(id: 7, category: "strachyFoods", name: "Riz", seasons: ["été", "automne", "hiver", "printemps"]), Item(id: 8, category: "strachyFoods", name: "Pates", seasons: ["été", "automne", "hiver", "printemps"]),
                 Item(id: 9, category: "allergies", name: "Carbohydrate", seasons: ["été","automne","hiver","printemps"]), Item(id: 10, category: "allergies", name: "Lactose", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 11, category: "proteins", name: "Boeuf", seasons: ["été","automne","hiver","printemps"]), Item(id: 12, category: "proteins", name: "Poisson", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 13, category: "seasonning", name: "curry", seasons: ["été","automne","hiver","printemps"]), Item(id: 14, category: "seasonning", name: "curcuma", seasons: ["été","automne","hiver","printemps"]),
                 Item(id: 15, category: "cookingTools", name: "Stove", seasons: ["été","automne","hiver","printemps"]), Item(id: 16, category: "cookingTools", name: "pan", seasons: ["été","automne","hiver","printemps"]), Item(id: 17, category: "cookingTools", name: "oven", seasons: ["été","automne","hiver","printemps"])
    ]
    
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
    
    /*func extractTagsPerCategorie(categorie: Categories) -> [Item:Bool] {
        var tags: [Item:Bool] = [:]
        for i in (0...self.items.count-1) {
            if items[i].category == categorie {
                tags[items[i]] = false
            }
        }
        return tags
    }*/
    
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
        
        for i in (0...(self.currentUser.items.count)-1) {
            if (self.currentUser.items.count) >= 1 {
                if self.currentUser.items[i].category == categorie {
                    itemList.append(self.currentUser.items[i])
                } else {
                    
                }
            } else {
                
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
        
        if categorie == "tools" {
            array = array + (currentUser.tools)
        } else {
            array = array + (currentUser.items)
        }
        
        return Array(Set(array))
    }
    
    func generateTags(type: String, season: String) -> [Meal: Bool] {
        var tagsDictionary = [Meal: Bool]()
        var meals: [Meal] = []
        let favoriteMeals = self.currentUser.favoriteMeals
        
        if type != "All" {
            for meal in currentUser.proposedMeals {
                if meal.recipe.mealType == type {
                    meals.append(meal)
                } else {}
            }
        } else {
            meals = currentUser.proposedMeals
        }
        
        if season != "All" {
            for meal in currentUser.proposedMeals {
                
                if meal.recipe.seasons.contains(season) {
                    
                    if meal.recipe.mealType == "All" {
                        meals.append(meal)
                    }
                    if meal.recipe.mealType == type {
                        meals.append(meal)
                    } else {}
                    
                } else {}
            }
        } else {
            meals = currentUser.proposedMeals
        }

        for meal in meals {
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
            self.currentUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [])
                        
            let docRef = self.db.collection("Users").document(id)

            docRef.getDocument { (document, error) in
                
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document, document.exists
                    {
                    do {
                        self.currentUser = try document.data(as: User.self)
                        self.currentView = .UserView
                        self.screenHistory.append(.signInView)
                        //print("Document data: \(String(describing: document.data()))")
                    }
                    catch {
                      print(error)
                    }
                  } else {
                      //self.currentUser = try document.data(as: User.self)
                      self.currentView = .UserView
                      self.screenHistory.append(.signInView)
                      /*do {
                          let newDocRef : DocumentReference = try self.db.collection("Users").addDocument(from: newUser)
                          newDocRef.getDocument { (document, error) in
                              if let error = error as NSError? {
                                  print("Error getting document: \(error.localizedDescription)")
                              }
                              else {
                                  if let document = document {
                                      do {
                                          self.currentUser = try document.data(as: User.self)
                                          self.currentView = .UserView
                                          self.screenHistory.append(.signInView)
                                          //print("Document data: \(String(describing: document.data()))")
                                      }
                                      catch {
                                        print(error)
                                      }
                                  }
                              }
                          }
                      }
                      catch {
                          print(error)
                      }*/
                  }
                }
            }
            
        }
    }
    
    func fetchUserInfoFromDB() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [])
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        self.currentUser.firstName = ""
                        let user = try document.data(as: User.self)
                        self.currentUser = user
                        
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
    
    func googleSignInUserUpdate() {
        
        guard let id = self.auth.currentUser?.uid else { return }
        let docRef = self.db.collection("Users").document(id)
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [])
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
                        let user = try document.data(as: User.self)
                        self.currentUser = user
                        self.currentView = .UserView
                        self.screenHistory.append(.signInView)
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
    
    func storeCurrentUserInfoIntoDB(user: User, completion: @escaping () -> Void) {
                
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
            let mealsList = removeMealFromLikedMeals()
            user.proposedMeals = mealsList
            let _ = try self.db.collection("Users").document(id).setData(from: user) { _ in
                
                let docRef = self.db.collection("Users").document(id)
                let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, numberOfPerson: 0, proposedMeals: [], favoriteMeals: [], dislikedMeals: [])
                
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
    
    private func removeMealFromLikedMeals() -> [BigModel.Meal] {
        
        //var newMealsList = mealsList
        var mealsList = currentUser.proposedMeals
        let meal = dislikedMeal
        
        if let index = mealsList.firstIndex(where: { $0.id == meal.id }) {
            mealsList.remove(at: index)
            print("Element retiré avec succès")
            return mealsList
        } else {
            print("Element non trouvé dans la liste")
            return mealsList
        }
        
    }
    
    @Published var dislikedMeal: Meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))
    
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
        let user = User(id: id, firstName: firstName, lastName: lastName, items: self.currentUser.items, tools: [], budget: self.currentUser.budget, spendedTime: self.currentUser.spendedTime, numberOfPerson: 0, proposedMeals: self.currentUser.proposedMeals, favoriteMeals: self.currentUser.favoriteMeals, dislikedMeals: self.currentUser.dislikedMeals)
        
        docRef.getDocument { (document, error) in
            do {
                let _ = try self.db.collection("Users").document(id).setData(from: user)
            } catch {
                
            }
        }
        
    }
        
    /*struct APIResponse: Decodable {
        let id: String?
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]
        let usage: Usage
    }
    
    struct Choice: Decodable {
        let index: Int
        let message: Message
        let finish_reason: String
    }
    
    struct Message: Codable {
        let role: Role
        let content: String
    }
    
    enum Role: String, Codable {
        case system
        case user
        case assistant
        case function
    }
    
    struct Usage: Decodable {
        let prompt_tokens: Int
        let completion_tokens: Int
        let total_tokens: Int
    }
    
    struct APIRequest: Encodable {
        let model: Model
        let messages: [Message]
    }
    
    enum Model: String, Codable {
        case gpt_3_5_turbo = "gpt-3.5-turbo"
    }
    
    @State private var prompt: String = ""
    @State private var resultText: String = ""
    @State private var cancellable: AnyCancellable?
    @State private var messages: [Message] = []*/
    
    /*func submit() {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return
        }
     
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
        messages.append(Message(role: .user, content: prompt))
     
        do {
            let payload = APIRequest(model: .gpt_3_5_turbo, messages: messages)
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
        } catch {
            print("Error: \(error)")
        }
     
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.resultText = "Error: \(error.localizedDescription)"
                    case .finished:
                        break
                    }
                },
                receiveValue: { response in
                    self.resultText = response.choices.first?.message.content ?? "No response"
                    self.messages.append(Message(role: .assistant, content: self.resultText))
                    print("messages : \(self.messages)")
                    self.prompt = ""
                }
            )
    }*/
    
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
            request.addValue("Bearer \(self.openAIKey)", forHTTPHeaderField: "Authorization")
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
                    let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    ///
                    //MARK: I know there's an error below, but we'll fix it later on in the article, so make sure not to change anything
                    ///
                    let responseHandler = OpenAIResponseHandler()
                    
                    print("jsonStr : [\(jsonStr)]")
                    let jsonString = (responseHandler.decodeJson(jsonString: jsonStr)!.choices[0].text)
                    
                    return (jsonString)
                    
                }
            } catch {
                print(error)
            }
        
        return("error")
            
        }
    
    func createMealsNameList(mealType: String) -> [String] {
        
        //let prompt1 = "Voici mon modèle d'ingredients en swift : struct Item: Identifiable, Comparable, Hashable, Codable { var id: Int var category: String var name: String var seasons: [String] }. Voici mon modèle d'ItemAndQtty en swift : struct ItemAndQtty: Codable, Identifiable { var id: String var item: Item var quantity: Int } Le type Categories est une enum : enum Categories: CaseIterable, Codable { case legumes, fruits, strachyFoods, proteins, seasonning, allergies, cookingTools }. La variable 'category' doit être écrit de la forme .nomdelacategorie. Voici mon modèle de menu en swift : struct Meal: Codable, Identifiable { var id: String var name: String var type: String = \(mealType) var season: String = \(selectedSeason) var itemsAndQ: [ItemAndQtty] var price: Int var spendedTime: Int var recipe: String }. Peux tu me donner la recette de "
        //var meals: [Meal] = []
        var mealsNameList: [String] = []
        
        let response = processPrompt(prompt: "Peux tu me proposer une liste de 5 plats de type \(mealType) d'\(selectedSeason) pour une personne qui aime \(listToString(list: self.currentUser.items)) et qui a \(listToString(list: self.currentUser.tools)). Cette personne a un budget de \(currentUser.budget), veut y consacrer maximum \(currentUser.spendedTime) et pour \(currentUser.numberOfPerson). Donne moi une réponse sans retour à la ligne, en séparant uniquement les différents plats par des tirest (par exemple : \"Rillettes de thon - Brandade de morue - Spaghettis à la carbonnara\").")
        //Donne moi des meals avec des ID distincts et différents entre eux pour chaque meals.
        mealsNameList = splitStringWithDash(inputString: response)
        
        //let response2 = processPrompt(prompt: "\(prompt1) \(mealsNameList[0])")
        //print("response2 \(response2)")
        //meals.append(jsonTest(jsonString: response2) ?? Meal(id: "", name: "", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""))
        
        return mealsNameList
        
    }
    
    @Published var isLoading = false
    @Published var testMealList: [Meal] = [Meal(id: "", recipe: Recipe(id: "", recipeName: "", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))]
    @Published var selectedMeal: Meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "gaga", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))
    @Published var selectedSeason: String = ""
    
    @Published var currentUserTags: [Meal: Bool] = [:]
    @Published var didPreferencesChanged: Bool = false
    
    func createMeals(mealType: String) async {
        
        /*var id: Int
         var category: String
         var name: String
         var seasons: [String]*/
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        let prompt1 = "Voici mon modèle d'ingredients en swift : struct Item: Identifiable, Comparable, Hashable, Codable { var id: Int var category: Categories var name: String var seasons: [String] }. La variable seasons peut prendre uniquement les 4 valeurs suivantes : 'Été', 'Automne', 'Hiver', 'Printemps'. Voici mon modèle d'ItemAndQtty en swift : struct ItemAndQtty: Codable, Identifiable { var id: String var item: Item var quantity: Int } La variable categorie peut prendre seulement ces valeurs : 'legumes', 'fruits', 'strachyFoods', 'proteins', 'seasonning', 'allergies', 'cookingTools' }. Voici mon modèle de menu en swift : struct Meal: Codable, Identifiable { var id: String var name: String var type: String = \(mealType) var seasons = ['été'] var itemsAndQ: [ItemAndQtty] var price: Int var spendedTime: Int var recipe: String }. Peux tu me donner l'objet de type Meal correspondant à "
        let mealsNameList: [String] = createMealsNameList(mealType: mealType)
        currentUserTags = [:]
        
        /*var user = currentUser
        user?.proposedMeals = []
        user?.favoriteMeals = []
        if self.currentUser != nil {
            self.updateCurrentUserInfoInDB(user: user ?? User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: []))
        }*/
        
        print("mealsNameList.count \(mealsNameList.count)")
        print(mealsNameList)
        
        for i in 0..<mealsNameList.count {
         let response = processPrompt(prompt: "\(prompt1) \(mealsNameList[i]) en utilisant le modèle de menus que je t'ai donné et en renvoyant une réponse au format JSON et en écrivant les recipes sans mettre de retour à la ligne et donnant des id unique et distincts constitués de minimum 20 caractères et contenant au moins une majuscule en utilisant uniquement des caractères utf8, un chiffre et un caractère spécial à chaque menus crées ? La valeur de season de l'objet de type Meal sera 'été'. Donne moi UNIQUEMENT la réponse au format JSON, sans texte autour. Pour les ID des items, il faut qu'ils soient constitués de chiffres et de lettres mais jamais uniquement de + de 10 chiffres")
            let formattedResponse: String = "{ \(response) }"
        print("formattedResponse : [\(extractTextBetweenBraces(input: formattedResponse))]")
        let meal = self.jsonTest(jsonString: formattedResponse) ?? Meal(id: "", recipe: Recipe(id: "", recipeName: "gaga", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))
            if meal.id != "dd" && !isDisliked(mealName: meal.recipe.recipeName) {
             self.currentUserTags[meal] = false
             self.currentUser.proposedMeals.append(meal)
             self.storeCurrentUserInfoIntoDB(user: currentUser) {}
         }
         print(meal.recipe.recipeName)
            
        }
             
        DispatchQueue.main.async {
            self.isLoading = false
        }
        print("done")
        
    }
    
    func createCatObject(name: String, colour: String, age: Int) {
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-0613",
            "messages": [
                [
                    "role": "user",
                    "content": "Create a new Meal object for the meal 'Brandade de morue'."
                ]
            ],
            "functions": [
                [
                    "name": "createCatObject",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "id": ["type": "string"],
                            "name": ["type": "string"],
                            "type": ["type": "string"],
                            "seasosn": ["type": "[string]"],
                            "itemsAndQ": ["type": "  "],
                            "name": ["type": "string"],
                            "name": ["type": "string"],
                        ],
                        "required": ["name", "colour", "age"]
                    ]
                ]
            ],
            "function_call": ["name": "createCatObject"]
        ]
        
        AF.request("https://api.openai.com/v1/engines/davinci/completions", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Authorization": "Bearer YOUR_API_KEY"])
            .validate()
            .responseDecodable(of: Meal.self) { response in
                guard let cat = response.value else {
                    print("Error: \(String(describing: response.error))")
                    return
                }
                print("Created Cat object: \(cat)")
            }
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
            // Vérifie si le nomRecherche correspond à l'attribut "nom" de l'objet Repas
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
        let meal = Meal(id: "", recipe: Recipe(id: "", recipeName: "Brandade", numberOfPersons: 0, mealType: "", seasons: [], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))
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
    
    func jsonTest(jsonString: String) -> Meal? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                print("jsonString [\(jsonString)]")
                let meal = try JSONDecoder().decode(Meal.self, from: jsonData)
                return meal
            } catch {
                print(jsonString)
                print("Erreur lors de la désérialisation JSON :", error)
                return nil
            }
        } else {
            print(jsonString)
            print("Erreur lors de la conversion de la chaîne en données JSON")
            return nil
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
    //
    //
    
    init() {
        
    }
    
    init(shouldInjectMockedData: Bool) {
        self.currentUser = User(firstName: "", lastName: "",
                                items: [Item(id: 0, category: "legumes", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "fruits", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "strachyFoods", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "proteins", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "seasonning", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "allergies", name: "Poireaux", seasons: ["été"]),
                                        Item(id: 0, category: "cookingTools", name: "Poireaux", seasons: ["été"])],
                                tools: [Item(id: 0, category: "Tools", name: "Casserolle", seasons: ["été"])],
                                budget: 0, spendedTime: 0, numberOfPerson: 0,
                                proposedMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "dfkljfrjf", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "002222", recipe: Recipe(id: "002222", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "05394939459", recipe: Recipe(id: "05394939459", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "59T845958", recipe: Recipe(id: "59T845958", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "DFORUER9UE", recipe: Recipe(id: "DFORUER9UE", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "IEFJEPFIO", recipe: Recipe(id: "IEFJEPFIO", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: [])))] ,
                                
                                favoriteMeals: [BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "efioejfifj", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "efioejfifj", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))),
                                                BigModel.Meal(id: "dfkljfrjf", recipe: Recipe(id: "efioejfifj", recipeName: "Spaghetti à la carbo", numberOfPersons: 4, mealType: "Dîner", seasons: ["été", "printemps"], ingredients: [], price: 0, prepDuration: 0, totalDuration: 0, recipeDescription: RecipeDescription(introduction: "", steps: []))) ],
                                
                                dislikedMeals: [])
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
