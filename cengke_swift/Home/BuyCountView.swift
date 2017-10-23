
//
//  BuyCountView.swift
//  cengke_swift
//
//  Created by qlp on 2017/7/3.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class BuyCountView: UIView {

    var lb :UILabel?
    var bt_reduce:UIButton?
    var bt_add:UIButton?
    var tf_count:UITextField?
    
    override init(frame: CGRect) {
        //
        super.init(frame: frame)
        //
        lb = UILabel.init()
        lb?.fixLabel(frame: [10,10,100,30], font: 14, text: "购买数量", textCol: nil, backCol: nil, Aligent: .center)
        lb?.textColor = UIColor.black
        self.addSubview(lb!)
        //
        bt_add = UIButton.init(type: .custom, frame: [self.frame.width-10-40,10,40,30], backCol: [240,240,240], titleCol: UIColor.black, font: 20, title: "+", img: nil)
        self.addSubview(bt_add!)
        //
        tf_count = UITextField.init(frame: CGRect.init(x: (bt_add?.frame.origin.x)!-45, y: 10, width: 40, height: 30))
        tf_count?.text = "1"
        tf_count?.textAlignment = .center
        tf_count?.keyboardType = .numberPad
        tf_count?.backgroundColor = UIColor.init(red: 240/250, green: 240/250, blue: 240/250, alpha: 1)
        self.addSubview(tf_count!)
        //
        bt_reduce = UIButton.init(type: .custom, frame: [(tf_count?.frame.origin.x)!-45,10,40,30], backCol: [240,240,240], titleCol: UIColor.black, font: 20, title: "-", img: nil)
        self.addSubview(bt_reduce!)
        //
        let line = UIView.init(frame: CGRect.init(x: 0, y: self.frame.height-0.5, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        self.addSubview(line)
    
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
