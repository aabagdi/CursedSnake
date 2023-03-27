//
//  TitleViewModel.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/28/23.
//

import Foundation
import GameKit
import SwiftUI

extension TitleView {
    class TitleModel : ObservableObject {
        @Published var startGame = false
        @Published var goToSettings = false
        @Published var showLeaderboard = false
        
        func authenticateUser() {
            GKLocalPlayer.local.authenticateHandler = { vc, error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
            }
        }
        
        func initUserDefaults() {
            let defaults = UserDefaults.standard
            if !defaults.bool(forKey: "UserDefaultsSet") {
                defaults.set(true, forKey: "UserDefaultsSet")
                defaults.set(0.5, forKey: "MusicVol")
                defaults.set(1.0, forKey: "SoundVol")
                defaults.set("Cursed Snake Theme", forKey: "BGM")
                defaults.set(1.0, forKey: "Difficulty")
            }
        }
    }
}
