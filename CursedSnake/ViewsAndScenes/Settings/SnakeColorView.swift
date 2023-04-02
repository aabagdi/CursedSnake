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
    
    let snakeHeadFrameWidth = 97.0
    
    var body: some View {
        let bgGradient = LinearGradient(colors: [Color("Bi Pink"), Color("Bi Purple"), Color("Bi Blue")], startPoint: .top, endPoint: .bottom)
        
        List {
            ColorPicker("Set the color of the Snake's head!!", selection: $HeadColor)
                .listRowSeparator(.hidden)
            ColorPicker("Set the color of the Snake's body!!", selection: $BodyColor)
            HStack{
                Spacer()
                VStack(spacing: 0) {
                    ZStack{
                        Ellipse()
                            .fill(HeadColor)
                        Ellipse()
                            .strokeBorder(.white, lineWidth: 3.0)
                        
                    }.frame(width: snakeHeadFrameWidth, height: snakeHeadFrameWidth / 0.571428571428571)
                    ForEach(0..<7) { _ in
                        ZStack {
                            Circle()
                                .fill(BodyColor)
                            Circle()
                                .strokeBorder(.white, lineWidth: 3.0)
                        }
                    }.frame(width: snakeHeadFrameWidth/2, height: snakeHeadFrameWidth/2)
                }
                Spacer()
            }
            .listRowBackground(bgGradient
                .hueRotation(.degrees(animateGradient ? -50 : 0))
                .animation(Animation.easeInOut(duration: 40).repeatForever(autoreverses: true), value: animateGradient)
            )
            .onAppear {
                animateGradient.toggle()
            }
            HStack{
                Spacer()
                Button {
                    self.HeadColor = randColor()
                    self.BodyColor = randColor()
                } label: {
                    Image(systemName: "dice")
                }
                Spacer()
            }
        }
    }
    
    func randColor() -> Color {
        let randRed = Double.random(in: 0...255) / 255
        let randGreen = Double.random(in: 0...255) / 255
        let randBlue = Double.random(in: 0...255) / 255
        //let randOpacity = 1.0 - Double.random(in: 0...1)
        
        return Color(red: randRed, green: randGreen, blue: randBlue)
    }
}


struct SnakeColorView_Previews: PreviewProvider {
    static var previews: some View {
        SnakeColorView()
    }
}
