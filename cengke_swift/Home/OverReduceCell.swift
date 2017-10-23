//
//  OverReduceCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/8/9.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class OverReduceCell: UITableViewCell {
    
    var model:GoodsModel?{
        didSet{
            customView?.sd_setImage(with: URL.init(string: (model?.productImage)!))
            titleLabel?.text = model?.productName
            priceLabel?.text = "￥"+(model?.price)!
        }
    }
    var customView:UIImageView?
    var titleLabel:UILabel?
    var priceLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addUI(){
        customView? = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 100, height: 100))
        self.contentView.addSubview(customView!)
        
        titleLabel? = UILabel.init(frame: CGRect.init(x: 130, y: 16, width: 170, height: 30))
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        titleLabel?.textColor = UIColor.black
        titleLabel?.textAlignment = .left
        self.contentView.addSubview(titleLabel!)
        
        priceLabel? = UILabel.init()
        priceLabel?.fixLabel(frame: [SCREEN_W-100,70,80,30], font: 15, text: "全场满减", textCol: nil, backCol:[218,185,106], Aligent: .center)
        priceLabel?.textColor = UIColor.white
        self.contentView.addSubview(priceLabel!)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
