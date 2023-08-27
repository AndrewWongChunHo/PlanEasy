//
//  PageView.swift
//  PlanEasy
//
//  Created by Croquettebb on 17/4/2023.
//

import SwiftUI

struct PageView: View {
    var page: Page
    
    var body: some View {
        VStack(spacing: 10) {
            Image(page.image)
                .resizable()
                .scaledToFit()
                .padding()
                .cornerRadius(30)
                .cornerRadius(10)
                .padding()
            
            Text(page.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(page.description)
                .font(.subheadline)
                .frame(width: 300)
                .foregroundColor(.white)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(page: Page.samplePage)
    }
}
