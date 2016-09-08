//
//  BizCard.swift
//  Ethos
//
//  Created by Scott Fitsimones on 8/31/16.
//  Copyright © 2016 Bolt Visual, Inc. All rights reserved.
//

import UIKit

class BizCard: NSObject {

    var fullName = ""
    var jobTitle = ""
    var bullet1 = ""
    var bullet2 = ""
    var bullet3 = ""
    var profileImageURL = ""
    var city = ""
    
    init(name : String, job : String, bullet1 : String, bullet2 : String, bullet3 : String, profileImageURL : String, city : String) {
        fullName = name
        jobTitle = job
//        self.bullet1 = bullet1
//        self.bullet2 = bullet2
//        self.bullet3 = bullet3
        self.profileImageURL = profileImageURL
        self.city = city
    }
}
