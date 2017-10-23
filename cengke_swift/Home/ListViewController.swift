//
//  ListViewController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/13.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class ListViewController: UIViewController,UIScrollViewDelegate {
    //子类继承设置字体颜色
    lazy var titleNormalColor:UIColor = UIColor.black
    lazy var titleSelectedColor:UIColor = UIColor.red
    
    //私有属性
    final var titleScrollView:UIScrollView?
    final var contentScrollView:UIScrollView?
    final lazy var titlesButtonArray:Array<UIButton> = Array.init()
    final var isLayoutVC:Bool = false
    //title 尺寸
    final let titleWidth:CGFloat = 80
    final let titleHeight:CGFloat = 44
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        //1.标题占位View
        self.setTitlesView()
        //2.内容占位View
        self.setContensView()
        //3.添加父子VC
        self.addContentControllers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        //4.初始化标题栏内容
        if self.isLayoutVC == false {
            self.initTitleButton()
            self.isLayoutVC = true
        }
    }
    // Mark:- 标题占位View
    
    final func setTitlesView(){
        let titleView_Y:CGFloat = (self.navigationController?.isNavigationBarHidden)! ? 20:64
        self.titleScrollView = UIScrollView.init(frame:CGRect(x: 0, y: titleView_Y, width: SCREEN_W, height: titleHeight))
        self.titleScrollView?.backgroundColor = UIColor.white
        self.titleScrollView?.showsVerticalScrollIndicator = false
        self.titleScrollView?.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.titleScrollView!)
        
    }
    //Mark：- 内容占位View
    final func setContensView(){
        let contentView_Y:CGFloat = (self.titleScrollView?.frame.maxY)!
        self.contentScrollView = UIScrollView.init(frame: CGRect(x: 0, y: contentView_Y, width: SCREEN_W, height: SCREEN_H - contentView_Y))
        self.contentScrollView?.backgroundColor = UIColor.white
        self.contentScrollView?.showsVerticalScrollIndicator = false
        self.contentScrollView?.showsHorizontalScrollIndicator = false
        self.contentScrollView?.isPagingEnabled = true
        self.contentScrollView?.delegate = self
        self.contentScrollView?.bounces = false
        self.view.addSubview(self.contentScrollView!)
    }
    //Mark:- 添加父子VC
    final func addContentControllers(){
        //let array = self.layoutContentControllers()
        guard let array = self.layoutContentControllers() else { return }
        for VC in array {
             self.addChildViewController(VC)
        }
    }
    //Mark:- 子类重写添加控制器
    func layoutContentControllers() ->Array<UIViewController>? {
        return nil
    }
    //Mark:- 初始化标题栏
    final func initTitleButton (){
        let count = self.childViewControllers.count
        if count == 0 {return}
        var button_w = titleWidth
        if SCREEN_W/CGFloat(count) > button_w {
            button_w = SCREEN_W/CGFloat(count)
        }
        var i:CGFloat = 0
        for ChidVC in self.childViewControllers {
            let button = UIButton.init(type: UIButtonType.custom)
            button.frame = CGRect(x: button_w*i, y: 0, width: button_w, height: (self.titleScrollView?.frame.height)!)
            button.setTitle(ChidVC.title, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(titleNormalColor, for: UIControlState.normal)
            button.backgroundColor = self.titleScrollView?.backgroundColor
          
            button.addTarget(self, action:#selector(ListViewController.titleButtonClick(button:)), for: UIControlEvents.touchUpInside)
            self.titleScrollView?.addSubview(button)
            self.titlesButtonArray.append(button)
            if  i == 0 {
                print("helllo")
                self.titleButtonClick(button: button)
                //self.updateContentViewWithIndex(index:Int(i))
                button.setTitleColor(titleSelectedColor, for: UIControlState.normal)
                button.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            }
            i += 1
        }
        self.titleScrollView?.contentSize = CGSize(width: button_w*i, height:0)
        self.contentScrollView?.contentSize = CGSize(width: SCREEN_W*i, height: 0)
        
     
    }
    //Mark:- titlrButton点击事件
    final func titleButtonClick(button:UIButton){
        //1.改变也button状态
        let index = self.titlesButtonArray.index(of: button)
        self.updateTitleWithIndex(index: index!)
        //2.改变VC
        self.updateContentViewWithIndex(index: index!)

        
    }
    //Mark:- 更新title显示
    final func updateTitleWithIndex(index:Int){
        let button = self.titlesButtonArray[index]
        let offset_x = (button.center.x - SCREEN_W/2) > 0 ? (button.center.x - SCREEN_W/2) : 0
        let offset_max_x = (self.titleScrollView?.contentSize.width)! - SCREEN_W
        if offset_x > offset_max_x {
            self.titleScrollView?.setContentOffset(CGPoint(x: offset_max_x, y: 0), animated: true)
        }else{
            self.titleScrollView?.setContentOffset(CGPoint(x: offset_x, y: 0), animated: true)
        }
    }
    //Mark:- 添加子VC
    final func updateContentViewWithIndex(index:Int){
        let childVC = self.childViewControllers[index]

        self.contentScrollView?.setContentOffset(CGPoint(x: SCREEN_W*CGFloat(index), y: 0), animated: true)
        if (childVC.view.superview != nil) {
            return
        }
        childVC.view.frame = CGRect(x: SCREEN_W*CGFloat(index), y: 0, width: SCREEN_W, height: (self.contentScrollView?.frame.height)!)
        self.contentScrollView?.addSubview(childVC.view)

    }
    //Mark:- UISCrollView Delegate 
    final func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //根据偏移量给titlebutton逐渐改变状态
        //颜色
        let leftIndex:Int = Int(scrollView.contentOffset.x/SCREEN_W)
        let rightIndex:Int = leftIndex + 1
        let leftButton = self.titlesButtonArray[leftIndex]
        if rightIndex >= self.childViewControllers.count {
            return
        }
        let rightButton = self.titlesButtonArray[rightIndex]
        let scale = (scrollView.contentOffset.x - CGFloat(leftIndex)*SCREEN_W)/SCREEN_W
        //获取rgb颜色值
        //print(titleNormalColor.cgColor.components)
        //print(titleSelectedColor.cgColor.components)
        let NormalRGB_r = titleNormalColor.cgColor.components?.count == 2 ? 0 : titleNormalColor.cgColor.components?[0]
        //print(NormalRGB_r ?? 0)
        let NormalRGB_g = titleNormalColor.cgColor.components?.count == 2 ? 0 : titleNormalColor.cgColor.components?[1]
        let NormalRGB_b = titleNormalColor.cgColor.components?.count == 2 ? 0 : titleNormalColor.cgColor.components?[2]
        
        let SelectedRGB_r = titleSelectedColor.cgColor.components?.count == 2 ? 0 : titleSelectedColor.cgColor.components?[0]
        let SelectedRGB_g = titleSelectedColor.cgColor.components?.count == 2 ? 0 : titleSelectedColor.cgColor.components?[1]
        let SelectedRGB_b = titleSelectedColor.cgColor.components?.count == 2 ? 0 : titleSelectedColor.cgColor.components?[2]
        let leftColorR = SelectedRGB_r! - scale*(SelectedRGB_r! - NormalRGB_r!)
        let leftColorG = SelectedRGB_g! - scale*(SelectedRGB_g! - NormalRGB_g!)
        let leftColorB = SelectedRGB_b! - scale*(SelectedRGB_b! - NormalRGB_b!)
        leftButton.setTitleColor(UIColor.init(red: leftColorR, green: leftColorG, blue: leftColorB, alpha: 1), for: UIControlState.normal)
        let rightColorR = NormalRGB_r! + scale*(SelectedRGB_r! - NormalRGB_r!)
        let rightColorG = NormalRGB_g! + scale*(SelectedRGB_g! - NormalRGB_g!)
        let rightColorB = NormalRGB_b! + scale*(SelectedRGB_b! - NormalRGB_b!)
        rightButton.setTitleColor(UIColor.init(red: rightColorR, green: rightColorG, blue: rightColorB, alpha: 1), for: UIControlState.normal)


        //大小
        leftButton.transform = CGAffineTransform.init(scaleX: 1 + (1 - scale)*0.3, y: 1 + (1 - scale)*0.3)
        rightButton.transform = CGAffineTransform.init(scaleX: 1 + scale*0.3, y: 1 + scale*0.3)
    }
    final func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page:Int = Int(scrollView.contentOffset.x/SCREEN_W)
        self.updateTitleWithIndex(index: page)
        self.updateContentViewWithIndex(index:page)
    }

}
