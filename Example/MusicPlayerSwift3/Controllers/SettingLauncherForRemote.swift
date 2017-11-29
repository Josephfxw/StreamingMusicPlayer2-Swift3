//
//  SettingLauncher.swift
//  MusicPlayerSwift3
//
//  Created by Joseph Fan on 6/17/17.


import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

class SettingsLauncherForRemote: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    let songDir:String = "http://josephxwf.com/music_app/"
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    let settings: [Setting] = {
        return [Setting(name: "Download", imageName: "download"), Setting(name: "Help", imageName: "help")]
    }()
    
    var homeController: RemoteMusicListViewController?
    var homeLocalController: LocalMusicListViewController?
    
    var songIndex:Int!
    
    func showSettings(songIndex:Int) {
        //show menu
        self.songIndex = songIndex
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    
    /*
    func showDownloadComplete() {
        //show menu
        
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    */
    
    func handleDismiss(_ setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
            
        }) { (completed: Bool) in
            
            /*
            if setting.name != "" && setting.name != "Cancel" {
                self.homeController?.showControllerForSetting(setting)
                
            }
            */
            
            if setting.name != "" && setting.name == "Download" {
                // Create destination URL
                //let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
                
                
                let documentsUrl:URL =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first as URL!
                
                let destinationFileUrl = documentsUrl.appendingPathComponent(songs[self.songIndex].getName())
                print ("=============DownloadDestination cachesDirectory is below=================")
                print (destinationFileUrl)
                print ("=============DownloadDestination cachesDirectory is above=================")
                
                //Create URL to the source file you want to download
                //let fileURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/1e/Stonehenge.jpg")
                
                let fileURL = URL(string: (self.songDir + songs[self.songIndex].getArtist() + " - " + songs[self.songIndex].getName()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                
                
                
                Downloader.load(url: fileURL!,to: destinationFileUrl){ (result:Int) in
                    //self.showDownloadComplete()
                   
                    let alert = UIAlertController(title: "", message: "Song was downloaded to local playlist sucessfully!", preferredStyle: .alert)
                    self.homeController?.present(alert, animated: true, completion: nil)
                    
                    
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: true, completion: nil)
                       
                    }
                        
                    
                        //self.homeLocalController?.tableView.reloadData()
                        
                }
                //var homeLocalController: LocalMusicListViewController?
                //
                //self.homeController?.performSegue(withIdentifier: "onelineToLocal", sender: self) // segue to next view controller
                self.homeLocalController?.tableView.reloadData()
            }
            self.homeLocalController?.tableView.reloadData()
            
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        
        let setting = settings[indexPath.item]
        cell.setting = setting
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = self.settings[indexPath.item]
        handleDismiss(setting)
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}








