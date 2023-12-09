//
//  MealsPropostion.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 29/11/2023.
//

import SwiftUI
import Combine

struct MealsPropostion: View {
    
    @EnvironmentObject var bigModel: BigModel
    //@State var chatMessages: [BigModel.ChatMessage] = []
    //@State var messageText: String = "Write a tag line for an ice cream shop"
    //@State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        
        VStack {
            
        }
        
    }
    
    /*func sendMessage() {
        let myMessage = BigModel.ChatMessage(
                id: UUID().uuidString,
                content: messageText,
                dateCreated: Date(),
                sender: .me
            )
            chatMessages.append(myMessage)

        bigModel.sendMessage(message: messageText).sink { completion in
                    // Handle error
                } receiveValue: { response in
                    guard
                        let textResponse = response.choices.first?.text
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                                    .union(.init(charactersIn: "\""))
                            )
                    else { return }
                    let gptMessage = BigModel.ChatMessage(
                        id: response.id,
                        content: textResponse,
                        dateCreated: Date(),
                        sender: .gpt
                    )
                    chatMessages.append(gptMessage)
                    print("gpt messages :")
                    print(gptMessage)
                }
                .store(in: &cancellables)
        
        }*/
    
}

struct MealsPropostion_Previews: PreviewProvider {
    static var previews: some View {
        MealsPropostion()
    }
}
