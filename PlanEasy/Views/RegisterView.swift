
import SwiftUI
import Firebase

struct RegisterView: View {
    
    @State var askText: String = "Have an account?"
    @State var primaryColor = Color("LoginText")
    @State var strokeColor = Color("Stroke")
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    
    var body: some View {
        ZStack {
            ZStack {
                Image("RegisterBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
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
                    
                    Text("Confirm Password")
                        .foregroundColor(primaryColor)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.trailing, 100)
                        .ignoresSafeArea(.keyboard)
                    
                    SecureField("Confirm Password", text: self.$repass)
                        .padding()
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Stroke") : self.strokeColor, lineWidth: 2))
                        .padding(.trailing, 8)
                        .ignoresSafeArea(.keyboard)
                    
              
                    
                    Button(action: {
                        self.register()
                        
                    }) {
                        Image("registerButton")
                            .renderingMode(.original)
                    }
                    .padding(.bottom,25)
                    .padding(.trailing, 10)
                    .ignoresSafeArea(.keyboard)

                    
                    Text("Have an account?")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                        .ignoresSafeArea(.keyboard)
                    
                    NavigationLink(
                        destination: LoginView(show: .constant(true)).navigationBarBackButtonHidden(true), label: {
                            Text("Login Now!")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .underline()
                                .ignoresSafeArea(.keyboard)
                        })
                }
            }
            .ignoresSafeArea(.keyboard)
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
    
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
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
                
                self.error = "Password Mismatch"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "please fill in all the contents properly"
            self.alert.toggle()
        }
    }

}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(show: .constant(true))
    }
}
