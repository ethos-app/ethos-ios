//
//  JoinBar.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/3/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class JoinBar: UIView {

    @IBOutlet var join: UIButton!
    
    @IBOutlet var joinText: UILabel!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        join.layer.cornerRadius = 3
    }
    

}
