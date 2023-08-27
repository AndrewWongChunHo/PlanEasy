//
//  OrderListView.swift
//  PlanEasy
//
//  Created by Croquettebb on 1/5/2023.
//

import SwiftUI
import Firebase

struct OrderListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var orders: [Order] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                   Button(action: {
                       presentationMode.wrappedValue.dismiss()
                   }, label: {
                       Image(systemName: "arrow.left")
                           .foregroundColor(.white)
                           .fontWeight(.bold)
                           .font(.title)
                   })
                   .padding(.leading, -80)
                    
                    Text("Order History")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                List(orders, id: \.orderID) { order in
                    NavigationLink(destination: OrderItemsView(order: order)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Order #" + order.orderID)
                                .font(.headline)
                            Text("HKD $\(Int(order.totalPrice))")
                            Text("\(order.timestamp)")
                                .foregroundColor(.gray).opacity(0.7)
                        }
                    }
                }
                .onAppear {
                    //Quote the reference
                    let ordersRef = Firestore.firestore().collection("orders")

                    // Listen for any changes in the orders collection
                    ordersRef.addSnapshotListener { querySnapshot, error in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching documents: \(error!)")
                            return
                        }
                        orders = documents.compactMap { queryDocumentSnapshot in
                            try? queryDocumentSnapshot.data(as: Order.self)
                        }
                    }
                }
            }
            .background(Color("bottom"))
        }
        
    }
}







struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
