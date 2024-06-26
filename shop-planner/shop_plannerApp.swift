//
//  shop_plannerApp.swift
//  shop-planner
//
//  Created by Eglantine Fonrose on 26/11/2023.
//

import SwiftUI
import Firebase
import LocalAuthentication

@main
struct shop_plannerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            //ContentView()
            BigRootView(bigModel: BigModel.shared, mocked: false)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Gros Minet")
        FirebaseApp.configure()
        return true
    }
        
}
