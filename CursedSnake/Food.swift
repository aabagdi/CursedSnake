//
//  Food.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 1/28/23.
//
import Foundation
import SpriteKit


class Food {
    var egg: SKSpriteNode
    
    var pointValue: Int
    
    init() {
        self.egg = SKSpriteNode(imageNamed: "Egg.png")
        self.egg.setScale(1.0)
        self.pointValue = Int.random(in: -2...1)
    }
}

