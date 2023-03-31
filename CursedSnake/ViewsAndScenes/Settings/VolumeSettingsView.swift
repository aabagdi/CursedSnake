//
//  SoundSettingsView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/11/23.
//

import SwiftUI
import Foundation


struct VolumeSettingsView: View {
    @AppStorage("MusicVol") private var musicVol: Double = 0.5
    @AppStorage("SoundVol") private var soundVol: Double = 1.0
    
    var body: some View {
        List {
            VStack{
                HStack{
                    Text("-")
                    Slider(value: $musicVol,
                           in: 0.0...1.0)
                    
                    Text("+")
                }
                Text("Music Volume")
            }.listRowSeparator(.hidden)
            
            VStack {
                HStack{
                    Text("-")
                    Slider(value: $soundVol,
                           in: 0.0...1.0)
                    
                    Text("+")
                }
                Text("Sound Volume")
            }
        }
    }
}

struct SoundSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeSettingsView()
    }
}
