//
//  GoodsDetailController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/29.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
import WebKit
class GoodsDetailController: UIViewController ,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CAAnimationDelegate{
    //产品id
    var product_id:String?
    
    //子视图
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView.init()
        view.fixFrame(frame: [0,0,SCREEN_W,SCREEN_H])
        view.backgroundColor = UIColor.white
        view.contentSize = CGSize.init(width: SCREEN_W, height: SCREEN_H*2)
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.delegate = self
        return view
    }()
    lazy var tableView:UITableView = {
        let view = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_W, height: SCREEN_H-50), style: .grouped)
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.register(GoodsDetailCell.self, forCellReuseIdentifier: "GoodsDetail")
        view.register(CustomViewCell.self, forCellReuseIdentifier: "Custom")
        view.register(CommentCell.self, forCellReuseIdentifier: "comment")
        return view
    }()
    lazy var webView:WKWebView = {
       let view = WKWebView.init(frame: CGRect.init(x: 0, y: SCREEN_H+64, width: SCREEN_W, height: SCREEN_H-114))
        view.scrollView.delegate = self
        view.scrollView.showsVerticalScrollIndicator = false
        return view
    }()
    var apphaView:UIView?
    var choseView:ChoseView?
    var overlay:UIView?
    lazy var bottomView:GoodsBottonView = {
       let view = GoodsBottonView.init()
       view.fixFrame(frame: [0,self.view.frame.height-50,SCREEN_W,50])
       view.backgroundColor = UIColor.white
       return view
    }()
    var headlab:UILabel?
    //bool
    var isStore:Bool = true
    var isShow:Bool = false
    //数据处理
    var model:GoodsDetailModel?
    var sizeArr:[String]?
    var colorArr:[String]?
    var goodsArr:[Any]?
    var contentArr:[Any]?
    var contentModel:contentModel?
    var activityArr:[Any]?
    var oldTotalPrice:Float = 0
    var totalPrice:Float = 0
    //图层绘制
    var layer:CALayer?
    var path:UIBezierPath?
    var cnt:Int = 0
    var emptyView:emptyView?
    lazy var user:Usr = {
        let data = UserDefaults.standard.object(forKey: "userData")
        return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! Usr
    }()
    //产品信息
    var center:CGPoint?
    var stockDic:NSDictionary?//产品库存量
    var goodsStock:Int = 0
    
    
    //加载视图
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //设置导航栏
        self.setNavigationType()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = Bundle.main.path(forResource: "stock", ofType: "plist")
        self.stockDic = NSDictionary.init(contentsOf: URL.init(fileURLWithPath: str!))!
        self.automaticallyAdjustsScrollViewInsets = false
        //子视图加载
        self.setUPGroup()
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(tableView)
        self.scrollView.addSubview(webView)
        self.creatChoseView()
        self.view.addSubview(bottomView)
        //创建头脚刷新label
        self.addRefreshLabel()
        //加载网络数据
        self.loadData()
        self.loadCartCountData()
        self.loadStoreData()
        
    }
    //Mark:子视图创建，处理
    //导航栏
    func setNavigationType(){
        self.setInViewWillAppear()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: (UIImage.init(named: "share")?.withRenderingMode(.alwaysOriginal)), style: .plain, target: self, action:#selector(self.share))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: (UIImage.init(named: "goods-back")?.withRenderingMode(.alwaysOriginal)), style: .plain, target: self, action: #selector(self.back))
    }
    func setInViewWillAppear(){
        
    }
    //导航栏分享
    func share(){
        
    }
    //导航栏返回
    func back(){
        self.navigationController?.popViewController(animated: true)
    }
    func setUPGroup(){
        
    }
    func creatChoseView(){
        
    }
    func addRefreshLabel(){
        
    }
    //Mark:-网络数据加载，处理
    func loadData(){
        
    }
    func loadCartCountData(){
        
    }
    func loadStoreData(){
        
    }


 

}
