//
//  CollectionTitleReusableView.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class CollectionTitleReusableView: UICollectionReusableView {
    lazy var titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 30))
    
    var title:String?{
        didSet{
            self.titleLabel.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.textAlignment = .center
        self.backgroundColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
