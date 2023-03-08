//
//  CreditsScene.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/24/23.
//

import Foundation
import SpriteKit

class CreditsSceneLight: SKScene {
    override func didMove(to view: SKView) {
        let newScene = SKScene(fileNamed: "CreditsSceneLight")!
        self.view?.presentScene(newScene)
    }
}
