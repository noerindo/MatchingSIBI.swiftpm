//
//  File.swift
//  MatchingSIBI
//
//  Created by Indah Nurindo on 19/04/2565 BE.
//

import Foundation
import SwiftUI

struct GridStack<Content:View>: View {
    
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) {
                 row in
                HStack {
                    ForEach(0 ..< columns, id:\.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping ( Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}


struct CardView1: View {
    @State private var showThing = true
    var name: String
    var isSelected: Bool = false
    var action: () -> Void
    
    var body: some View {
        VStack{
            Button(action: self.action){
                Image(uiImage: UIImage(named: "\(name).jpg")!).renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 5)
            }
            .padding(EdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2))
            Text(name)
                .font(.system(size:60, weight: .heavy, design: .default))
                .padding(.top, 10)
                .foregroundColor(isSelected ? Color.black: Color.clear)
            
        }
    }
    
    
}
