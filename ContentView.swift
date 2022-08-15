
import SwiftUI

struct ContentView: View {
  @State private var isPresented = false
    @State private var isPresented1 = false
    private let game = SignMemoryGame()
    var body: some View {

            GeometryReader{ g in
                ZStack{
                    Image("Background1")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    Image("background2")
                        .resizable()
                        .frame(width: g.size.width*0.9, height: g.size.width*0.8)
                    HStack{
                        Button("\(Image("Learn"))"){
                            isPresented1.toggle()
                            Sounds.playSounds(soundfile: "click.mp3")
                        }
                        .font(.system(size: g.size.width*0.11))
                        .padding(.top,g.size.width/10)
                        
                        .fullScreenCover(isPresented: $isPresented1, content: LearnView.init)
                        Button("\(Image("Play"))"){
                            isPresented.toggle()
                            Sounds.playSounds(soundfile: "click.mp3")
                        }
                        .font(.system(size: g.size.width*0.11))
                        .padding(.top,g.size.width/10)
                        
                        .fullScreenCover(isPresented: $isPresented) {
                            GameView(viewModel: game)
                        }
                       

                    }.padding(.top, g.size.width/1.5)
                    }
            }
            
//            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



