//
//  TitleView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/21/23.
//

import SwiftUI
import SpriteKit
import GameKit
import Foundation


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
                    Button("Settings") {
                        TitleModel.goToSettings.toggle()
                    }
                    .navigationDestination(isPresented: $TitleModel.goToSettings) {
                        SettingsView()
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
                TitleModel.initUserDefaults()
                self.TitleThemePlayer.play(sound: "TitleScreen")
                self.TitleThemePlayer.setVol(newVol: UserDefaults.standard.float(forKey: "MusicVol"))
                self.TitleThemePlayer.triggerLoop()
            })
            .onDisappear(perform: {
                self.TitleThemePlayer.stop()
            })
        }
    }
}
