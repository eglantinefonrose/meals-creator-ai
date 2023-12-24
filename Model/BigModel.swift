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
    
    public static var shared = BigModel(shouldInjectMockedData: true)
    
    @Published var currentView: ViewEnum = .signInView
    @Published var screenHistory: [ViewEnum] = []
    
    struct User: Identifiable, Codable {
        var id: String
        var firstName: String
        var lastName: String
        var items: [Item]
        var tools: [Item]
        var budget: Int
        var spendedTime: Int
        var proposedMeals: [Meal]
        var favoriteMeals: [Meal]
    }
    
    struct Item: Identifiable, Comparable, Hashable, Codable {
        
        static func < (lhs: Item, rhs: Item) -> Bool {
            lhs.name < rhs.name
        }
        
        var id: Int
        var category: String
        var name: String
    }
    
    struct Meal: Codable, Identifiable, Hashable, Comparable {
        
        static func < (lhs: Meal, rhs: Meal) -> Bool {
            lhs.name < rhs.name
        }
        
        var id: String
        var name: String
        var itemsAndQ: [ItemAndQtty]
        var price: Float
        var spendedTime: Int
        var recipe: String
        
    }
    
    struct ItemAndQtty: Codable, Identifiable, Hashable {
        var id: String
        var item: Item
        var quantity: Int
    }
            
    
    @Published var currentUser: User?
    
    let items = [Item(id: 0, category: "legumes", name: "Carotte"), Item(id: 1, category: "legumes", name: "Poireaux"),Item(id: 2, category: "legumes", name: "Courgette"),Item(id: 3, category: "legumes", name: "Aubergine"),Item(id: 4, category: "legumes", name: "Brocolli"),
                 Item(id: 5, category: "fruits", name: "Pomme"), Item(id: 6, category: "fruits", name: "Poire"),
                 Item(id: 7, category: "strachyFoods", name: "Riz"), Item(id: 8, category: "strachyFoods", name: "Pates"),
                 Item(id: 9, category: "allergies", name: "Carbohydrate"), Item(id: 10, category: "allergies", name: "Lactose"),
                 Item(id: 11, category: "proteins", name: "Boeuf"), Item(id: 12, category: "proteins", name: "Poisson"),
                 Item(id: 13, category: "seasonning", name: "curry"), Item(id: 14, category: "seasonning", name: "curcuma"),
                 Item(id: 15, category: "cookingTools", name: "Stove"), Item(id: 16, category: "cookingTools", name: "pan"), Item(id: 17, category: "cookingTools", name: "oven")
    ]
    
    func isInTheList(item: Item) -> Bool {
        
        if (self.currentUser?.items.count) != 0 {
            for i in (0...(self.currentUser?.items.count ?? 0)-1) {
                if currentUser?.items[i].id == item.id {
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
        let list1 = currentUser?.items ?? []
        
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
    
    func extractItemsPerCategorie(categorie: String) -> [Item] {
        var itemList: [Item] = []
        
        for i in (0...(self.currentUser?.items.count ?? 0)-1) {
            if (self.currentUser?.items.count ?? 0) > 1 {
                if self.currentUser?.items[i].category == categorie {
                    itemList.append(self.currentUser?.items[i] ?? Item(id: 0, category: "legumes", name: ""))
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
            array = array + (currentUser?.tools ?? [])
        } else {
            array = array + (currentUser?.items ?? [])
        }
        
        return Array(Set(array))
    }
    
    func generateTags() -> [Meal: Bool] {
        var tagsDictionary = [Meal: Bool]()
        let meals = self.currentUser?.proposedMeals ?? []
        let favoriteMeals = self.currentUser?.favoriteMeals ?? []

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
            self.currentUser = User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: [])
            
            let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: [])
            
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
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: [])
        
        docRef.getDocument { (document, error) in
            
            if let document = document {
                if document.exists {
                    do {
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
        let newUser = User(id: id, firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: [])
        
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
    
    func storeCurrentUserInfoIntoDB(user: User) {
                
        if currentUser != nil {
            do {
                // Update the UserInfo inside the Firebase DB
                let _currentUser: User = currentUser!
                let currentUserId: String = _currentUser.id
                let _ = try self.db.collection("Users").document(currentUserId).setData(from: user)
                // Refresh the BigModel from the DB
                fetchUserInfoFromDB()
            } catch {
                print("ERR001[updateCurrentUserInfoInDB]=\(error)")
            }
        } else {
            print("ERR002[updateCurrentUserInfoInDB]=No currentUser")
        }
        
    }
    
    func removeMealFromFavouriteMeals(meal: Meal, mealsList: [Meal]) -> [Meal] {
        
        var newMealsList = mealsList
        
        if let index = mealsList.firstIndex(where: { $0.id == meal.id }) {
            newMealsList.remove(at: index)
            return newMealsList
            print("Element retiré avec succès")
        } else {
            print("Element non trouvé dans la liste")
            return newMealsList
        }
    }
    
    func updateUserNames(firstName: String, lastName: String) {
        
        guard let id = self.currentUser?.id else { return }
        let docRef = self.db.collection("Users").document(id)
        let user = User(id: id, firstName: firstName, lastName: lastName, items: self.currentUser?.items ?? [], tools: [], budget: self.currentUser?.budget ?? 0, spendedTime: self.currentUser?.spendedTime ?? 0, proposedMeals: self.currentUser?.proposedMeals ?? [], favoriteMeals: self.currentUser?.favoriteMeals ?? [])
        
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
    
    let openAIURL = URL(string: "https://api.openai.com/v1/engines/text-davinci-003/completions")
    var openAIKey: String {
        return getSecretKey() ?? "nil"
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
         //       "temperature": String(temperature)
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
                    let jsonString = (responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].text)!
                    return (jsonString)
                    
                }
            } catch {
                print(error)
            }
        
        return("error")
            
        }
    
    func createMealsNameList() -> [String] {
        
        let prompt1 = "Voici mon modèle d'ingredients en swift : struct Item: Identifiable, Comparable, Hashable, Codable { var id: Int var category: Categories var name: String }. Voici mon modèle d'ItemAndQtty en swift : struct ItemAndQtty: Codable, Identifiable { var id: String var item: Item var quantity: Int } Le type Categories est une enum : enum Categories: CaseIterable, Codable { case legumes, fruits, strachyFoods, proteins, seasonning, allergies, cookingTools }. La variable 'category' doit être écrit de la forme .nomdelacategorie. Voici mon modèle de menu en swift : struct Meal: Codable, Identifiable { var id: String var name: String var itemsAndQ: [ItemAndQtty] var price: Int var spendedTime: Int var recipe: String }. Peux tu me donner la recette de "
        var meals: [Meal] = []
        var mealsNameList: [String] = []
        
        let response = processPrompt(prompt: "Peux tu me proposer une liste de 5 plats pour une personne qui aime \(listToString(list: self.currentUser?.items ?? [])) et qui a \(listToString(list: self.currentUser?.tools ?? [])). Donne moi des meals avec des ID distincts et différents entre eux pour chaque meals. Donne moi une réponse sans retour à la ligne, en séparant uniquement les différents plats par des tirest (ex: repas1 - repas2 - repas3 etc...).")
        mealsNameList = splitStringWithDash(inputString: response)
        
        //let response2 = processPrompt(prompt: "\(prompt1) \(mealsNameList[0])")
        //print("response2 \(response2)")
        //meals.append(jsonTest(jsonString: response2) ?? Meal(id: "", name: "", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""))
        
        return mealsNameList
        
    }
    
    @Published var isLoading = false
    @Published var testMealList: [Meal] = [Meal(id: "", name: "Brand", itemsAndQ: [], price: 0, spendedTime: 0, recipe: "0")]
    @Published var selectedMeal: Meal = Meal(id: "dd", name: "gagag", itemsAndQ: [ItemAndQtty(id: "e", item: Item(id: 88, category: "", name: "Carottes"), quantity: 200), ItemAndQtty(id: "e", item: Item(id: 5, category: "", name: "Carottes"), quantity: 200), ItemAndQtty(id: "e", item: Item(id: 0, category: "", name: "Carottes"), quantity: 200)], price: 0, spendedTime: 0, recipe: "")
    
    
    @Published var currentUserTags: [Meal: Bool] = [:]
    @Published var didPreferencesChanged = false
    
    func createMeals() async {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
            let prompt1 = "Voici mon modèle d'ingredients en swift : struct Item: Identifiable, Comparable, Hashable, Codable { var id: Int var category: Categories var name: String }. Voici mon modèle d'ItemAndQtty en swift : struct ItemAndQtty: Codable, Identifiable { var id: String var item: Item var quantity: Int } Le type Categories est une enum : enum Categories: CaseIterable, Codable { case legumes, fruits, strachyFoods, proteins, seasonning, allergies, cookingTools }. La variable 'category' doit être écrit de la forme .nomdelacategorie. Voici mon modèle de menu en swift : struct Meal: Codable, Identifiable { var id: String var name: String var itemsAndQ: [ItemAndQtty] var price: Int var spendedTime: Int var recipe: String }. Peux tu me donner la recette de "
            let mealsNameList: [String] = createMealsNameList()
            currentUserTags = [:]
            
            /*var user = currentUser
            user?.proposedMeals = []
            user?.favoriteMeals = []
            if self.currentUser != nil {
                self.updateCurrentUserInfoInDB(user: user ?? User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: []))
            }*/
        
        for i in 0..<mealsNameList.count {
            let response = processPrompt(prompt: "\(prompt1) \(mealsNameList[i]) en utilisant le modèle de menus que je t'ai donné et en renvoyant une réponse au format JSON et en écrivant les recipes sans mettre de retour à la ligne et donnant des id unique et distincts constitués de minimum 20 caractères et contenant au moins une majuscule en utilisant uniquement des caractères utf8, un chiffre et un caractère spécial à chaque menus crées ?")
                
            let meal = self.jsonTest(jsonString: response) ?? Meal(id: "dd", name: "gagag", itemsAndQ: [ItemAndQtty(id: "e", item: Item(id: 88, category: "", name: "Carottes"), quantity: 200), ItemAndQtty(id: "e", item: Item(id: 5, category: "", name: "Carottes"), quantity: 200), ItemAndQtty(id: "e", item: Item(id: 0, category: "", name: "Carottes"), quantity: 200)], price: 0, spendedTime: 0, recipe: "")
            if meal.id != "dd" {
                self.currentUserTags[meal] = false
                self.currentUser?.proposedMeals.append(meal)
                if currentUser != nil {
                    self.updateCurrentUserInfoInDB(user: currentUser ?? User(firstName: "", lastName: "", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [], favoriteMeals: []))
                }
                //print("append")
            }
            print(meal.name)
            
        }
             
        DispatchQueue.main.async {
            self.isLoading = false
        }
        print("done")
        
        
    }
    
    
    func updateList() async {
        // Modifiez votre liste ici comme vous le souhaitez
        print("à")
        //for i in 0...10 {
            let meal = Meal(id: "dd", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: "")
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
                print(jsonString)
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
    
    func listToString(list: Array<Any>) -> String {
        var itemsString: String = ""
        for i in 0..<list.count {
            itemsString += "\(String(describing: list[i])), "
        }
        return itemsString
    }
    
    func toolsStringList() -> String {
        var itemsString: String = ""
        for i in 0...(currentUser?.tools.count ?? 0) {
            itemsString += "\(String(describing: currentUser?.tools[i].name)), "
        }
        return itemsString
    }
    
    //
    //
    //
    //
    //
    
    init() {
        print("Constructor BigModel - default")
    }
    
    init(shouldInjectMockedData: Bool) {
        self.currentUser = User(firstName: "Malo", lastName: "Fonrose", items: [], tools: [], budget: 0, spendedTime: 0, proposedMeals: [BigModel.Meal(id: "ktuyffg", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""), BigModel.Meal(id: "yjfgj", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""), BigModel.Meal(id: "sdfgjvjkuhu", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""), BigModel.Meal(id: "lyughompij", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: ""), BigModel.Meal(id: "ttttt", name: "Brandade", itemsAndQ: [], price: 0, spendedTime: 0, recipe: "")], favoriteMeals: [])
        self.currentView = .signInView
    }
    
}

extension View {
    func getRootViewController () -> UIViewController {
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return.init()
        }
        return root
    }
}
