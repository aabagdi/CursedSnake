//
//  TitleView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/21/23.
//

import SwiftUI
import SpriteKit


struct TitleView: View {
    @State var startGame = false
    @State var goToCredits = false
    var body: some View {
        let TitleThemePlayer = AudioPlayer()
        NavigationStack {
            VStack {
                Text("Cursed Snake").font(.custom("Adam'sFontRegular", size: 52)).multilineTextAlignment(.center)
                VStack{
                    Button("Play Game") {
                        startGame.toggle()
                    }
                    .navigationDestination(isPresented: $startGame) {
                        SpriteView(scene: SKScene(fileNamed: "GameScene")!)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .edgesIgnoringSafeArea([.top, .bottom])
                    }
                    Button("Credits") {
                        goToCredits.toggle()
                    }
                    .navigationDestination(isPresented: $goToCredits) {
                        let creditsScene = SKScene(fileNamed: "CreditsScene")!
                        SpriteView(scene: creditsScene)
                    }
                }.buttonStyle(.borderedProminent)
            }.onDisappear(perform: {
                TitleThemePlayer.stop()
            })
        }.onAppear(perform: {
            TitleThemePlayer.play(sound: "TitleScreen")
        })
    }
}

