//
//  PhotoEditorView.swift
//  PlanEasy
//
//  Created by Croquettebb on 2/5/2023.
//

import SwiftUI
import CZImageEditor
import LinkPresentation

struct PhotoEditView: View {
    @State private var image = UIImage(named: "logo")!
    @State private var showImagePicker = false
    @State private var showImageEditor = false
    @State private var savedImageEditorParameters = ImageEditorParameters()
    @State private var showAlert = false
    @State private var showShareSheet = false
    @State private var yourOwnFilters: [CIFilter] = [
        CIFilter(name: "CISepiaTone")!,
        CIFilter(name: "CIPhotoEffectNoir")!,
        CIFilter(name: "CIColorInvert")!,
        CIFilter(name: "CIColorMonochrome")!,
        CIFilter(name: "CIColorPosterize")!,
        CIFilter(name: "CIEdgeWork")!,
        CIFilter(name: "CISpotColor")!,
        CIFilter(name: "CIVibrance")!,
        CIFilter(name: "CIXRay")!,
        CIFilter(name: "CIPhotoEffectTransfer")!
    ]
    
    var body: some View {
        ZStack{
            VStack {
                
                HStack{
                    Text("Photo Editor")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        let imageSaver = ImageSaver()
                        imageSaver.writeToPhotoAlbum(image: image)
                        showAlert = true
                    }, label: {
                        Image(systemName: "square.and.arrow.down.fill")
                            .foregroundColor(.black)
                            .font(.title)
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Saved Successfully"))
                    }
                    
                }
                .padding()
                .padding(.top, 20)
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 450)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                Spacer()
                
                VStack{
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Select Image")
                            .padding(.horizontal, 20)
                            .foregroundColor(Color("bottom"))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 90)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 8)
                    
                    Text("Edit")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 155)
                        .padding(.vertical, 15)
                        .background(Color("bottom"))
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                        .onTapGesture {
                            showImageEditor = true
                        }
                
                }
                .padding(.bottom, 80)
 
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            .fullScreenCover(isPresented: $showImageEditor) {
                CZImageEditor(image: $image, parameters: $savedImageEditorParameters, filters: yourOwnFilters)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView(sourceType: .photoLibrary) { selectedImage in
                    image = selectedImage
                }
            }
        }
        .background(Color("HomeBG"))
    }
    
}
    
struct PhotoEditorView_Previews: PreviewProvider {
        static var previews: some View {
            PhotoEditView()
        }
    }




struct ImagePickerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Callback = (UIImage) -> Void

    var sourceType: UIImagePickerController.SourceType
    var onImageSelected: Callback

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = context.coordinator
        return imagePickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImageSelected: onImageSelected)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let onImageSelected: Callback

        init(onImageSelected: @escaping Callback) {
            self.onImageSelected = onImageSelected
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                onImageSelected(selectedImage)
            }
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct ShareButton: UIViewControllerRepresentable {
    
    let image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}




    
    





