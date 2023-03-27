//
//  DifficultyView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/26/23.
//

import SwiftUI

var currentDifficulty : String {
    let currentSpeed = UserDefaults.standard.float(forKey: "Difficulty")
    switch currentSpeed {
    case 1.3:
        return "Pansy"
    
    case 1.15:
        return "Easy"
        
    case 1.0:
        return "Normal"
    
    case 0.85:
        return "Hard"
    
    case 0.7:
        return "Cracked"
        
    default:
        return "Normal"
    }
}

struct DifficultyView: View {

    @State var difficultyString : String = currentDifficulty
    
    private var DifficultyList : [String] = ["Pansy", "Easy", "Normal", "Hard", "Cracked"]
    
    var body: some View {
        List {
            VStack {
                Picker("Choose your difficulty!!", selection: $difficultyString) {
                    ForEach(DifficultyList, id: \.self) {
                        item in Text(item)
                    }
                }
            }
        }.onDisappear() {
            switch difficultyString {
            case "Pansy":
                UserDefaults.standard.set(1.3, forKey: "Difficulty")
                
            case "Easy":
                UserDefaults.standard.set(1.15, forKey: "Difficulty")
            
            case "Normal":
                UserDefaults.standard.set(1.0, forKey: "Difficulty")
                
            case "Hard":
                UserDefaults.standard.set(0.85, forKey: "Difficulty")
            
            case "Cracked":
                UserDefaults.standard.set(0.7, forKey: "Difficulty")
                
            default:
                UserDefaults.standard.set(1.0, forKey: "Difficulty")
            }
            
        }
    }
}

struct DifficultyView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyView()
    }
}
