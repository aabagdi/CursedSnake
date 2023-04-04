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
    @State private var tapped : Bool = false
    @StateObject private var model = TitleModel()
    private var TitleThemePlayer = AudioPlayer()
    private var HellYeaBroPlayer = AudioPlayer()
    
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
                    .scaleEffect(tapped ? 1.5 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.3), value: tapped)
                    .onTapGesture {
                        self.HellYeaBroPlayer.play(sound: "HellYeaBrother")
                        self.TitleThemePlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                        tapped.toggle()
                        Task {
                            try await Task.sleep(nanoseconds: 200_000_000)
                            tapped.toggle()
                        }
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
                    /*Button("Reset GC") {
                        GKAchievement.resetAchievements()
                    }*/
                }.buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .font(.system(size: 35, weight: Font.Weight.bold))
            }.scaledToFit()
                .onAppear(perform: {
                    model.authenticateUser()
                    model.initUserDefaults()
                    self.TitleThemePlayer.play(sound: "TitleScreen")
                    self.TitleThemePlayer.setVol(newVol: UserDefaults.standard.float(forKey: "MusicVol"))
                    self.TitleThemePlayer.triggerLoop()
                })
                .onDisappear(perform: {
                    self.TitleThemePlayer.fadeOut(duration: 0.5)
                })
        }
    }
}
