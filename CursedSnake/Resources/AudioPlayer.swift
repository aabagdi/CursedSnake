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
        self.AudioPlayer.play()
    }
    
    func triggerLoop() {
        self.AudioPlayer.numberOfLoops = -1
    }
    
    func stop() {
        self.AudioPlayer.stop()
    }
    
    func pause() {
        self.AudioPlayer.pause()
    }
    
    func resume() {
        self.AudioPlayer.play()
    }
    
    func isPlaying() -> Bool {
        return self.AudioPlayer.isPlaying
    }
    
    func getVol() -> Float {
        return self.AudioPlayer.volume
    }
    
    func setVol(newVol: Float) {
        self.AudioPlayer.volume = newVol
    }
}
