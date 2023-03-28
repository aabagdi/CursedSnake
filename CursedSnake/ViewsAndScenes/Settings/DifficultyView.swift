//
//  DifficultyView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/26/23.
//

import SwiftUI

struct DifficultyView: View {
    
    @AppStorage("Difficulty") private var difficulty : String = "Normal"
    
    private var DifficultyList : [String] = ["Pansy", "Easy", "Normal", "Hard", "Cracked"]
    
    var body: some View {
        List {
            VStack {
                Picker("Choose your difficulty!!", selection: $difficulty) {
                    ForEach(DifficultyList, id: \.self) {
                        item in Text(item)
                    }
                }
            }
        }
    }
}

struct DifficultyView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultyView()
    }
}
