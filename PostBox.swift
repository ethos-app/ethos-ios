//
//  PostBox.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/7/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

@objc protocol ImageSeekDelegate : class {
    func showImagePicker()
    func imageCancelled()
    @objc optional func postPress()
}
class PostBox: UIView {

    var pickButton : UIButton?
    var sendButton : UIButton?
    var textView : UITextView?
    var cancelMedia : UIButton?
    weak var delegate : ImageSeekDelegate?
    enum BoxType {
    case header
    case keyboard
    case group
    }

    var rightFrame : CGRect?
    var leftFrame : CGRect?
    
    var type = BoxType.header
    override func draw(_ rect: CGRect) {
        rightFrame = CGRect(x: self.frame.width-40, y: self.frame.height-35, width: 30, height: 30)
        leftFrame = CGRect(x: self.frame.width-92, y: self.frame.height-43, width: 30, height: 30)
        pickButton?.contentMode = UIViewContentMode.scaleAspectFill
        super.draw(rect)
        let textFrame = CGRect(x: 8, y: 8, width: self.frame.width-16, height: self.frame.height-15)
        textView = UITextView(frame: textFrame)
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        textView!.layer.cornerRadius = 5
        textView?.clipsToBounds = true
        textView?.tintColor = UIColor.hexStringToUIColor("247BA0")
        textView!.font = UIFont(name: "Raleway-Regular", size: 22)
        let boldText = UIFont(name: "Raleway-Italic", size: 22)
//        let onMind = ""
//        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGray])
//        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        let camImage = UIImage(named: "ic_photo_camera_2x")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    
        cancelMedia = UIButton(frame: CGRect(x: self.frame.width-22, y: 7, width: 18, height: 18))
        cancelMedia?.setImage(UIImage(named: "icon"), for: UIControlState())
        cancelMedia?.addTarget(self, action: #selector(self.restorePicker), for: UIControlEvents.touchUpInside)
        cancelMedia!.isUserInteractionEnabled = true
        cancelMedia?.alpha = 0
        pickButton = UIButton()
        pickButton?.setImage(camImage, for: UIControlState.normal)
        pickButton!.tintColor = UIColor.lightGray
        pickButton!.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.showPicker))
        pickButton!.addGestureRecognizer(gesture)
        pickButton!.frame = rightFrame!
       
        textView?.text = ""
        self.addSubview(textView!)
        self.addSubview(pickButton!)
        self.addSubview(cancelMedia!)
        
        if self.type == .keyboard {
            textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 75)
            textView?.text = "Write a comment..."
            let sendImg = UIImage(named: "ic_send_2x")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            sendButton = UIButton()
            sendButton?.setImage(sendImg, for: UIControlState.normal)
            sendButton?.tintColor = UIColor.lightGray
            sendButton?.isUserInteractionEnabled = true
            sendButton?.frame = CGRect(x: self.frame.width-45, y: self.frame.height-43, width: 30, height: 30)
            pickButton?.frame = leftFrame!
            self.addSubview(sendButton!)
            let send = UITapGestureRecognizer(target: self, action: #selector(self.postPressed))
            send.numberOfTapsRequired = 1
            self.sendButton?.addGestureRecognizer(send)
        }
        
    }
    func disable() {
        print("CALL")
        textView?.text = "🔒 This is a private group."
     //   textView?.isEditable = false
    }
    func postPressed() {
        delegate?.postPress!()
    }
    func restorePicker() {
        delegate?.imageCancelled()
                let camImage = UIImage(named: "ic_photo_camera_2x")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        pickButton?.setImage(camImage, for: UIControlState.normal)
        pickButton?.frame = CGRect(x: self.frame.width-40, y: self.frame.height-35, width: 30, height: 30)
        cancelMedia?.alpha = 0
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        
    }
    func showPicker() {
        delegate?.showImagePicker()
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 75)
    }

    func prepareWrite() {
        
    }
    
    func resetText() {
        print("I RESET")
        print(type)
        textView?.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5)
        let boldText = UIFont(name: "Raleway-Italic", size: 22)
        var onMind = "Talk openly with your friends..."
        if type == .group {
            onMind = "Talk openly with this gorup..."
        } else if type == .keyboard {
            onMind = "Add a comment..."
        }
        let holderText = NSMutableAttributedString(string: onMind, attributes: [NSFontAttributeName : textView!.font!, NSForegroundColorAttributeName : UIColor.lightGray])
        
        holderText.addAttribute(NSFontAttributeName, value: boldText!, range: NSMakeRange(7, 6))
        textView?.attributedText = holderText
        if self.type == .keyboard {
            textView?.text = "Write a comment..."
            
        }
      ///  self.addSubview(textView!)
        
    }
}
