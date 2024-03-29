//
//  BackgroundMusicView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/15/23.
//

import SwiftUI

struct BGMSettingsView: View {
    @AppStorage("BGM") private var selectedBGM: String = "Cursed Snake Theme"
    
    private var BGMList: [String] = ["Cursed Snake Theme", "Cursed Pong Theme", "Aadit's Presidential Breakdown"]
    
    var body: some View {
        List {
            VStack {
                Picker("Choose your background music!!", selection: $selectedBGM) {
                    ForEach(BGMList, id: \.self) {
                        item in Text(item)
                        
                    }
                }
            }
        }
    }
}
