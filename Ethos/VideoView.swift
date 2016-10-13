//
//  VideoView.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/12/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class VideoView: UIView {

    let playerVars = [
        "playsinline" : 1,
        "showinfo" : 1,
        "rel" : 0,
        "modestbranding" : 1,
        "controls" : 1,
        "origin" : "https://meetethos.com"
    ] as [String : Any]
    @IBOutlet var vid: YTPlayerView!
    
    override func draw(_ rect: CGRect) {
        // load youtube embed HTML
    }
 
    func loadVideo(id : String) {
        self.vid.load(withVideoId: id, playerVars: playerVars)
    }

}
