//
//  OnboardingView.swift
//  PlanEasy
//
//  Created by Croquettebb on 14/2/2023.
//

import SwiftUI
import AVKit
import AVFoundation

struct OnboardingView: View {
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
                    
                    VStack(spacing: 40) {
                        
                        Image("onboarding")
                            .padding(.top, -200)
                        
                        NavigationLink(
                            destination: LoginView( show: .constant(true)).navigationBarBackButtonHidden(true),
                            label: {
                                Image("getStarted")
                                
                            })
                        
                    }
                    
                }
                
            }
            
            
        }

        

        
        
 
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

extension View{
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}
