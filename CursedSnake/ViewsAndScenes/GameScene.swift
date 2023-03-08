import SpriteKit
import SwiftUI
import UIKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: Snake!
    private var food: SKSpriteNode!
    private var score: SKLabelNode!
    private var soundPlayer: AudioPlayer!
    private var BGMPlayer: AudioPlayer!
    
    func randomPosition() -> CGPoint {
        let randX = CGFloat.random(in: frame.minX + 29...frame.maxX - 29)
        let randY = CGFloat.random(in: frame.minY + 29...frame.maxY - 55)
        return CGPoint(x: randX, y: randY)
    }
    
    func generateRandomColor() -> UIColor { //thanks to https://gist.github.com/asarode
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    func genFood() -> SKSpriteNode {
        let food = SKSpriteNode(imageNamed: "Egg.png")
        food.position = randomPosition()
        food.zPosition = 2
        food.setScale(0.03)
        return food
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let snake = Snake()
        snake.SnakeBody.first?.position = CGPoint(x: frame.midX, y: frame.midY - 300)
        let food = genFood()
        self.addChild(food)
        for i in snake.SnakeBody {
            self.addChild(i)
        }
        let initFont = UIFont.familyNames.randomElement()
        let scoreCounter = SKLabelNode(fontNamed: initFont)
        scoreCounter.zPosition = 3
        scoreCounter.text = String(0)
        scoreCounter.fontSize = 65
        scoreCounter.fontColor = generateRandomColor()
        scoreCounter.position = CGPoint(x: frame.midX, y: frame.maxY - 120)
        self.addChild(scoreCounter)
        
        let soundPlayer = AudioPlayer()
        let BGMPlayer = AudioPlayer()
        
        self.player = snake
        self.food = food
        self.score = scoreCounter
        self.soundPlayer = soundPlayer
        self.BGMPlayer = BGMPlayer
        
        self.BGMPlayer.play(sound: "BGM")
        
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        let head = player!.SnakeBody.first
        let headX = head!.position.x
        let headY = head!.position.y
        
        head?.physicsBody?.usesPreciseCollisionDetection = true
        
        switch player!.SnakeDirection {
        case .up:
            /*for i in player!.SnakeBody {
             i.position.y += player!.SnakeSpeed
             }
             head!.position.y += 20*/
            
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY + 20.0), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .down:
            /*for i in player!.SnakeBody {
             i.position.y -= player!.SnakeSpeed
             }
             head!.position.y -= 20*/
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY - 20.0), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
            
        case .left:
            /*for i in player!.SnakeBody {
             i.position.x -= player!.SnakeSpeed
             }
             head!.position.x -= 20*/
            let moveAction = SKAction.move(to: CGPoint(x: headX - 20.0, y: headY), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            //player!.incrementSnake()
            //self.addChild(player!.SnakeBody.last!)
            player!.moveTail()
            
        case .right:
            /*for i in player!.SnakeBody {
             i.position.x += player!.SnakeSpeed
             }
             head!.position.x += 20*/
            let moveAction = SKAction.move(to: CGPoint(x: headX + 20.0, y: headY), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .dead:
            return
        }
        if head!.intersects(food) {
            self.soundPlayer.play(sound: "Chew")
            let randNum = Int.random(in: 0...100)
            food.removeFromParent()
            let newFood = genFood()
            self.addChild(newFood)
            if randNum > 5 {
                player!.incrementSnake()
                self.addChild(player.SnakeBody.last!)
                self.score.fontName = UIFont.familyNames.randomElement()
                self.score.fontColor = generateRandomColor()
                self.score.text = String(Int(self.score.text!)! + 1)
            }
            else {
                self.soundPlayer.play(sound: "Omg")
                for _  in (0...player!.returnLength()) {
                    player!.incrementSnake()
                    self.addChild(player.SnakeBody.last!)
                }
                self.score.fontName = UIFont.familyNames.randomElement()
                self.score.fontColor = generateRandomColor()
                self.score.text = String(Int(self.score.text!)! - 1)
                
            }
            self.food = newFood
        }
        
        if player!.returnLength() >= 15 {
            player!.SnakeSpeed = 0.15
        }
        
        if player!.returnLength() >= 20 {
            player!.SnakeSpeed = 0.1
        }
        
        if player!.returnLength() >= 35 {
            player!.SnakeSpeed = 0.08
        }
        
        if player!.returnLength() >= 50 {
            player!.SnakeSpeed = 0.06
        }
        
        if player!.returnLength() >= 85 {
            player!.SnakeSpeed = 0.04
        }
        
        if player!.returnLength() >= 100 {
            player!.SnakeSpeed = 0.03
        }
        
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
            scene?.view?.isPaused.toggle()
            if BGMPlayer.isPlaying() {
                BGMPlayer.pause()
            }
            else {
                BGMPlayer.resume()
            }
        }
        else if touchedNode.name == "returnToMenu" {
            let vc = UIHostingController(rootView: TitleView())
            // TODO: are there any edge cases when wither view or window are nil?
            self.view!.window!.rootViewController = vc
        }
        
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        if player!.SnakeDirection != .left && player!.SnakeDirection != .right {
            player!.changeDirection(direction: .right)
        }
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        if player!.SnakeDirection != .right && player!.SnakeDirection != .left {
            player!.changeDirection(direction: .left)
        }
    }
    
    @objc func swipeUp(sender: UISwipeGestureRecognizer) {
        if player!.SnakeDirection != .down && player!.SnakeDirection != .down{
            player!.changeDirection(direction: .up)
        }
    }
    
    @objc func swipeDown(sender: UISwipeGestureRecognizer) {
        if player!.SnakeDirection != .up && player!.SnakeDirection != .down {
            player!.changeDirection(direction: .down)
        }
    }
    
    func windowHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func windowWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func goToGameScene() {
        let screenWidth = self.windowWidth()
        let screenHeight = self.windowHeight()
        let gameScene: GameScene = GameScene(size: CGSize(width: screenWidth, height: screenHeight))
        self.view!.presentScene(gameScene)
    }
    
    func submitScore() async {
        let currentScore = Int(self.score.text!)
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.loadLeaderboards(IDs:["com.aabagdi.CursedSnake.DailyTopScores"]) { (fetchedLBs, error) in
                guard let lb = fetchedLBs?.first else { return }
                guard let endDate = lb.startDate?.addingTimeInterval(lb.duration), endDate > Date() else { return }
                lb.submitScore(currentScore!, context: 0, player: GKLocalPlayer.local) { error in }
                //GKLeaderboard.submitScore(currentScore!, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.DailyTopScores"], completionHandler: { error in })
                print("Woo")
            }
        }
    }
    
    func endGame() {
        self.BGMPlayer.stop()
        self.soundPlayer.play(sound: "Explosion")
        
        Task {
            await submitScore()
        }
        
        let gameOver = SKLabelNode(fontNamed: "Zapfino")
        
        let moveIntoView = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: 5)
        let moveDown = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY - 100), duration: 2)
        let rotate = SKAction.rotate(byAngle: 20 * Double.pi, duration: 5)
        let fadeAway = SKAction.fadeOut(withDuration: 1.5)
        let explode = SKAction.scale(by: 30, duration: 1.5)
        
        let returnToMenu = SKLabelNode(fontNamed: "Party LET")
        returnToMenu.zPosition = 3
        returnToMenu.text = "Tap to return to main menu"
        returnToMenu.fontSize = 50
        returnToMenu.fontColor = .cyan
        returnToMenu.position = CGPoint(x: self.frame.midX - 500, y: self.frame.midY)
        self.addChild(returnToMenu)
        
        gameOver.zPosition = 3
        gameOver.text = "Game over, hmbpmhpbhmh"
        gameOver.fontSize = 24
        gameOver.fontColor = SKColor.white
        gameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 550)
        self.addChild(gameOver)
        for i in player!.SnakeBody {
            let nodeCopy = i
            i.removeFromParent()
            nodeCopy.physicsBody = nil
            nodeCopy.fillColor = SKColor.orange
            self.addChild(nodeCopy)
            nodeCopy.run(explode)
            nodeCopy.run(fadeAway, completion: {() -> Void in
                nodeCopy.removeFromParent()
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
