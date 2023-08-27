import SwiftUI
import LocalAuthentication

struct MainControlView: View {
    @State var show = false
//    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @AppStorage("status") var logged = false
    @State var imageSize: CGFloat
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if logged{
                    
                    RobotSizeSelection(imageSize: imageSize)
//                    WardrobeView()
                }
                else{
                    
                    ZStack{
                        
                        OnboardingView()
                        
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    logged = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct MainControlView_Previews: PreviewProvider {
    static var previews: some View {
            MainControlView(imageSize: 250)
        
    }
}
