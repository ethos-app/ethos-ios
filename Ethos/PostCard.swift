//
//  BizCard.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/31/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class PostCard: NSObject {

    var posterEmoji = ""
    var userText = ""
    var content = ""
    var type = 0
    var groupID = 0

    init(posterEmoji : String, userText : String, content : String, type : Int) {
        self.posterEmoji = posterEmoji
        self.userText = userText
        self.content = content
        self.type = type
    }
}
