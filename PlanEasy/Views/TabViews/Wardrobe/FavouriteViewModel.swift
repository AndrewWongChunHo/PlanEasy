//
//  FavouriteViewModel.swift
//  PlanEasy
//
//  Created by Croquettebb on 24/4/2023.
//

import Firebase
import SwiftUI

class FavouriteViewModel: ObservableObject {
    
    @Published var favouriteItems = [FavouriteItem]()
    

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    func fetchFavouriteItems() {
        listener = db.collection("favouriteItem").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching cart items: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.favouriteItems = documents.compactMap { queryDocumentSnapshot -> FavouriteItem? in
                            return try? queryDocumentSnapshot.data(as: FavouriteItem.self)
            }
        }
    }

    deinit {
        listener?.remove()
    }
    
    
    func removeFavItem(itemID: String) {
        // Get a reference to the document to be deleted
        let favItemRef = db.collection("favouriteItem").document(itemID)
        
        // Delete the document from Firestore
        favItemRef.delete { [self] error in
            if let error = error {
                print("Error deleting cart item: \(error.localizedDescription)")
            } else {
                // If the document is successfully deleted, remove the item from the local cart array
                if let index = self.favouriteItems.firstIndex(where: { $0.itemID == itemID }) {
                    favouriteItems.remove(at: index)
                }
            }
        }
    }
    
  }


struct FavouriteItem: Codable {
    let itemID: String
    let productImage: String
    let title: String
    let subtitle: String
    let price: Double
}
