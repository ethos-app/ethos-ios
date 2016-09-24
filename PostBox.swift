//
//  PostBox.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/7/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

protocol ImageSeekDelegate : class {
    func showImagePicker()
    func imageCancelled()
}
class PostBox: UIView {

    var pickButton : UIImageView?
    var textView : UITextView?
    var cancelMedia : UIButton?
    weak var delegate : ImageSeekDelegate?
    override func draw(_ rect: CGRect) {
        pickButton?.contentMode = UIViewContentMode.scaleAspectFill
        super.draw(rect)
        let textFrame = CGRect(x: 8, y: 8, width: self.frame.width-16, height: self.frame.height-12)
        textView = UITextView(frame: textFrame)
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        textView!.layer.cornerRadius = 5
        textView?.clipsToBounds = true
        textView!.font = UIFont(name: "Raleway-Regular", size: 20)
        let boldText = UIFont(name: "Raleway-Italic", size: 18)
        let onMind = "What's really on your mind?"
        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGray])
        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        let camImage = UIImage(named: "ic_photo_camera_2x")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    
        cancelMedia = UIButton(frame: CGRect(x: self.frame.width-22, y: 7, width: 18, height: 18))
        cancelMedia?.setImage(UIImage(named: "icon"), for: UIControlState())
        cancelMedia?.addTarget(self, action: #selector(self.restorePicker), for: UIControlEvents.touchUpInside)
        cancelMedia!.isUserInteractionEnabled = true
        cancelMedia?.alpha = 0
        pickButton = UIImageView(image: camImage)
        pickButton!.tintColor = UIColor.lightGray
        pickButton!.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showPicker))
        pickButton!.addGestureRecognizer(gesture)
        pickButton!.frame = CGRect(x: self.frame.width-45, y: self.frame.height-35, width: 30, height: 30)
        
        textView?.attributedText = holderText
        self.addSubview(textView!)
        self.addSubview(pickButton!)
        self.addSubview(cancelMedia!)

    }
    func restorePicker() {
        delegate?.imageCancelled()
                let camImage = UIImage(named: "ic_photo_camera_2x")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        pickButton?.image = camImage
        pickButton!.frame = CGRect(x: self.frame.width-45, y: self.frame.height-35, width: 30, height: 30)
        cancelMedia?.alpha = 0
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        
    }
    func showPicker() {
        delegate?.showImagePicker()
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 75)
    }

    func resetText() {
        let boldText = UIFont(name: "Raleway-Italic", size: 18)
        let onMind = "What's really on your mind?"
        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGray])
        
        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        textView?.attributedText = holderText
      ///  self.addSubview(textView!)
        
    }
}
