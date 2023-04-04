//
//  StatsView.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 4/3/23.
//

import SwiftUI

struct StatsView: View {
    @State private var showReset : Bool = false
    @State private var highScore : Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var deaths : Int = UserDefaults.standard.integer(forKey: "Deaths")
    @State private var food : Int = UserDefaults.standard.integer(forKey: "Food")
    @State private var maxLength : Int = UserDefaults.standard.integer(forKey: "MaxLength")
    
    var body: some View {
        List {
            HStack {
                Text("High score")
                Spacer()
                Text(String(highScore))
                    .foregroundColor(.secondary)
            }.swipeActions(allowsFullSwipe: false) {
                Button("Reset") {
                    highScore = 0
                    UserDefaults.standard.set(0, forKey: "HighScore")
                }
                .tint(.red)
            }
            
            HStack {
                Text("Number of deaths")
                Spacer()
                Text(String(deaths))
                    .foregroundColor(.secondary)
            }.swipeActions(allowsFullSwipe: false) {
                Button("Reset") {
                    deaths = 0
                    UserDefaults.standard.set(0, forKey: "Deaths")
                }
                .tint(.red)
            }
            
            HStack {
                Text("Food eaten")
                Spacer()
                Text(String(food))
                    .foregroundColor(.secondary)
            }.swipeActions(allowsFullSwipe: false) {
                Button("Reset") {
                    food = 0
                    UserDefaults.standard.set(0, forKey: "Food")
                }
                .tint(.red)
            }
            
            HStack {
                Text("Longest snake")
                Spacer()
                Text(String(maxLength))
                    .foregroundColor(.secondary)
            }.swipeActions(allowsFullSwipe: false) {
                Button("Reset") {
                    maxLength = 0
                    UserDefaults.standard.set(0, forKey: "MaxLength")
                }
                .tint(.red)
            }
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
