//
//  QLPProgressHUDManager.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class QProgressManager:NSObject {
   var remainHUD:MBProgressHUD?
    //static let progressHUD:QProgressManager = QProgressManager.init(frame:CGRect.zero)
   class func showHUD(view:UIView,message:String,delay:TimeInterval){
        let progressHUD =  MBProgressHUD.init(view: view)
        //progressHUD.backgroundColor = UIColor.red
        progressHUD.label.text = message
        progressHUD.label.numberOfLines = 0
        progressHUD.mode = .customView
        view.addSubview(progressHUD)
        progressHUD.show(animated: true)
        progressHUD.hide(animated: true, afterDelay: delay)
        //progressHUD.removeFromSuperview()
        
    }
    func showProgressWithView(view:UIView){
    
        self.remainHUD = MBProgressHUD.init(view: view)
        //progressHUD = MBProgressHUD.init(view: view)
        //QProgressManager.progressHUD.frame = view.bounds
        view.addSubview(remainHUD!)
        remainHUD?.mode = .annularDeterminate
        remainHUD?.label.text = "Loading"
        remainHUD?.show(animated: true)
    
    }
    func hideProgress(){
     remainHUD?.hide(animated: true)
     remainHUD?.removeFromSuperview()
    }

}
