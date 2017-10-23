//
//  WorthController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
import SwiftyJSON
class WorthController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    lazy var dataArray:[WorthModel] = []
    var tableView:UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.loadData()

    }
    func createUI(){
        tableView? = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64-44-44), style: .grouped)
        tableView?.showsVerticalScrollIndicator = false
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(WorthCell.self, forCellReuseIdentifier: "worth")
        self.view.addSubview(tableView!)
        
        let header = MJRefreshNormalHeader.init { 
            self.loadData()
        }
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = header
    }
    func loadData(){
        let proHUD = QProgressManager.init()
        proHUD.showProgressWithView(view: self.view)
        let path = "http://m.zenkers.cn:8001/home/subject"
        DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: nil, View: self.view) { (resonseObj) in
            //关闭刷新ui
            self.tableView?.mj_header.endRefreshing()
            proHUD.hideProgress()
            let json = JSON(resonseObj)
            guard let code = json["code"].number else{return}
            if code.intValue == 0{
                self.dataArray.removeAll()
                let arr:[WorthModel] = WorthModel.mj_objectArray(withKeyValuesArray:json["article"].rawValue) as! [WorthModel]
                
                self.dataArray += arr
                self.tableView?.reloadData()
            }
        }
    }
    //Mark：-
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WorthCell = tableView.dequeueReusableCell(withIdentifier: "worth", for: indexPath) as! WorthCell
        cell.selectionStyle = .none
        cell.worthModel = self.dataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:WorthModel = self.dataArray[indexPath.row]
        let detailVC = GoodsDetailController.init()
        detailVC.product_id = model.relevanceUrl
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.8, 0.5, 0.8)
        UIView.animate(withDuration: 1) { 
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

}
