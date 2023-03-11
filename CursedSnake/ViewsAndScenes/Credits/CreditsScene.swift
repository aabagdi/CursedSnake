//
//  CreditsScene.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/24/23.
//

import Foundation
import SpriteKit

class CreditsScene: SKScene {
    override func didMove(to view: SKView) {
        switch UITraitCollection.current.userInterfaceStyle {
        case .light:
            let newScene = SKScene(fileNamed: "CreditsSceneLight")!
            self.view?.presentScene(newScene)
    
        case .dark:
            let newScene = SKScene(fileNamed: "CreditsSceneDark")!
            self.view?.presentScene(newScene)
            
        case .unspecified:
            break
            
        @unknown default:
            break
        }
    }
}
