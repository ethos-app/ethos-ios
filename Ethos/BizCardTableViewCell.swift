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
    
    @IBOutlet var pic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func layoutSubviews() {
        self.cardSetup()
    }
    func cardSetup() {

        self.backgroundColor =  UIColor.hexStringToUIColor("e9e9e9")
        self.pic.layer.cornerRadius = self.pic.frame.width/2
        self.pic.clipsToBounds = true
        self.cardBack.layer.masksToBounds = false
        self.cardBack.layer.cornerRadius = 6
        self.cardBack.layer.shadowOffset = CGSizeMake(0.8, 0.8)
        self.cardBack.layer.shadowRadius = 1.2
        self.cardBack.layer.shadowOpacity = 0.2
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
