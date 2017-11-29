//
//  DeleteSong.swift
//  MusicPlayerSwift3
//
//  Created by Joseph Fan on 6/19/17.

import Foundation
import UIKit

/*

func removeFile(itemNameWithExtention:String) {
    
    
    print ("Removing")
    let fileManager = FileManager.default
    let nsDocumentDirectory = FileManager.SearchPathDirectory.cachesDirectory
    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
    guard let dirPath = paths.first else {
        return
    }
    let filePath = "\(dirPath)/\(itemNameWithExtention)"
    do {
        try fileManager.removeItem(atPath: filePath)
    } catch let error as NSError {
        print(error.debugDescription)
    }

}

*/


class RemoveSong {
    
    //var homeController: RemoteMusicListViewController?
    class func load(itemNameWithExtention:String, completion: @escaping (_ result:Int) -> ()) {
        
        print ("Removing")
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.cachesDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemNameWithExtention)"
        do {
            try fileManager.removeItem(atPath: filePath)
            completion(1)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
}

