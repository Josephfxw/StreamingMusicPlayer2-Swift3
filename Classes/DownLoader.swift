//
//  DownLoader.swift
//  MusicPlayerSwift3
//
//  Created by Joseph Fan on 6/16/17.
//  Copyright © 2017 The EST Group. All rights reserved.
//

import Foundation
import UIKit
/*
class Downloader {
    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription as Any);
            }
        }
        task.resume()
    }
}

*/

class Downloader {
    
   //var homeController: RemoteMusicListViewController?
   class func load(url: URL, to localUrl: URL, completion: @escaping (_ result:Int) -> ()) {
//if let audioUrl = URL(string: "http://freetone.org/ring/stan/iPhone_5-Alarm.mp3") {
    
    // then lets create your document folder url
    //let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // lets create your destination file url
   // let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
   // print(destinationUrl)
    
    // to check if it exists before downloading it
    if FileManager.default.fileExists(atPath: localUrl.path) {
        print("The file already exists at path")    
        
        // if the file doesn't exist
    } else {
        
        // you can use NSURLSession.sharedSession to download the data asynchronously
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            guard let location = location, error == nil else { return }
            do {
                // after downloading your file you need to move it to your destination url
                try FileManager.default.moveItem(at: location, to: localUrl)
                print("File moved to documents folder")
                completion(1)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }).resume()
    }
}

}


