//
//  LoginViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var rememberPwd: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userName = defaults.string(forKey: "userName") {     //若登录过或刚注册完，则从默认设置中读取用户名
            userNameTextFiled.text = userName
        }
        
        if let pwd = defaults.string(forKey: "pwd") {               //若有密码则读取密码
            pwdTextField.text = pwd
            rememberPwd.isOn = true
        }
    }
    
    @IBAction func tapGesturePressed(_ sender: Any) {
        userNameTextFiled.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    @IBAction func backBtnPresssed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFiledDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func conformBtnPressed(_ sender: Any) {
        guard userNameTextFiled.text != "" && pwdTextField.text != "" else {
            let errorAlert = UIAlertController(title: "登录失败", message: "用户名或密码未填写 ", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return}
        let querryResult = sqlite.execQuerySQL(sql: "SELECT * FROM user WHERE name='\(userNameTextFiled.text!)'")
        sqlite.closeDB()
        
        if querryResult?.count != 0 {                                       //成功登录
            if let rightPwd = querryResult?[0]["pwd"] as? String {
                if rightPwd == pwdTextField.text! {
                    self.performSegue(withIdentifier: "loginedSegue", sender: self)
                    
                    defaults.set(userNameTextFiled.text, forKey: "userName")
                    
                    if rememberPwd.isOn {
                        defaults.set(pwdTextField.text, forKey: "pwd")
                    } else {
                        if defaults.string(forKey: "pwd") != nil {          //用户选择不记住密码时且登录成功时，把之前记住的密码也忘掉
                            defaults.removeObject(forKey: "pwd")
                        }
                    }
                    
                    return
                }
            }
        }
        
        
        let errorAlert = UIAlertController(title: "登录失败", message: "用户名或密码错误 ", preferredStyle: .alert)     //若前面的if失效，则说明登录失败，弹窗
        errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        present(errorAlert, animated: true, completion: nil)
        return
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginedSegue" {
            if let vc = segue.destination as? TabBarViewController {
                vc.userName = userNameTextFiled.text!
            }
        }
    }
}
