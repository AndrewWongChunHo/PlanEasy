//
//  OrderItemsView.swift
//  PlanEasy
//
//  Created by Croquettebb on 2/5/2023.
//

import SwiftUI
import Firebase

struct OrderItemsView: View {
    let order: Order
    
    var body: some View {
        List(order.items, id: \.itemID) { item in
            HStack {
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text("HKD $\(Int(item.price))")
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("Quantity: \(item.quantity)")
            }
        }
        .navigationTitle("Order #\(order.orderID)")
    }
}



struct OrderItemsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
