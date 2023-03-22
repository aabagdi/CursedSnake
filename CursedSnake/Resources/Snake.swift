//
//  Snake.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 1/20/23.
//

import Foundation
import SpriteKit

class Snake {
    enum SnakeStates {
        case up
        case down
        case left
        case right
        case dead
    }
    
    var SnakeDirection: SnakeStates = .up
    var SnakeSpeed: CGFloat
    
    var SnakeBody = [SKShapeNode]()
    
    func returnLength() -> Int {
        return SnakeBody.count
    }
    
    func incrementSnake() {
        let newSegment = SKShapeNode(circleOfRadius: 5)
        newSegment.name = "body"
        newSegment.fillColor = .white
        newSegment.zPosition = 2
        newSegment.physicsBody = SKPhysicsBody(circleOfRadius: 3)
        newSegment.physicsBody!.contactTestBitMask = 0b11
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
    
    func moveTail() {
        if self.returnLength() > 1 {
            for i in (1...(self.returnLength() - 1)).reversed() {
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
    
    init() {
        let head = SKShapeNode(ellipseOf: CGSize(width: 20, height: 35))
        head.name = "head"
        head.fillColor = .white
        head.zPosition = 2
        head.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        head.physicsBody!.categoryBitMask = 0b11
        head.physicsBody!.usesPreciseCollisionDetection = true
        self.SnakeBody.append(head)
        self.SnakeSpeed = 0.2
        //self.incrementSnake()
        /*for _ in (0...25) {
         incrementSnake()
         }*/
    }
}
