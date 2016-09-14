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
    var postID = 0;
    var posterID = 0
    var likeCount = 0;
    var commentCount = 0;
    var userLiked = 0;
    var date = ""
    init(posterEmoji : String, userText : String, type : Int) {
        self.posterEmoji = posterEmoji
        self.userText = userText
        self.type = type
    }
}
