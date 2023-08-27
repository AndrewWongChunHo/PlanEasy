//
//  WardrobeImagePicker.swift
//  PlanEasy
//
//  Created by Croquettebb on 9/2/2023.
//

import SwiftUI
import PhotosUI

@MainActor
class WardrobeImagePicker: ObservableObject {
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            Task {
                try await loadTransferable(from:imageSelection)
            }
        }
    }
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    self.uiImage = uiImage
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
