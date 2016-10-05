//
//  FloatBtn.swift
//  Ethos
//
//  Created by Scott Fitsimones on 10/1/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class FloatBtn: UIButton {

    override var isHighlighted : Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
            self.backgroundColor = UIColor.green
            } else {
                self.backgroundColor = UIColor.red
            }
            super.isHighlighted = newValue
        }
    
    }
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.red
    }
    
    
    

}
