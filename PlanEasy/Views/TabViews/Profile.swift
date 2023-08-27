//
//  Profile.swift
//  PlanEasy
//
//  Created by SunnyHa on 28/3/2023.
//

import SwiftUI
import Firebase
import StoreKit

struct Profile: View {
    
    @State private var image: Image? = Image("logo")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @StateObject var storeVM = StoreVM()
    @State var isPurchase = false
    @State private var showARView = false
    
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack{
                    
                    Text("My Profile")
                        .font(.system(size: 28).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(spacing: 15){
                        
                        image!
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .offset(y: -30)
                            .padding(.bottom, -30)
                            .onTapGesture { self.shouldPresentActionScheet = true }
                            .sheet(isPresented: $shouldPresentImagePicker) {
                                SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, image: self.$image, isPresented: self.$shouldPresentImagePicker)
                        }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                            ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = true
                            }), ActionSheet.Button.default(Text("Photo Library"), action: {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = false
                            }), ActionSheet.Button.cancel()])
                        }
                        
                        if let email = Auth.auth().currentUser?.email{
                            Text(email)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            } else {
                                    Text("No user logged in")
                            }

                    }
                    .padding([.horizontal,.bottom])
                    .frame(maxWidth: .infinity)
                    .background(
                    
                        Color.white
                            .cornerRadius(12)
                    )
                    .padding(.top,40)
                    
                    // Custom navigation Link
                    
                    CustomNavigationLink(title: "Edit Profile") {
                        
                        Text("")
                            .navigationTitle("Edit Profile")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("HomeBG").ignoresSafeArea())
                    }
                    
                    //Try Clothes
                    NavigationLink(destination: TryOnView().navigationBarBackButtonHidden(true), label: {
                        
                        HStack{
                            
                            Text("Try AR Clothes")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            
                            Color.white
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        )
                        .padding(.top,12)
                        .frame(maxWidth: .infinity)
                        
                    })
                    
                    //Order History
                    
                    NavigationLink(destination: OrderListView().navigationBarBackButtonHidden(true), label: {
                        
                        HStack{
                            
                            Text("Order History")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            
                            Color.white
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        )
                        .padding(.top,12)
                        .frame(maxWidth: .infinity)
                        
                    })
                    
                    //Cards
                    
                    CustomNavigationLink(title: "Cards") {
                        
                        Text("")
                            .navigationTitle("Cards")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color("HomeBG").ignoresSafeArea())
                    }
                    
                    //Subscription
                    
                    NavigationLink(destination: WardrobeView().navigationBarBackButtonHidden(true), label: {
                        
                        HStack{
                            
                            Text("Personal Wardrobe")
                                .font(.system(size: 17))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.black)
                        .padding()
                        .background(
                            
                            Color.white
                                .cornerRadius(12)
                                .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        )
                        .padding(.top,12)
                        .frame(maxWidth: .infinity)
                        
                    })
                }
                .padding(.horizontal,22)
                .padding(.vertical,20)
                
                VStack{
                    
                    if storeVM.purchasedSubscription.isEmpty {
                        ForEach(storeVM.subscriptions) { product in
                            Button(action: {
                                Task {
                                    await buy(product: product)
                                }
                            }) {
                                
                                Text("Upgrade to Premium")
                                    .foregroundColor(.black)
                                    .padding(.vertical)
                                    .fontWeight(.bold)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                                
                            }
                            .background(Color.yellow)
                            .cornerRadius(10)
                            
                        }
                        
                    } else {
                        NavigationLink(destination: GPT3View().navigationBarBackButtonHidden(true)) {
                            Text("Styling Consultation")
                             .foregroundColor(.white)
                             .padding(.vertical)
                             .fontWeight(.bold)
                             .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            .background(Color("bottom"))
                            .cornerRadius(10)
                    }
                    
                    
                    Button(action: {
                        
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                        
                    }) {
                        
                        Text("Logout")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color.red)
                    .cornerRadius(10)
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
    
    func buy(product: StoreKit.Product) async {
        do {
            if try await storeVM.purchase(product) != nil {
                isPurchase = true
            }
        } catch {
            print("purchase failed")
        }
    }
    // Avoiding new Structs
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String,@ViewBuilder content: @escaping ()->Detail)-> some View{
        
        NavigationLink {
            content()
        } label: {
            
            HStack{
                
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(
            
                Color.white
                    .cornerRadius(12)
                    .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 2)
            )
            .padding(.top,12)
            .frame(maxWidth: .infinity)
        }
        
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile().environmentObject(StoreVM())
    }
}



