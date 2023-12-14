//
//  ContentView.swift
//  MathbudTutorial
//
//  Created by David Bolis on 24/3/2023.
//

import SwiftUI
import KeychainAccess

struct APIView: View {
    @State var promttf = ""
    @State var degrees = 0.0
    let theopenaiclass = OpenAIConnector()
    @EnvironmentObject var bigModel: BigModel
    let string1 = "Peux tu me proposer une liste de plusieurs plats pour une personne qui aime les poivrons, le poulet, les aubergines, les carottes, le sel, le paprika et qui a un four et une poele. Donne moi une réponse sans retour à la ligne, en séparant uniquement les différents plats par des tirets."
    let jsonString = "\n\n{  \n\"id\": \"Em23i9f7AdmHSn3K\", \n\"name\": \"Rillette de thon\",\n\"price\": 6,\n\"spendedTime\": 15,\n\"recipe\": \"1. Mettre le thon dans un saladier et l\'écraser à l\'aide d\'une fourchette. 2. Ajouter l\'oignon finement émincé, le sel, le poivre, l\'huile d\'olive et mélanger jusqu\'à ce que le mélange soit homogène. 3. Faire fondre le beurre. 4. Ajouter le beurre à la préparation de thon et bien mélanger. 5. Servir et accompagner de mini toasts.\"\n}"
    
    var body: some View {
        VStack {
            Button(action:{
                
                //let response = bigModel.createMealsNameList()
                //print(bigModel.createMeals())
                
            }){
                Text("Answer Question")
            }
        }
        .padding()
        
    }
}
public class OpenAIConnector {
    
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

func jsonTest(jsonString: String) {
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            print(jsonString)
            let meal = try JSONDecoder().decode(String.self, from: jsonData)
            print(meal)
        } catch {
            print("Erreur lors de la désérialisation JSON :", error)
        }
    } else {
        print("Erreur lors de la conversion de la chaîne en données JSON")
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

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
        self.init(
            get: { source.wrappedValue ?? nilProxy },
            set: { newValue in
                if newValue == nilProxy {
                    source.wrappedValue = nil
                }
                else {
                    source.wrappedValue = newValue
                }
        })
    }
}
