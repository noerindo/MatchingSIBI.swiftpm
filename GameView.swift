//
//  File.swift
//  MatchingSIBI
//
//  Created by Indah Nurindo on 18/04/2565 BE.
//

import Foundation
import SwiftUI
import AVFoundation
import AVFAudio

struct GameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SignMemoryGame
    @State private var isAudio = false
    var body: some View {
        
        GeometryReader{ i in
        ZStack{
            Image("Background1")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.linear) {
                                viewModel.choose(card: card)
                            }
                        }
                    
                } .padding(.top,i.size.width/10)

                HStack{
                    Button(action: 
                        withAnimation(.easeInOut){
                        viewModel.resetGame
                        
                        }
                    ) {
                        Image("30")
                            .resizable()
                            .frame(width: i.size.width/9, height: i.size.width/9)
                    }
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        Sounds.playSounds(soundfile: "click.mp3")
                       
                    } label: {
                       Image("38")
                            .resizable()
                            .frame(width: i.size.width/9, height: i.size.width/9)
                            .padding(EdgeInsets(top: 0, leading: i.size.width*0.05, bottom: 0, trailing: 0))
                    }
                }
            }
            .padding()
            }
            HStack{
                Text("Matching Card SIBI")
                    .font(.system(size:i.size.width*0.07, weight: .heavy, design: .default))
                    .padding()
                    .padding(.trailing,i.size.width*0.07 )
                Button(action: {
                    
                    if Sounds.player?.isPlaying == true{
                        Sounds.player?.stop()
                       }else {
                           Sounds.playBackSound(soundfile: "560446__migfus20__happy-background-music.mp3")
                       }
                    self.isAudio.toggle()
                }){
                    Image(uiImage: UIImage(named: isAudio ? "33" : "31")!)
                        .renderingMode(.original)
                        .resizable()
                        .padding(.bottom,i.size.width*0.02)
                        .frame(width: i.size.width/9, height: i.size.width/9)
                        .aspectRatio(contentMode: .fit)
                        
                        
                }.padding(.vertical, 20)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView( viewModel: SignMemoryGame())
    }
}


