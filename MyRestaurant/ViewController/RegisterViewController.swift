//
//  RegisterViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet weak var userNameTextFiled: UITextField!
    @IBOutlet weak var pwdTextFiled: UITextField!
    @IBOutlet weak var pwdAgainTextFiled: UITextField!
    @IBOutlet weak var agreeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapGesturePressed(_ sender: Any) {
        userNameTextFiled.resignFirstResponder()
        pwdTextFiled.resignFirstResponder()
        pwdAgainTextFiled.resignFirstResponder()
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFiledDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func conformBtnPressed(_ sender: Any) {
        guard userNameTextFiled.text != "" && pwdTextFiled.text != "" && pwdAgainTextFiled.text != "" else {
            let errorAlert = UIAlertController(title: "注册失败", message: "用户名和密码未填写", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard pwdAgainTextFiled.text == pwdTextFiled.text else {
            let errorAlert = UIAlertController(title: "注册失败", message: "请确保第二次密码与第一次密码相同", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        guard agreeSwitch.isOn else {
            let errorAlert = UIAlertController(title: "注册失败", message: "请确认同意用户协议", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() {return}
        
        let createSql = "CREATE TABLE IF NOT EXISTS user('name' TEXT NOT NULL PRIMARY KEY, 'pwd' TEXT, 'pic' BLOB);"
        if !sqlite.execNoneQuerySQL(sql: createSql) {sqlite.closeDB(); return}
        
        let userAdd = "INSERT INTO user(name, pwd) VALUES('\(userNameTextFiled.text!)', '\(pwdTextFiled.text!)');"
        if !sqlite.execNoneQuerySQL(sql: userAdd) {sqlite.closeDB(); return}
        
        sqlite.closeDB()
        
        
        defaults.set(userNameTextFiled.text, forKey: "userName")        //记住用户名
        if defaults.value(forKey: "pwd") != nil {
            defaults.removeObject(forKey: "pwd")
        }
        
        let successAlert = UIAlertController(title: "注册成功", message: "", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: { (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(successAlert, animated: true, completion: nil)
    }
    
}
