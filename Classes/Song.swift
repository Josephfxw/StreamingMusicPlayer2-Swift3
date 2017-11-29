//
//  Song.swift


import Foundation

class Song {
    var id: Int
    var name: String
    var numLikes: Int
    var numPlays: Int
    var artist: String
    
    init? (id: String, name: String, numLikes: String, numPlays: String, artist: String) {
        self.id = Int(id)!
        self.name = name
        self.numLikes = Int(numLikes)!
        self.numPlays = Int(numPlays)!
        self.artist = artist
    }
    
    func getId () -> Int {
        return id
    }
    
    func getName () -> String {
        //return name
        return name.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
    
    func getNumLikes () -> Int {
        return numLikes
    }
    
    func getNumPlays () -> Int {
        return numPlays
    }
    
    func getArtist () -> String {
        return artist
    }
    
    func getCleanName () -> String {
        
        
        
        return name.replacingOccurrences(of: "(.mp3)|( )", with: "", options: .regularExpression, range: nil)
    }
}
