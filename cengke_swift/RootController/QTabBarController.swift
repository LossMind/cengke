//
//  QTabBarController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class QTabBarController: UITabBarController,UITabBarControllerDelegate{
    var selectRemain:UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self as UITabBarControllerDelegate
        NotificationCenter.default.addObserver(self, selector: #selector(QTabBarController.logInSuccess), name: NSNotification.Name(rawValue: "logInSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QTabBarController.logOut), name: NSNotification.Name(rawValue: "logOut"), object: nil)
    
    }
    func logInSuccess(){
        self.selectedViewController = self.selectRemain
        
    }
    func logOut(){
        self.selectedViewController = self.viewControllers?.first
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.selectedViewController = viewController
        if viewController.tabBarItem.title == "购物车" || viewController.tabBarItem.title == "我的" {
            let data = UserDefaults.standard.object(forKey: "userData")

            if data == nil {
                let VC = LogInController.init()
                let NVVC = UINavigationController.init(rootViewController: VC)
                self.present(NVVC, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    deinit{
       NotificationCenter.default.removeObserver(self)
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
