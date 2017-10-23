//
//  OverReduceController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/30.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
import SwiftyJSON
class OverReduceController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var tableView:UITableView?
    lazy var dataArray:[GoodsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func setNavigationBar(){
        self.navigationItem.title = "满减活动"
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(UIImage.init(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(self.goback), for: .touchUpInside)
        let leftBarbtn = UIBarButtonItem.init(customView: btn)
        let spaceBtn = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spaceBtn.width = -10
        self.navigationItem.leftBarButtonItems = [spaceBtn,leftBarbtn]
    }
    func goback(){
        self.navigationController?.popViewController(animated: true)
    }
    func creatUI(){
        tableView? = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.register(OverReduceCell.self, forCellReuseIdentifier: "activity")
        self.view.addSubview(tableView!)
        //添加刷新
        let header:MJRefreshNormalHeader = MJRefreshNormalHeader.init {
            self.loadData()
        }
        header.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = header
        let imageView:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_W, height: 150*Screen_Scale))
        imageView.image = UIImage.init(named: "manjian.jpg")
        tableView?.tableHeaderView = imageView
        
    }
    func loadData(){
        let proHUD = QProgressManager.init()
        proHUD.showProgressWithView(view: self.view)
        let path = "http://m.zenkers.cn:8001/activity/overReduce"
        DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: nil, View: self.view) { (resonseObj) in
            self.tableView?.mj_header.endRefreshing()
            proHUD.hideProgress()
            self.paseData(reponse: resonseObj)
        }
    }
    func paseData(reponse:Any?){
        let json = JSON(reponse ?? 0)
        guard let code = json["code"].number else{return}
        if code.intValue == 0{
            dataArray.removeAll()
            let arr:[GoodsModel] = GoodsModel.mj_objectArray(withKeyValuesArray:json["activity"]["productList"].rawValue) as! [GoodsModel]

            dataArray += arr

            self.tableView?.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OverReduceCell = tableView.dequeueReusableCell(withIdentifier: "activity", for: indexPath) as! OverReduceCell
        cell.selectionStyle = .none
        cell.model = dataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:GoodsModel = self.dataArray[indexPath.row]
        let detailVC:GoodsDetailController = GoodsDetailController.init()
        detailVC.product_id = model.productId
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }


}
