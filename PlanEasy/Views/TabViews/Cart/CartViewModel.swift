//
//  CartViewModel.swift
//  PlanEasy
//
//  Created by Croquettebb on 21/4/2023.
//

import Firebase
import MessageUI
import SwiftUI

class CartViewModel: NSObject, ObservableObject {
    
    @Published var numberOfItemsInCart = 0
    
    @Published var cartItems = [CartItem]()
    
    @Published var orderPlaced: Bool = false

    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    func fetchCartItems() {
        listener = db.collection("cart").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching cart items: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.numberOfItemsInCart = documents.count
            self.cartItems = documents.compactMap { queryDocumentSnapshot -> CartItem? in
                            return try? queryDocumentSnapshot.data(as: CartItem.self)
            }
        }
    }

    deinit {
        listener?.remove()
    }
    
    func updateCartItemQuantity(item: CartItem, quantity: Int) {
      
        let cartItemRef = db.collection("cart").document(item.itemID)
        
        cartItemRef.updateData(["quantity": quantity]) { error in
            if let error = error {
                print("Error updating cart item quantity: \(error.localizedDescription)")
            } else {
                print("Cart item quantity updated successfully!")
            }
        }
    }
    
    func removeCartItem(itemID: String) {
        // Get a reference to the document to be deleted
        let cartItemRef = db.collection("cart").document(itemID)
        
        // Delete the document from Firestore
        cartItemRef.delete { [self] error in
            if let error = error {
                print("Error deleting cart item: \(error.localizedDescription)")
            } else {
                // If the document is successfully deleted, remove the item from the local cart array
                if let index = self.cartItems.firstIndex(where: { $0.itemID == itemID }) {
                    cartItems.remove(at: index)
                }
            }
        }
    }
    
    func total() -> Double {
            return cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        }
    
    func sendOrderConfirmationEmail(orderID: String, to recipient: String) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }

        // Configure the mail composer
        let mailComposer = MFMailComposeViewController()
        mailComposer.setToRecipients([recipient])
        mailComposer.setSubject("Order Confirmation")

        // Query Firestore for the order details
        let db = Firestore.firestore()
        db.collection("orders").document(orderID).getDocument { (snapshot, error) in
            guard let snapshot = snapshot, let data = snapshot.data(),
                  let items = data["items"] as? [[String: Any]],
                  let timestamp = data["timestamp"] as? Timestamp,
                  let totalPrice = data["totalPrice"] as? Double else {
                return
            }
            
            // Create the email body
            var body = "Thank you for your order!\n\nOrder ID: \(orderID)\n\nItems ordered:\n\n"
            for item in items {
                if let title = item["title"] as? String,
                   let quantity = item["quantity"] as? Int,
                   let price = item["price"] as? Double {
                    body += "\(title) - \(quantity) x \(price)\n"
                }
            }
            body += "\nTotal: \(totalPrice)"

            mailComposer.setMessageBody(body, isHTML: false)
            mailComposer.mailComposeDelegate = self // Set the delegate to handle the email actions

            // Present the mail composer
            if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
                rootViewController.present(mailComposer, animated: true, completion: nil)
            }
        }
    }
    
    func placeOrder() {
          // Create a reference to the orders collection
          let ordersRef = db.collection("orders")

          // Get a new document ID for the order
          let orderID = ordersRef.document().documentID

          // Create an order object with information from the cart items
          var orderItems = [OrderItem]()
          var total = 0.0
          for item in cartItems {
              let orderItem = OrderItem(itemID: item.itemID, title: item.title, subtitle: item.subtitle, price: item.price, quantity: item.quantity)
              orderItems.append(orderItem)
              total += item.price * Double(item.quantity)
          }
         let order = Order(orderID: orderID, items: orderItems, totalPrice: total, timestamp: Date())

          // Add the order to Firestore
          do {
              try ordersRef.document(orderID).setData(from: order)
          } catch {
              print("Error adding order to Firestore: \(error.localizedDescription)")
              return
          }

          // Delete all cart items from Firestore
          for item in cartItems {
              let cartItemRef = db.collection("cart").document(item.itemID)
              cartItemRef.delete { error in
                  if let error = error {
                      print("Error deleting cart item: \(error.localizedDescription)")
                  } else {
                      print("Cart item successfully deleted")
                  }
              }
          }

          // Clear the cart items array
          cartItems = []

          // Set the orderPlaced flag to true
          orderPlaced = true
        
        sendOrderConfirmationEmail(orderID: orderID, to: Auth.auth().currentUser?.email ?? "123@gmail.com")
      }
    
    
  }



struct CartItem: Codable {
    let itemID: String
    let productImage: String
    let title: String
    let subtitle: String
    let price: Double
    var quantity: Int
}

struct OrderItem: Codable {
    let itemID: String
    let title: String
    let subtitle: String
    let price: Double
    let quantity: Int
}

struct Order: Codable {
    let orderID: String
    let items: [OrderItem]
    let totalPrice: Double
    let timestamp: Date
}

extension CartViewModel: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


