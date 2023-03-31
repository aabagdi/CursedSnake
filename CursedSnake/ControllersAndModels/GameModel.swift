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
            let currDiff = UserDefaults.standard.string(forKey: "Difficulty")
            if (GKLocalPlayer.local.isAuthenticated) {
                switch currDiff {
                case "Pansy":
                    try! await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.AllTimePansy"])
                    print("Pansy")
                    
                case "Easy":
                    try! await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.AllTimeEasy"])
                    print("Easy")
                
                case "Hard":
                    try! await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.AllTimeHard"])
                    print("Hard")
                    
                case "Cracked":
                    try! await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.AllTimeCracked"])
                    print("Cracked")
                
                default:
                    try! await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.aabagdi.CursedSnake.AllTimeNormal"])
                    print("Normal")
                }
            }
        }
        
        func calcAchievements(score: Int, claw: Bool, scoreCounter: Bool) {
            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
                let fifteenID = "15"
                var fifteenAchievement: GKAchievement? = nil
                
                // Find an existing achievement.
                fifteenAchievement = achievements?.first(where: { $0.identifier == fifteenID})

                
                // Otherwise, create a new achievement.
                if fifteenAchievement == nil {
                    fifteenAchievement = GKAchievement(identifier: fifteenID)
                }
                
                if score == 15 {
                    fifteenAchievement?.showsCompletionBanner = true
                    fifteenAchievement?.percentComplete = 100
                }
                
                let thirtyID = "30"
                var thirtyAchievement: GKAchievement? = nil
            
                thirtyAchievement = achievements?.first(where: { $0.identifier == thirtyID})

                if thirtyAchievement == nil {
                    thirtyAchievement = GKAchievement(identifier: thirtyID)
                }
                
                if score == 30 {
                    thirtyAchievement?.showsCompletionBanner = true
                    thirtyAchievement?.percentComplete = 100
                }
                
                let fiftyID = "50"
                var fiftyAchievement: GKAchievement? = nil
                
                fiftyAchievement = achievements?.first(where: { $0.identifier == fiftyID})

                if fiftyAchievement == nil {
                    fiftyAchievement = GKAchievement(identifier: fiftyID)
                }
                
                if score == 50 {
                    fiftyAchievement?.showsCompletionBanner = true
                    fiftyAchievement?.percentComplete = 100
                }
                
                let hundredID = "100"
                var hundredAchievement: GKAchievement? = nil

                hundredAchievement = achievements?.first(where: { $0.identifier == hundredID})

                if hundredAchievement == nil {
                    hundredAchievement = GKAchievement(identifier: hundredID)
                }
                
                if score == 100 {
                    hundredAchievement?.showsCompletionBanner = true
                    hundredAchievement?.percentComplete = 100
                }

                let negativeID = "1"
                var negativeAchievement: GKAchievement? = nil

                negativeAchievement = achievements?.first(where: { $0.identifier == negativeID})

                if negativeAchievement == nil {
                    negativeAchievement = GKAchievement(identifier: negativeID)
                }
                
                if score < 0 {
                    negativeAchievement?.showsCompletionBanner = true
                    negativeAchievement?.percentComplete = 100
                }
                
                let clawID = "69"
                var clawAchievement: GKAchievement? = nil

                clawAchievement = achievements?.first(where: { $0.identifier == clawID})

                if clawAchievement == nil {
                    clawAchievement = GKAchievement(identifier: clawID)
                }
                
                if claw {
                    clawAchievement?.showsCompletionBanner = true
                    clawAchievement?.percentComplete = 100
                }
                
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
                
                let scoreCounterID = "2"
                var scoreCounterAchievement: GKAchievement? = nil

                scoreCounterAchievement = achievements?.first(where: { $0.identifier == scoreCounterID})

                if scoreCounterAchievement == nil {
                    scoreCounterAchievement = GKAchievement(identifier: scoreCounterID)
                }
                
                if scoreCounter {
                    scoreCounterAchievement?.showsCompletionBanner = true
                    scoreCounterAchievement?.percentComplete = 100
                }
                
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
                
                // Insert code to report the percentage.
            
                let achievementsToReport: [GKAchievement] = [fifteenAchievement!, thirtyAchievement!, fiftyAchievement!, hundredAchievement!, clawAchievement!, negativeAchievement!, scoreCounterAchievement!]
                
                GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                    if error != nil {
                        print("Error: \(String(describing: error))")
                    }
                })
            })
        }
    }

}
