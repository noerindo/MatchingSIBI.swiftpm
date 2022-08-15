//
//  File.swift
//  MatchingSIBI
//
//  Created by Indah Nurindo on 22/04/2565 BE.
//

import Foundation
import SwiftUI
import AVFoundation
import AVFAudio

struct Cardify: AnimatableModifier {
    var colors: [Color] = [Color.colorCard]
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .opacity(isFaceUp ? 0 : 1)
        }
        .foregroundColor(Color.colorCard)
        .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    private let cornerRadius: CGFloat = 10
    private let lineWidth: CGFloat = 3
}


extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}

struct GridLayout {
    var size: CGSize
    var rowCount: Int = 0
    var columnCount: Int = 0
    
    init(itemCount: Int, nearAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var smallestVariance: Double?
        let sizeAspectRatio = abs(Double(size.width/size.height))
        for rows in 1...itemCount {
            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
            if (rows - 1) * columns < itemCount {
                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
                let variance = abs(itemAspectRatio - desiredAspectRatio)
                if smallestVariance == nil || variance < smallestVariance! {
                    smallestVariance = variance
                    bestLayout = (rowCount: rows, columnCount: columns)
                }
            }
        }
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    var itemSize: CGSize {
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            return CGSize(
                width: size.width / CGFloat(columnCount),
                height: size.height / CGFloat(rowCount)
            )
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height
            )
        }
    }
}

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool = true
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(CGFloat(startAngle.radians)),
            y: center.y + radius * sin(CGFloat(startAngle.radians))
        )
        
        var path = Path()
        
        path.move(to: center)
        path.addLine(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        path.addLine(to: center)
        
        return path
    }
}

struct Grid<Item,ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], _ viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            let layout =  GridLayout(itemCount: items.count, in: geometry.size)
            
            ForEach(items) { item in
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: items.firstIndex(where: { item.id == $0.id })! ))
            }
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            if !card.isMatched || card.isFaceUp {
                ZStack {
                    Group {
                        if card.isConsumingBonusTime {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90))
                                .onAppear {
                                    startBonusTimeAnimation()
                                    Sounds.playSounds(soundfile: "403019__inspectorj__ui-confirmation-alert-c4.wav")
                                }
                        }
                        else {
                            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90))
                        }
                    }
                    .padding(6)
                    .opacity(pieOpacity)
                    
                    HStack{
                        Image("\(card.content)")
                            .resizable()
                            .frame(width: geometry.size.width/2, height:  geometry.size.width/2)
                            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                            .animation(card.isMatched ? Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false) : .default, value: true)
                        Text("\(card.content)")
                            .font(.system(size:geometry.size.width/2, weight: .heavy, design: .default))
                            .foregroundColor(card.isMatched ? Color.black: Color.clear)
                       
                      
                    }
                    
                }
                .cardify(isFaceUp: card.isFaceUp)
                .transition(.scale)
                
            }
        }
        .padding(5)
    }
    
    private let fontScaleFactor: CGFloat = 0.6
    private let pieOpacity = 0.4
}
