//
//  MusicListViewController.swift
//  MusicPlayerSwift3
//
//  Created by Aufree on 12/28/15.
//  Copyright © 2015 The EST Group. All rights reserved.
//

import UIKit

import AVFoundation

//var audioPlayer = AVAudioPlayer()
var Localmp3FileNames:[String] = [] // global variable that all controller classes can access
//var currentNumber = 0

var whichPlayer:String = ""

class LocalMusicListViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleView: UINavigationItem!
    var cachesUrl:URL!
    var indicatorView: MusicPlayerSwift3View!
    //var titles: [String]?
    var startAnimating: Bool = false
    var currentNumber = 0
    
    let musicviewcontroller = MusicViewController() // create instance of MusicViewController
    //var vc:UIViewController!
    
    
    @IBOutlet weak var songTableView: UITableView! // i added
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //force navi bar to appear above table view
        
        //navigationController?.navigationBar.isTranslucent = false
        
        //title = "Music indicator demo"
        //songs = [] //make songs array empty before each time songlisttableview appear
        Localmp3FileNames = []
        //retrieveSongs()
        tableView.tableFooterView = UIView()
        
        
    }
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    
        //createIndicatorView() // show the top
        
       ////////////////////////////////////get song names from caches dir//////////////////////////////
        //let cachesUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
       // let destinationFileUrl = cachesUrl.appendingPathComponent("qq.jpg")
        
        // Get the caches directory url
        //cachesUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         cachesUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        print ("=============LocalMusicSource cachesDirectory is below=================")
        print (cachesUrl)
        print ("=============LocalMusicSource cachesDirectory is above=================")
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: cachesUrl, includingPropertiesForKeys: nil, options: [])
            
            //print("\n directoryContents:", directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let Localmp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            //print("\n mp3 urls:",Localmp3Files)
           
            //Localmp3FileNames = Localmp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            Localmp3FileNames  = Localmp3Files.map{ $0.lastPathComponent }
            //print("\n mp3 list:", Localmp3FileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.tableView.reloadData() // update table view
        
    }
    
    
    func createIndicatorView() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        indicatorView = MusicPlayerSwift3View.init(frame: CGRect(origin: CGPoint(x: (screenSize.width - 50), y: 0), size: CGSize(width: 50, height: 44)))
        indicatorView.hidesWhenStopped = false
        indicatorView.tintColor = UIColor.red
        navigationController?.navigationBar.addSubview(indicatorView)
        //self.titleView.titleView = indicatorView
        //self.navigationItem.title = "123"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LocalMusicListViewController.didTapIndicator(_:)))
        tap.delegate = self
        indicatorView.addGestureRecognizer(tap)
        
    }
    
    
    
    func didTapIndicator(_ sender: UITapGestureRecognizer? = nil) {
        startAnimating = !startAnimating
        
        if startAnimating {
            indicatorView.state = .playing
        } else {
            indicatorView.state = .stopped
        }
        
    }
    
    
    
    
    lazy var settingsLauncherForLocal: SettingsLauncherForLocal = {
        let launcher = SettingsLauncherForLocal()
        launcher.homeController = self
        
        return launcher
    }()
    
    func handleMore(songIndex:Int) {
        //show menu
        settingsLauncherForLocal.showSettings(songIndex:songIndex)
    }
    
    func showControllerForSetting(_ setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        
        handleMore(songIndex:indexPath.row)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return titles!.count
        return Localmp3FileNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57;
    }
    
    // put songs name from array Localmp3FileNames in table view 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "musicListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MusicListCell
        cell.accessoryType = .detailButton
        cell.tintColor = UIColor.gray
        
        //let chatImageView = UIImageView(image:#imageLiteral(resourceName: "Icon-Small-2"))
        //cell.accessoryView = chatImageView
        
        cell.musicNumber = indexPath.row + 1
        //cell.musicTitleLabel.text = titles![indexPath.row]
        
        
        cell.musicTitleLabel.text = Localmp3FileNames[indexPath.row].replacingOccurrences(of: "(.mp3)|( )", with: "", options: .regularExpression, range: nil)
        cell.state = .stopped
        
        if cell.musicNumber - 1 == self.currentNumber && whichPlayer == "local" {
            if player != nil && player!.rate != 0 {
                cell.state = .playing
            }
            else{
                cell.state = .paused
            }
            
        }
        //print ("\n musicNumber", cell.musicNumber)
        //print ("\n currentNumber", currentNumber)
        
        return cell
    }
    
    // MARK: - Table view data delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        updateMusicIndicatorWithIndexPath(indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
         musicviewcontroller.playbackSlider = UISlider(frame:CGRect(x: 10, y: 170, width: 300, height: 20))
         musicviewcontroller.playbackSlider!.minimumValue = 0
         */
        
        
        
        currentSong = indexPath.row
        whichPlayer = "local" 
        
        /*
         self.dismiss(animated: true, completion: nil)// dismiss the instance of musicListviewController
         
         let storyboard = UIStoryboard(name: "Music", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "music") as UIViewController
         present(vc, animated: true, completion: nil)
         */
        
        
        performSegue(withIdentifier: "SegueLocalMusicToMusicView", sender: self) // segue to next view controller
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Here we pass the note they tapped on between the view controllers
        if segue.identifier == "SegueLocalMusicToMusicView" {
            // Get the controller we are going to
            let music = segue.destination as! MusicViewController
            // Lookup the data we want to pass
            
            // Pass the data forward
            music.marker = "LocalMusic"
            music.SongsDirLocalURL = cachesUrl
        }
    }
    
    
    
    // MARK: - Update music indicator
    
    func updateMusicIndicatorWithIndexPath(_ indexPath: IndexPath) {
        for cell in tableView.visibleCells as! [MusicListCell] {
            cell.state = .stopped
        }
        let musicsCell = tableView.cellForRow(at: indexPath) as! MusicListCell
        musicsCell.state = .playing
        self.currentNumber = indexPath.row
      
       
    }
    
    

    
    

    
    
    
    
    
}//end of class



