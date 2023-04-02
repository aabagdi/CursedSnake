import Foundation
import GameplayKit
import SwiftUI
import SpriteKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: Snake!
    private var food: SKSpriteNode!
    private var score: SKLabelNode!
    private var soundPlayer: AudioPlayer!
    private var BGMPlayer: AudioPlayer!
    private var GestureRecognizers: [UIGestureRecognizer] = []
    private var encounteredClaw : Bool = false
    private var SnakeModel : GameModel = GameModel()
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let snake = Snake()
        let body = snake.getBody()
        let food = SnakeModel.genFood()
        self.addChild(food)
        for i in body {
            self.addChild(i)
        }
        let randFont = UIFont.familyNames.randomElement()
        let scoreCounter = SKLabelNode(fontNamed: randFont)
        scoreCounter.zPosition = 3
        scoreCounter.text = "0"
        scoreCounter.fontSize = 65
        scoreCounter.fontColor = SnakeModel.generateRandomColor()
        scoreCounter.position = CGPoint(x: 0, y: 312)
        scoreCounter.name = "ScoreCounter"
        self.addChild(scoreCounter)
        
        let soundPlayer = AudioPlayer()
        let BGMPlayer = AudioPlayer()
        
        self.player = snake
        self.food = food
        self.score = scoreCounter
        self.soundPlayer = soundPlayer
        self.BGMPlayer = BGMPlayer
        
        self.BGMPlayer.play(sound: UserDefaults.standard.string(forKey: "BGM") ?? "Cursed Snake Theme")
        self.BGMPlayer.fadeIn(vol: UserDefaults.standard.float(forKey: "MusicVol"), duration: 0.5)
        self.BGMPlayer.triggerLoop()
        
        let swipeRight = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(GameScene.swipeRight(sender:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(GameScene.swipeLeft(sender:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self,
                                               action: #selector(GameScene.swipeUp(sender:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self,
                                                 action: #selector(GameScene.swipeDown(sender:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
        self.GestureRecognizers = [swipeUp, swipeDown, swipeLeft, swipeRight]
    }
    
    override func update(_ currentTime: TimeInterval) {
        let head = player!.getBody().first
        let speed = player.getSpeed()
        let headX = head!.position.x
        let headY = head!.position.y
        let snakeLength = player!.getLength()
        
        head?.physicsBody?.usesPreciseCollisionDetection = true
        
        switch player!.getDirection() {
        case .up:
            
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY + 20.0), duration: speed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .down:
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY - 20.0), duration: speed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .left:
            let moveAction = SKAction.move(to: CGPoint(x: headX - 20.0, y: headY), duration: speed)
            head!.run(moveAction)
            //player!.incrementSnake()
            //self.addChild(player!.SnakeBody.last!)
            player!.moveTail()
            
        case .right:
            let moveAction = SKAction.move(to: CGPoint(x: headX + 20.0, y: headY), duration: speed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .dead:
            return
        }
        if head!.intersects(food) {
            let newFood = SnakeModel.genFood()
            self.addChild(newFood)
            food.removeFromParent()
            self.score.fontName = UIFont.familyNames.randomElement()
            self.score.fontColor = SnakeModel.generateRandomColor()
            if food.name == "Egg" {
                let randNum = GKRandomSource.sharedRandom().nextInt(upperBound: 99)
                if randNum < 1 {
                    self.soundPlayer.play(sound: "Omg")
                    self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                    for _  in (0...snakeLength) {
                        player!.incrementSnake()
                        self.addChild(player.getBody().last!)
                    }
                    self.score.text = String(Int(self.score.text!)! - 1)
                }
                else {
                    self.soundPlayer.play(sound: "Chew")
                    self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                    player!.incrementSnake()
                    self.addChild(player.getBody().last!)
                    self.score.text = String(Int(self.score.text!)! + 1)
                }
            }
            else {
                self.encounteredClaw = true
                self.soundPlayer.play(sound: "Claw")
                self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                self.score.text = String(Int(self.score.text!)! + 69)
            }
            self.food = newFood
            SnakeModel.calcAchievements(score: Int(self.score.text!)!, claw: self.encounteredClaw, scoreCounter: false)
        }
        if head!.intersects(self.score) && self.score.fontName == "Adam\'s Font" {
                player!.changeDirection(direction: .dead)
                SnakeModel.calcAchievements(score: Int(self.score.text!)!, claw: self.encounteredClaw, scoreCounter: true)
                endGame()
            }
        
        player.lengthDependentSpeed()
        
        if head!.position.x < frame.minX || head!.position.x > frame.maxX {
            player!.changeDirection(direction: .dead)
            endGame()
        }
        
        if head!.position.y < frame.minY || head!.position.y > frame.maxY {
            player!.changeDirection(direction: .dead)
            endGame()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.parent == nil {
            return
        }
        if contact.bodyA.node?.name == "head" || contact.bodyB.node?.name == "head" {
            player!.changeDirection(direction: .dead)
            endGame()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touches:UITouch = touches.first!
        let touchPos = touches.location(in: self)
        let touchedNode = self.atPoint(touchPos)
        if touchedNode.name == "Pause" {
            pauseUnpause()
        }
        else if touchedNode.name == "returnToMenu" {
            let vc = UIHostingController(rootView: TitleView())
            // TODO: are there any edge cases when wither view or window are nil?
            self.view!.window!.rootViewController = vc
        }
        
    }
    
    func pauseUnpause() {
        scene?.view?.isPaused.toggle()
        switch scene?.view?.isPaused {
        case true:
            soundPlayer.play(sound: "Pause")
            self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
            self.BGMPlayer.fadeOut(duration: 0.5)
            for recognizer in GestureRecognizers {
                view?.removeGestureRecognizer(recognizer)
            }
        case false:
            soundPlayer.play(sound: "Unpause")
            self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
            BGMPlayer.fadeIn(vol: UserDefaults.standard.float(forKey: "MusicVol"), duration: 0.7)
            for recognizer in GestureRecognizers {
                view?.addGestureRecognizer(recognizer)
            }
            
        default:
            break
        }
    }
    
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        if player!.getDirection() != .left && player!.getDirection() != .right {
            player!.changeDirection(direction: .right)
        }
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        if player!.getDirection() != .right && player!.getDirection() != .left {
            player!.changeDirection(direction: .left)
        }
    }
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        if player!.getDirection() != .down && player!.getDirection() != .up {
            player!.changeDirection(direction: .up)
        }
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        if player!.getDirection() != .up && player!.getDirection() != .down {
            player!.changeDirection(direction: .down)
        }
    }
    
    func endGame() {
        self.BGMPlayer.fadeOut(duration: 0.3)
        self.soundPlayer.play(sound: "Explosion")
        self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
        Task {
            await SnakeModel.submitScore(score: Int(self.score.text!)!)
        }
        let body = player.getBody()
        let gameOver = SKLabelNode(fontNamed: "Zapfino")
        let moveIntoView = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 5)
        let moveDown = SKAction.move(to: CGPoint(x: 0, y: -100), duration: 2)
        let rotate = SKAction.rotate(byAngle: 20 * Double.pi, duration: 5)
        let fadeAway = SKAction.fadeOut(withDuration: 1.5)
        let explode = SKAction.scale(by: 30, duration: 1.5)
        
        let returnToMenu = SKLabelNode(fontNamed: "Party LET")
        returnToMenu.zPosition = 3
        returnToMenu.text = "Tap to return to main menu"
        returnToMenu.fontSize = 50
        returnToMenu.fontColor = .cyan
        returnToMenu.position = CGPoint(x: -500, y: 0)
        self.addChild(returnToMenu)
        
        gameOver.zPosition = 3
        gameOver.text = "Game over, hmbpmhpbhmh"
        gameOver.fontSize = 24
        gameOver.fontColor = SKColor.white
        gameOver.position = CGPoint(x: 0, y: -550)
        self.addChild(gameOver)
        for i in body {
            i.physicsBody = nil
            i.fillColor = SKColor.orange
            i.run(explode)
            i.run(fadeAway, completion: {() -> Void in
                i.removeFromParent()
            })
        }
        self.food.run(fadeAway, completion: {() -> Void in
            self.food.removeFromParent()
        })
        
        let pauseButton = self.childNode(withName: "Pause")
        pauseButton!.removeFromParent()
        gameOver.run(moveIntoView)
        gameOver.run(rotate, completion: {
            returnToMenu.run(moveIntoView, completion: {
                returnToMenu.run(moveDown, completion: {
                    returnToMenu.name = "returnToMenu"
                })
            })
        })
    }
}
