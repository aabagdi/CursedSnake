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
    
    @State private var animateGradient : Bool = false
    
    var body: some View {
        let bgGradient = LinearGradient(colors: [Color("Bi Pink"), Color("Bi Purple"), Color("Bi Blue")], startPoint: animateGradient ? .top : .bottom, endPoint: animateGradient ? .bottom : .top)
        
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
            }
            .listRowBackground(bgGradient)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        }
    }
}

struct SnakeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SnakeColorView()
    }
}
