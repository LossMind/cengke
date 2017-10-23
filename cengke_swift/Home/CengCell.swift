//
//  CengCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
typealias CengCellClicked = ()->()
class CengCell: UICollectionViewCell {
    //点击事件
    var signBtnClicked:CengCellClicked?
    var actvBtnClicked:CengCellClicked?
    
    final var signBtn:UIButton?
    final var avtvBtn:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    final func creatUI(){
        signBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: (self.frame.width - 2)*0.5, height: 140*Screen_Scale))
        signBtn?.setImage(UIImage.init(named: "qiandao"), for: UIControlState.normal)
        signBtn?.addTarget(self, action: #selector(CengCell.signClicked), for: UIControlEvents.touchUpInside)
        
        avtvBtn = UIButton.init(frame: CGRect.init(x: (signBtn?.frame.maxX)! + 2, y: 0 , width: (signBtn?.frame.width)!, height: (signBtn?.frame.height)!))
        avtvBtn?.setImage(UIImage.init(named: "gouman"), for: UIControlState.normal)
        avtvBtn?.addTarget(self, action: #selector(self.actvClicked), for: UIControlEvents.touchUpInside)
        
        self.contentView.addSubview(signBtn!)
        self.contentView.addSubview(avtvBtn!)
    }
    func signClicked(){
        if self.signBtnClicked != nil {
            self.signBtnClicked!()
        }
    }
    func actvClicked(){
        if self.actvBtnClicked != nil {
            self.actvBtnClicked!()
        }
    }

}
