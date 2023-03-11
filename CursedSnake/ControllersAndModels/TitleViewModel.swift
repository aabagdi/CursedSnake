//
//  TitleViewModel.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/28/23.
//

import Foundation
import GameKit

extension TitleView {
    class TitleViewModel : ObservableObject {
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
    }
}
