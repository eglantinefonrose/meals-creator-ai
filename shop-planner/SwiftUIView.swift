//
//  SwiftUIView.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 04/03/2024.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section(header: Text("To buy")) {
                    ForEach(store.products) {
                      product in
                        HStack {
                          // 2:
                        Text(product.displayName)
                          Spacer()
                            // 3:
                          Button("(product.displayPrice)") {
                            // Here is going to be purchasing action...
                        }
                      }
                    }
                }
                
                //Button("Restore purchases") {
                //}
                
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(Store())
        }
    }
