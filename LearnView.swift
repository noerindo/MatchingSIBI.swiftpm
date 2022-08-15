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

struct LearnView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var signs: [String]  = ["A", "B", "C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","~"]
    @State var selections: [String] = []
 
    var body: some View {
        ZStack{
            Image("Background1")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                ScrollView{
                    ZStack{
                        GeometryReader{ i in
                            Image("9")
                                .resizable()
                                .frame(width: i.size.width/2, height: i.size.width/6, alignment: .center)
                                .padding(EdgeInsets(top: 0, leading: i.size.width/4, bottom: 0, trailing: i.size.width/5))
                                Text("SIBI")
                                    .font(Font.custom("OpenSans-Bold", size: i.size.width/10))
                                    .foregroundColor(Color.white)
                                    .frame(width: i.size.width/2, height: i.size.width/6, alignment: .center)
                                    .padding(EdgeInsets(top: 0, leading: i.size.width/4, bottom: 0, trailing: i.size.width/5))
                              
                        }
                    }
                    .padding(.bottom, 200)
                    
                    GridStack(rows: 9, columns: 3) { row, col in
                        CardView1(name: self.signs[row * 3 + col], isSelected: self.selections.contains(self.signs[row * 3 + col])){
                            if self.selections.contains(self.signs[row * 3 + col]) {
                                self.selections.removeAll(where: { $0 == self.signs[row * 3 + col] })
                                Sounds.playSounds(soundfile: "\($signs[row * 3 + col]).mp3")
                            }
                            else {
                                self.selections.append(self.signs[row * 3 + col])
                                Sounds.playSounds(soundfile: "\(signs[row * 3 + col]).mp3")
                            }
                        }
                    }
                    
                }
            }
            GeometryReader{ i in
                Button {
                    presentationMode.wrappedValue.dismiss()
                    Sounds.playSounds(soundfile: "click.mp3")
                } label: {
                   Image("38")
                        .resizable()
                        .frame(width: i.size.width/9, height: i.size.width/9)
                        .padding(EdgeInsets(top: 0, leading: i.size.width/1.16, bottom: 0, trailing: 0))
                }
            }
        }
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}





