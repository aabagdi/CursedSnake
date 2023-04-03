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
    
    @StateObject private var model = TitleModel()
    let TitleThemePlayer = AudioPlayer()
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader {g in
                    VStack {
                        Text("Cursed Snake")
                            .font(.custom("Adam'sFontRegular", size: g.size.height))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.01)
                    }
                }
                VStack{
                    Button("Play Game") {
                        model.startGame.toggle()
                    }
                    .navigationDestination(isPresented: $model.startGame) {
                        GameViewControllerRepresentable()
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .edgesIgnoringSafeArea([.top, .bottom])
                    }
                    Button("Settings") {
                        model.goToSettings.toggle()
                    }
                    .navigationDestination(isPresented: $model.goToSettings) {
                        SettingsView()
                    }
                    
                    Button("Game Center") {
                        model.showLeaderboard.toggle()
                    }
                    .sheet(isPresented: $model.showLeaderboard) {
                        GameCenterView()
                    }
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .font(.system(size: 35, weight: Font.Weight.bold))
                
            }.scaledToFit()
<<<<<<< Updated upstream
            .onAppear(perform: {
                //TitleModel.authenticateUser()
                TitleModel.initUserDefaults()
                self.TitleThemePlayer.play(sound: "TitleScreen")
                self.TitleThemePlayer.setVol(newVol: UserDefaults.standard.float(forKey: "MusicVol"))
                self.TitleThemePlayer.triggerLoop()
            })
            .onDisappear(perform: {
                self.TitleThemePlayer.stop()
            })
=======
                .onAppear(perform: {
                    model.authenticateUser()
                    //GKAchievement.resetAchievements()
                    model.initUserDefaults()
                    self.TitleThemePlayer.play(sound: "TitleScreen")
                    self.TitleThemePlayer.setVol(newVol: UserDefaults.standard.float(forKey: "MusicVol"))
                    self.TitleThemePlayer.triggerLoop()
                })
                .onDisappear(perform: {
                    self.TitleThemePlayer.stop()
                })
>>>>>>> Stashed changes
        }
    }
}
