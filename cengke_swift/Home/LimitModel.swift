//
//  LimitModel.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/15.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class LimitModel: NSObject {
    var imgUrl:String?
    var productList:[GoodsModel]?
    var remainingTime:NSNumber?
    
    override func mj_keyValuesDidFinishConvertingToObject() {
        self.productList = GoodsModel.mj_objectArray(withKeyValuesArray: self.productList).copy() as? [GoodsModel]
    }
    
}
