//
//  CycleCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
typealias cycleCellClicked = (_ index:Int)->()
class CycleCell: UICollectionViewCell ,SDCycleScrollViewDelegate{
    //数据
    var CycleCellArray:NSArray?
    //点击响应
    var beClicked:cycleCellClicked?
    //自视图
    var cycleView:SDCycleScrollView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addUI(){
        cycleView = SDCycleScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 150*Screen_Scale), delegate: self, placeholderImage: nil)
        cycleView?.pageControlStyle = SDCycleScrollViewPageContolStyleClassic
        cycleView?.pageControlAliment = SDCycleScrollViewPageContolAlimentRight
        self.contentView.addSubview(cycleView!)
        
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        if self.beClicked != nil {
            self.beClicked!(index)
        }
    }
    
}
