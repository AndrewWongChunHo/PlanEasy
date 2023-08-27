import SwiftUI
import Firebase
import LocalAuthentication

struct LoginView: View {
    
    @State var primaryColor = Color("LoginText")
    @State var strokeColor = Color("Stroke")
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View {
        
        ZStack{
            
            ZStack {
                Image("LoginBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .ignoresSafeArea(.keyboard)
                
                VStack {
                    Text("Email")
                        .foregroundColor(primaryColor)
                        .fontWeight(.bold)
                        .padding(.trailing, 210)
                        .padding(.top, 300)
                        .ignoresSafeArea(.keyboard)
                    
                    TextField("Enter Email", text: self.$email)
                        .padding()
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Stroke") : self.strokeColor, lineWidth: 2))
                        .padding(.trailing, 10)
                        .ignoresSafeArea(.keyboard)
            

                    Text("Password")
                        .foregroundColor(primaryColor)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.trailing, 170)
                        .ignoresSafeArea(.keyboard)
                    
                    SecureField("Enter Password", text: self.$pass)
                        .padding()
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Stroke") : self.strokeColor, lineWidth: 2))
                        .padding(.trailing, 8)
                        .ignoresSafeArea(.keyboard)
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.reset()
                            
                        }) {
                            
                            Text("Forget Password?")
                                .fontWeight(.regular)
                                .foregroundColor(primaryColor)
                                .underline()
                                .ignoresSafeArea(.keyboard)
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                    .padding(.top, 2)
                    .padding(.trailing, 80)
                    
                    Button(action: {
                        withAnimation(.easeIn){
                            self.authenticateWithFaceID()
                        }
                    }) {
                        Image("loginButton")
                            .renderingMode(.original)
                    }
                    .ignoresSafeArea(.keyboard)
                    .padding(.bottom, 80)
                    .padding(.trailing, 10)
                    
                    Text("Do not have an account?")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .ignoresSafeArea(.keyboard)
                    
                    NavigationLink(
                        destination: RegisterView(show: .constant(true)).navigationBarBackButtonHidden(true),
                        label: {
                            Text("Register Now!")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .underline()
                        })
                    
                    .ignoresSafeArea(.keyboard)
                }
            }
            .ignoresSafeArea(.keyboard)
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
        }
        .ignoresSafeArea(.keyboard)
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "Reset"
                self.alert.toggle()
            }
        }
        else{
            self.error = "The email is empty"
            self.alert.toggle()
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        }
        else{
            
            self.error = "Please fill in all the contents properly"
            self.alert.toggle()
        }
    }
    
    func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        // Check if Face ID authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            // Authenticate with Face ID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        // Authentication succeeded, verify the user's email using Firebase Authentication
                        verify()
                    } else {
                        // Authentication failed, show an error message
                        self.error = error?.localizedDescription ?? "Authentication failed"
                        self.alert.toggle()
                    }
                }
            }
        } else {
            // Face ID authentication is not available, show an error message
            self.error = error?.localizedDescription ?? "Face ID not available"
            self.alert.toggle()
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(show: .constant(true))
    }
}
