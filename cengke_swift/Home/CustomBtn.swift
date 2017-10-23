//
//  CustomBtn.swift
//  cengke_swift
//
//  Created by qlp on 2017/8/16.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class CustomBtn: UIButton {
    var label:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addUI(){
        label = UILabel.init(frame: CGRect.init(x: self.frame.width-20, y: -5, width: 18, height: 18))
        label?.isHidden = true
        label?.font = UIFont.systemFont(ofSize: 12)
        label?.textColor = UIColor.white
        label?.textAlignment = .center
        label?.layer.cornerRadius = 9
        label?.backgroundColor = UIColor.red
        self.addSubview(label!)
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 0, y: self.frame.height*2/3+5, width: self.frame.width, height: self.frame.width/3-5)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect.init(x: 10, y: 0, width: self.frame.size.width-10, height: self.frame.height*2/3)
    }

}
