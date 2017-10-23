//
//  LimitCell.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit
typealias CellBlock = (_ productID:String)->()
class LimitCell: UICollectionViewCell ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    //
    var limitgoods:[GoodsModel]?
    //数据模型
    var model:LimitModel?{
        didSet{
            cengImageView?.sd_setImage(with: NSURL.init(string:(model!).imgUrl!)! as URL)
            limitgoods = (model!).productList! 
            self.refreshTimeLable(time: Int(model!.remainingTime!)/1000, complete: 0)
            collectionView?.reloadData()
        }
        
    }
    //block点击事件
    var cellClicked:CellBlock?
    
    //视图控件
    final var cengImageView:UIImageView?
    final var hourLable:UILabel?
    final var minuteLabel:UILabel?
    final var secondLabel:UILabel?
    final var timeLanle:UILabel?
    final var timer:DispatchSourceTimer?
    final var time:Int?
    
    var collectionView:UICollectionView?
    
    override init(frame:CGRect){
        //UIView
        super.init(frame:frame)
        self.backgroundColor = UIColor.white
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func creatUI(){
        //主题图片
        cengImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 150*Screen_Scale))
        cengImageView?.image = UIImage.init(named: "11")
        cengImageView?.backgroundColor = UIColor.black
        self.contentView.addSubview(cengImageView!)
        //倒计时label
        secondLabel = UILabel.init(frame: CGRect.init(x: self.frame.width-40, y: (cengImageView?.frame.maxY)! + 5, width: 20, height: 20))
        secondLabel?.backgroundColor = UIColor.black
        secondLabel?.textColor = UIColor.white
        secondLabel?.font = UIFont.systemFont(ofSize: 13)
        secondLabel?.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(secondLabel!)
        let lable = UILabel.init(frame: CGRect.init(x: (secondLabel?.frame.origin.x)! - 10, y: (secondLabel?.frame.origin.y)!, width: 10, height: 20))
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = ":"
        lable.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(lable)
        
        minuteLabel = UILabel.init(frame: CGRect.init(x:(secondLabel?.frame.origin.x)! - 30 , y: (cengImageView?.frame.maxY)! + 5, width: 20, height: 20))
        minuteLabel?.backgroundColor = UIColor.black
        minuteLabel?.textColor = UIColor.white
        minuteLabel?.font = UIFont.systemFont(ofSize: 13)
        minuteLabel?.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(minuteLabel!)
        let lable1 = UILabel.init(frame: CGRect.init(x: (minuteLabel?.frame.origin.x)! - 10, y: (secondLabel?.frame.origin.y)!, width: 10, height: 20))
        lable1.font = UIFont.systemFont(ofSize: 13)
        lable1.text = ":"
        lable1.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(lable1)
        
        hourLable = UILabel.init(frame: CGRect.init(x: (minuteLabel?.frame.origin.x)! - 30, y: (cengImageView?.frame.maxY)! + 5, width: 20, height: 20))
        hourLable?.backgroundColor = UIColor.black
        hourLable?.textColor = UIColor.white
        hourLable?.font = UIFont.systemFont(ofSize: 13)
        hourLable?.textAlignment = NSTextAlignment.center
        self.contentView.addSubview(hourLable!)
        timeLanle = UILabel.init(frame: CGRect.init(x: (hourLable?.frame.origin.x)! - 60, y: (hourLable?.frame.origin.y)!, width: 40, height: 20))
        timeLanle?.text = "倒计时"
        timeLanle?.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(timeLanle!)
        //商品collectionView
        let layOut = UICollectionViewFlowLayout.init()
        layOut.scrollDirection = .horizontal
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: (hourLable?.frame.maxY)! + 5, width: self.frame.width, height: 150), collectionViewLayout: layOut)
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(GoodsCell.self, forCellWithReuseIdentifier: "goods")
        self.contentView.addSubview(collectionView!)
    }
    //Mark:- collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.limitgoods == nil {
            return 1
        }
        return self.limitgoods!.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goods", for: indexPath)
        if limitgoods == nil {return cell}
        cell.backgroundColor = UIColor.white
        (cell as! GoodsCell).model = limitgoods?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.limitgoods?[indexPath.row]
        if self.cellClicked != nil{
            self.cellClicked!((model?.productId)!)
        }
    }
    //Mark:-绑定timer，开启倒计时
    func refreshTimeLable(time:Int? ,complete:Any){
        self.time = time
        if timer == nil{
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
         //绑定响应block
        timer?.setEventHandler(handler: {
            if time == 0{
                self.timer?.cancel()
                self.timer = nil
                DispatchQueue.main.async {
                    self.refreshTimeUI(timeArr: [0,0,0,0])
                }
            }else{
                    let days:Int = self.time!/(3600*24)
                    let hours:Int = (self.time! - days*24*3600)/3600
                    let minute:Int = (self.time!%3600)/60
                    let second:Int = self.time!%60
                    let timeArr = [days,hours,minute,second]
                DispatchQueue.main.async {
                    self.refreshTimeUI(timeArr: timeArr)
                    //print(timeArr)
                }
                self.time = self.time! - 1
                //print("time\(self.time)")
            }
            
        })
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        timer?.resume()
        }
    }
    //刷新倒计时UI
    func refreshTimeUI(timeArr:[Int]){
        if timeArr[1] < 10 {
        hourLable?.text = "0\(timeArr[1])"
        }else{
        hourLable?.text = "\(timeArr[1])"
        }
        if timeArr[2] < 10 {
            minuteLabel?.text = "0\(timeArr[2])"
        }else{
            minuteLabel?.text = "\(timeArr[2])"
        }
        if timeArr[3] < 10 {
            secondLabel?.text = "0\(timeArr[3])"
        }else{
            secondLabel?.text = "\(timeArr[3])"
        }
    }
    
    
}
