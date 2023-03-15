//
//  SoundSettingsView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/11/23.
//

import SwiftUI
import Foundation


struct SoundSettingsView: View {
    @State var musicVol: Float = UserDefaults.standard.float(forKey: "MusicVol")
    
    @State var soundVol: Float = UserDefaults.standard.float(forKey: "SoundVol")
    
    var body: some View {
        List {
            VStack{
                Slider(value: $musicVol,
                       in: 0.0...1.0,
                       onEditingChanged: {_ in
                    UserDefaults.standard.set(musicVol, forKey: "MusicVol")
                })
                Text("Music Volume")
            }
            
            VStack{
                Slider(value: $soundVol,
                       in: 0.0...1.0,
                       onEditingChanged: {_ in
                    UserDefaults.standard.set(soundVol, forKey: "SoundVol")
                })
                Text("Sound Volume")
            }
        }
    }
}

struct SoundSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettingsView()
    }
}
