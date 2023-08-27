//
//  PlanEasyApp.swift
//  PlanEasy
//
//  Created by SunnyHa on 25/1/2023.
//

import SwiftUI
import Firebase

@main
struct PlanEasyApp: App {
    
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, MyWardrobeContainer().persistentContainer.viewContext)
                .onAppear {
                    print(URL.documentsDirectory.path)
                }
        }
    }
}
