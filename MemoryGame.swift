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

struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: [Card] = [Card]()
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            
            cards.append(Card(content: content))
            cards.append(Card(content: content))
                
        }
        cards.shuffle()
    }
    
    private var indexOfOneAndOnlyCard: Int?
    
    mutating func choose(card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
            
            if indexOfOneAndOnlyCard == nil {
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfOneAndOnlyCard = chosenIndex
            } else {
                if cards[indexOfOneAndOnlyCard!].content == cards[chosenIndex].content {
                    cards[indexOfOneAndOnlyCard!].isMatched = true
                    cards[chosenIndex].isMatched = true
                    
                }
                indexOfOneAndOnlyCard = nil
                    
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    
    
    struct Card: Identifiable {
        var id = UUID()
        var content: CardContent
        
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                    
                }
            }
        }
    
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval {
            if let lastFaceUpdate = lastFaceUpdate {
                return pastFaceUpdate + Date().timeIntervalSince(lastFaceUpdate)
            } else {
                return pastFaceUpdate
            }
        }
        
        var lastFaceUpdate: Date?
        
        var pastFaceUpdate: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0

        }
        
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpdate == nil {
                lastFaceUpdate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpdate = faceUpTime
            lastFaceUpdate = nil
        }
    }
}

class SignMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = SignMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let signs = ["A", "B", "C", "D", "E","F", "G", "H", "I", "J","K","L", "M", "N", "O", "P","Q", "R", "S", "T", "U","V", "W", "X", "Y", "Z",].shuffled()

        return MemoryGame<String>(numberOfPairsOfCards: Int.random(in: 2...26)) { index in
            return signs[index]
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    
    // MARK: - Intents
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = SignMemoryGame.createMemoryGame()
    }
}
