//
//  TitleViewModel.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/28/23.
//

import Foundation

extension TitleView {
    class TitleViewModel : ObservableObject {
        @Published var startGame = false
        @Published var goToCredits = false
        @Published var displayingTitle = true
    }
}
