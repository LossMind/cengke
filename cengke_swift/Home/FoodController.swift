//
//  FoodController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/14.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class FoodController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var collectionView:UICollectionView?
    var Flowlayout:UICollectionViewFlowLayout?
    var loadPath:String?
    lazy var baberArray:[Any] = []
    lazy var dataArray:[Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        self.loadData()
    }
    func createUI(){
        Flowlayout = UICollectionViewFlowLayout.init()
        Flowlayout?.scrollDirection = .vertical
        Flowlayout?.minimumLineSpacing = 1
        Flowlayout?.minimumInteritemSpacing = 1
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-64-44-44), collectionViewLayout:Flowlayout!)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(FoodCell.self, forCellWithReuseIdentifier: "food")
        
    }
    func loadData(){
        
    }
    func paseData(){
        
    }
    //Mark:-
    
    
    
    

}
