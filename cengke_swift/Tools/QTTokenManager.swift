//
//  QTTokenManager.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/25.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class QTTokenManager: NSObject {
    class func search(text:String,key:String){
        let userDefaul = UserDefaults.standard
        var arr = userDefaul.array(forKey: key)
        if arr == nil{
            arr = Array.init()
        }
        for str in arr! {
            if (str as! String) == text {
                return
            }
        }
        arr?.append(text)
        userDefaul.set(arr, forKey: key)
        userDefaul.synchronize()
    }
    class func removeObjectWithKey(key:String){
    let userDefaul = UserDefaults.standard
    userDefaul.removeObject(forKey: key)
    userDefaul.synchronize()
    }
}
