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
            let textFrame = CGRect(x: 0, y: 18, width: 100, height: 30)
            let labelView = UILabel(frame: textFrame)
            labelView.text = newString!
            labelView.font = UIFont(name: "Raleway-Regular", size: 13)
            labelView.textColor = UIColor.darkGray
            self.addSubview(labelView)
            print("added")
        }
    }
    
    var imageFile : UIImage? {
        get {
            return self.imageFile
        }
        set(newImage) {
            let whiteImage = newImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            let imageView = UIImageView(image: whiteImage)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            let start = (self.frame.width/2)
            let imFrame = CGRect(x: start, y: 6, width: 40, height: 20)
            imageView.frame = imFrame
            imageView.tintColor = UIColor.hexStringToUIColor("FF8811")
            imageView.backgroundColor = UIColor.clear
            self.addSubview(imageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = false
        bottomLine = UIView(frame: CGRect(x: 0, y: rect.height-2, width: 65, height: 2))
        bottomLine?.backgroundColor = UIColor.hexStringToUIColor("0080ff")
        self.addSubview(bottomLine!)
        bottomLine?.alpha = 0
    }
    
    func selectMe() {
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(BarButton.show), userInfo: nil, repeats: false)
    }
    func show() {
      //  bottomLine!.alpha = 1

    }
    
    func deselectMe() {
   //     bottomLine!.alpha = 0
    }


}
