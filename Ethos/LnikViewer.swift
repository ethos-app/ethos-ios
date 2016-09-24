//
//  LnikViewer.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/21/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class LnikViewer: UIView {

    @IBOutlet var linkImage: UIImageView!
    
    @IBOutlet var linkTitle: UILabel!
    
    @IBOutlet var linkDesc: UILabel!
    
    
    @IBOutlet var linkURL: UILabel!
    

    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
       linkImage.clipsToBounds = true
        let frame = CGRect(x: 0, y: 5, width: self.frame.width, height: self.frame.height-5)
        let aroundView = UIView(frame: frame)
        aroundView.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.5).cgColor
        aroundView.layer.borderWidth = 1
        aroundView.layer.cornerRadius = 12
        aroundView.backgroundColor = UIColor.clear
        aroundView.clipsToBounds = true
        linkImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        linkImage.layer.borderColor = UIColor.hexStringToUIColor("247BA0").cgColor
        linkImage.layer.borderWidth = 1
        linkImage.layer.cornerRadius = 5
   //     self.addSubview(aroundView)
    }
    
    
    
    

}
