//
//  GroupTableViewCell.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/24/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet var groupImg: UIImageView!
    
    @IBOutlet var groupTitle: UILabel!
    
    @IBOutlet var groupDesc: UILabel!
    
    @IBOutlet var mod: UIImageView!
    
    @IBOutlet var cardBack: UIView!
    
    @IBOutlet var option: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        option?.layer.cornerRadius = 3
        option?.layer.borderColor = UIColor.lightGray.cgColor
        // Initialization code
        self.backgroundColor =  UIColor.hexStringToUIColor("e9e9e9")
        self.cardBack.layer.masksToBounds = true
        self.cardBack.layer.cornerRadius = 6
        self.cardBack.layer.shadowOffset = CGSize(width: 0.8, height: 0.8)
        self.cardBack.layer.shadowRadius = 1.4
        self.cardBack.layer.shadowOpacity = 0.1
        self.cardBack.clipsToBounds = false
        self.cardBack.layer.borderColor = UIColor.lightGray.cgColor
        self.cardBack.layer.borderWidth = 0.4
        groupImg.layer.cornerRadius = 30
        groupImg.clipsToBounds = true
        groupImg.layer.borderColor = UIColor.darkGray.cgColor
        groupImg.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
