//
//  BizCard.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/31/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class PostCard: NSObject {

    var comment = false
    var commentId = 0
    var posterEmoji = ""
    var userText = ""
    var content = ""
    var type = 0
    var groupID = 0
    var postID = 0;
    var posterID = 0
    var likeCount = "";
    var commentCount = "";
    var userLiked = 0;
    var userOwned = 0;
    var date = ""
    var imageStore : UIImage?
    var hasImage = false
    var linkTitle = ""
    var linkDesc = ""
    var linkURL = ""
    var linkImage : UIImage?
    var hasLinkData = false
    
    var message = ""
    var alertId = ""
    var contentAlert = ""
    var userRead = true
    
    var isEthos = false
    var notifyUserID = 0
    
    var groupString = ""
    var replyTo = NSMutableArray()
    var responseToEmojis = NSArray()
    init(posterEmoji : String, userText : String, type : Int) {
        self.posterEmoji = posterEmoji
        self.userText = userText
        self.type = type
    }
}
