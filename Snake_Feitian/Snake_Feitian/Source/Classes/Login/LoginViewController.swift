//
//  LoginViewController.swift
//  Snake-OrderSystem
//
//  Created by Snake on 2017/11/6.
//  Copyright © 2017年 Snake. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rememberPaswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //self.rememberPaswordButton.setImage(UIImage.init(named: "checkbox_1"), for: .normal)
        
        //是否自动登录
        self.autoLogin()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // =================================
    // MARK:
    // =================================
    
    func autoLogin() {
        
        if !SessionManager.share.rememberPhone.isEmpty {
            self.phoneTextField.text = SessionManager.share.rememberPhone
        }
        
        if SessionManager.share.isNeedRememberPassword {
            
            self.rememberPaswordButton.setImage(UIImage.init(named: "checkbox_selected_1"), for: .normal)
            SessionManager.share.isNeedRememberPassword = true
            
            if !SessionManager.share.rememberPassword.isEmpty {
                self.passwordTextField.text = SessionManager.share.rememberPassword
            }
        }
        
    }
    
    
    // =================================
    // MARK:
    // =================================

    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        
        let phoneValue: String = self.phoneTextField.text ?? ""
        let pwdValue: String = self.passwordTextField.text ?? ""
        let pwdValueMd5: String = pwdValue.md5()

        let dict: NSDictionary = ["username": phoneValue, "password": pwdValueMd5]
        let apiName: String = "http://123.207.68.190:21026/api/v1/user/login"
        
        if phoneValue.isEmpty || pwdValue.isEmpty {
            let alertVC: UIAlertController = UIAlertController.init(title: "提示：手机号或密码不能为空", message: "", preferredStyle: .alert)
            let alertAction: UIAlertAction = UIAlertAction.init(title: "确认", style: .default, handler: nil)
            
            alertVC.addAction(alertAction)
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
//            HttpRequestManager.sharedManager.postRequest(apiName: apiName, paramDict: dict, resultCallback: { (isSuccess: Bool, resultObject: Any) in
//
//                if isSuccess {
//
//                    let dict: NSDictionary = resultObject as! NSDictionary
//                    if let _: String = dict.value(forKey: "token") as? String {
//                        self.loginSuccessfully(phoneValue: phoneValue, pwdValue: pwdValue)
//                        //保存基本信息
//                        SessionManager.share.saveBasicInformation(dict: dict)
//                    }
//
//                } else {
//
//                    let dict: NSDictionary = resultObject as! NSDictionary
//                    let message: String = dict.value(forKey: "message") as! String
//
//                    let alertVC: UIAlertController = UIAlertController.init(title: message, message: "", preferredStyle: .alert)
//                    let cancelAction: UIAlertAction = UIAlertAction.init(title: "确认", style: .cancel, handler: nil)
//                    alertVC.addAction(cancelAction)
//                    self.present(alertVC, animated: true, completion: nil)
//                }
//
//            })
        }
        
    }
    
    @IBAction func rememberPwdButtonDidTouch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func loginSuccessfully(phoneValue: String, pwdValue: String) {
        
        SessionManager.share.isLogin = true
        
        SessionManager.share.rememberPhone = phoneValue
        
        SessionManager.share.isNeedRememberPassword = self.rememberPaswordButton.isSelected
        
        if self.rememberPaswordButton.isSelected {
            SessionManager.share.rememberPassword = pwdValue
        } else {
            SessionManager.share.rememberPassword = ""
        }
        
        NotificationCenter.default.post(name: K_LOGIN_CHECK_STATUS, object: nil, userInfo: nil)
        
    }
}
