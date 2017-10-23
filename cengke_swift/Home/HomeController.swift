//
//  HomeController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/12.
//  Copyright © 2017年 qlp. All rights reserved.
//#import "MJRefresh.h"
//#import "AFNetworking.h"
//#import "SDWebImageManager.h"
//#import "UIImageView+WebCache.h"
//#import "MJExtension.h"
//#import "SDCycleScrollView.h"
import UIKit

class HomeController: ListViewController {

    @IBOutlet weak var SearchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
   

    }
    func setNavigationBar(){
        SearchBtn.frame.size = CGSize.init(width: 200, height: 30)
        SearchBtn.layer.cornerRadius = 5
        SearchBtn.layer.masksToBounds = true
    }
    @IBAction func SearchBtnClick(_ sender: Any) {
        let searchVC = searchController.init()
        searchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(searchVC, animated: true)
        
    }
    override func layoutContentControllers() -> Array<UIViewController>? {
        var array = Array<UIViewController>.init()
        
        let commondVC = RecoommendController.init()
        let goodVC = GoodController.init()
        let WorthVC = WorthController.init()
        let houseLiveVC = HouseLiveController.init()
        let digitalVC = DigitalController.init()
        let foodVC = FoodController.init()
        
        commondVC.title = "推荐"
        goodVC.title = "有好货"
        WorthVC.title = "值得买"
        houseLiveVC.title = "家居日用"
        digitalVC.title = "时尚数码"
        foodVC.title = "安心美食"
        
        array.append(commondVC)
        array.append(goodVC)
        array.append(WorthVC)
        array.append(houseLiveVC)
        array.append(digitalVC)
        array.append(foodVC)
        
        return array

    }
}
