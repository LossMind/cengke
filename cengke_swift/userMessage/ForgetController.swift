//
//  ForgetController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class ForgetController: UIViewController,UITextFieldDelegate {
    //子视图
    var phoneText:UITextField?
    var idCodeText:UITextField?
    var mainScroll:UIScrollView?
    var codeBtn:UIButton?
    var phone:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 254/250, green: 254/250, blue: 254/250, alpha: 1)
        self.setNavigationBar()
        self.creatUI()
        
    }
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
    func creatUI(){
        //
        mainScroll = UIScrollView.init(frame: self.view.bounds)
        mainScroll?.showsVerticalScrollIndicator = false
        mainScroll?.delegate  = self as? UIScrollViewDelegate
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ForgetController.dismissKeyBoard))
        mainScroll?.addGestureRecognizer(tap)
        self.view.addSubview(mainScroll!)
        
        //let tap = UITapGestureRecognizer.init(target: self, action: <#T##Selector?#>)
        phoneText = UITextField.init(frame: CGRect.init(x: 15, y: 40, width: SCREEN_H - 30, height: 40))
        phoneText?.placeholder = "请输入手机号码"
        phoneText?.delegate = self
        phoneText?.font = UIFont.systemFont(ofSize: 15)
        phoneText?.keyboardType = .numberPad
        let phoneImage = UIImageView.init(image: UIImage.init(named: "dianhua"))
        phoneText?.leftView = phoneImage
        phoneText?.leftViewMode = .always
        mainScroll?.addSubview(phoneText!)
        
        //
        let line1 = UIView.init(frame: CGRect.init(x: 20, y: (phoneText?.frame.maxY)!+5, width: SCREEN_W-40, height: 1))
        line1.backgroundColor = UIColor.lightGray
        mainScroll?.addSubview(line1)
        
        //
        idCodeText = UITextField.init(frame: CGRect.init(x: 15, y: line1.frame.maxY + 5, width: SCREEN_W - 40, height: 40))
        idCodeText?.placeholder = "请输入验证码"
        idCodeText?.font = UIFont.systemFont(ofSize: 15)
        idCodeText?.keyboardType = .numberPad
        let idcodeImage = UIImageView.init(image: UIImage.init(named: "anquan"))
        idCodeText?.leftView = idcodeImage
        idCodeText?.leftViewMode = .always
        //
        codeBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        codeBtn?.setTitle("获取验证码", for: .normal)
        codeBtn?.addTarget(self, action: #selector(ForgetController.getIdCode), for: .touchUpInside)
        codeBtn?.setTitleColor(UIColor.white, for: .normal)
        codeBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        codeBtn?.backgroundColor = UIColor.init(red: 127/250, green: 118/250, blue: 147/250, alpha: 1)
        idCodeText?.rightView = codeBtn
        idCodeText?.rightViewMode = .always
        mainScroll?.addSubview(idCodeText!)
        
        //
        let line2 = UIView.init(frame: CGRect.init(x: 20, y: (idCodeText?.frame.maxY)! + 5, width: SCREEN_W-40, height: 1))
        line2.backgroundColor = UIColor.lightGray
        mainScroll?.addSubview(line2)
        
        //
        let nextBtn = UIButton.init(frame: CGRect.init(x: 20, y: line2.frame.maxY + 50, width: SCREEN_W-40, height: 50))
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        nextBtn.titleLabel?.textColor = UIColor.white
        nextBtn.backgroundColor = UIColor.init(red: 127/250, green: 118/250, blue: 147/250, alpha: 1)
        nextBtn.addTarget(self, action: #selector(ForgetController.goNext), for: .touchUpInside)
        //registBtn.backgroundColor = UIColor.black
        mainScroll?.addSubview(nextBtn)
    }
    func goBack(){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    func goNext(){
        if phoneText?.text?.characters.count == 0 {
            QProgressManager.showHUD(view: self.view, message: "请输入手机号码", delay: 1)
        }else if idCodeText?.text?.characters.count == 0{
            QProgressManager.showHUD(view: self.view, message: "请输入验证码", delay: 1)
        }else if !self.isMobileNumber(mobileNumber: (phoneText?.text)!){
            QProgressManager.showHUD(view: self.view, message: "手机号码格式错误", delay: 1)
        }else {
            let proHUD = QProgressManager.init()
            proHUD.showProgressWithView(view: self.view)
            let path = "http://m.zenkers.cn:8001/user/checkVcode"
            
            DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: ["phone":phoneText?.text as AnyObject,"vCode":idCodeText?.text as AnyObject], View: self.view, completion: { (response) in
                proHUD.hideProgress()
                guard let jsonDic = response as? NSDictionary else{
                   return
                }
                let code = jsonDic["code"] as! NSNumber
                if code.intValue == 0{
                   let findVC = FindCodeController.init()
                    findVC.phoneNumber = jsonDic["phone"] as? String
                   self.navigationController?.pushViewController(findVC, animated: true)
                }
            })
        }
    }
    func getIdCode(){
        if phoneText?.text?.characters.count == 0{
            QProgressManager.showHUD(view: self.view, message: "请输入手机号码", delay: 1)
        }else if !self.isMobileNumber(mobileNumber: (phoneText?.text)!){
            QProgressManager.showHUD(view: self.view, message: "手机号码格式错误", delay: 1)
        }else{
            let path = "http://m.zenkers.cn:8001/user/vcoded"
            DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: ["mobile_phone":phoneText?.text as AnyObject], View: self.view, completion: { (response) in
                guard let jsonDic = response as? NSDictionary else{return}
                let code = jsonDic["code"] as! NSNumber
                if code.intValue == 0
                {
                    var timeCount = 59
                    let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
                    timer.setEventHandler(handler:{
                        if timeCount <= 0 {
                            timer.cancel()
                            DispatchQueue.main.async {
                                self.codeBtn?.setTitle("获取验证码", for: .normal)
                                self.codeBtn?.backgroundColor = UIColor.init(red: 127/250, green: 118/250, blue: 147/250, alpha: 1)
                                self.codeBtn?.isUserInteractionEnabled = true
                            }
                        }else {
                            //let seconds:Int = timeCount%60
                            DispatchQueue.main.async {
                                //设置按钮读秒效果
                                self.codeBtn?.setTitle("重新发送\(timeCount)", for: .normal)
                                self.codeBtn?.backgroundColor = UIColor.init(red: 221/250, green: 221/250, blue: 221/250, alpha: 1)
                                self.codeBtn?.isUserInteractionEnabled = false
                            }
                            timeCount-=1
                        }
                    })
                    timer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
                    timer.resume()
                }else {
                    QProgressManager.showHUD(view: self.view, message: jsonDic["message"] as! String, delay: 1)
                }
            })
        }
        
    }
    //键盘收起
    func dismissKeyBoard(){
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    //手机号长度
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneText {
            if range.location >= 11 {
                return false
            }
        }
        return true
    }


}
