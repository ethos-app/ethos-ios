//
//  MusicView.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/11/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import Jukebox
import Alamofire

public protocol MusicDelegate : class {
    func startSong(url : String, musicView : MusicView)
    func stopSong()
}
public class MusicView: UIView {

    weak var delegate : MusicDelegate?
    
    @IBOutlet var title: UILabel!
    
    @IBOutlet var artist: UILabel!
    
    @IBOutlet var progress: UIProgressView!
    
    @IBOutlet var play: UIButton!
    
    @IBOutlet var art: UIImageView!
    var prog = 0.0
    
    var playURL = ""
    var playing = false
    var id = ""
    let ply = UIImage(named: "play")
    let pause = UIImage(named: "pause")

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        progress.progressTintColor = UIColor.hexStringToUIColor("1DB954")
        self.bringSubview(toFront: play)
        play.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        play.layer.cornerRadius = play.frame.width/2
        self.isUserInteractionEnabled = true
        progress.progress = 0.001
        play.addTarget(self, action: #selector(self.playMusic), for: UIControlEvents.touchUpInside)
    }
    func stopMusic() {
        play.setImage(ply, for: UIControlState.normal)
        progress.progress = 0.001
        playing = false
        delegate?.stopSong()
    }
    func playMusic() {
        if playing == false {
        play.setImage(pause, for: UIControlState.normal)
            delegate?.startSong(url: self.playURL, musicView : self)
        playing = true
        } else {
            play.setImage(ply, for: UIControlState.normal)
            progress.progress = 0.001
            playing = false
            delegate?.stopSong()
        }
    }
    func loadSong(id : String) {
        self.id = id
        Alamofire.request("https://api.spotify.com/v1/tracks/\(id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        .responseJSON { (response) in
            let info = response.result.value
            print(info)
            if let rep = info as? NSDictionary {
            if let previewURL = rep.object(forKey: "preview_url") {
                self.playURL = previewURL as! String
            }
            let artist = rep.object(forKey: "artists") as! NSArray
            var artistName = ""
            let song = rep.object(forKey: "name")
            if let first = artist.firstObject as? NSDictionary {
            artistName = first.object(forKey: "name") as! String
            }
                if let album = rep.object(forKey: "album") as? NSDictionary {
                    if let images = album.object(forKey: "images") as? NSArray {
                        if let second = images.object(at: 1) as? NSDictionary {
                            if let imageURL = second.object(forKey: "url") as? String {
                            let mURL = URL(string: imageURL)
                                print(mURL)

                            self.art.hnk_setImageFromURL(mURL!)
                            }
                        }
                    }
                }
            self.title.text = song as! String?
            self.artist.text = artistName
            
            }
        }
        
    }

    @IBAction func openSpotify(_ sender: AnyObject) {
        let url = "spotify:track:\(self.id)"
        let link = URL(string: url)
        UIApplication.shared.openURL(link!)
    }
 

}
