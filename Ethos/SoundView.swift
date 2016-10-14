//
//  SoundView.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/13/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class SoundView: UIView {

    @IBOutlet var web: UIWebView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func load(url : String) {
        UserDefaults.standard.register(defaults: ["UserAgent": "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0"])

        web.scrollView.isScrollEnabled = false
        let link = URL(string: url)
        var req = URLRequest(url: link!)
        req.setValue("Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.4) Gecko/20100101 Firefox/4.0", forHTTPHeaderField: "User-Agent")
        web.loadRequest(req)
        print(link)
    }

}
