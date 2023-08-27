//
//  ProductDetailView.swift
//  PlanEasy
//
//  Created by Croquettebb on 20/4/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import Combine
import SceneKit


struct ProductDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var clothes: ClothesProduct
    
    let db = Firestore.firestore()
    
    @StateObject var cartItems = CartViewModel()
    
    @State private var showAlert = false
    
    @State private var isPresentingShoppingCartView = false
    
    @State private var isFavourite = true
    
    @State private var showARView = false
    
    @State var heartColor = Color.black.opacity(0.7)
    
    @State var descriptionText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    
    var body: some View {
        
        VStack{
            
            // Title Bar and Product Image
            VStack{
                
                // Title Bar
                HStack{
                    
                    Button{
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Button {
                        isPresentingShoppingCartView = true
                    } label: {
                        CartButtonView(numberOfItems: cartItems.numberOfItemsInCart)
                            .frame(width: 15, height: 22)
                            .padding()
                    }
                    .sheet(isPresented: $isPresentingShoppingCartView) {
                        ShoppingCartView(cartViewModel: CartViewModel())
                    }
                    
                    Button(action: {
                        let itemID = clothes.id!
                        let favItemRef = db.collection("favouriteItem").document(itemID)
                        if clothes.isFavourite {
                            // Remove the item from the "favouriteItem" collection if it already exists
                            favItemRef.delete()
                            clothes.isFavourite = false
                            heartColor = Color.black.opacity(0.7)
                            UserDefaults.standard.set(false, forKey: itemID) // Store the state of isFavourite as false
                        } else {
                            // Add the item to the "favouriteItem" collection if it doesn't already exist
                            let favItem = FavouriteItem(itemID: itemID, productImage: clothes.productImage, title: clothes.title, subtitle: clothes.subtitle, price: clothes.price ?? 0.0)
                            do {
                                try favItemRef.setData(from: favItem)
                                clothes.isFavourite = true
                                heartColor = Color.red
                                UserDefaults.standard.set(true, forKey: itemID) // Store the state of isFavourite as true
                            } catch {
                                print("Error adding item to cart: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Image(systemName: "heart.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .padding(.top, -4)
                            .foregroundColor(heartColor)
                            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: clothes.isFavourite)
                    }
                }
                .padding()
                .padding(.top, -50)
                
                // Product Image
                // Adding Matched Geometry Effect
//                Image(clothes.productImage)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .padding(.horizontal)
//                    .offset(y: -12)
//                    .frame(maxHeight: .infinity)
                
                LegacySceneView(scene: {
                    let scene = SCNScene(named: clothes.sceneKit)!
                                   scene.background.contents = UIColor.clear
                                   return scene
                               }(), options: [.autoenablesDefaultLighting,.allowsCameraControl]
                           )
                    .frame(width: 250 , height: 250)
                    .padding(.top, -30)
                    .background(Color.clear)
                
            }
            .frame(height: getRect().height / 2.7)
            .zIndex(1)
            
            // product Details
            ScrollView(.vertical, showsIndicators: false) {
                
                // Product Data
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack {
                        Text(clothes.title)
                            .font(.system(size: 20).bold())
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            showARView = true
                        }) {
                            Image(systemName: "camera.fill")
                        }
                        .foregroundColor(.black)
                        .sheet(isPresented: $showARView) {
                            ARCharacterView(cardStackData: CardStackData())
                                .navigationBarBackButtonHidden(true)
                        }
                        
                    }
                        
                        Text(clothes.subtitle)
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Text(descriptionText)
                            .font(.system(size: 16).bold())
                            .padding(.top)
                        
                        Button {
                            
                        } label: {
                            
                            // Since we need image at right
                            Label {
                                Image(systemName: "arrow.right")
                            } icon: {
                                Text("Full description")
                            }
                            .font(.system(size: 15).bold())
                            .foregroundColor(Color("Purple"))
                        }
                        
                    VStack{
                        HStack{
                            
                            Text("Total")
                                .font(.system(size: 17))
                            
                            Spacer()
                            
                            Text(String(format: "%.2f", clothes.price ?? 0.0))
                                .font(.system(size: 20).bold())
                                .foregroundColor(Color("bottom"))
                        }
                        .padding(.vertical,20)
                        
                        // Add to basket button
                        Button(action: {
                            let itemID = clothes.id!
                            let cartItemRef = db.collection("cart").document(itemID)
                            cartItemRef.getDocument { document, error in
                                if let document = document, document.exists {
                                    // If the item already exists in the cart, update the quantity
                                    let currentQuantity = document.data()?["quantity"] as? Int ?? 0
                                    cartItemRef.updateData(["quantity": currentQuantity + 1])
                                } else {
                                    // If the item doesn't exist in the cart, create a new cart item
                                    let cartItem = CartItem(itemID: itemID, productImage: clothes.productImage, title: clothes.title, subtitle: clothes.subtitle, price: clothes.price ?? 0.0, quantity: 1)
                                    do {
                                        try cartItemRef.setData(from: cartItem)
                                    } catch {
                                        print("Error adding item to cart: \(error.localizedDescription)")
                                    }
                                }
                                self.showAlert = true
                            }
                        }) {
                            Text("Add to Basket")
                                .font(.system(size: 20).bold())
                                .foregroundColor(.white)
                                .padding(.vertical,20)
                                .frame(maxWidth: .infinity)
                                .background(
                                    Color("bottom")
                                        .cornerRadius(15)
                                        .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                                )
                        }
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("Added to Cart"), dismissButton: .default(Text("Done")))
                        })
                     }
                    .padding(.top, -33)
                    }
                    .padding([.horizontal,.bottom],25)
                    .padding(.top,25)
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
                .onAppear{
                    cartItems.fetchCartItems()
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(
                    Color.white
                    // Corner Radius for only top side
                        .clipShape(CustomCorners(corners:[.topLeft,.topRight], radius: 25))
                        .ignoresSafeArea()
                )
                .zIndex(0)
            }
            .background(Color("HomeBG"))
        }
        
    }
    
    struct ProductDetailView_Previews: PreviewProvider {
        static var previews: some View {
            let clothesTest = ClothesProduct(id: "hi", title: "Ultra Light Down Jacket", subtitle: "Hi", price: 10.0, productImage: "c4", style: "Japanese Style", model: "", sceneKit: "character/Earth.usdz", type: "Today's Wearable")
            return
            NavigationView {
                ProductDetailView(clothes: clothesTest)
            }
            
        }
    }

struct LegacySceneView: UIViewRepresentable {
    var scene: SCNScene
    var options: SceneView.Options
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = UIColor.clear
        view.allowsCameraControl = options.contains(.allowsCameraControl)
        view.autoenablesDefaultLighting = options.contains(.autoenablesDefaultLighting)
        view.rendersContinuously = options.contains(.rendersContinuously)
        view.isJitteringEnabled = options.contains(.jitteringEnabled)
        view.isTemporalAntialiasingEnabled = options.contains(.temporalAntialiasingEnabled)
        view.scene = scene
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) { }
}
    

