//
//  SettingsView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 3/11/23.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    let settings: Array<Setting> = [
        Setting(title: "Volume", color: .red, imageName: "speaker.wave.2.fill"),
        Setting(title: "Background Music", color: .blue, imageName: "music.note"),
        Setting(title: "Game Difficulty", color: .gray, imageName: "dumbbell.fill"),
        Setting(title: "Snake Color", color: .purple, imageName: "pencil.tip.crop.circle"),
        Setting(title: "Game Statistics", color: .orange, imageName: "list.bullet.clipboard"),
        Setting(title: "Credits", color: .yellow, imageName: "text.alignleft")
    ]
    var body: some View {
        NavigationStack {
            List {
                ForEach(settings, id: \.self) { setting in
                    NavigationLink(destination: RootSettingView(viewToDisplay: setting.title)) {
                        HStack {
                            SettingImage(color: setting.color, imageName: setting.imageName)
                            Text(setting.title)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct SettingImage: View {
    let color: Color
    let imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .foregroundColor(color)
            .frame(width: 25, height: 25)
    }
}


struct Setting: Hashable {
  let title: String
  let color: Color
  let imageName: String
}

