//
//  FloatButton.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/1/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class FloatButton: UIView {

    @IBOutlet var button: FloatBtn!
 
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.cornerRadius = 1
        self.clipsToBounds = true
        
    }


}
