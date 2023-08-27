//
//  TryOnView.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/5/2023.
//

import SwiftUI

struct TryOnView: View {
    
    @Environment(\.presentationMode) var presentationMode

    
    var columns = [GridItem(.adaptive(minimum: 150), spacing: 20)]
    
    @State private var showARView = false
    
    var body: some View {
        
        
        NavigationView{
            
            VStack (spacing: 0){

                HStack {
                        
                    Button(action: {
                        withAnimation(.easeInOut){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                    Text("Try the clothes on")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity,alignment: .leading)

                    Spacer()
                    


                }
                .padding()
                
                ScrollView {
                    VStack{
                        LazyVGrid(columns: columns, spacing: 20) {
                            //1
                            Button(action: {
                                showARView = true
                            }, label: {
                                TryOnCard(image: "try1", name: "Clothes 1")
                            })
                            .sheet(isPresented: $showARView) {
                                ArForClothes1()
                            }
                            
                            //2
                            Button(action: {
                                showARView = true
                            }, label: {
                                TryOnCard(image: "try2", name: "Clothes 2")
                            })
                            .sheet(isPresented: $showARView) {
                                ArForClothes2()
                            }
                            
                            //3
                            Button(action: {
                                showARView = true
                            }, label: {
                                TryOnCard(image: "try1", name: "Clothes 3")
                            })
                            .sheet(isPresented: $showARView) {
                                ArForClothes3()
                            }
                            
                            //4
                            Button(action: {
                                showARView = true
                            }, label: {
                                TryOnCard(image: "try1", name: "Clothes 4")
                            })
                            .sheet(isPresented: $showARView) {
                                ArForClothes4()
                            }
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                }
               }
            
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
            .background(Color("HomeBG").ignoresSafeArea())
            .padding(.top, -150)
        }
        

    }
    

struct TryOnView_Previews: PreviewProvider {
    static var previews: some View {
        TryOnView()
    }
}
