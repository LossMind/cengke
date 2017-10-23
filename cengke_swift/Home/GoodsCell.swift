//
//  GoodsCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class GoodsCell: UICollectionViewCell {
    var model:GoodsModel?{
        didSet{
            imageView?.sd_setImage(with: NSURL.init(string: model!.productImage!)! as URL)
            titleLabel?.text = model!.productName
            priceLabel?.text = "￥:" + model!.price!
        }
    }
    var priceLabel:UILabel?
    var titleLabel:UILabel?
    var imageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addUI(){
        imageView = UIImageView.init(frame:CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
        self.addSubview(imageView!)
        
        titleLabel = UILabel.init(frame: CGRect.init(x: 5, y: (imageView?.frame.maxY)!+5, width: self.frame.width - 10, height: 15))
        titleLabel?.font = UIFont.systemFont(ofSize: 13)
        titleLabel?.textAlignment = .center
        self.addSubview(titleLabel!)
        
        priceLabel = UILabel.init(frame: CGRect.init(x: 0, y: (titleLabel?.frame.maxY)! + 5, width: self.frame.width, height: 15))
        priceLabel?.font = UIFont.systemFont(ofSize: 13)
        priceLabel?.textColor = UIColor.init(red: 218/250, green: 185/250, blue: 106/250, alpha: 1)
        priceLabel?.textAlignment = .center
        self.addSubview(priceLabel!)
        
    }
    
}
