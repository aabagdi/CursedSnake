//
//  Snake.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 1/20/23.
//

import Foundation
import SpriteKit
import SwiftUI

class Snake {
    enum SnakeStates {
        case up
        case down
        case left
        case right
        case dead
    }
    
    private var difficultyMultDict : [String : CGFloat] = ["Pansy" : 1.4, "Easy" : 1.2, "Normal" : 1.0, "Hard" : 0.6, "Cracked" : 0.3]
    
    private var SnakeDirection: SnakeStates = .up
    
    private var SnakeSpeed: CGFloat = 0.2
    
    private var SnakeBody = [SKShapeNode]()
    
    private var SnakeHeadColor = UserDefaults.standard.string(forKey: "HeadColor")
    private var SnakeBodyColor = UserDefaults.standard.string(forKey: "BodyColor")
    
    func getLength() -> Int {
        return SnakeBody.count
    }
    
    func incrementSnake() {
        let newSegment = SKShapeNode(circleOfRadius: 5)
        newSegment.name = "body"
        newSegment.fillColor = UIColor(Color(rawValue: SnakeBodyColor ?? ".white") ?? .white)
        newSegment.zPosition = 2
        newSegment.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        newSegment.physicsBody!.contactTestBitMask = 0b11
        newSegment.physicsBody!.isDynamic = false
        let lastSegmentPos = SnakeBody.last?.position
        switch SnakeDirection {
        case .up:
            newSegment.position = CGPointMake(lastSegmentPos!.x, lastSegmentPos!.y - 10.0)
            
        case .down:
            newSegment.position = CGPointMake(lastSegmentPos!.x, lastSegmentPos!.y + 10.0)
            
        case .left:
            newSegment.position = CGPointMake(lastSegmentPos!.x + 10.0, lastSegmentPos!.y)
            
        case .right:
            newSegment.position = CGPointMake(lastSegmentPos!.x - 10.0, lastSegmentPos!.y)
            
        case .dead:
            return
        }
        SnakeBody.append(newSegment)
    }
    
    func lengthDependentSpeed() {
        let snakeLength = self.getLength()
        let diffMult = difficultyMultDict[(UserDefaults.standard.string(forKey: "Difficulty")) ?? "Normal"]!
        switch snakeLength {
        case 1...15:
            self.setSpeed(speed: 0.2 * diffMult)
            
        case 16...30:
            self.setSpeed(speed: 0.15 * diffMult)
            
        case 31...45:
            self.setSpeed(speed: 0.1 * diffMult)
            
        case 46...60:
            self.setSpeed(speed: 0.08 * diffMult)
            
        case 61...85:
            self.setSpeed(speed: 0.06 * diffMult)
            
        case 86...100:
            self.setSpeed(speed: 0.045 * diffMult)
            
        default:
            self.setSpeed(speed: 0.03 * diffMult)
        }
    }
    
    func moveTail() {
        if self.getLength() > 1 {
            for i in (1...(self.getLength() - 1)).reversed() {
                let curr = SnakeBody[i]
                let pred = SnakeBody[i - 1]
                if i == 1 {
                    switch SnakeDirection {
                    case .up:
                        let predX = pred.position.x
                        let predY = pred.position.y - 12.5
                        let moveAction = SKAction.move(to: CGPoint(x: predX, y: predY), duration: self.SnakeSpeed / 2)
                        curr.run(moveAction)
                    case .down:
                        let predX = pred.position.x
                        let predY = pred.position.y + 12.5
                        let moveAction = SKAction.move(to: CGPoint(x: predX, y: predY), duration: self.SnakeSpeed / 2)
                        curr.run(moveAction)
                    case .left:
                        let predX = pred.position.x + 12.5
                        let predY = pred.position.y
                        let moveAction = SKAction.move(to: CGPoint(x: predX, y: predY), duration: self.SnakeSpeed / 2)
                        curr.run(moveAction)
                    case .right:
                        let predX = pred.position.x - 12.5
                        let predY = pred.position.y
                        let moveAction = SKAction.move(to: CGPoint(x: predX, y: predY), duration: self.SnakeSpeed / 2)
                        curr.run(moveAction)
                    case .dead:
                        return
                    }
                }
                else {
                    switch SnakeDirection {
                    case .up:
                        let predX = pred.position.x
                        let predY = pred.position.y - 5
                        let predPos = boundaryCheck(point: CGPointMake(predX, predY))
                        let moveAction = SKAction.move(to: predPos, duration: self.SnakeSpeed / 4)
                        curr.run(moveAction)
                    case .down:
                        let predX = pred.position.x
                        let predY = pred.position.y + 5
                        let predPos = boundaryCheck(point: CGPointMake(predX, predY))
                        let moveAction = SKAction.move(to: predPos, duration: self.SnakeSpeed / 4)
                        curr.run(moveAction)
                    case .left:
                        let predX = pred.position.x + 5
                        let predY = pred.position.y
                        let predPos = boundaryCheck(point: CGPointMake(predX, predY))
                        let moveAction = SKAction.move(to: predPos, duration: self.SnakeSpeed / 4)
                        curr.run(moveAction)
                    case .right:
                        let predX = pred.position.x - 5
                        let predY = pred.position.y
                        let predPos = boundaryCheck(point: CGPointMake(predX, predY))
                        let moveAction = SKAction.move(to: predPos, duration: self.SnakeSpeed / 4)
                        curr.run(moveAction)
                    case .dead:
                        return
                    }
                }
            }
        }
    }
    
    func changeDirection(direction: SnakeStates) {
        let head = SnakeBody.first
        let tail = SnakeBody.last
        if SnakeDirection == .dead {
            return
        }
        
        if direction == SnakeDirection {
            return
        }
        
        else if SnakeDirection == .left && direction != .right {
            SnakeDirection = direction
            let rotation = SKAction.rotate(byAngle: -(Double.pi) / 2.0, duration: 0.00000000005)
            head!.run(rotation)
            tail!.position.x = tail!.position.x + CGFloat(10)
        }
        
        else if SnakeDirection == .right && direction != .left {
            SnakeDirection = direction
            let rotation = SKAction.rotate(byAngle: (Double.pi) / 2.0, duration: 0.00000000005)
            head!.run(rotation)
            tail!.position.x = tail!.position.x - CGFloat(10)
        }
        
        else if SnakeDirection == .up && direction != .down {
            SnakeDirection = direction
            let rotation = SKAction.rotate(byAngle: (Double.pi) / 2.0, duration: 0.00000000005)
            head!.run(rotation)
            tail!.position.y = tail!.position.y - CGFloat(10)
            
        }
        
        else if SnakeDirection == .down && direction != .up {
            SnakeDirection = direction
            let rotation = SKAction.rotate(byAngle: -(Double.pi) / 2.0, duration: 0.00000000005)
            head!.run(rotation)
            tail!.position.y = tail!.position.y + CGFloat(10)
        }
    }
    
    func boundaryCheck(point: CGPoint) -> CGPoint {
        var currentX = point.x
        var currentY = point.y
        
        let xRange = -190.0...190.0
        let yRange = -432.0...432.0
        
        currentX = currentX < xRange.lowerBound ? xRange.lowerBound : currentX
        currentX = currentX > xRange.upperBound ? xRange.upperBound : currentX
        
        currentY = currentY < yRange.lowerBound ? yRange.lowerBound : currentY
        currentY = currentY > yRange.upperBound ? yRange.upperBound : currentY
        
        
        return CGPointMake(currentX, currentY)
    }
    
    func getBody() -> [SKShapeNode] {
        return SnakeBody
    }
    
    func getDirection() -> SnakeStates {
        return SnakeDirection
    }
    
    func getSpeed() -> CGFloat {
        return SnakeSpeed
    }
    
    func setSpeed(speed: CGFloat) {
        self.SnakeSpeed = speed
    }
    
    init() {
        let head = SKShapeNode(ellipseOf: CGSize(width: 20, height: 35))
        head.name = "head"
        head.fillColor = UIColor(Color(rawValue: SnakeHeadColor ?? ".white") ?? .white)
        head.zPosition = 2
        head.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        head.physicsBody!.categoryBitMask = 0b11
        head.physicsBody!.usesPreciseCollisionDetection = true
        head.position = CGPoint(x: 0, y: -300)
        self.SnakeBody.append(head)
        //self.incrementSnake()
        /*for _ in (0...25) {
            incrementSnake()
         }*/
    }
}
