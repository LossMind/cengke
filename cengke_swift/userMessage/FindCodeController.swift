
//
//  FindCodeController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class FindCodeController: UIViewController ,UITextFieldDelegate{
    var phoneNumber:String?
    
    var codeText:UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setNavigationBar()
        self.creatUI()
        // Do any additional setup after loading the view.
    }
    //Mark:navigation
    func setNavigationBar(){
        self.navigationItem.title = "找回密码"
        let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(UIImage.init(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(ForgetController.goBack), for:.touchUpInside)
        let leftBtn = UIBarButtonItem.init(customView: btn)
        let spaceItem =  UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.leftBarButtonItems = [leftBtn,spaceItem]
    }
    func goBack(){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    //
    func creatUI(){
        codeText = UITextField.init(frame: CGRect.init(x: 15, y: 104, width: SCREEN_H - 30, height: 50))
        codeText?.placeholder = "  输入新密码"
        codeText?.delegate = self
        codeText?.backgroundColor = UIColor.lightGray
        codeText?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(codeText!)
        //
        let doneBtn = UIButton.init(frame: CGRect.init(x: 15, y: (codeText?.frame.maxY)! + 50, width: SCREEN_W - 30, height: 50))
        doneBtn.setTitle("完成", for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        doneBtn.titleLabel?.textColor = UIColor.white
        doneBtn.backgroundColor = UIColor.init(red: 127/250, green: 118/250, blue: 147/250, alpha: 1)
        doneBtn.addTarget(self, action: #selector(FindCodeController.doneChange), for: .touchUpInside)
    }
    func doneChange(){
        self.view.endEditing(true)
        if (codeText?.text?.characters.count)! < 6 {
            QProgressManager.showHUD(view: self.view, message: "您的密码过短", delay: 1)
        }else{
            let proHUD = QProgressManager.init()
            proHUD.showProgressWithView(view: self.view)
            let path = "http://m.zenkers.cn:8001/user/newPassword"
            DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: ["phone":self.phoneNumber as AnyObject,"password":self.codeText?.text?.MD5() as AnyObject], View: self.view, completion: { (resonse) in
                guard let jsonDic = resonse as?NSDictionary else{return}
                let code = jsonDic["code"] as! NSNumber
                if code.intValue == 0{
                    QProgressManager.showHUD(view: self.view, message: "修改密码成功", delay: 1)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    //键盘收起
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
