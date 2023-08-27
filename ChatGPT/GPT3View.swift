

import SwiftUI

struct GPT3View: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var gpt3ViewModel = GPT3ViewModel()
    @State var typingMessage: String = ""
    @Namespace var bottomID
    @FocusState private var fieldIsFocused: Bool

    var body: some View {
        
        NavigationView(){
            VStack(alignment: .leading){
                HStack{
                    Button{
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(Color.black.opacity(0.9))
                    }
                    
                    Text("Styling Consultation")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.9))

                    
                    Spacer()
                }
                .padding()
                .padding(.top, 10)
                if !gpt3ViewModel.messages.isEmpty{
                    ScrollViewReader { reader in
                        ScrollView(.vertical) {
                            ForEach(gpt3ViewModel.messages) { message in
                                MessageView(message: message)
                            }
                            Text("").id(bottomID)
                        }
                        
                        .onChange(of: gpt3ViewModel.messages.last?.content as? String) { _ in
                            DispatchQueue.main.async {
                                withAnimation {
                                    reader.scrollTo(bottomID)
                                }
                            }
                        }
                        .onChange(of: gpt3ViewModel.messages.count) { _ in
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                        
                        .onAppear {
                            withAnimation {
                                reader.scrollTo(bottomID)
                            }
                        }
                    }
                } else {
                    VStack{
                        Image(systemName: "ellipses.bubble")
                            .font(.largeTitle)
                        Text("Ask our styling consultant!")
                            .font(.subheadline)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                HStack(alignment: .center){
                    TextField("Message...", text: $typingMessage, axis: .vertical)
                        .focused($fieldIsFocused)
                        .padding()
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onTapGesture {
                            fieldIsFocused = true
                        }
                    Button(action: sendMessage) {
                        Image(systemName: typingMessage.isEmpty ? "circle" : "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(typingMessage.isEmpty ? .white.opacity(0.75) : .white)
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                }
                .onDisappear {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
                .background(Color(red: 63/255, green: 66/255, blue: 78/255, opacity: 1))
                .cornerRadius(12)
                .padding([.leading, .trailing, .bottom], 10)
                .shadow(color: .black, radius: 0.5)
            }
            .background(Color("HomeBG"))
            .gesture(TapGesture().onEnded {
                hideKeyboard()
            })
        }
    }
    
    private func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        hideKeyboard()
        Task{
            await gpt3ViewModel.getResponse(text: tempMessage)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
