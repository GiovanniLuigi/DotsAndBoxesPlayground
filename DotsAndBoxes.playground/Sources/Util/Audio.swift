import Foundation
import AVFoundation

var backgroundMusicPlayer: AVAudioPlayer!
func playBackgroundMusic(filename: String) {
    let resourceUrl = Bundle.main.url(forResource:
        filename, withExtension: nil)
    guard let url = resourceUrl else {
        print("Could not find file: \(filename)")
        return
    }
    do {
        try backgroundMusicPlayer =
            AVAudioPlayer(contentsOf: url)
        backgroundMusicPlayer.stop()
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.rate = 0.005
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    } catch {
        print("Could not create audio player!")
        return
    }
}
