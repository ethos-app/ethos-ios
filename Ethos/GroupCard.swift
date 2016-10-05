//
//  GroupCard.swift
//  Ethos
//
//  Created by Scott Fitsimones on 9/24/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class GroupCard: NSObject {

    var groupID = 0
    var groupTitle = ""
    var groupDesc = ""
    var groupImg = ""
    var groupOwner = 0
    var groupType = 0
    var isOwner = false
    var isModerator = false
    var isFeatured = false
    var isMember = false
    var requestedJoin = false
    init(id : Int) {
        self.groupID = id
    }
}
