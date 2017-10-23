//
//  GoodsImageModel.swift
//  cengke_swift
//
//  Created by qlp on 2017/7/3.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class GoodsImageModel: NSObject {
    var price:String?
    var productImage:String?
    var skuAttrOneName:String?
    var skuAttrOneValue:String?
    var skuAttrTwoName:String?
    var skuAttrTwoValue:String?
    var skuNumber:String?
    var skuID:String?
    
    var oldPrice:String?
    var isDel:Int?
    var activityList:[Any]?
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
       return ["skuID":"id"]
    }
}
