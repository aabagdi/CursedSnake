import Foundation
import SwiftUI
import SpriteKit
import UIKit
import GameKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: Snake!
    private var food: SKSpriteNode!
    private var score: SKLabelNode!
    private var soundPlayer: AudioPlayer!
    private var BGMPlayer: AudioPlayer!
    private var GestureRecognizers: [UIGestureRecognizer] = []
    private var randomDist: GKRandomDistribution!
    private var encounteredClaw : Bool = false
    
    func randomPosition() -> CGPoint {
        let randX = CGFloat.random(in: -166...166)
        let randY = CGFloat.random(in: -408...367)
        return CGPoint(x: randX, y: randY)
    }
    
    func generateRandomColor() -> UIColor { //thanks to https://gist.github.com/asarode
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    
    func genFood() -> SKSpriteNode {
        let randNum = Int.random(in: 0...10000)
        if randNum < 1 {
            let claw = SKSpriteNode(imageNamed: "Claw.png")
            claw.position = randomPosition()
            claw.zPosition = 2
            claw.setScale(0.1)
            claw.name = "Claw"
            return claw
        }
        let food = SKSpriteNode(imageNamed: "Egg.png")
        food.position = randomPosition()
        food.zPosition = 2
        food.setScale(0.03)
        food.name = "Egg"
        return food
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let snake = Snake()
        snake.SnakeBody.first?.position = CGPoint(x: 0, y: -300)
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
        scoreCounter.position = CGPoint(x: 0, y: 312)
        scoreCounter.name = "ScoreCounter"
        self.addChild(scoreCounter)
        
        let soundPlayer = AudioPlayer()
        let BGMPlayer = AudioPlayer()
        let dist = GKRandomDistribution(randomSource: GKMersenneTwisterRandomSource(), lowestValue: 1, highestValue: 101)
        
        self.player = snake
        self.food = food
        self.score = scoreCounter
        self.soundPlayer = soundPlayer
        self.BGMPlayer = BGMPlayer
        self.randomDist = dist
        
        self.BGMPlayer.play(sound: UserDefaults.standard.string(forKey: "BGM") ?? "Cursed Snake Theme")
        self.BGMPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "MusicVol"))
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
        let head = player!.SnakeBody.first
        let headX = head!.position.x
        let headY = head!.position.y
        
        head?.physicsBody?.usesPreciseCollisionDetection = true
        
        switch player!.SnakeDirection {
        case .up:
            
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY + 20.0), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .down:
            let moveAction = SKAction.move(to: CGPoint(x: headX, y: headY - 20.0), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .left:
            let moveAction = SKAction.move(to: CGPoint(x: headX - 20.0, y: headY), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            //player!.incrementSnake()
            //self.addChild(player!.SnakeBody.last!)
            player!.moveTail()
            
        case .right:
            let moveAction = SKAction.move(to: CGPoint(x: headX + 20.0, y: headY), duration: player!.SnakeSpeed)
            head!.run(moveAction)
            player!.moveTail()
            
        case .dead:
            return
        }
        if head!.intersects(food) {
            let newFood = genFood()
            self.addChild(newFood)
            food.removeFromParent()
            self.score.fontName = UIFont.familyNames.randomElement()
            self.score.fontColor = generateRandomColor()
            if food.name == "Egg" {
                self.soundPlayer.play(sound: "Chew")
                self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                let randNum = self.randomDist.nextInt()
                if randNum > 1 {
                    player!.incrementSnake()
                    self.addChild(player.SnakeBody.last!)
                    self.score.fontName = UIFont.familyNames.randomElement()
                    self.score.fontColor = generateRandomColor()
                    self.score.text = String(Int(self.score.text!)! + 1)
                }
                else {
                    self.soundPlayer.play(sound: "Omg")
                    self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
                    for _  in (0...player!.returnLength()) {
                        player!.incrementSnake()
                        self.addChild(player.SnakeBody.last!)
                    }
                    self.score.text = String(Int(self.score.text!)! - 1)
                }
            }
            else {
                self.encounteredClaw = true
                self.score.text = String(Int(self.score.text!)! + 69)
            }
            self.food = newFood
            calcAchievements()
        }
        if head!.intersects(self.score) {
            if self.score.fontName == "Adam'sFontRegular" {
                player!.changeDirection(direction: .dead)
                endGame()
            }
        }
        
        if player!.returnLength() >= 14 {
            player!.SnakeSpeed = 0.15
        }
        
        if player!.returnLength() >= 19 {
            player!.SnakeSpeed = 0.1
        }
        
        if player!.returnLength() >= 34 {
            player!.SnakeSpeed = 0.08
        }
        
        if player!.returnLength() >= 49 {
            player!.SnakeSpeed = 0.06
        }
        
        if player!.returnLength() >= 84 {
            player!.SnakeSpeed = 0.04
        }
        
        if player!.returnLength() >= 99 {
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
            BGMPlayer.pause()
            for recognizer in GestureRecognizers {
                view?.removeGestureRecognizer(recognizer)
            }
        case false:
            soundPlayer.play(sound: "Unpause")
            self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
            BGMPlayer.resume()
            for recognizer in GestureRecognizers {
                view?.addGestureRecognizer(recognizer)
            }
            
        case .none:
            break
            
        case .some(_):
            break
        }
    }
    
    func calcAchievements() {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let fifteenID = "15"
            var fifteenAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            fifteenAchievement = achievements?.first(where: { $0.identifier == fifteenID})
            
            // Otherwise, create a new achievement.
            if fifteenAchievement == nil {
                fifteenAchievement = GKAchievement(identifier: fifteenID)
            }
            
            if Int(self.score.text!)! >= 15 {
                fifteenAchievement?.showsCompletionBanner = true
                fifteenAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let thirtyID = "30"
            var thirtyAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            thirtyAchievement = achievements?.first(where: { $0.identifier == thirtyID})
            
            // Otherwise, create a new achievement.
            if thirtyAchievement == nil {
                thirtyAchievement = GKAchievement(identifier: thirtyID)
            }
            
            if Int(self.score.text!)! >= 30 {
                thirtyAchievement?.showsCompletionBanner = true
                thirtyAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let fiftyID = "50"
            var fiftyAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            fiftyAchievement = achievements?.first(where: { $0.identifier == fiftyID})
            
            // Otherwise, create a new achievement.
            if fiftyAchievement == nil {
                fiftyAchievement = GKAchievement(identifier: fiftyID)
            }
            
            if Int(self.score.text!)! >= 50 {
                fiftyAchievement?.showsCompletionBanner = true
                fiftyAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let hundredID = "100"
            var hundredAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            hundredAchievement = achievements?.first(where: { $0.identifier == hundredID})
            
            // Otherwise, create a new achievement.
            if hundredAchievement == nil {
                hundredAchievement = GKAchievement(identifier: hundredID)
            }
            
            if Int(self.score.text!)! >= 100 {
                hundredAchievement?.showsCompletionBanner = true
                hundredAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let negativeID = "1"
            var negativeAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            negativeAchievement = achievements?.first(where: { $0.identifier == negativeID})
            
            // Otherwise, create a new achievement.
            if negativeAchievement == nil {
                negativeAchievement = GKAchievement(identifier: negativeID)
            }
            
            if Int(self.score.text!)! < 0 {
                negativeAchievement?.showsCompletionBanner = true
                negativeAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let clawID = "69"
            var clawAchievement: GKAchievement? = nil
            
            // Find an existing achievement.
            clawAchievement = achievements?.first(where: { $0.identifier == clawID})
            
            // Otherwise, create a new achievement.
            if clawAchievement == nil {
                clawAchievement = GKAchievement(identifier: clawID)
            }
            
            if self.encounteredClaw {
                clawAchievement?.showsCompletionBanner = true
                clawAchievement?.percentComplete = 100
            }
            
            // Insert code to report the percentage.
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
            
            let achievementsToReport: [GKAchievement] = [fifteenAchievement!, thirtyAchievement!, fiftyAchievement!, hundredAchievement!, clawAchievement!, negativeAchievement!]
            
            // Report the progress to Game Center.
            GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                if error != nil {
                    // Handle the error that occurs.
                    print("Error: \(String(describing: error))")
                }
            })
        })
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
                guard let daily = fetchedLBs?.first else { return }
                daily.submitScore(currentScore!, context: 0, player: GKLocalPlayer.local) { error in }
                print("Woo")
            }
        }
    }
    
    func endGame() {
        self.BGMPlayer.stop()
        self.soundPlayer.play(sound: "Explosion")
        self.soundPlayer.setVol(newVol: UserDefaults.standard.float(forKey: "SoundVol"))
        Task {
            await submitScore()
        }
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
