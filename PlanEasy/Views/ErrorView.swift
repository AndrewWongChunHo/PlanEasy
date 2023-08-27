import SwiftUI

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    

    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    Text(self.error == "RESET" ? "Message" : "ERROR")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                }
                .padding(.horizontal, 15)
                
                Text(self.error == "Reset" ? "Password reset link has been sent successfully" : self.error)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text(self.error == "RESET" ? "OK" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("LoginText"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
            .padding(.top, 250)
            .padding(.leading, 35)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
    }
}


struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(true), error: .constant("Error"))
    }
}
