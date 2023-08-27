//
//  FormType.swift
//  PlanEasy
//
//  Created by Croquettebb on 10/2/2023.
//

import SwiftUI

enum FormType: Identifiable, View {
    case new(UIImage)
    case update(MyWardrobe)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .update:
            return "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new(let uiImage):
            return ImageFormView(viewModel: FormViewModel(uiImage))
        case .update(let myImage):
            return ImageFormView(viewModel: FormViewModel(myImage))
        }
    }
}
