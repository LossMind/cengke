//
//  ImageCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/8/9.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    var imageView:UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView? = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_W-20, height: 150*Screen_Scale))
        self.contentView.addSubview(imageView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
