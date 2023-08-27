//
//  MyWardrobeContainer.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/2/2023.
//

import Foundation
import CoreData

class MyWardrobeContainer {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "WardrobeImageModel")
//        error handling
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
    
    
}
