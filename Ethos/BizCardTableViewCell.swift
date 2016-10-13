//
//  BizCardTableViewCell.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit
import URLEmbeddedView

class BizCardTableViewCell: UITableViewCell {
    var liked : Int = 0;
    @IBOutlet var cardBack: UIView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var img: UIImageView!
    var imageCover : UIView?
    
    @IBOutlet var backMoji: UIView!
    
    @IBOutlet var react: UIButton!

    @IBOutlet var comment: UIButton!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var bottomBar: UIView!
    
    @IBOutlet var options: UIButton!
    
    var likesCount = 0
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var linkStack: UIStackView!
    
    @IBOutlet var groupTitle: UILabel!
    
    @IBOutlet var linkImg: UIImageView!
    
    var cellType = 0
    
    var linkEmbed : URLEmbeddedView?
    
    var groupLabel : UILabel?
    
    var emojiList : EmojiBar?
    var reply : UIButton?
    
    var musicView : UIView?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        self.backgroundColor =  UIColor.hexStringToUIColor("e9e9e9")
        
       
        bottomBar?.backgroundColor = UIColor.hexStringToUIColor("247BA0").withAlphaComponent(0.75)
        bottomBar?.clipsToBounds = true
        cardBack.clipsToBounds = true
        react?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "ic_favorite_border")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react?.setImage(image, for: UIControlState())
        comment?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let image2 = UIImage(named: "ic_comment")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        comment?.setImage(image2, for: UIControlState())
        comment?.setTitle(" 0", for: UIControlState())
        comment?.tintColor = UIColor.hexStringToUIColor("FFFFFF")
        react?.imageEdgeInsets = UIEdgeInsets(top: 13, left: 12, bottom: 12, right: 12)
        comment?.imageEdgeInsets = UIEdgeInsets(top: 14, left: 12, bottom: 12, right: 12)
        comment?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        react?.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        react?.addTarget(self, action: #selector(BizCardTableViewCell.state(gesture:)), for: UIControlEvents.touchUpInside)
        
        self.backMoji.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.backMoji.layer.cornerRadius = 15
        self.cardBack.layer.masksToBounds = true
        self.cardBack.layer.cornerRadius = 9
        if bottomBar != nil {
        self.bottomBar.layer.cornerRadius = 5
        }
        self.cardBack.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        self.cardBack.layer.shadowRadius = 1.8
        self.cardBack.layer.shadowOpacity = 0.15
        self.cardBack.clipsToBounds = false
        self.cardBack.layer.borderColor = UIColor.lightGray.cgColor
        self.cardBack.layer.borderWidth = 0.4
        
        let frame = CGRect(x: 50, y: 15, width: self.frame.width-200, height: 25)
      
       
        emojiList = EmojiBar.loadFromNibNamed(nibNamed: "EmojiBar") as? EmojiBar
        emojiList?.translatesAutoresizingMaskIntoConstraints = true
        emojiList?.alpha = 0
        emojiList?.backgroundColor = UIColor.clear
        self.addSubview(emojiList!)
        reply = UIButton()
        reply?.frame = CGRect(x: self.frame.width-35, y: self.frame.height-42, width: 50, height: 50)
        reply?.setTitleColor(reply?.titleColor(for: UIControlState.normal)?.withAlphaComponent(0.6), for: UIControlState.normal)
        reply?.alpha = 0.8
        reply?.titleLabel?.textAlignment = NSTextAlignment.right
        reply?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        reply?.setTitle("Reply", for: UIControlState.normal)
        reply?.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
        self.contentView.addSubview(reply!)
        imageCover = UIView()
        imageCover!.backgroundColor = UIColor.black
        imageCover!.alpha = 0.6
        imageCover?.clipsToBounds = true
        
        musicView = MusicView.loadFromNibNamed(nibNamed: "MusicView")
        musicView?.frame = CGRect(x: 0, y: 70, width: 310, height: 0)
      //  self.contentView.addSubview(musicView!)
        }

    override func layoutSubviews() {
             reply?.frame = CGRect(x: self.frame.width-55, y: self.frame.height-44, width: 50, height: 50)
        emojiList?.frame = CGRect(x: 30, y: 10, width: self.frame.width-200, height: 40)
        self.cardSetup()
        react?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        super.layoutSubviews()
    }
    func cardSetup() {
     
        // bottom bar view
        let bottomFrame = CGRect(x: 0, y: self.frame.height-45, width: self.frame.width, height: 45)
        bottomBar = UIView(frame: bottomFrame)
        
    }
    func showOptions() {
        
    }
    
    func state(gesture : UIGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.began {
        (liked == 0) ? like() : unlike()
        }
    }
    func like() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.autoreverse, animations: {
            self.react.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { (done) in
                //
                self.react.transform = CGAffineTransform(scaleX: 1, y: 1)

        }
        let image = UIImage(named: "ic_favorite")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react!.setImage(image, for: UIControlState())
            if next != nil {
                likesCount += 1;
   

            react.setTitle("\(likesCount) ", for: UIControlState())

        
        }
        liked = 1
    }
    
    func unlike() {
        let image = UIImage(named: "ic_favorite_border")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react!.setImage(image, for: UIControlState())
        if let count = react.titleLabel?.text {
            var next : Int? = Int(count)
            
            likesCount -= 1
            
            react.setTitle("\(likesCount)", for: UIControlState())
            if likesCount == 0 {
                react.setTitle("", for: UIControlState())

            }
            if next != nil {
                next = next! - 1
            }
        }
        liked = 0
    }
    
    func setCount(_ num : Int) {
        if num > 0 {
        self.react?.setTitle("\(num)", for: UIControlState())
        self.react?.setNeedsLayout()
        self.react?.layoutIfNeeded()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
