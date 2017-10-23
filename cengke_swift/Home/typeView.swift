//
//  typeView.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/25.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
protocol typeSelectDelegate {
    func btnIndex(tag:Int, btn:UIButton)
}
class typeView: UIView {
    var height:CGFloat = 0
    var selIndex:Int?
    var delegate:typeSelectDelegate?
    init(frame:CGRect, dataSource:[String]?, typeName:String) {
        super.init(frame: frame)
        if dataSource == nil {
            return
        }
        let lable = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: 200, height: 20))
        lable.text = typeName
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(lable)
        
        //var isLineReturn = false
        var  upX:CGFloat = 10
        var upY:CGFloat = 40
        var i:Int = 0
        for str in dataSource!{
            let dic = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
            let size = (str as NSString).size(attributes: dic)
            if upX > (self.frame.width-20-size.width-35){
                //isLineReturn = true
                upX = 10
                upY += 30
            }
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: upX, y: upY, width: size.width+30, height: 25)
            btn.backgroundColor = UIColor.init(red: 240/250, green: 240/250, blue: 240/240, alpha: 1)
            btn.setBackgroundImage(UIImage.init(named: "12.jpg"), for: .highlighted)
            btn.setTitle(str, for: UIControlState(rawValue: 0))
            btn.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            btn.layer.cornerRadius = 8
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.layer.borderWidth = 0
            btn.layer.masksToBounds = true
            
            self.addSubview(btn)
            
            btn.tag = 20+i
            btn.addTarget(self, action: #selector(typeView.touchBtn(btn:)), for: .touchUpInside)
            upX += size.width+35
            i += 1
        }
        upY += 30
        let line = UILabel.init(frame: CGRect.init(x: 0, y: upY+10, width: self.frame.width, height: 0.5))
        self.addSubview(line)
        self.height = upY + 11
        self.selIndex = -1
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height:self.height )
    }
    func setDataSource(dataSource:[String],typeName:String){
        for view in self.subviews{
            view.removeFromSuperview()
        }
        print(dataSource)
        let lable = UILabel.init(frame: CGRect.init(x: 10, y: 10, width: 200, height: 20))
        lable.text = typeName
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(lable)
        
        //var isLineReturn = false
        var  upX:CGFloat = 10
        var upY:CGFloat = 40
        var i:Int = 0
        for str in dataSource{
            let dic = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 14)]
            let size = (str as NSString).size(attributes: dic)
            if upX > (self.frame.width-20-size.width-35){
                //isLineReturn = true
                upX = 10
                upY += 30
            }
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect.init(x: upX, y: upY, width: size.width+30, height: 25)
            btn.backgroundColor = UIColor.init(red: 240/250, green: 240/250, blue: 240/240, alpha: 1)
            btn.setBackgroundImage(UIImage.init(named: "12.jpg"), for: .highlighted)
            btn.setTitle(str, for: UIControlState(rawValue: 0))
            btn.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
            btn.setTitleColor(UIColor.white, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            btn.layer.cornerRadius = 8
            btn.layer.borderColor = UIColor.clear.cgColor
            btn.layer.borderWidth = 0
            btn.layer.masksToBounds = true
            
            self.addSubview(btn)
            
            btn.tag = 20+i
            btn.addTarget(self, action: #selector(typeView.touchBtn(btn:)), for: .touchUpInside)
            upX += size.width+35
            i += 1
        }
        upY += 30
        let line = UILabel.init(frame: CGRect.init(x: 0, y: upY+10, width: self.frame.width, height: 0.5))
        self.height = upY + 11
        self.selIndex = -1
        self.frame = CGRect.init(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height:self.height )
        self.addSubview(line)
        
    }
    func touchBtn(btn:UIButton){
        if btn.isSelected == false{
            self.selIndex = btn.tag - 20
            btn.backgroundColor = UIColor.red
        }else{
            self.selIndex = -1
            btn.isSelected = false
            btn.backgroundColor = UIColor.init(red: 240/250, green: 240/250, blue: 240/250, alpha: 1)
            
        }
        self.delegate?.btnIndex(tag: btn.tag-20, btn: btn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
