//
//  ContentView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 10/12/2023.
//

import SwiftUI

class MyModel: ObservableObject {
    @Published var stringList: [String] = ["Item 1", "Item 2", "Item 3"]

    func updateList() {
        // Modifiez votre liste ici comme vous le souhaitez
        stringList.append("New Item")
    }
}

struct ContentView: View {
    @ObservedObject private var model = MyModel()

    var body: some View {
        NavigationView {
            VStack {
                List(model.stringList, id: \.self) { item in
                    Text(item)
                }
                .navigationBarTitle("String List")

                Button("Edit") {
                    model.updateList()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
