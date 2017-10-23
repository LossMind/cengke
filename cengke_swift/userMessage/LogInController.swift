//
//  LogInController.swift
//  cengke_swift
//
//  Created by qlp on 2017/6/18.
//  Copyright © 2017年 qlp. All rights reserved.
//

import UIKit

class LogInController: UIViewController ,UITextFieldDelegate ,UIScrollViewDelegate{
    var scrollView:UIScrollView?
    var nameTextField:UITextField?
    var codeTextField:UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 254/250, green: 254/250, blue: 254/250, alpha: 1)
        self.setNavigationBar()
        self.creatUI()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    func setNavigationBar(){
        self.navigationItem.title = "账户登录"
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        button.setImage(UIImage.init(named: "back"), for: .normal)
        button.addTarget(self, action: #selector(LogInController.goBack), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem.init(customView: button)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.leftBarButtonItems = [spaceItem,leftBarBtn]
        
    }
    //Mark:-创建UI界面
    func creatUI(){
        //主视图scrollView
        scrollView = UIScrollView.init(frame: self.view.bounds)
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.delegate = self
        self.view.addSubview(scrollView!)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(LogInController.disMiss))
        scrollView?.addGestureRecognizer(tap)
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y:0, width: SCREEN_W, height: SCREEN_W/3))
        scrollView?.addSubview(imageView)
        //用户名输入
        nameTextField = UITextField.init(frame: CGRect.init(x: 15, y: imageView.frame.maxY + 10, width: SCREEN_W - 30, height: 30))
        nameTextField?.placeholder = "请输入手机号码"
        nameTextField?.delegate = self
        nameTextField?.keyboardType = .numberPad
        nameTextField?.font = UIFont.systemFont(ofSize: 15)
        let nameImageView = UIImageView.init(image: UIImage.init(named: "usertx"))
        let codeImgaeView = UIImageView.init(image: UIImage.init(named: "mima"))
        nameTextField?.leftView = nameImageView
        nameTextField?.leftViewMode = .always
        scrollView?.addSubview(nameTextField!)
        
        let line1 = UIView.init(frame: CGRect.init(x: 20, y: (nameTextField?.frame.maxY)! + 10, width: SCREEN_W - 40, height: 1))
        line1.backgroundColor = UIColor.black
        scrollView?.addSubview(line1)
        
        //密码输入
        codeTextField = UITextField.init(frame: CGRect.init(x: 15, y: line1.frame.maxY + 10, width: SCREEN_W - 30, height: 30))
        codeTextField?.delegate = self
        codeTextField?.placeholder = "请输入密码"
        codeTextField?.font = UIFont.systemFont(ofSize: 15)
        codeTextField?.isSecureTextEntry = true
        codeTextField?.leftView = codeImgaeView
        codeTextField?.leftViewMode = .always
        scrollView?.addSubview(codeTextField!)
        
        let line2 = UIView.init(frame: CGRect.init(x: 20, y: (codeTextField?.frame.maxY)! + 10, width: SCREEN_W - 40, height: 1))
        line2.backgroundColor = UIColor.black
        scrollView?.addSubview(line2)
        
        let label = UILabel.init(frame: CGRect.init(x: 15, y: line2.frame.maxY + 35, width: SCREEN_W - 30, height: 20))
        label.text = "分享好友变身会员！享八折优惠"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        scrollView?.addSubview(label)
        
        //登录按钮
        let loginBtn = UIButton.init(frame: CGRect.init(x: 20, y: label.frame.maxY + 10, width: SCREEN_W - 40, height: 50))
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        loginBtn.titleLabel?.textColor = UIColor.white
        loginBtn.backgroundColor = UIColor.init(red: 127/250, green: 118/250, blue: 147/250, alpha: 1)
        loginBtn.addTarget(self, action: #selector(LogInController.logIn), for: .touchUpInside)
        scrollView?.addSubview(loginBtn)
        
        //注册按钮
        let registerBtn = UIButton.init(frame: CGRect.init(x: 15, y: loginBtn.frame.maxY + 20, width: 60, height: 20))
        registerBtn.setTitle("注册账号", for: .normal)
        registerBtn.setTitleColor(UIColor.gray, for: .normal)
        registerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        registerBtn.titleLabel?.textAlignment = .left
        registerBtn.addTarget(self, action: #selector(LogInController.registAccount), for: .touchUpInside)
        scrollView?.addSubview(registerBtn)
        
        //忘记密码
        let forgetBtn = UIButton.init(frame: CGRect.init(x: SCREEN_W - 75, y: loginBtn.frame.maxY + 20, width: 60, height: 20))
        forgetBtn.setTitle("忘记密码", for: .normal)
        forgetBtn.setTitleColor(UIColor.gray, for: .normal)
        forgetBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        forgetBtn.titleLabel?.textAlignment = .right
        forgetBtn.addTarget(self, action: #selector(LogInController.forgetCode), for: .touchUpInside)
        scrollView?.addSubview(forgetBtn)
        
        let line3 = UIView.init(frame: CGRect.init(x: 40, y: registerBtn.frame.maxY + 70, width: SCREEN_W - 80, height: 1))
        line3.backgroundColor = UIColor.gray
        scrollView?.addSubview(line3)
        
        //其他登录方式
        let otherLabel = UILabel.init(frame: CGRect.init(x: SCREEN_W*0.5-50, y: line3.frame.maxY-11, width: 100, height: 21))
        otherLabel.text = "其他登录方式"
        otherLabel.backgroundColor = UIColor.white
        otherLabel.textColor = UIColor.gray
        otherLabel.font = UIFont.systemFont(ofSize: 14)
        otherLabel.textAlignment = .center
        scrollView?.addSubview(otherLabel)
        
        let qqBtn = UIButton.init(frame: CGRect.init(x: SCREEN_W*0.5 - 60, y: line3.frame.maxY + 40, width: 50, height: 50))
        qqBtn.setImage(UIImage.init(named: "qq"), for: .normal)
        //qqBtn.backgroundColor = UIColor.black
        qqBtn.addTarget(self, action: #selector(LogInController.qqLog), for: .touchUpInside)
        scrollView?.addSubview(qqBtn)
        
        let weixinBtn = UIButton.init(frame: CGRect.init(x: qqBtn.frame.maxX + 20, y: line3.frame.maxY + 40, width: 50, height: 50))
        weixinBtn.setImage(UIImage.init(named: "weixin"), for: .normal)
        weixinBtn.addTarget(self, action: #selector(LogInController.weixinLog), for: .touchUpInside)
        scrollView?.addSubview(weixinBtn)
        
        scrollView?.contentSize = CGSize.init(width: SCREEN_W, height: qqBtn.frame.maxY + 40)
        
        
        
    }
    //Mark:-UI绑定事件
    func goBack(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    func logIn(){
        if nameTextField?.text?.characters.count == 0{
            QProgressManager.showHUD(view: self.view, message: "请输入手机号码", delay: 1)
            return
        }else if codeTextField?.text?.characters.count == 0{
            QProgressManager.showHUD(view: self.view, message: "请输入密码", delay: 1)
            return
        }else if !self.isMobileNumber(mobileNumber: (nameTextField?.text)!) {
            QProgressManager.showHUD(view: self.view, message: "手机号码格式错误", delay: 1)
            return
        }else {
            let progressHUD = QProgressManager.init()
            progressHUD.showProgressWithView(view: self.view)
            let path = "http://m.zenkers.cn:8001/user/login"
            let dic  = ["username":nameTextField?.text,"password":codeTextField?.text]
            DownloadManager.sharedManager.request(requestType: .GET, urlString: path, parameters: dic as [String : AnyObject],View: self.view, completion: { (response) in
                progressHUD.hideProgress()
                guard let dic:[String:AnyObject] = response as? [String : AnyObject] else{
                    return
                }
                let code:NSNumber = dic["code"] as! NSNumber
                if Int(code) == 0 {
                    QProgressManager.showHUD(view: self.view, message: "登录成功", delay: 1)
                    let user:Usr = Usr.mj_object(withKeyValues: dic["data"]!["relogin"]!)
                    let userData = NSKeyedArchiver.archivedData(withRootObject: user)
                    UserDefaults.standard.set(userData, forKey: "userData")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion: {
                        
                    })
                    
                }else{
                    QProgressManager.showHUD(view: self.view, message: dic["message"] as! String, delay: 2)
                }
            })
        }
        
        
    }
    func registAccount(){
        let regVC = RegisterController.init()
        self.navigationController?.pushViewController(regVC, animated: true)
    }
    func forgetCode(){
        let forgetVC = ForgetController.init()
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    func qqLog(){
        
    }
    func weixinLog(){
        
    }
    //Mark:-键盘事件
    //收起
    func disMiss(){self.view.endEditing(true)}
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //手机号长度控制
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            if range.location >= 11 {
                return false
            }
        }
        return true
    }
    //Mark:-支持方法

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //加密
    //func MD5(inputString:String)->String{}



}
