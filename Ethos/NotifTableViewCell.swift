//
//  NotifTableViewCell.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/24/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class NotifTableViewCell: UITableViewCell {

    @IBOutlet var previewImg: UIImageView!
    
    @IBOutlet var label: UILabel!
    
    @IBOutlet var emoji: UIImageView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if previewImg != nil {
        previewImg.clipsToBounds = true
        }
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
