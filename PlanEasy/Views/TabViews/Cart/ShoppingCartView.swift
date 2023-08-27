//
//  ShoppingCartView.swift
//  PlanEasy
//
//  Created by Croquettebb on 21/4/2023.
//

import SwiftUI
import Firebase

struct ShoppingCartView: View {
    
    @ObservedObject var cartViewModel = CartViewModel()
    @State private var isPlaceOrderSuccess = false
    @State private var showEmailView = false
    
    init(cartViewModel: CartViewModel) {
        self.cartViewModel = cartViewModel
        self.cartViewModel.fetchCartItems()
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 10){
                
                if isPlaceOrderSuccess {
                    Text("Ordered Successfully")
                        .font(.system(size: 28).bold())
                        .foregroundColor(.green)
                        .padding()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack{
                        
                        HStack{
                            
                            Text("Your Basket")
                                .font(.system(size: 28).bold())
                            
                            Spacer()
                            
                           
                        }
                        
                        // Checking if liked products are empty
                        if cartViewModel.cartItems.isEmpty{
                            
                            Group{
                                Image("empty_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .padding(.leading,30)
                                    .padding(.top,35)
                                    .frame(maxWidth: 300)
                                
                                Text("No Items added")
                                    .font(.system(size: 25))
                                    .fontWeight(.semibold)
                                
                                Text("Hit the plus button to save into basket.")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                                    .padding(.top,10)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        else{
                            
                            // Displaying Products
                            VStack(spacing: 15) {
                                ForEach(self.cartViewModel.cartItems, id: \.title) { item in
                                    CardItemView(image: item.productImage, title: item.title, subtitle: item.subtitle, quantity: item.quantity, id: item.itemID, cartItem: item)
                                }
                            }
                            .onAppear {
                                cartViewModel.fetchCartItems()
                            }
                            .padding(.top,25)
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
                // showinig Total and check out Button
                if !cartViewModel.cartItems.isEmpty{
                    
                    Group{
                        
                        HStack{
                            
                            Text("Total")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                            
                            Spacer()

                            let total = cartViewModel.total()
                            Text("Total: HKD $\(String(format: "%.2f", total))")
                                .font(.system(size: 18).bold())
                                .foregroundColor(Color("bottom"))
                        }
                        .padding(.horizontal,25)
                        
                        Button(action: {
                            cartViewModel.placeOrder()
                            self.isPlaceOrderSuccess = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.isPlaceOrderSuccess = false
                            }
                        }, label: {
                            Text("Place an order")
                                .font(.system(size: 20).bold())
                                .foregroundColor(.white)
                                .padding(.vertical,20)
                                .frame(maxWidth: .infinity)
                                .background(
                                
                                    Color("bottom")
                                        .cornerRadius(15)
                                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                                )
                        })
                        
                    }
                    .padding(.horizontal,25)
                }
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
            
                Color("HomeBG")
                    .ignoresSafeArea()
            )
        }
        
    }

    }
    
    struct ShoppingCartView_Previews: PreviewProvider {
        static var previews: some View {
            ShoppingCartView(cartViewModel: CartViewModel())
        }
    }
    
    struct CardItemView: View{
        
        @State var image: String
        @State var title: String
        @State var subtitle: String
        @State var quantity: Int
        @ObservedObject var cartViewModel = CartViewModel()
        var id: String
        var cartItem: CartItem
        
        var body: some View{
            
            
            HStack(spacing: 15){
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Text(title)
                            .font(.system(size: 18).bold())
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            cartViewModel.removeCartItem(itemID: id)
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        })
                        .padding(.trailing, 10)
                    }
                    
                    Text(subtitle)
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("bottom"))
                    
                    // Quantity Buttons
                    HStack(spacing: 10){
                        
                        Text("Quantity: ")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Button {
                            cartViewModel.updateCartItemQuantity(item: cartItem , quantity: quantity-1)
                            quantity = (quantity > 0 ? (quantity - 1) : 0)
                        } label: {
                            Image(systemName: "minus")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color("#9599E2"))
                                .cornerRadius(4)
                        }
                        
                        Text("\(quantity)")
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Button {
                            cartViewModel.updateCartItemQuantity(item: cartItem , quantity: quantity+1)
                            quantity += 1
                        } label: {
                            Image(systemName: "plus")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color("#9599E2"))
                                .cornerRadius(4)
                        }
                    }
                }
            }
            .padding(.horizontal,10)
            .padding(.vertical,10)
            .frame(maxWidth: .infinity,alignment: .leading)
            .background(
                
                Color.white
                    .cornerRadius(10)
            )
        }
    }
    
    
    

