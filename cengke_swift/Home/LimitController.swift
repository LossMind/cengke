//
//  LimitController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
import SwiftyJSON
class LimitController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    lazy var dataArray:[GoodsModel] = []
    final var timeCount:Int = 0
    var timer:DispatchSourceTimer?
    
    
    //子控件
    final var tableView:UITableView?
    final var hourLabel:UILabel?
    final var minuteLbable:UILabel?
    final var secondLable:UILabel?
    final var timeLable:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.creatUI()
        self.loadData()
    }
    func setNavigationBar(){
        self.navigationItem.title = "限时蹭"
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(UIImage.init(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(self.goback), for: .touchUpInside)
        let leftItem = UIBarButtonItem.init(customView: btn)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.leftBarButtonItems = [leftItem,spaceItem]
        
    }
    func goback(){
        self.navigationController?.popViewController(animated: true)
        
    }
    func creatUI(){
        tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.register(limitDetailCell.self, forCellReuseIdentifier: "limit")
        self.view.addSubview(tableView!)
        
        //添加刷新
        let header = MJRefreshNormalHeader.init(refreshingBlock:{
             self.loadData()
        })
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView?.mj_header = header
        //添加头视图
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width:SCREEN_W, height: 30))
        tableView?.tableHeaderView = headerView
        let label = UILabel.init(frame: CGRect.init(x: 5, y: 5, width: 150, height: 20))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "抢购中，先下单先得哦"
        headerView.addSubview(label)
        
        //头视图添加计时UI
        secondLable = UILabel.init(frame: CGRect.init(x: SCREEN_W-40, y: 5, width: 20, height: 20))
        secondLable?.font = UIFont.systemFont(ofSize: 13)
        secondLable?.textColor = UIColor.white
        secondLable?.backgroundColor = UIColor.black
        secondLable?.textAlignment = .center
        secondLable?.text = "00"
        headerView.addSubview(secondLable!)
        //
        let lable = UILabel.init(frame: CGRect.init(x: (secondLable?.frame.origin.x)! - 10, y: (secondLable?.frame.origin.y)!, width: 10, height: 20))
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = ":"
        lable.textAlignment = NSTextAlignment.center
        headerView.addSubview(lable)
        
        minuteLbable = UILabel.init(frame: CGRect.init(x:(secondLable?.frame.origin.x)!-30 , y: (secondLable?.frame.origin.y)!
            , width: 20, height: 20))
        minuteLbable?.backgroundColor = UIColor.black
        minuteLbable?.textColor = UIColor.white
        minuteLbable?.font = UIFont.systemFont(ofSize: 13)
        minuteLbable?.textAlignment = NSTextAlignment.center
        minuteLbable?.text = "00"
        headerView.addSubview(minuteLbable!)
        let lable1 = UILabel.init(frame: CGRect.init(x: (minuteLbable?.frame.origin.x)! - 10, y: (secondLable?.frame.origin.y)!, width: 10, height: 20))
        lable1.font = UIFont.systemFont(ofSize: 13)
        lable1.text = ":"
        lable1.textAlignment = NSTextAlignment.center
        headerView.addSubview(lable1)
        
        hourLabel = UILabel.init(frame: CGRect.init(x: (minuteLbable?.frame.origin.x)! - 30, y: (minuteLbable?.frame.origin.y)!, width: 20, height: 20))
        hourLabel?.backgroundColor = UIColor.black
        hourLabel?.textColor = UIColor.white
        hourLabel?.font = UIFont.systemFont(ofSize: 13)
        hourLabel?.textAlignment = NSTextAlignment.center
        hourLabel?.text = "00"
        headerView.addSubview(hourLabel!)
        timeLable = UILabel.init(frame: CGRect.init(x: (hourLabel?.frame.origin.x)! - 60, y: (hourLabel?.frame.origin.y)!, width: 40, height: 20))
        timeLable?.text = "倒计时"
        timeLable?.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(timeLable!)
        
    }
    //
    func loadData(){
        let proHUD = QProgressManager.init()
        proHUD.showProgressWithView(view: self.view)
        let path = "http://m.zenkers.cn:8001/goods/limit"
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
            self.dataArray.removeAll()
            let arr:[GoodsModel] = GoodsModel.mj_objectArray(withKeyValuesArray:json["productList"].rawValue) as! [GoodsModel]
            self.timeCount = json["remainingTime"].intValue/1000
            
            if arr.count==0{return}
            dataArray += arr
            self.timeCountTask()
            self.tableView?.reloadData()
        }
    }
    //Mark:-绑定timer，开启倒计时
    func timeCountTask(){
        if self.timer == nil{
         timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
         //绑定响应block
        timer?.setEventHandler(handler: {
            if self.timeCount <= 0{
                self.timer?.cancel()
                self.timer = nil
                DispatchQueue.main.async {
                    self.refreshTimeUI(timeArr: [0,0,0,0])
                }
            }else{
                let days:Int = self.timeCount/(3600*24)
                let hours:Int = (self.timeCount - days*24*3600)/3600
                let minute:Int = (self.timeCount%3600)/60
                let second:Int = self.timeCount%60
                let timeArr = [days,hours,minute,second]
                DispatchQueue.main.async {
                    self.refreshTimeUI(timeArr: timeArr)
                    //print(timeArr)
                }
                self.timeCount -= 1
                print("timeCount:\(self.timeCount)")
            }
            
        })
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        self.timer?.resume()
    }
    }
    //刷新倒计时UI
    func refreshTimeUI(timeArr:[Int]){
        if timeArr[1] < 10 {
            hourLabel?.text = "0\(timeArr[1])"
        }else{
            hourLabel?.text = "\(timeArr[1])"
        }
        if timeArr[2] < 10 {
            minuteLbable?.text = "0\(timeArr[2])"
        }else{
            minuteLbable?.text = "\(timeArr[2])"
        }
        if timeArr[3] < 10 {
            secondLable?.text = "0\(timeArr[3])"
        }else{
            secondLable?.text = "\(timeArr[3])"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "limit", for: indexPath)
        cell.selectionStyle = .none
        (cell as! limitDetailCell).model = dataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:GoodsModel = self.dataArray[indexPath.row]
        let goodDetailVC = GoodsDetailController.init()
        goodDetailVC.product_id = model.productId
        self.navigationController?.pushViewController(goodDetailVC, animated: true)
        
    }
}
