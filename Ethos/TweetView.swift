//
//  TweetView.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/13/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import Alamofire

class TweetView: UIView {

    @IBOutlet var web: UIWebView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func loadTweet(url : String) {
        web.scrollView.isScrollEnabled = false
        var scURL = "https://publish.twitter.com/oembed?url="
        scURL.append(url)
        scURL.append("&hide_media=true&data-cards=hidden")
        Alamofire.request(scURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        .responseJSON { (response) in
            
            if let rep = response.result.value as? NSDictionary {
                if let html = rep.object(forKey: "html") as? String {
                    var top = "<head> <script async src=\"https://platform.twitter.com/widgets.js\" charset=\"utf-8\"></script></head>"
                    top.append(html)
                    print(top)
                    self.web.loadHTMLString(top, baseURL: nil)
                }
            }
        }
    }

}
