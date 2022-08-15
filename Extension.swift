//
//  File.swift
//  MatchingSIBI
//
//  Created by Indah Nurindo on 22/04/2565 BE.
//

import Foundation
import SwiftUI
import AVFoundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension Color {
    static func rgb(r: Double,g:Double, b:Double)-> Color {
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    static let colorCard = Color.rgb(r: 153, g: 76, b: 0).opacity(1)
}

class Sounds {
    static var audioPlayer:AVAudioPlayer?
    static var player:AVAudioPlayer?
    
    static func playSounds(soundfile: String) {
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            }catch{
                print("Error")
            }
        }
    }
    
    static func playBackSound(soundfile: String){
        if let path = Bundle.main.path(forResource: soundfile, ofType: nil){
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                print("Error")
            }
        }
        
    }
}
