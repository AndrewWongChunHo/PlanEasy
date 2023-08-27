//
//  SlidingScreenView.swift
//  PlanEasy
//
//  Created by Croquettebb on 17/4/2023.
//

import SwiftUI
import AVKit
import AVFoundation


struct SlidingScreenView: View {
    @State private var pageIndex = 0
    private let pages: [Page] = Page.Pages
    private let dotAppearance = UIPageControl.appearance()

    var body: some View {
        NavigationView {
          GeometryReader{ geo in
              ZStack {
                  PlayerView()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: geo.size.width, height: geo.size.height+100)
                      .overlay(Color.black.opacity(0.2))
                      .blur(radius: 1)
                      .edgesIgnoringSafeArea(.all)
                  VStack {
                      TabView(selection: $pageIndex) {
                          ForEach(pages) { page in
                              VStack {
                                  Spacer()
                                  PageView(page: page)
                                  Spacer()
                                  if page == pages.last {
                                      NavigationLink(destination: OnboardingView().navigationBarBackButtonHidden(true)) {
                                          Image("screenButton")
                                      } 
                                  } else {
                                      Button(action: {
                                          incrementPage()
                                      }) {
                                          Image("screenButton")
                                      }
                                  }
                                  Spacer()
                              }
                              .tag(page.tag)
                          }
                      }
                      .animation(.easeInOut, value: pageIndex)
                      .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                      .tabViewStyle(PageTabViewStyle())
                      .onAppear {
                          dotAppearance.currentPageIndicatorTintColor = .white
                          dotAppearance.pageIndicatorTintColor = .white
                      }
                  }
              }
            }
        }
    }

    func incrementPage() {
        pageIndex += 1
    }
}

struct SlidingScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingScreenView()
    }
}
