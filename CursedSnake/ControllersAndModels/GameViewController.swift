import UIKit
import SpriteKit
import SwiftUI

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .fill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func loadView() {
        self.view = SKView()
    }
}

struct GameViewControllerRepresentable : UIViewControllerRepresentable {
    typealias UIViewControllerType = GameViewController
    
    func makeUIViewController(context: Context) -> GameViewController {
        let vc = GameViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: GameViewController, context: Context) {
        
    }
}
