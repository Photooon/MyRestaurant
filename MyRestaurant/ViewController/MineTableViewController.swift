//
//  MineTableViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/30.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class MineTableViewController: UITableViewController {

    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //获取全局变量
        if let tabBarViewController = tabBarController as? TabBarViewController {
            userName = tabBarViewController.userName
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as! UserTableViewCell
            cell.userNameLabel.text = userName
            cell.img.image = ImageManager.LoadImage(tableName: "user", userName: userName)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "about", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        } else {
            return 52
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
