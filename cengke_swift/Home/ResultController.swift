//
//  ResultController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/25.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
//import Alamofire
import SwiftyJSON
enum GoodsFromCBType:Int {
    case Search = 0//默认
    case Catagory
    case Brand
}
enum PriceOrderType {
    case PriceAsc//升序
    case PriceDes//降序
}
class ResultController: UIViewController,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var searchWord:String?
    var type:GoodsFromCBType = .Search
    var cbID:String?
    
    final var textField:UITextField?
    final var collextionView:UICollectionView?
    final lazy var dataSouce:[Any] = Array.init()
    final var sort:NSInteger?
    final var priceOrder:PriceOrderType = .PriceAsc//价格排序
    final lazy var noGoodsView:UIView = {()->UIView in
        //图片
        let view:UIView = UIView.init(frame: self.view.bounds)
        view.backgroundColor = UIColor.white
        view.isHidden = true
        let imageView = UIImageView.init(frame: CGRect.init(x: SCREEN_W*0.5-50, y: SCREEN_H*0.5-100, width: 100, height: 100))
        imageView.image = UIImage.init(named: "nosearch")
        view.addSubview(imageView)
        //文字
        let label = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY+20, width: SCREEN_W, height: 20))
        label.text = "您寻找的商品还未上架"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        view.addSubview(label)
        //添加点击键盘control事件
        let tap = UITapGestureRecognizer.init(target: self, action:#selector(self.tapClicked))
        view.addGestureRecognizer(tap)
        self.view.addSubview(view)
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.sort = 1
        self.setNavigationBar()
        self.creatUI()
        self.loadData()
    }
    func setNavigationBar(){
        textField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width-100, height: 30))
        textField?.returnKeyType = .search
        textField?.placeholder = "纯棉四件套"
        textField?.text = self.searchWord
        textField?.borderStyle = .none
        textField?.delegate = self
        textField?.font = UIFont.systemFont(ofSize: 14)
        textField?.clearButtonMode = .always
        textField?.backgroundColor = UIColor.init(red: 221/250, green: 221/250, blue: 221/250, alpha: 1)
        
        let imageView = UIImageView.init(image: UIImage.init(named: "search"))
        textField?.leftView = imageView
        textField?.layer.cornerRadius = 3
        textField?.leftViewMode = .always
        textField?.contentVerticalAlignment = .center
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: textField!)
        
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 35, height: 30))
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(ResultController.cancleClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    func cancleClick(){
        self.navigationController?.popViewController(animated: true)
    }
    func creatUI(){
        let arr = ["人气","销量","价格"]
        let titleView = SearchTitleView.init(frame: CGRect.init(x: 0, y: 64, width:self.view.frame.width, height: 40), titles: arr)
        titleView.clicked = {(index:Int) in
            switch index {
            case 0:
                self.sort = 4
            case 1: break
                
            default:
                if self.priceOrder  == .PriceAsc{
                    self.priceOrder = .PriceDes
                    self.sort = 3
                }else{
                    self.priceOrder = .PriceAsc
                    self.sort = 2
                }
            }
            self.loadData()
        }
        self.view.addSubview(titleView)
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.scrollDirection = .vertical
        
        collextionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 104, width: self.view.frame.width, height: self.view.frame.height-104), collectionViewLayout: flowLayout)
        collextionView?.dataSource = self
        collextionView?.delegate = self
        collextionView?.showsVerticalScrollIndicator = false
        collextionView?.backgroundColor = UIColor.white
        collextionView?.register(GoodsCell.self, forCellWithReuseIdentifier: "goods")
        //
//        let tap = UITapGestureRecognizer.init(target: self, action:#selector(self.tapClicked))
//        collextionView?.addGestureRecognizer(tap)
        self.view.addSubview(collextionView!)
        
    }

    func loadData(){
        let proHUD = QProgressManager.init()
        proHUD.showProgressWithView(view: self.view)
        var path:String
        var para = [String:Any]()
        switch type {
        case .Catagory:
            path = "http://m.zenkers.cn:8001/goods/category"
            para["categoryid"]=self.cbID
            para["pageindex"]=1
            let numberSort = NSNumber.init(value: self.sort!)
            para["sort"] = numberSort
        case .Brand:
            path = "http://m.zenkers.cn:8001/goods/brand"
            para["brandid"]=self.cbID
            para["pageindex"]=1
            let numberSort = NSNumber.init(value: self.sort!)
            para["sort"] = numberSort
        case .Search :
            path = "http://m.zenkers.cn:8001/search/search_all"
            para["word"]=self.searchWord
            para["pageindex"]=1
            let numberSort = NSNumber.init(value: self.sort!)
            para["sort"] = numberSort
        }
        DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: para as [String : AnyObject], View: self.view) { (response) in
            proHUD.hideProgress()
            self.paseData(response: response)
        }
    }
    func paseData(response:Any?){
        let  josn = JSON(response ?? "error")
        guard let code = josn["code"].number else{
            return
        }
        if code.intValue == 0{
            self.noGoodsView.isHidden = true
            dataSouce.removeAll()
            let array = GoodsModel.mj_objectArray(withKeyValuesArray: josn["data"]["products"].rawValue)
            if array == nil && array?.count == 0{return}
            dataSouce += array!
            self.collextionView?.reloadData()
        }else{
            self.noGoodsView.isHidden = false
        }
        
    }
    //Mark:- collectionView代理方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSouce.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collextionView?.dequeueReusableCell(withReuseIdentifier: "goods", for: indexPath)
        (cell as! GoodsCell).model = dataSouce[indexPath.row] as? GoodsModel
        
        return cell!
    }
    //layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.view.frame.width*0.5-1, height: self.view.frame.width*0.5+65)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSouce[indexPath.row] as? GoodsModel
        let GoodsDetailVC = GoodsDetailController.init()
        GoodsDetailVC.product_id = model?.productId
        self.navigationController?.pushViewController(GoodsDetailVC, animated: true)
    }
    //Mark:-键盘事件
    func tapClicked(){
        textField?.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0{
            QTTokenManager.search(text: textField.text!, key: "search")
            self.searchWord = textField.text
            self.type = .Search
            self.loadData()
            return true
        }
        return false
    }
    
}
