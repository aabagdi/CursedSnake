//
//  TitleViewController.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/27/23.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

class TitleViewController : UIViewController {
    
    let titleScreen = UIHostingController(rootView: TitleView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            addChild(titleScreen)
            view.addSubview(titleScreen.view)
            titleScreen.didMove(toParent: self)
            setupConstraints()
        }
    }
    
    override func loadView() {
        self.view = SKView()
    }
    
    fileprivate func setupConstraints() {
        titleScreen.view.translatesAutoresizingMaskIntoConstraints = false
        titleScreen.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        titleScreen.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        titleScreen.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        titleScreen.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
