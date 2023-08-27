//
//  PageModel.swift
//  PlanEasy
//
//  Created by Croquettebb on 17/4/2023.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var image: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", image: "short.sunny", tag: 0)
    
    static var Pages: [Page] = [
        Page(name: "Welcome to Default App!", description: "The best app to get stuff done on an app.", image: "short.thunder", tag: 0),
        Page(name: "Meet new people!", description: "The perfect place to meet new people so you can meet new people!", image: "short.drizzle", tag: 1),
        Page(name: "Edit your face", description: "Don't like your face? Well then edit your face with our edit-face tool!", image: "short.cloudy", tag: 2),
    ]
}
