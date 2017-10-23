
//
//  GoodController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
import SwiftyJSON
class GoodController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView:UICollectionView?
    var flowlayOut:UICollectionViewFlowLayout?
    var dataArray:[GoodsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.creatUI()
        self.loadData()
        
    }
    func creatUI(){
        //
        self.flowlayOut? = UICollectionViewFlowLayout.init()
        flowlayOut?.scrollDirection = .vertical
        flowlayOut?.minimumLineSpacing = 1
        flowlayOut?.minimumInteritemSpacing = 1
        //
        self.collectionView? = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-44-64-44), collectionViewLayout: flowlayOut!)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.fixBackCol(col: [242,246,249])
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView?.register(GoodsCell.self, forCellWithReuseIdentifier: "goods")
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: "image")
        self.view.addSubview(self.collectionView!)
        //添加刷新
        let header:MJRefreshNormalHeader = MJRefreshNormalHeader.init { 
            self.loadData()
        }
        header.lastUpdatedTimeLabel.isHidden = false
        collectionView?.mj_header = header
    }
    func loadData(){
        let proHUD = QProgressManager.init()
        proHUD.showProgressWithView(view: self.view)
        let path = "http://m.zenkers.cn:8001/home/goodGoods"
        DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: nil, View: self.view) { (resonseObj) in
            //关闭刷新ui
            self.collectionView?.mj_header.endRefreshing()
            proHUD.hideProgress()
            let json = JSON(resonseObj)
            guard let code = json["code"].number else{return}
            if code.intValue == 0{
                self.dataArray.removeAll()
                let arr:[GoodsModel] = GoodsModel.mj_objectArray(withKeyValuesArray:json["productList"].rawValue) as! [GoodsModel]
                
                self.dataArray += arr
                self.collectionView?.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if self.dataArray.count>1&&self.dataArray.count%2 != 0 {
                return self.dataArray.count
            }else{
                return self.dataArray.count + 1
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell:ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCell
            cell.imageView?.image = UIImage.init(named: "youhaohuo.jpg")
            return cell
        default:
            if indexPath.row == 0{
                let cell:ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as! ImageCell
                cell.imageView?.image = UIImage.init(named: "goodgoods.jpg")
                return cell
            }else{
                let cell:GoodsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "goods", for: indexPath) as! GoodsCell
                cell.backgroundColor = UIColor.white
                let model:GoodsModel = dataArray[indexPath.row-1]
                cell.model = model
                return cell
                
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize.init(width: self.view.frame.width, height: 150*Screen_Scale)
        default:
            if indexPath.row==0{
            return CGSize.init(width: self.view.frame.width, height: 150*Screen_Scale)
            }else{
               return CGSize.init(width: self.view.frame.width*0.5-1, height: self.view.frame.width*0.5+65)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

            let headView = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 5, width: self.view.frame.width, height: 20))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = "- 有好货 -"
            headView.addSubview(label)
            return headView

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize.zero
        default:
            return CGSize.init(width: self.view.frame.width, height: 30)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row != 0{
            let detailVC = GoodsDetailController.init()
            detailVC.hidesBottomBarWhenPushed = true
            let model:GoodsModel = self.dataArray[indexPath.row-1]
            detailVC.product_id = model.productId
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
