//
//  TitleView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/21/23.
//

import SwiftUI
import SpriteKit
import GameKit

struct TitleView: View {
    
    @StateObject private var TitleModel = TitleViewModel()
    let TitleThemePlayer = AudioPlayer()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Cursed Snake").font(.custom("Adam'sFontRegular", size: 52)).multilineTextAlignment(.center)
                VStack{
                    Button("Play Game") {
                        TitleModel.startGame.toggle()
                    }
                    .navigationDestination(isPresented: $TitleModel.startGame) {
                        GameViewControllerRepresentable()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .edgesIgnoringSafeArea([.top, .bottom])
                    }
                    Button("Credits") {
                        TitleModel.goToCredits.toggle()
                    }
                    .navigationDestination(isPresented: $TitleModel.goToCredits) {
                        let creditsScene = CreditsScene()
                        SpriteView(scene: creditsScene)
                    }
                    Button("Game Center") {
                        TitleModel.showLeaderboard.toggle()
                    }
                    .sheet(isPresented: $TitleModel.showLeaderboard) {
                        GameCenterView()
                    }
                }.buttonStyle(.borderedProminent)
            }.onAppear(perform: {
                TitleModel.authenticateUser()
                self.TitleThemePlayer.play(sound: "TitleScreen")
            })
            .onDisappear(perform: {
                self.TitleThemePlayer.stop()
            })
        }
    }
}
