//
//  SFButton.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/31/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class BarButton: UIView {
    
    // Button Label
    
    var bottomLine : UIView?
 
    var label : String? {
        get {
            return self.label
        } set(newString) {
            let textFrame = CGRectMake(0, 18, 100, 30)
            let labelView = UILabel(frame: textFrame)
            labelView.text = newString!
            labelView.font = UIFont(name: "Raleway-Regular", size: 13)
            labelView.textColor = UIColor.darkGrayColor()
            self.addSubview(labelView)
            print("added")
        }
    }
    
    var imageFile : UIImage? {
        get {
            return self.imageFile
        }
        set(newImage) {
            let whiteImage = newImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            let imageView = UIImageView(image: whiteImage)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            let start = (self.frame.width/2)
            let imFrame = CGRectMake(start, 6, 40, 20)
            imageView.frame = imFrame
            imageView.tintColor = UIColor.hexStringToUIColor("FF8811")
            imageView.backgroundColor = UIColor.clearColor()
            self.addSubview(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.clipsToBounds = false
        bottomLine = UIView(frame: CGRectMake(0, rect.height-2, 65, 2))
        bottomLine?.backgroundColor = UIColor.hexStringToUIColor("0080ff")
        self.addSubview(bottomLine!)
        bottomLine?.alpha = 0
    }
    
    func selectMe() {
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "show", userInfo: nil, repeats: false)
    }
    func show() {
      //  bottomLine!.alpha = 1

    }
    
    func deselectMe() {
   //     bottomLine!.alpha = 0
    }


}
