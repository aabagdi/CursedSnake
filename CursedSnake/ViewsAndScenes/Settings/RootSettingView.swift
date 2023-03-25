//
//  RootSettingsView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/11/23.
//

import SwiftUI
import SpriteKit
import Foundation


struct RootSettingView: View {
    let viewToDisplay: String
    var body: some View {
        switch viewToDisplay {
        case "Volume":
            VolumeSettingsView()
            
        case "Background Music":
            BGMSettingsView()
            
        case "Snake Color":
            SnakeColorView()
            
        case "Credits":
            let creditsScene = CreditsScene()
            SpriteView(scene: creditsScene)
            
        default:
            RootSettingView(viewToDisplay: "")
        }
    }
}
