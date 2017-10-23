//
//  emptyView.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/24.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
typealias RefreshBlock = ()->()
class emptyView: UIView {
    var refreshBlock:RefreshBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        //
        let imageView = UIImageView.init(frame: CGRect.init(x: SCREEN_W*0.5-50, y: SCREEN_H*05-100, width: 100, height: 100))
        imageView.image = UIImage.init(named: "nowife")
        self.addSubview(imageView)
        //
        let label = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 20, width: SCREEN_W, height: 20))
        label.text = "请检查你的网络连接"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(label)
        //
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(emptyView.refreahData))
        self.addGestureRecognizer(tap)
        
    }
    func refreahData(){
        if refreshBlock != nil {
            refreshBlock!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
