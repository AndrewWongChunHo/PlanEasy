//
//  RobotSizeSelection.swift
//  PlanEasy
//
//  Created by Croquettebb on 23/4/2023.
//

import SwiftUI
import Firebase

struct RobotSizeSelection: View {
    @State var selectedSize: String = ""
    @State var imageSize: CGFloat
    @State private var navigateToMainPage = false
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack {
                    HStack {
                        Spacer()
                        Text("Select your skeleton size")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Button(action: {
                            selectedSize = "small"
                            imageSize = 350 // update image size
                        }) {
                            Text("Small")
                                .foregroundColor(selectedSize == "small" ? .white : .black)
                                .font(.title2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(selectedSize == "small" ? Color.blue : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedSize == "small" ? Color.clear : Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            selectedSize = "medium"
                            imageSize = 380 // update image size
                        }) {
                            Text("Medium")
                                .foregroundColor(selectedSize == "medium" ? .white : .black)
                                .font(.title2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(selectedSize == "medium" ? Color.blue : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedSize == "medium" ? Color.clear : Color.gray, lineWidth: 1)
                                )
                        }
                        
                        Button(action: {
                            selectedSize = "large"
                            imageSize = 420 // update image size
                        }) {
                            Text("Large")
                                .foregroundColor(selectedSize == "large" ? .white : .black)
                                .font(.title2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(selectedSize == "large" ? Color.blue : Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedSize == "large" ? Color.clear : Color.gray, lineWidth: 1)
                                )
                        }
                        
                    }
                        
                           Image("Robot")
                               .resizable()
                               .frame(width: imageSize, height: imageSize)
                               .padding(.top, 50)
                    
                    Spacer()
                    
                    Button(action: {
                        // Get the current user's ID
                        guard let userID = Auth.auth().currentUser?.uid else {
                            return
                        }
                        
                        // Save the user's selection to Firestore
                        let db = Firestore.firestore()
                        let preferencesRef = db.collection("user_preferences").document(userID)
                        preferencesRef.setData(["skeleton_size": selectedSize], merge: true) { error in
                            if let error = error {
                                print("Error saving user preferences: \(error.localizedDescription)")
                            } else {
                                print("User preferences saved successfully")
                                navigateToMainPage = true
                            }
                        }
                    }) {
                        Text("Save")
                            .font(.system(size: 20).bold())
                            .foregroundColor(.white)
                            .padding(.vertical,20)
                            .frame(maxWidth: 300)
                            .background(
                                Color("bottom")
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                            )
                    }
                    .padding(.bottom, 50)
                    .background(
                        NavigationLink(destination: MainPage().navigationBarBackButtonHidden(true), isActive: $navigateToMainPage) { EmptyView() }
                    )
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
                .background(Color("HomeBG").ignoresSafeArea())
            }
        }
    }
}

struct RobotSizeSelection_Previews: PreviewProvider {
    static var previews: some View {
        RobotSizeSelection(imageSize: 350)
    }
}
