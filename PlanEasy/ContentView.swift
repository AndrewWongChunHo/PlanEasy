//
//  ContentView.swift
//  PlanEasy
//
//  Created by SunnyHa on 25/1/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        MainControlView(imageSize: 250)
//        ARCharacterView()
    }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

