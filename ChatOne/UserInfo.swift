//
//  UserInfo.swift
//  ChatOne
//
//  Created by 沈宇帆 on 26/1/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class UserInfo: NSObject {
    var uName: String?
    var emailAdd: String?
    var uImage: UIImage?
    var gender: String?
    var uBio: String?
    var uid:String?
    
    init(uName:String,emailAdd: String,uImage: UIImage,gender: String,uBio:String,uid:String) {
        self.uName = uName
        self.emailAdd = emailAdd
        self.uImage = uImage
        self.gender = gender
        self.uBio = uBio
        self.uid = uid
    }
}
