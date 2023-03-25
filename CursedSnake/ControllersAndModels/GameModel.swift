//
//  GameModel.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/25/23.
//

import Foundation
import GameKit
import SpriteKit

extension GameScene {
    struct GameModel {
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
            let randNum = Int.random(in: 1...1001)
            if randNum < 2 {
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
        
        func submitScore(score: Int) async {
            if (GKLocalPlayer.local.isAuthenticated) {
                GKLeaderboard.loadLeaderboards(IDs:["com.aabagdi.CursedSnake.DailyTopScores"]) { (fetchedLBs, error) in
                    guard let daily = fetchedLBs?.first else { return }
                    daily.submitScore(score, context: 0, player: GKLocalPlayer.local) { error in }
                    print("Woo")
                }
            }
        }
        
        func calcAchievements(score: Int, claw: Bool) {
            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
                let fifteenID = "15"
                var fifteenAchievement: GKAchievement? = nil
                
                // Find an existing achievement.
                fifteenAchievement = achievements?.first(where: { $0.identifier == fifteenID})
                
                // Otherwise, create a new achievement.
                if fifteenAchievement == nil {
                    fifteenAchievement = GKAchievement(identifier: fifteenID)
                }
                
                if score >= 15 {
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
                
                if score >= 30 {
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
                
                if score >= 50 {
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
                
                if score >= 100 {
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
                
                if score < 0 {
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
                
                if claw {
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
    }

}
