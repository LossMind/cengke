//
//  limitDetailCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/29.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class limitDetailCell: UITableViewCell {
    var model:GoodsModel?{
        didSet{
            customView?.sd_setImage(with: NSURL.init(string: (model?.productImage)!)! as URL)
            titleLable?.text = model?.productName
            priceLable?.text = "￥" + (model?.price)!
            //let price:String =
            let oldPrice = NSMutableAttributedString.init(string:"￥"+(model?.oldPrice)!)
            oldPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: oldPrice.length))
            print(oldPrice)
            oldPriceLable?.attributedText = oldPrice
        }
    }
    //子控件
    final var customView:UIImageView?
    final var titleLable:UILabel?
    final var priceLable:UILabel?
    final var oldPriceLable:UILabel?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func addUI(){
        self.imageView?.removeFromSuperview()
        customView = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 100, height: 100))
        self.contentView.addSubview(customView!)
        //
        titleLable = UILabel.init(frame: CGRect.init(x: 130, y: 16, width: 200, height: 30))
        titleLable?.font = UIFont.systemFont(ofSize: 15)
        titleLable?.textColor = UIColor.black
        titleLable?.textAlignment = .left
        self.contentView.addSubview(titleLable!)
        //
        priceLable = UILabel.init(frame: CGRect.init(x: (titleLable?.mj_origin.x)!, y: (titleLable?.frame.maxY)!+5, width: 200, height: 20))
        priceLable?.font = UIFont.systemFont(ofSize: 17)
        priceLable?.textColor = UIColor.init(red: 218/250, green: 185/250, blue: 106/150, alpha: 1)
        priceLable?.textAlignment = .left
        self.contentView.addSubview(priceLable!)
        //
        oldPriceLable = UILabel.init(frame: CGRect.init(x: (titleLable?.mj_origin.x)!, y: (priceLable?.frame.maxY)!, width: 200, height: 20))
        oldPriceLable?.font = UIFont.systemFont(ofSize: 14)
        oldPriceLable?.textColor = UIColor.lightGray
        oldPriceLable?.textAlignment = .left
        self.contentView.addSubview(oldPriceLable!)
        
        let label = UILabel.init(frame: CGRect.init(x: SCREEN_H-100, y: 70, width: 80, height: 30))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = UIColor.init(red: 218/250, green: 185/250, blue: 106/250, alpha: 1)
        label.textColor = UIColor.white
        label.text = "立即抢购"
        self.contentView.addSubview(label)
        
        
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
