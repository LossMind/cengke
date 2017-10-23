//
//  WorthCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/8/16.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class WorthCell: UITableViewCell {
    var worthModel:WorthModel?{
        didSet{
            customView?.sd_setImage(with: URL.init(string: (worthModel?.mainImg)!))
            title?.text = worthModel?.title
            subTitle?.text = worthModel?.tag
            subTitle?.sizeToFit()
            worthModel?.rowHeight = (subTitle?.frame.maxY)!+15
        }
    }
    final var customView:UIImageView?
    final var title:UILabel?
    final var subTitle:UILabel?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUI(){
        customView? = UIImageView.init(frame: CGRect.init(x: 10, y: 0, width: SCREEN_W-20 , height:160*Screen_Scale ))
        self.contentView.addSubview(customView!)
        title? = UILabel.init(frame: CGRect.init(x: Margin, y: (imageView?.frame.maxY)!+10, width: SCREEN_W-2*Margin, height: 20))
        title?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(title!)
         subTitle = UILabel.init(frame: CGRect.init(x: Margin, y:(title?.frame.maxY)!+10, width: SCREEN_W-2*Margin, height: 20))
        subTitle?.font = UIFont.systemFont(ofSize: 13)
        subTitle?.textColor = UIColor.gray
        subTitle?.numberOfLines = 0
        self.contentView.addSubview(subTitle!)
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
