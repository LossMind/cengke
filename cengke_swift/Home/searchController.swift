//
//  searchController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/25.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class searchController: UIViewController,UITextFieldDelegate,typeSelectDelegate,UIScrollViewDelegate {
    var textField:UITextField?
    var mainScrollView:UIScrollView?
    lazy var hotSearch:[String] = Array.init()
    var historySear:[String]?
    var historyView:typeView?
    var hotView:typeView?

    override func viewDidLoad() {
        super.viewDidLoad()
        //设置导航栏
        self.setNavigationbar()
        //添加UI视图
        self.creatUI()
        //读取历史搜索数据
        self.readHistoryRecord()
        //加载热门搜索数据
        self.loadHotSearcch()
    }
    func setNavigationbar(){
        textField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width-100, height: 30))
        textField?.returnKeyType = .search
        textField?.placeholder = "纯棉四件套"
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
        btn.addTarget(self, action: #selector(searchController.cancleClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
    }
    //加载默认视图
    func creatUI(){
        self.view.backgroundColor = UIColor.white
        mainScrollView = UIScrollView.init(frame: self.view.bounds)
        mainScrollView?.showsVerticalScrollIndicator = false
        mainScrollView?.delegate = self
        //
        historyView = typeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 0), dataSource: nil, typeName: "历史记录")
        historyView?.isHidden = true
        
        hotView = typeView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 0), dataSource: nil, typeName: "热门搜索")
        //
        mainScrollView?.addSubview(historyView!)
        mainScrollView?.addSubview(hotView!)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(searchController.dismissKeyboard))
        mainScrollView?.addGestureRecognizer(tap)
        
        self.view.addSubview(mainScrollView!)
    
    }
   //Mark:-hotView
    //加载数据
    func loadHotSearcch(){
        let path = "http://m.zenkers.cn:8001/search/hot_search"
        DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: nil, View: self.view) { (response) in
            guard let jsonDic = response as? NSDictionary else{return}
            let arr = jsonDic["data"] as! [String]
            self.hotSearch.removeAll()
            self.hotSearch += arr
            self.refreshHotView()
            
        }
    }
    //刷新数据
    func refreshHotView(){
        if hotSearch.count != 0 {
            hotView?.setDataSource(dataSource: self.hotSearch, typeName: "热门搜索")
            hotView?.delegate = self
            mainScrollView?.addSubview(hotView!)
            mainScrollView?.contentSize = CGSize.init(width: self.view.frame.width, height: (hotView?.frame.maxY)! > self.view.frame.height ? (hotView?.frame.maxY)!:self.view.frame.height)
            }
    }

    //Mark:-历史记录
    //读取历史记录
    func readHistoryRecord(){
        let userDefaul = UserDefaults.standard
        historySear = userDefaul.array(forKey: "search") as? [String]
        self.refreshHistoryView()
    }
    //刷新新历史数据视图
    func refreshHistoryView(){
        if historySear == nil {
            historyView?.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 0)
            historyView?.isHidden = true
            hotView?.frame = CGRect.init(x: 0, y: (historyView?.frame.maxY)!, width: self.view.frame.width, height: (hotView?.height)!)
            return
        }
        historyView?.isHidden = false
        historyView?.isUserInteractionEnabled = true
        historyView?.setDataSource(dataSource: historySear!, typeName: "历史记录")
        historyView?.delegate = self
        let deleBtn = UIButton.init(frame: CGRect.init(x: self.view.frame.width-40, y: 10, width: 20, height: 20))
        deleBtn.setImage(UIImage.init(named: "lajitong"), for: .normal)
        deleBtn.addTarget(self, action: #selector(searchController.deleteClick), for: .touchUpInside)
        historyView?.addSubview(deleBtn)
        hotView?.frame = CGRect.init(x: 0, y: (historyView?.frame.maxY)!, width: self.view.frame.width, height: (hotView?.height)!)
        mainScrollView?.contentSize = CGSize.init(width: self.view.frame.width, height: (hotView?.frame.maxY)! > self.view.frame.height ? (hotView?.frame.maxY)!:self.view.frame.height)
    }
    //-清除历史记录
    func deleteClick(){
        QTTokenManager.removeObjectWithKey(key: "search")
        historySear = nil
        self.refreshHistoryView()
    }

    func cancleClick(){
        self.navigationController?.popViewController(animated: true)
    }
    //search跳转
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0{
            QTTokenManager.search(text: textField.text!, key: "search")
            self.readHistoryRecord()
            let resultVC = ResultController.init()
            resultVC.searchWord = textField.text
            self.navigationController?.pushViewController(resultVC, animated: true)
            
        }
        return true
    }
    //点击取消键盘
    func dismissKeyboard(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    //滚动取消键盘
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       textField?.resignFirstResponder()
    }
    //点击热词或历史记录跳转
    func btnIndex(tag: Int, btn: UIButton) {
        btn.backgroundColor = UIColor.init(red: 240/250, green: 240/250, blue: 240/250, alpha: 1)
        let resultVC = ResultController.init()
        resultVC.searchWord = btn.titleLabel?.text
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    

}
