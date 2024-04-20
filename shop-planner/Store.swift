//
//  Store.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 04/03/2024.
//

import StoreKit
// 2:
class Store: ObservableObject {
    // 3:
    private var productIDs = ["stone"]
    // 4:
    @Published var products = [Product]()
    // 5:
    init() {
        Task {
            await requestProducts()
        }
    }
    // 6:
    @MainActor
    func requestProducts() async {
        do {
            // 7:
            products = try await Product.products(for: productIDs)
        } catch {
            // 8:
            print(error)
    }
  }
}
