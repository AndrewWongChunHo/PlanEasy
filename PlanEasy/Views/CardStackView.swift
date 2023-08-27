//
//  CardStackView.swift
//  PlanEasy
//
//  Created by Jack Tsoi on 21/2/2023.
//

import SwiftUI
import Combine

let cardSpace:CGFloat = 10

struct Card : Identifiable, Hashable, Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    
    var intID : Int
    
    static let cardImages: [String] = ["p1","p2","p3"]
    static let arModels: [String] = ["character/robot_dressed","character/t_shirt","character/robot_dressed"]
    
    var zIndex : Int
    var imageName : String
    var arName: String
}

class CardStackData: ObservableObject {
    
    @Published var cards: [Card] = []
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = Just(Card.arModels)
            .flatMap({ models in
                Publishers.Sequence(sequence: models.enumerated())
            })
            .sink(receiveValue: { index, model in
                self.cards.append(Card(intID: index, zIndex: index, imageName: Card.cardImages[index], arName: model))
            })
    }
    
    func getArModelNames() -> [String] {
        return self.cards.map({ $0.arName })
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct CardStackView: View {
    
    @State var data : CardStackData = CardStackData()

    
    var body: some View {
        HStack {
            VStack {
                CardStack(degree: .constant(0.0)).environmentObject(data)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CardStack: View {
    @Binding var degree : Double
    @EnvironmentObject var data : CardStackData
    
    @State var offset = CGSize.zero
    @State var dragging:Bool = false
    @State var tapped:Bool = false
    @State var tappedLocation:Int = -1
    @State var locationDragged:Int = -1
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ForEach(self.data.cards, id: \.self) { card in
                    ColorCard(card: card, reader:reader, offset: self.$offset, tappedLocation: self.$tappedLocation, locationDragged:self.$locationDragged, tapped: self.$tapped, dragging: self.$dragging)
                        .environmentObject(self.data)
                        .zIndex(Double(card.zIndex))
                }
            }.rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        }
        .animation(.spring())
    }
}

struct ColorCard: View {
    
    @EnvironmentObject var data : CardStackData
    
    var card: Card
    var reader: GeometryProxy
    @State var offsetHeightBeforeDragStarted: Int = 0
    @Binding var offset: CGSize
    @Binding var tappedLocation:Int
    @Binding var locationDragged:Int
    @Binding var tapped:Bool
    @Binding var dragging:Bool
    @State private var showARView = false
    
    var body: some View {
        VStack {
            Group {
                VStack {
                    //                    card.color
                    ZStack {
                        Image(card.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        Button(action: {
                            // Action to perform when the button is tapped
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .offset(x: -80, y: 140)
                        Button(action: {
                            showARView = true
                        }) {
                            Image(systemName: "tshirt")
                                .foregroundColor(.white)
                        }
                        .sheet(isPresented: $showARView) {
                            ARCharacterView(cardStackData: CardStackData())
                                .navigationBarBackButtonHidden(true)
                        }
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .offset(x: 80, y: 140)
                    }
                    
                }
                .frame(width: 250, height: 350) //卡片的大小
                .cornerRadius(20).shadow(radius: 20)
                .offset(
                    x: (self.locationDragged == card.intID) ? CGFloat(card.zIndex) * self.offset.width / 14
                    : 0,
                    y: (self.locationDragged == card.intID) ? CGFloat(card.zIndex) * self.offset.height / 4
                    : 0
                )
                .offset(
                    x: (self.tapped && self.tappedLocation != card.intID) ? 0 : 0,//點擊後牌組左右的位置(左-, 右+)
                    y: (self.tapped && self.tappedLocation != card.intID) ? 0 : 0 //點擊後牌組上下的位置(上-, 下+)
                )
                .position(x: reader.size.width / 2, y: (self.tapped && self.tappedLocation == card.intID) ? reader.size.height / 2 - 50 : reader.size.height / 2)//點擊後單牌的位置
            }
            .rotationEffect(
                (card.zIndex % 2 == 0) ? .degrees(-0.2 * Double(arc4random_uniform(15)+1) ) : .degrees(0.2 * Double(arc4random_uniform(15)+1) )
            )
            
            .onTapGesture() { //Show the card
                if card.intID == 0 { // check if this is the first card
                    self.tapped.toggle()
                    self.tappedLocation = self.card.intID
                    // navigate to another page
                    NavigationLink(destination: MainPage()) {
                        Profile()
                    }.hidden()
                } else {
                    self.tapped.toggle()
                    self.tappedLocation = self.card.intID
                }
            }
            
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        self.locationDragged = self.card.intID
                        self.offset = gesture.translation
                        self.dragging = true
                    }
                    .onEnded {gesture in
                        // when finger is lifted
                        if gesture.translation.width < -190 || gesture.translation.width > 190 {
                            withAnimation {
                                if let index = self.data.cards.firstIndex(of: self.card) {
                                    if index == 0 { // check if it's the first card being dragged
                                        self.data.cards.remove(at: index)
                                        self.data.cards.append(self.card)
                                    } else {
                                        self.data.cards.remove(at: index)
                                        self.data.cards.insert(self.card, at: 0)
                                    }
                                    
                                    for index in 0..<self.data.cards.count {
                                        self.data.cards[index].zIndex = index
                                    }
                                }
                            }}
                        self.locationDragged = -1 //Reset
                        self.offset = .zero
                        self.dragging = false
                        self.tapped = false //enable drag to dismiss
                        self.offsetHeightBeforeDragStarted = Int(self.offset.height)
                    }
            )
        }.offset(y: (cardSpace * CGFloat(card.zIndex)))
    }
}

struct CardStackView_Previews: PreviewProvider {
    static var previews: some View {
        CardStackView().environmentObject(CardStackData())
        
    }
}
