//
//  PostBox.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/7/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class PostBox: UIView {

    var textView : UITextView?
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let textFrame = CGRectMake(8, 8, self.frame.width-16, self.frame.height-12)
        textView = UITextView(frame: textFrame)
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        textView!.layer.cornerRadius = 5
        textView?.clipsToBounds = true
        textView!.font = UIFont(name: "Raleway-Regular", size: 18)
        let boldText = UIFont(name: "Raleway-Italic", size: 18)
        let onMind = "What's really on your mind?"
        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGrayColor()])

        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        textView?.attributedText = holderText
        self.addSubview(textView!)
    }

    func resetText() {
        let boldText = UIFont(name: "Raleway-Italic", size: 18)
        let onMind = "What's really on your mind?"
        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        
        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        textView?.attributedText = holderText
        self.addSubview(textView!)
        
    }
}
