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
var songs:[Song] = [] // global variable that all controller classes can access




class RemoteMusicListViewController: UITableViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var titleView: UINavigationItem!
    
    var indicatorView: MusicPlayerSwift3View!
    //var titles: [String]?
    var startAnimating: Bool = false
    var currentNumber = 0
    let musicviewcontroller = MusicViewController() // create instance of MusicViewController
    var LocalMusicListViewController:UIViewController!
    //var vc:UIViewController!
    
    @IBOutlet weak var songTableView: UITableView! // i added
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //force navi bar to appear above table view
        //navigationController?.navigationBar.isTranslucent = false
        //title = "Music indicator demo"
        
        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleInterruption")), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        
       
        
        songs = [] //make songs array empty before each time songlisttableview appear
        tableView.delegate = self
        tableView.dataSource = self
        retrieveSongs()
        tableView.tableFooterView = UIView()
        
        let barViewControllers = self.tabBarController?.viewControllers
        self.LocalMusicListViewController = barViewControllers![1] as! LocalMusicListViewController
        //LocalMusicListViewController.myOrder = self.myOrder  //shared model
        
        
        
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setSession () {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print(error)
        }
    }


    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event!.type == UIEventType.remoteControl {
            if event!.subtype == UIEventSubtype.remoteControlPause{
                //print("pause")
                player?.pause()
            }
            else if event!.subtype == UIEventSubtype.remoteControlPlay{
                //print("playing")
                player?.play()
            }
        }
    }
    
    func handleInterruption(_ notification: Notification) {
        player?.pause()
        
        let interruptionTypeAsObject = notification.userInfo![AVAudioSessionInterruptionTypeKey] as! NSNumber
        
        let interruptionType = AVAudioSessionInterruptionType(rawValue: interruptionTypeAsObject.uintValue)
        
        if let type = interruptionType {
            if type == .ended {
                player?.play()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        //createIndicatorView() // show the top
        
     self.tableView.reloadData() // update table view
        
    }
 
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Here we pass the note they tapped on between the view controllers
        if segue.identifier == "SegueRemoteMusicToMusicView" {
            // Get the controller we are going to
            let music = segue.destination as! MusicViewController
            // Lookup the data we want to pass
            
            // Pass the data forward
            music.marker = "RemoteMusic"
            music.SongsDir = "http://josephxwf.com/music_app/"
        }
    }
    
  
    
    
    
    lazy var settingsLauncherForRemote: SettingsLauncherForRemote = {
        let launcher = SettingsLauncherForRemote()
        launcher.homeController = self
        launcher.homeLocalController = self.LocalMusicListViewController as! LocalMusicListViewController?
        return launcher
    }()
    
    func handleMore(songIndex:Int) {
        //show menu
        settingsLauncherForRemote.showSettings(songIndex: songIndex)
    }
    
    func showControllerForSetting(_ setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    
    
    
    
    
    
    func createIndicatorView() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        indicatorView = MusicPlayerSwift3View.init(frame: CGRect(origin: CGPoint(x: (screenSize.width - 50), y: 0), size: CGSize(width: 50, height: 44)))
        indicatorView.hidesWhenStopped = false
        indicatorView.tintColor = UIColor.red
        navigationController?.navigationBar.addSubview(indicatorView)
        //self.titleView.titleView = indicatorView
        //self.navigationItem.title = "123"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RemoteMusicListViewController.didTapIndicator(_:)))
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

    // MARK: - Table view data source
    
 

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return titles!.count
        return songs.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "musicListCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MusicListCell
        cell.accessoryType = .detailButton
        
        //UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessoryIcon"]], autorelease];
        //cell.accessoryView = [[ UIImageView, alloc ]
          //  initWithImage:[UIImage imageNamed:@"Something" ]];
        
       // let theImageView = UIImageView()
       // theImageView.image = UIImage(named: "remote.png")
    
        
        //cell.accessoryType = .detailButton
        //let chatImageView = UIImageView(image:#imageLiteral(resourceName: "Icon-Small-2"))
        //cell.accessoryView = chatImageView
        cell.tintColor = UIColor.gray
        
        
        cell.musicNumber = indexPath.row + 1
        //cell.musicTitleLabel.text = titles![indexPath.row]
        cell.musicTitleLabel.text = songs[indexPath.row].getCleanName()
        cell.state = .stopped
        
        if cell.musicNumber - 1 == self.currentNumber && whichPlayer == "remote" {
            if player != nil && player!.rate != 0 {
                cell.state = .playing
            }
            else{
                cell.state = .paused
            }
            
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath){
        
        handleMore(songIndex: indexPath.row)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateMusicIndicatorWithIndexPath(indexPath)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        /*
        musicviewcontroller.playbackSlider = UISlider(frame:CGRect(x: 10, y: 170, width: 300, height: 20))
        musicviewcontroller.playbackSlider!.minimumValue = 0
        */
      
        
        
        currentSong = indexPath.row
        whichPlayer = "remote" 
    
      /*
        self.dismiss(animated: true, completion: nil)// dismiss the instance of musicListviewController
        
        let storyboard = UIStoryboard(name: "Music", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "music") as UIViewController
        present(vc, animated: true, completion: nil)
    */
        
        
        performSegue(withIdentifier: "SegueRemoteMusicToMusicView", sender: self) // segue to next view controller
        
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


    func parseSongs (_ data: NSString) {
        if (data.contains("*")) {
            let dataArray = (data as String).characters.split{$0 == "*"}.map(String.init)
            for item in dataArray {
                let itemData = item.characters.split {$0 == ","}.map(String.init)
                let newSong = Song(id: itemData[0], name: itemData[1], numLikes: itemData[2], numPlays: itemData[3], artist: itemData[4])
                songs.append(newSong!)
            }
           
          
            DispatchQueue.main.async { [unowned self] in
                self.songTableView.reloadData()
            }
        }
    }


    func retrieveSongs () {
        let url = URL(string: "http://josephxwf.com/music_app/getmusic.php")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            let retrievedList = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(retrievedList!)
            self.parseSongs(retrievedList!)
        })
        
        task.resume()
        // print("Getting songs")
    }

    
        


}//end of class



