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
    
    
    @IBOutlet var info: UILabel!
    
    @IBOutlet var city: UILabel!
    
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
        bottomBar.backgroundColor = UIColor.hexStringToUIColor("247BA0")
        bottomBar.clipsToBounds = true
        
        let react = UIButton(frame: firstHalf)
        
        let comment = UIButton(frame: secondHalf)
        self.cardBack.addSubview(bottomBar)

        self.cardBack.layer.masksToBounds = true
        self.cardBack.layer.cornerRadius = 6
        self.cardBack.layer.shadowOffset = CGSizeMake(0.8, 0.8)
        self.cardBack.layer.shadowRadius = 0.8
        self.cardBack.layer.shadowOpacity = 0.1
        

        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
