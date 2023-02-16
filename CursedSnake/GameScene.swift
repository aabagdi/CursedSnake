import SpriteKit
import UIKit


class GameScene: SKScene {
    private var player: Snake!
    private var food: SKSpriteNode!
    private var score: SKLabelNode!
    
    func randomPosition() -> CGPoint {
        let randX = CGFloat.random(in: frame.minX + 29...frame.maxX - 29)
        let randY = CGFloat.random(in: frame.minY + 29...frame.maxY - 50)
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
        
        self.player = snake
        self.food = food
        self.score = scoreCounter
        
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
            let randNum = Int.random(in: 0...100)
            food.removeFromParent()
            let newFood = genFood()
            self.addChild(newFood)
            if randNum > 10 {
                player!.incrementSnake()
                self.addChild(player.SnakeBody.last!)
                self.score.fontName = UIFont.familyNames.randomElement()
                self.score.fontColor = generateRandomColor()
                self.score.text = String(Int(self.score.text!)! + 1)
            }
            else {
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
        
        if head!.position.x < frame.minX || head!.position.x > frame.maxX {
            player!.changeDirection(direction: .dead)
            endGame()
        }
        
        if head!.position.y < frame.minY || head!.position.y > frame.maxY {
            player!.changeDirection(direction: .dead)
            endGame()
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
    
    func endGame() {
        for i in player!.SnakeBody.reversed() {
            let fadeAway = SKAction.fadeOut(withDuration: 4.0)
            i.run(fadeAway, completion: {() -> Void in
                print("faded")
                i.removeFromParent()
            })
        }
        food.removeFromParent()
        let gameOver = SKLabelNode(fontNamed: "Zapfino")
        let moveIntoView = SKAction.move(to: CGPoint(x: frame.midX, y: frame.midY), duration: 5)
        let rotate = SKAction.rotate(byAngle: 20 * Double.pi, duration: 5)
        gameOver.zPosition = 3
        gameOver.text = "Game over, hmbpmhpbhmh"
        gameOver.fontSize = 25
        gameOver.fontColor = SKColor.white
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY - 550)
        self.addChild(gameOver)
        gameOver.run(moveIntoView)
        gameOver.run(rotate)
        return
    }
}
