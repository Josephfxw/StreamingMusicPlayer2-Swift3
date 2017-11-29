//
//  Player.swift
//  MusicPlayerSwift3
//
//  Created by Joseph Fan on 6/15/17.


import Foundation
import MediaPlayer

class Player
{
    var avPlayer: AVPlayer!
    
    init () {
        avPlayer = AVPlayer()
    }
    
    func playStream (_ fileUrl: String) {
        if let url = URL(string: fileUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
            
            avPlayer = AVPlayer(url: url)
            avPlayer.play()
            
            //setPlayingScreen(fileUrl)
            
            //print("Playing stream")
        }
    }
    
    func playAudio () {
        if (avPlayer.rate == 0 && avPlayer.error == nil) {
            avPlayer.play()
        }
    }
    
    func pauseAudio () {
        if (avPlayer.rate > 0 && avPlayer.error == nil) {
            avPlayer.pause()
        }
    }
    
    func setPlayingScreen (_ fileUrl: String) {
        let urlArray = fileUrl.characters.split{$0 == "/"}.map(String.init)
        
        let name = urlArray[urlArray.endIndex-1]
        
        //print(name)
        
        let songInfo = [
            MPMediaItemPropertyTitle: name,
            MPMediaItemPropertyArtist: "Penny Play"
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        
    }
    
    
}







