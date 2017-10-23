//
//  SearchTitleView.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/26.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
typealias onClickBlock = (_ index:NSInteger)->()
class SearchTitleView: UIView {
    //
    var items:[String]?
    var forward:Bool?
    var clicked:onClickBlock?
    var selctedBtn:UIButton?
    final var shapeLayer:CAShapeLayer?
    init(frame: CGRect,titles:[String]?) {
        super.init(frame: frame)
        self.addTitles(titles: titles)
        self.forward = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addTitles(titles:[String]?) {
        if titles == nil && titles?.count==0{return}
        
        var i:CGFloat = 0
        let count = CGFloat(titles!.count)
        let width = self.frame.width
        let height = self.frame.height
        for str in titles! {
            let btn = UIButton.init(frame: CGRect.init(x: i*width/count, y: 0, width: (width-2)/count, height: height))
            btn.setTitle(str, for: .normal)
            btn.setImage(UIImage.init(named: "header-search"), for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.tag = Int(210 + i)
            btn.addTarget(self, action: #selector(self.onClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
            //
            let line = UIView.init(frame: CGRect.init(x: btn.frame.maxX, y: 10, width: 1, height: height-20))
            line.backgroundColor = UIColor.init(red: 200/250, green: 200/250, blue: 200/250, alpha: 1)
            self.addSubview(line)
            if Int(i) == 0{
                btn.setTitleColor(UIColor.red, for: .normal)
                self.selctedBtn = btn
            }else if Int(i) == 2{
                shapeLayer = CAShapeLayer.init()
                let path = UIBezierPath.init()
                path.move(to: CGPoint.init(x: 0, y: 0))
                path.addLine(to: CGPoint.init(x: 8, y: 0))
                path.addLine(to: CGPoint.init(x: 4, y: 5))
                path.close()
                shapeLayer?.path = path.cgPath
                shapeLayer?.lineWidth = 1.0
                shapeLayer?.fillColor = UIColor.gray.cgColor

                let bound = shapeLayer?.path?.copy(strokingWithWidth: (shapeLayer?.lineWidth)!,lineCap: CGLineCap.butt,lineJoin: CGLineJoin.miter, miterLimit: (shapeLayer?.miterLimit)!, transform: CGAffineTransform.init())
                shapeLayer?.bounds = (bound?.boundingBox)!
                shapeLayer?.position = CGPoint.init(x:self.frame.width-20, y: self.frame.height*0.5)
                shapeLayer?.backgroundColor = UIColor.blue.cgColor
                self.layer.addSublayer(shapeLayer!)
            }
            i += 1
            //btnArray.append(btn)
        }
    }
    func onClick(btn:UIButton){
        self.selctedBtn?.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        self.selctedBtn = btn
        let index = btn.tag-210
        if index==2{
            if self.forward! {
                self.forward = false
            }else{
                self.forward = true
            }
            let animation = CAKeyframeAnimation.init(keyPath: "transform.rotation")
            animation.values = self.forward! ? [0,Double.pi]:[Double.pi,0]
            animation.isRemovedOnCompletion = false
            animation.fillMode = kCAFillModeForwards
            shapeLayer?.add(animation, forKey: animation.keyPath)
        }
        if self.clicked != nil {
            self.clicked!(index)
        }
    }
}
