//
//  MusicViewController.swift
//  MusicPlayerSwift3
//
//  Created by Joseph Fan on 4/7/17.
//  Copyright © 2017 The EST Group. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
var player:AVPlayer?
var currentSong = 0;
var url:URL!

class MusicViewController: UIViewController {
    var progressSlider:UISlider?
    //let startURL = "http://josephxwf.com/music_app/"
    var marker:String = ""
    var SongsDir:String = ""
    var SongsDirLocalURL:URL!
    
    @IBOutlet weak var curLabel: UILabel!
    @IBOutlet weak var durLabel: UILabel!
    
    
    
    //all of the outlets
    
    var playerItem:AVPlayerItem?
    var playerLayer:AVPlayerLayer?
    
    
    
    @IBOutlet weak var volume1: UILabel!
    @IBOutlet weak var volume2: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var myImageView: UIImageView!
   
   // @IBOutlet weak var progressSlider: UISlider!
    
    
    
    
    @IBAction func play(_ sender: Any) {
        //play button clicked --> song plays if it was paused and vicaversa
        if player!.rate == 0
        {
            player!.play()
            //  playButton!.setImage(UIImage(named: "29-circle-pause.png"), for: UIControlState.normal)
            playPauseButton.setImage(UIImage(named: "big_pause_button"), for: UIControlState())
        } else {
            player!.pause()
            // playButton!.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
            
            playPauseButton.setImage(UIImage(named: "big_play_button"), for: UIControlState())
        }
    
    
    }
   
    
    
    
    

    
    
    func changePlayButton () {
        if(player!.rate != 0) {
            playPauseButton.setImage(UIImage(named: "big_pause_button"), for: UIControlState())
        }
        else {
            playPauseButton.setImage(UIImage(named: "big_play_button"), for: UIControlState())
        }
    }
    
    
  /*
    @IBAction func pause(_ sender: Any)
    {
        if audioStuffed == true && audioPlayer.isPlaying
        {
            audioPlayer.pause()
        }
    }
  */
   
    
    @IBAction func prev(_ sender: Any) {
    
        //if currentSong != 0 && audioStuffed == true
        
   
        if(currentSong > 0){
            currentSong = (currentSong - 1)  % songs.count ;
           
        }else {currentSong = songs.count - 1; }
        
        
        player!.pause()
        player = nil
        
        
        
        
        setPlayer(currentSong: currentSong);
        // if player!.rate == 0
        // {
        player!.play()
        //label.text = songs[currentSong].getCleanName()
        // }
        
        
        
        changePlayButton()
    }
    
    

        
    
    
    
   @IBAction func next(_ sender: Any) {
        //if currentSong< songs.count-1 && audioStuffed == true
    
        currentSong = (currentSong + 1)  % songs.count  ;
        player!.pause()
        player = nil

        setPlayer(currentSong: currentSong);
        //if player!.rate == 0
        //{
            
        player!.play()
    
            
        //}

        changePlayButton()
    }
    
    

    
    
    
    
    
    @IBAction func slider(_ sender: UISlider) //audio volume slider
    {
        
       player?.volume = Float(sender.value)
        
    }
    

    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       /*
        setSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: Selector(("handleInterruption")), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        */
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        // Add playback slider
        
        //progressSlider = UISlider(frame:CGRect(x: 35, y: 420, width: 300, height: 10))
        progressSlider!.minimumValue = 0
        
     
        
        if player == nil {
            setPlayer(currentSong: currentSong)
            player!.play()
        }
        else if player!.rate != 0 {
            player!.pause()
            player = nil
            setPlayer(currentSong: currentSong)
            player!.play()
        }else {
            setPlayer(currentSong: currentSong)
            player!.play()
        }
        
        //setPlayer(currentSong: currentSong)
        //play(self)
        
        
        //label.text = songs[currentSong].getCleanName()
        volume1.backgroundColor = UIColor(patternImage: UIImage(named: "volume1")!)
        volume2.backgroundColor = UIColor(patternImage: UIImage(named: "volume2")!)
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Begin of code")
        if let checkedUrl = URL(string: "https://www.cleverfiles.com/howto/wp-content/uploads/2016/08/mini.jpg") {
            myImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
        //print("End of code. The image will continue downloading in the background and it will be loaded when it ends.")
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    /*
    func setSession () {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print(error)
        }
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

    */
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.myImageView.image = UIImage(data: data)
            }
        }
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    @IBAction func toMusicListClicked(_ segue:UIStoryboardSegue) {
        /*
        let storyboard = UIStoryboard(name: "MusicList", bundle: nil)// go to music list page
        let vc = storyboard.instantiateViewController(withIdentifier: "musicList") as UIViewController
        present(vc, animated: true, completion: nil)
       */
        //let window = UIApplication.shared.keyWindow
       // self.view.frame = CGRect(x: 0, y: 100, width: (window?.frame.width)!, height: 100)
        //self.view.isHidden = true
        
        self.dismiss(animated: true, completion: nil)
        
        //self.tabBarController?.selectedIndex = 0
        
        
      //  var noteDetail = segue.source as! LocalMusicListViewController
     //   noteDetail.view.isHidden = false
        
        
        
        
       
        
    
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func progressSliderValueChanged(_ progressSlider:UISlider)
    {
        
        let seconds : Int64 = Int64(progressSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player!.play()
        }
    }
    
    
 
    
    
    
    //setup avplayer avPlayerItem --> objects used to play audio files
    func setPlayer(currentSong:Int ){
        
        
        //var url:URL!
        if marker == "RemoteMusic" {
            self.label.text = songs[currentSong].getCleanName();
            url = URL(string: (SongsDir + songs[currentSong].getArtist() + " - " + songs[currentSong].getName()).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        }else if marker == "LocalMusic" {
            self.label.text = Localmp3FileNames[currentSong].replacingOccurrences(of: "(.mp3)|( )", with: "", options: .regularExpression, range: nil);

            //let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            //url = documentsUrl.appendingPathComponent(Localmp3FileNames[currentSong] + ".mp3")
            
            url =  SongsDirLocalURL.appendingPathComponent(Localmp3FileNames[currentSong])
            
            //url = URL(string: SongsDir + Localmp3FileNames[currentSong] + ".mp3")
        }
        
       // let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
       // let destinationFileUrl = documentsUrl.appendingPathComponent("Fingers.mp3")
       // Downloader.load(url: url!,to: destinationFileUrl,completion:{} )
        
        
        
        
        

    
    
        
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        if #available(iOS 10.0, *) {
            player?.automaticallyWaitsToMinimizeStalling = false
        } else {
            // Fallback on earlier versions
            
        }
        
        playerLayer=AVPlayerLayer(player: player!)
        playerLayer?.frame=CGRect(x: 0, y: 0, width: 10, height: 50)
        self.view.layer.addSublayer(playerLayer!)
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        let mySecs = Int(seconds) % 60
        let myMins = Int(seconds / 60)
        
        progressSlider?.value = 0  //set slider thumb to beginning
        self.curLabel.text = "0:0" //set intital current progress time to 0:0
        let myTimes = String(myMins) + ":" + String(mySecs);
        durLabel.text = myTimes;
        
        
        
        progressSlider!.maximumValue = Float(seconds)
        progressSlider!.isContinuous = false
        progressSlider!.tintColor = UIColor.blue
        
        progressSlider?.addTarget(self, action: #selector(MusicViewController.progressSliderValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(progressSlider!)
        
        //subroutine used to keep track of current location of time in audio file
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(player!.currentTime());
                
               
                
                let mySecs2 = Int(time) % 60
                
                /*
                if(mySecs2 == 1){//show title of song after 1 second
                    self.label.text = songs[currentSong].getCleanName();
                }*/
                
                let myMins2 = Int(time / 60)
                
                let myTimes2 = String(myMins2) + ":" + String(mySecs2);
                self.curLabel.text = myTimes2;//current time of audio track
                
                
                self.progressSlider!.value = Float ( time );
                
                // continous play next song after the previous song is over
                if(Int(time) == Int(seconds) && currentSong != songs.count-1){
                    
                    self.contPlay()
                }
            }
        }
    }
    
    

    
    
    
    //plays next song automatically when previous song finishes
    func contPlay(){
        
        if(currentSong < songs.count - 1){
            currentSong = currentSong + 1;
        
            player!.pause()
            player = nil
            
            setPlayer(currentSong: currentSong);
            //if player!.rate == 0
            //{
            player!.play()
                           // }
            
        }
    }

    
    
    
}

