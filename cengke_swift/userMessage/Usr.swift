//
//  Usr.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class Usr: NSObject ,NSCoding {
    var user_name:String?
    var userId:String?
    var token:String?
    var mobile_phone:String?
    var user_level:String?
    var user_sex:String?
    var user_profile_picture:String?
    var user_code:String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_name, forKey: "user_name")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(mobile_phone, forKey: "moblie_phone")
        aCoder.encode(user_level, forKey: "user_level")
        aCoder.encode(user_sex, forKey: "user_sex")
        aCoder.encode(user_code, forKey: "user_code")
        aCoder.encode(user_profile_picture, forKey: "user_profile_picture")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
        user_name = aDecoder.decodeObject(forKey: "user_name") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        mobile_phone = aDecoder.decodeObject(forKey: "mobile_phone") as? String
        user_level = aDecoder.decodeObject(forKey: "user_level") as? String
        user_sex = aDecoder.decodeObject(forKey: "user_sex") as? String
        user_profile_picture = aDecoder.decodeObject(forKey: "user_profile_picture") as? String
        user_code = aDecoder.decodeObject(forKey: "user_code") as? String
    }

}
