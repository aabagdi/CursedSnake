//
//  SnakeColorView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/24/23.
//

import SwiftUI

struct SnakeColorView: View {
    @AppStorage("HeadColor") private var HeadColor : Color = .white
    @AppStorage("BodyColor") private var BodyColor : Color = .white
    
    var body: some View {
        List {
            ColorPicker("Set the color of the Snake's head!!", selection: $HeadColor)
            ColorPicker("Set the color of the Snake's body!!", selection: $BodyColor)
            HStack{
                Spacer()
                VStack(spacing: 0) {
                    ZStack{
                        Ellipse()
                            .fill(HeadColor)
                        Ellipse()
                            .strokeBorder(.white, lineWidth: 3.2)
                        
                    }.frame(width: 100, height: 175)
                    ForEach(0..<7) { _ in
                        ZStack {
                            Circle()
                                .fill(BodyColor)
                            Circle()
                                .strokeBorder(.white, lineWidth: 3.2)
                        }
                    }.frame(width: 50, height: 50)
                }
                Spacer()
            }.listRowBackground(LinearGradient(gradient: Gradient(colors: [Color("Bi Pink"), Color("Bi Purple"), Color("Bi Blue")]), startPoint: .top, endPoint: .bottom))
        }
    }
}
