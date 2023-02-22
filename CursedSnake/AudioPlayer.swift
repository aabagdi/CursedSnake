//
//  AudioPlayer.swift
//  CursedSnake
//
//  Created by Aadit Bagdi on 2/16/23.
//

import AVFoundation

class AudioPlayer {
    private var AudioPlayer: AVAudioPlayer!
    
    func play(sound: String) {
        let soundEffect = Bundle.main.url(forResource: sound, withExtension: "mp3")
        self.AudioPlayer = try! AVAudioPlayer(contentsOf: soundEffect!)
        self.AudioPlayer.prepareToPlay()
        if sound == "Megadeth" {
            self.AudioPlayer.volume = 0.5
            self.AudioPlayer.numberOfLoops = -1
        }
        self.AudioPlayer?.play()
    }
    
    func pause() {
        self.AudioPlayer.pause()
    }
    
}
