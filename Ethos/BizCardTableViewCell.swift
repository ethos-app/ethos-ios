//
//  BizCardTableViewCell.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/30/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class BizCardTableViewCell: UITableViewCell {

    @IBOutlet var cardBack: UIView!
    
    @IBOutlet var name: UILabel!
    
    @IBOutlet var desc: UILabel!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var backMoji: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func layoutSubviews() {
        self.cardSetup()
    }
    func cardSetup() {

        self.backgroundColor =  UIColor.hexStringToUIColor("e9e9e9")
        let bottomFrame = CGRectMake(0, self.frame.height-45, self.frame.width, 45)
        let bottomBar = UIView(frame: bottomFrame)
        bottomBar.backgroundColor = UIColor.hexStringToUIColor("247BA0").colorWithAlphaComponent(0.8)
        bottomBar.clipsToBounds = true
        
        let firstHalf = CGRectMake(0, -4, self.frame.width/2, bottomBar.frame.height)
        let react = UIButton(frame: firstHalf)
        
        react.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        react.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        react.setImage(UIImage(named: "ic_favorite_border"), forState: UIControlState.Normal)
        react.addTarget(self, action: #selector(BizCardTableViewCell.react), forControlEvents: UIControlEvents.TouchUpInside)
        let secondHalf = CGRectMake(self.frame.width/2, -4, self.frame.width/2, bottomBar.frame.height)
        let comment = UIButton(frame: secondHalf)
        comment.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        comment.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

        comment.setImage(UIImage(named: "ic_comment"), forState: UIControlState.Normal)

        
        bottomBar.addSubview(react)
        bottomBar.addSubview(comment)

        self.cardBack.addSubview(bottomBar)
        self.backMoji.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        self.backMoji.layer.cornerRadius = 15
        self.cardBack.layer.masksToBounds = true
        self.cardBack.layer.cornerRadius = 6
        self.cardBack.layer.shadowOffset = CGSizeMake(0.8, 0.8)
        self.cardBack.layer.shadowRadius = 0.8
        self.cardBack.layer.shadowOpacity = 0.1
        
    }
    func react(button : UIButton) {
        if button.imageView?.image == UIImage(named: "ic_favorite.png") {
            button.setImage(UIImage(named: "ic_favorite_border.png"), forState: UIControlState.Normal)

        } else {
        button.setImage(UIImage(named: "ic_favorite.png"), forState: UIControlState.Normal)
        }
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
