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
    
    @IBOutlet var backMoji: UIView!
    
    @IBOutlet var react: UIButton!

    @IBOutlet var comment: UIButton!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var bottomBar: UIView!
    
    @IBOutlet var options: UIButton!
    
    var likesCount = 0
    
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var linkStack: UIStackView!
    
    
    @IBOutlet var linkImg: UIImageView!
    
    var cellType = 0
    
    var linkEmbed : URLEmbeddedView?
    
    var groupLabel : UILabel?
    
    var reply : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
        self.backgroundColor =  UIColor.hexStringToUIColor("e9e9e9")

        bottomBar!.backgroundColor = UIColor.hexStringToUIColor("247BA0").withAlphaComponent(0.75)
        bottomBar!.clipsToBounds = true
        cardBack.clipsToBounds = true
        react!.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let image = UIImage(named: "ic_favorite_border")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react!.setImage(image, for: UIControlState())
        comment!.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let image2 = UIImage(named: "ic_comment")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        comment!.setImage(image2, for: UIControlState())
        comment?.setTitle(" 0", for: UIControlState())
        comment.tintColor = UIColor.hexStringToUIColor("FFFFFF")
        react!.imageEdgeInsets = UIEdgeInsets(top: 13, left: 12, bottom: 12, right: 12)
        comment!.imageEdgeInsets = UIEdgeInsets(top: 14, left: 12, bottom: 12, right: 12)
        react.addTarget(self, action: #selector(BizCardTableViewCell.state(gesture:)), for: UIControlEvents.touchUpInside)
        
        self.backMoji.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.backMoji.layer.cornerRadius = 15
        self.cardBack.layer.masksToBounds = true
        self.cardBack.layer.cornerRadius = 6
        self.cardBack.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        self.cardBack.layer.shadowRadius = 1.8
        self.cardBack.layer.shadowOpacity = 0.3
        self.cardBack.clipsToBounds = false
        self.cardBack.layer.borderColor = UIColor.lightGray.cgColor
        self.cardBack.layer.borderWidth = 0.4
        
        let frame = CGRect(x: 50, y: 0, width: self.frame.width-100, height: 60)
        groupLabel = UILabel(frame: frame)
        groupLabel?.font = UIFont(name: "Raleway Regular", size: 13)
        groupLabel?.textColor = UIColor.lightGray
        groupLabel?.text = ""
        self.contentView.addSubview(groupLabel!)
        
        reply = UIButton()
        reply?.frame = CGRect(x: self.frame.width-50, y: 32, width: 50, height: 50)
        reply?.titleLabel?.textAlignment = NSTextAlignment.right
        reply?.titleLabel?.font = UIFont(name: "Raleway Light", size: 11)
        reply?.setTitle("Reply", for: UIControlState.normal)
        reply?.setTitleColor(UIColor.hexStringToUIColor("247BA0"), for: UIControlState.normal)
        self.contentView.addSubview(reply!)

          }

    override func layoutSubviews() {
        reply?.frame = CGRect(x: self.frame.width-75, y: 30, width: 50, height: 50)
        self.cardSetup()
        react!.imageView?.contentMode = UIViewContentMode.scaleAspectFit
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
            print("ONCE")
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
        print("I was liked!")
        let image = UIImage(named: "ic_favorite")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react!.setImage(image, for: UIControlState())
            if next != nil {
                likesCount += 1;
   

            react.setTitle("\(likesCount) ", for: UIControlState())

        
        }
        liked = 1
    }
    
    func unlike() {
        print("UNLIKED")
        let image = UIImage(named: "ic_favorite_border")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        react!.setImage(image, for: UIControlState())
        if let count = react.titleLabel?.text {
            var next : Int? = Int(count)
            
            print(likesCount)
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
