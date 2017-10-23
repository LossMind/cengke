

//
//  ChoseView.swift
//  cengke_swift
//
//  Created by qlp on 2017/7/3.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class ChoseView: UIView ,UITextFieldDelegate,UIAlertViewDelegate,typeSelectDelegate{
    //子视图
    var alphaView:UIView?
    var whiteView:UIView?
    var img:UIImageView?
    var lb_price:UILabel?
    var lb_stock:UILabel?
    var lb_detail:UILabel?
    var lb_line:UILabel?
    var oldPrice:UILabel?
    //
    var mainScrollView:UIScrollView?
    
    var szieView:typeView?
    var colorVIew:typeView?
    var countView:BuyCountView?
    //
    var bt_sure:UIButton?
    var bt_cancle:UIButton?
    //数据处理
    var sizeArr:[String]?
    var colArr:[String]?
    var goodsImgArr:[GoodsImageModel]?
    var stockDic:[String:Any]?
    var stock:Int?
    //字串
    var goodsProperty1:String?
    var goodsProperty2:String?
    var skuID:String?
    var product_Img:String?
    var size:String?
    var color:String?
    var price:Float?
    //数据模型
    var goodsModel:GoodsImageModel?
    //图片浏览
    var photo:HUPhotoBrowser?
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        stock = 100000
        self.backgroundColor = UIColor.clear
        //半透明视图
        alphaView = UIView.init()
        alphaView?.fixFrame(frame: [0,0,self.frame.width,self.frame.height])
        alphaView?.backgroundColor = UIColor.black
        alphaView?.alpha = 0.2
        self.addSubview(alphaView!)
        //装载商品信息的视图
        whiteView = UIView.init()
        whiteView?.fixFrame(frame: [0,200,self.frame.width,self.frame.height-200])
        whiteView?.backgroundColor = UIColor.white
        self.addSubview(whiteView!)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapped))
        whiteView?.addGestureRecognizer(tap)
        //商品图片
        img = UIImageView.init()
        img?.fixFrame(frame:[10,-20,100,100])
        img?.backgroundColor = UIColor.white
        img?.layer.cornerRadius = 4
        img?.layer.borderColor = UIColor.white.cgColor
        img?.layer.borderWidth = 5
        img?.layer.masksToBounds = true
        whiteView?.addSubview(img!)
        //
        bt_cancle = UIButton.init(type: .custom, frame: [(whiteView?.frame.width)!-40,10,30,30], backCol: nil, titleCol: nil, font: nil, title: nil , img: "close")
        whiteView?.addSubview(bt_cancle!)
        //商品价格
        lb_price = UILabel.init()
        lb_price?.fixFrame(frame: [(img?.frame.maxX)! + 20,10,100,20])
        lb_price?.textColor = UIColor.red
        lb_price?.font = UIFont.systemFont(ofSize: 14)
        whiteView?.addSubview(lb_price!)
        oldPrice = UILabel.init()
        oldPrice?.fixFrame(frame: [(lb_price?.frame.maxX)!+5,(lb_price?.frame.origin.y)!,80,20])
        oldPrice?.textColor = UIColor.lightGray
        oldPrice?.textAlignment = .left
        oldPrice?.font = UIFont.systemFont(ofSize: 14)
        whiteView?.addSubview(oldPrice!)
        //商品Sku
        lb_stock = UILabel.init()
        lb_stock?.fixFrame(frame:[(img?.frame.maxX)!+20,(lb_price?.frame.maxY)!,(whiteView?.frame.width)!-(img?.frame.maxX)!-40-40,20])
        lb_stock?.textColor = UIColor.black
        lb_stock?.font = UIFont.systemFont(ofSize:14)
        whiteView?.addSubview(lb_stock!)
        //用户所选择商品的尺码和颜色
        lb_detail = UILabel.init()
        lb_detail?.fixFrame(frame: [(img?.frame.maxX)!+20,(lb_stock?.frame.maxY)!,(whiteView?.frame.width)!-(img?.frame.maxX)!-40-40,40])
        lb_detail?.numberOfLines = 2
        lb_detail?.textColor = UIColor.black
        lb_detail?.font = UIFont.systemFont(ofSize: 14)
        whiteView?.addSubview(lb_detail!)
        //分界线
        lb_line = UILabel.init()
        lb_line?.fixFrame(frame: [0,(img?.frame.maxY)!+20,(whiteView?.frame.size.width)!,0.5])
        lb_line?.backgroundColor = UIColor.lightGray
        whiteView?.addSubview(lb_line!)
        //商品过多时，使用UISCrollView滑动显示
        mainScrollView = UIScrollView.init()
        mainScrollView?.fixFrame(frame: [0,(lb_line?.frame.maxY)!,(whiteView?.frame.width)!,(whiteView?.frame.height)!-(lb_line?.frame.maxY)!])
        mainScrollView?.showsHorizontalScrollIndicator = false
        mainScrollView?.showsVerticalScrollIndicator = false
        whiteView?.addSubview(mainScrollView!)
        //购买数量的视图
        countView = BuyCountView.init()
        countView?.fixFrame(frame: [0,0,self.frame.size.width,50])
        mainScrollView?.addSubview(countView!)
        countView?.bt_add?.addTarget(self, action: #selector(self.add), for: .touchUpInside)
        countView?.tf_count?.delegate = self
        countView?.bt_reduce?.addTarget(self, action: #selector(self.reduce), for: .touchUpInside)
        
    }
    
    func initTypeView(sizeArr:[String],colorArray:[String],stockDic:[String:Any]){
        self.sizeArr = sizeArr
        self.colArr = colorArray
        self.stockDic = stockDic
        //尺码
        if sizeArr.count > 0{
            szieView = typeView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 50), dataSource: self.sizeArr, typeName: self.goodsProperty1!)
            szieView?.delegate = self
            mainScrollView?.addSubview(szieView!)
            szieView?.fixFrame(frame: [0,0,self.frame.width,(szieView?.height)!])
        }
        //颜色分类
        if colorArray.count > 0{
            colorVIew = typeView.init(frame: CGRect.init(x: 0, y: (szieView?.frame.height)!, width: self.frame.width, height: 50), dataSource: self.colArr, typeName: self.goodsProperty2!)
            colorVIew?.delegate = self
            mainScrollView?.addSubview(colorVIew!)
            colorVIew?.fixFrame(frame: [0,(szieView?.frame.maxY)!,self.frame.width,(colorVIew?.height)!])
        }else{
            self.reloadBtn(arr:self.sizeArr!, view:szieView!)
        }
        //购买数量
        if colorArray.count > 0 {
            countView?.fixFrame(frame: [0,(colorVIew?.frame.maxY)!,self.frame.width,50])
        }else{
            countView?.fixFrame(frame: [0,(colorVIew?.frame.origin.y)!+(szieView?.frame.size.height)!,self.frame.width,50])
        }
        mainScrollView?.contentSize = CGSize.init(width: self.frame.width, height: (countView?.frame.maxY)!)
        let model = self.goodsImgArr?[0]
        lb_price?.text = "价格:￥\(model?.price ?? "")"
        if model?.oldPrice != nil{
            let newPrice = NSMutableAttributedString.init(string: "￥\(model?.oldPrice ?? "")")
            newPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: newPrice.length))
            oldPrice?.attributedText = newPrice
        }
        lb_detail?.text = "请选择商品 \(self.goodsProperty1 ?? "") \(self.goodsProperty2 ?? "")"
        //点击放大图片
        img?.sd_setImage(with: NSURL.init(string: (model?.productImage)!)! as URL)
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(self.showBigImage))
        img?.isUserInteractionEnabled = true
        img?.addGestureRecognizer(tap1)
        if (self.colArr?.count)! <= 0{
            if sizeArr.count == 1{
                let btn = szieView?.viewWithTag(20) as! UIButton
                szieView?.selIndex = btn.tag - 20
                let size = sizeArr[(szieView?.selIndex)!]
                self.size = size
                for model in self.goodsImgArr!{
                    if model.skuAttrOneValue == size {
                        lb_price?.text = "价格: ￥\(model.price ?? "")"
                        self.goodsModel = model
                        if model.oldPrice != nil {
                            let newPrice = NSMutableAttributedString.init(string: "￥\(model.oldPrice ?? "")")
                            newPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: newPrice.length))
                            oldPrice?.attributedText = newPrice
                        }
                        self.skuID = model.skuID
                        self.product_Img = model.productImage
                        //img?.sd_setImage(with: NSURL.init(string: model.productImage!) as? URL )
                        img?.sd_setImage(with: URL.init(string: model.productImage!))
                        lb_stock?.text = model.skuNumber
                        self.price = Float(model.price!)
                    }
                }
                lb_detail?.text = "已选 \"\(size)\""
                self.resumeBtn(arr: self.sizeArr!, view: self.szieView!)
                //self.resumeBtn(arr:self.colArr!, view: self.colorVIew!)
            }
        }else{
            if sizeArr.count == 1 && colorArray.count==1{
                let btn1 = szieView?.viewWithTag(20) as! UIButton
                let btn2 = colorVIew?.viewWithTag(20) as! UIButton
                szieView?.selIndex = btn1.tag - 20
                colorVIew?.selIndex = btn2.tag - 20
                let size = sizeArr[(szieView?.selIndex)!]
                let color = colorArray[(colorVIew?.selIndex)!]
                self.size = size
                self.color = color
                for model in self.goodsImgArr!{
                    if model.skuAttrOneValue == size && model.skuAttrTwoValue == color{
                        lb_price?.text = "价格: ￥\(model.price ?? "")"
                        self.goodsModel = model
                        if model.oldPrice != nil {
                            let newPrice = NSMutableAttributedString.init(string: "￥\(model.oldPrice ?? "")")
                            newPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: newPrice.length))
                            oldPrice?.attributedText = newPrice
                        }
                        self.skuID = model.skuID
                        self.product_Img = model.productImage
                        img?.sd_setImage(with: URL.init(string: model.productImage!))
                        lb_stock?.text = model.skuNumber
                        self.price = Float(model.price!)
                    }
                }
                lb_detail?.text = "已选 \"\(size)\" \"\(color)\""
                self.resumeBtn(arr: self.sizeArr!, view: self.szieView!)
                self.resumeBtn(arr:self.colArr!, view: self.colorVIew!)
            }
        }
        
    }

    /*
     此处嵌入浏览图片代码
     */
    func showBigImage(){
        if img?.image != nil {
            self.photo = HUPhotoBrowser.show(from: self.img, withImages: [(img?.image)!], at: 0)
        }
    }
    //Mark:-typeViewdelegate 
    func btnIndex(tag: Int, btn: UIButton) {
        if (self.colArr?.count)! > 0 {
            //通过seletIndex是否>=0来判断尺码和颜色是否被选择，-1是未选择状态
            if ((szieView?.selIndex)! >= 0&&(colorVIew?.selIndex)! >= 0){
                //尺码和颜色都选择的时候
                let size = self.sizeArr?[(szieView?.selIndex)!]
                let color = self.colArr?[(colorVIew?.selIndex)!]
                self.size = size
                self.color = color
                for model in self.goodsImgArr! {
                    if model.skuAttrOneValue == size && model.skuAttrTwoValue == color{
                        lb_price?.text = "价格: ￥\(model.price ?? "")"
                        self.goodsModel = model
                        if model.oldPrice != nil {
                            let newPrice = NSMutableAttributedString.init(string: "￥\(model.oldPrice ?? "")")
                            newPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: newPrice.length))
                            oldPrice?.attributedText = newPrice
                        }
                        self.skuID = model.skuID
                        self.product_Img = model.productImage
                        img?.sd_setImage(with: URL.init(string: model.productImage!))
                        lb_stock?.text = model.skuNumber
                        self.price = Float(model.price!)
                }
                }
                lb_detail?.text = "已选 \"\(size ?? "")\" \"\(color ?? "")\""
                stock = Int((stockDic?[size!] as! [String:String])[color!]!)
                self.reloadColBtn(arr: colArr!, view: colorVIew!, size: size!)
                self.reloadsizeBtn(arr: sizeArr!, view: szieView!, color: color!)
            }else if (szieView?.selIndex == -1 && colorVIew?.selIndex == -1) {
                //尺码和颜色都没选的时候
                let model = self.goodsImgArr?[0]
                lb_price?.text = "价格: ￥\(model?.price ?? "")"
                if model?.oldPrice != nil {
                    let newPrice = NSMutableAttributedString.init(string: "￥\(model?.oldPrice ?? "")")
                    newPrice.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber.init(value: 1), range: NSRange.init(location: 0, length: newPrice.length))
                    oldPrice?.attributedText = newPrice
                }
                lb_detail?.text = "请选择\"\(self.goodsProperty1 ?? "")\"\(self.goodsProperty2 ?? "")\""
                self.stock = 100000
                lb_stock?.text = nil
                img?.sd_setImage(with: URL.init(string: model!.productImage!))
                //全部恢复可点击状态
                self.resumeBtn(arr: self.colArr!, view: colorVIew!)
                self.resumeBtn(arr: sizeArr!, view: szieView!)
            }else if (szieView?.selIndex)! == -1 && (colorVIew?.selIndex)! >= 0{
                //选择了颜色
                let color = colArr?[(colorVIew?.selIndex!)!]
                
            }

        }
    }
    //恢复按钮的原始状态
    func resumeBtn(arr:[Any],view:typeView){
        for i in 0..<arr.count{
            let btn = view.viewWithTag(20+i) as! UIButton
            btn.isEnabled = true
            btn.isSelected = false
            btn.fixBackCol(col: [240,240,240])
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.white, for: .selected)
            if view.selIndex == i {
                btn.isSelected = true
                btn.backgroundColor = UIColor.red
            }
            
        }
    }
    //根据所选的尺码或者颜色对应的库存，确定哪些按钮不可选
    func reloadColBtn(arr:[Any],view:typeView,size:String){
        for i in 0..<arr.count{
          let btn = view.viewWithTag(20+i) as! UIButton
            btn.isEnabled = false
            btn.fixBackCol(col: [240,240,240])
            for model in self.goodsImgArr!{
                if model.skuAttrOneValue == size && model.skuAttrTwoValue == btn.titleLabel?.text{
                    let status = model.isDel
                    if status == 0 {
                        btn.isEnabled = false
                        btn.setTitleColor(UIColor.lightGray, for: .normal)
                    }else{
                        btn.isEnabled = true
                        btn.setTitleColor(UIColor.black, for: .normal)
                    }
                }
            }
            if view.selIndex == i {
                btn.isSelected = true
                btn.backgroundColor = UIColor.red
            }
        }
    }
    //根据所选的尺码或者颜色对应的库存确定哪些不可选
    func reloadsizeBtn(arr:[Any],view:typeView,color:String){
        for i in 0..<arr.count {
            let btn = view.viewWithTag(20+i) as! UIButton
            btn.isEnabled = false
            btn.fixBackCol(col: [240,240,240])
            for model in self.goodsImgArr!{
                if model.skuAttrTwoValue == color && model.skuAttrOneValue == btn.titleLabel?.text{
                    let status = model.isDel
                    if status == 0 {
                        btn.isEnabled = false
                        btn.setTitleColor(UIColor.lightGray, for: .normal)
                    }else{
                        btn.isEnabled = true
                        btn.setTitleColor(UIColor.black, for: .normal)
                    }
                }
            }
            if view.selIndex == i {
                btn.isSelected = true
                btn.backgroundColor = UIColor.red
            }
            
        }
    }
    func reloadBtn(arr:[Any],view:typeView){
        for i in 0..<arr.count{
            let btn = view.viewWithTag(20+i) as! UIButton
            btn.isSelected = false
            btn.fixBackCol(col: [240,240,240])
            for model in self.goodsImgArr!{
                if model.skuAttrOneValue == btn.titleLabel?.text{
                    let staus = model.isDel
                    if staus == 0{
                        btn.isEnabled = false
                        btn.setTitleColor(UIColor.lightGray, for: .normal)
                    }else{
                        btn.isEnabled = true
                        btn.setTitleColor(UIColor.black, for: .normal)
                    }
            
                }
            }
            if view.selIndex == i {
                btn.isSelected = true
                btn.backgroundColor = UIColor.red
            }
            
        }
    }

    func tapped(){
        mainScrollView?.contentOffset = CGPoint.zero
        countView?.tf_count?.resignFirstResponder()
    }
    //Mark:-数量加减
    func add(){
        let count = Int((countView?.tf_count?.text)!)
        if count! < 50{
            countView?.tf_count?.text = "\(count!+1)"
        }else{
            QProgressManager.showHUD(view: self, message: "数量超出范围", delay: 1)
        }
    }
    func reduce(){
        let count = Int((countView?.tf_count?.text)!)
        if count! > 1{
            countView?.tf_count?.text = "\(count!-1)"
        }
    }
    //#Mark:-tf_count delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        mainScrollView?.contentOffset = CGPoint.init(x: 0, y: (countView?.frame.origin.y)!)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let count = Int((countView?.tf_count?.text)!)
        if count == 0{
            countView?.tf_count?.text = "1"
        }else if count! > 50 {
            countView?.tf_count?.text = "50"
            QProgressManager.showHUD(view: self, message: "数量超出范围", delay: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
    


