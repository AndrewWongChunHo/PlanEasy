//
//  WardrobeView.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/2/2023.
//

import SwiftUI
import PhotosUI

struct WardrobeView: View {
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    private var myImages: FetchedResults<MyWardrobe>
    @StateObject private var imagePicker = WardrobeImagePicker()
    @Environment(\.presentationMode) var presentationMode
    @State private var formType: FormType?
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        ZStack {
            NavigationStack {
                Group{
                    if !myImages.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(myImages) { myImage in
                                    Button {
                                        formType = .update(myImage)
                                    } label: {
                                        VStack {
                                            Image(uiImage: myImage.uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipped()
                                                .shadow(radius: 5.0)
                                            Text(myImage.nameView)
                                                .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    } else {
                        Text("Select your clothes")
                    }
                }
                .navigationTitle("My Wardrobe")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        PhotosPicker("Add Clothes",
                                     selection: $imagePicker.imageSelection,
                                     matching: .images,
                                     photoLibrary: .shared())
                        .buttonStyle(.borderedProminent)
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.headline)
                                .foregroundColor(.black)
                        })
                    }
                }
                .onChange(of: imagePicker.uiImage) { newImage in
                    if let newImage {
                        formType = .new(newImage)
                    }
                }
                .sheet(item: $formType) { $0 }
            }
        }
        .background(Color("HomeBG"))
    }
}

struct MyImagesGridView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView()
    }
}
