//
//  AudioPlayer.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/16/23.
//

import AVFoundation

class AudioPlayer {
    private var chordPlayer: AVAudioPlayer!
    
    func play(sound: String) {
        let soundEffect = Bundle.main.url(forResource: sound, withExtension: "mp3")
        self.chordPlayer = try! AVAudioPlayer(contentsOf: soundEffect!)
        self.chordPlayer?.play()
    }
    
}
