//
//  OrderTableViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController, UpdateDataDelegate {

    var userName: String = ""
    var order: Order? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置tableView行高
        tableView.rowHeight = 160
        
        //获取全局变量
        if let tabBarViewController = tabBarController as? TabBarViewController {
            userName = tabBarViewController.userName
            order = tabBarViewController.order
            order?.updateDelegates.append(self as UpdateDataDelegate)
        }
        
        updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return order!.orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "order", for: indexPath) as! OrderTableViewCell
        
        if let dish = order!.getDish(index: indexPath.row) {
            cell.dish = dish
            cell.order = order
            cell.nameLabel.text = cell.dish!.name
            cell.unitPriceLabel.text = String(cell.dish!.price) + "¥"
            cell.img.image = cell.dish!.img
            
            if order!.orders.keys.contains(cell.dish!.id) {
                cell.countLabel.text = String(order!.orders[cell.dish!.id]!)
            } else {
                cell.countLabel.text = "0"
            }
            
            cell.totalPriceLabel.text = String(dish.price * Double(order!.orders[dish.id]!)) + "¥"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let warningAlert = UIAlertController(title: "删除警告", message: "确认删除这道菜品？ ", preferredStyle: .alert)
            warningAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: {(alertAction) in
                let deletedCell = self.tableView.cellForRow(at: indexPath) as! OrderTableViewCell
                
                self.order?.orders.removeValue(forKey: deletedCell.dish!.id)
                
                self.tableView.deleteRows(at: [indexPath], with: .fade)  //页面中删除
            }))
            warningAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            present(warningAlert, animated: true, completion: nil)
        }
    }
    
    func updateData() {
        tableView.reloadData()
        if order?.orders.count == 0 {
            title = "订单"
        } else {
            title = "总计：" + String(order!.totalPrice()) + "¥"
        }
    }
    
    @IBAction func purchaseBtnPressed(_ sender: Any) {
        
        guard order?.orders.count != 0 else {
            let errorAlert = UIAlertController(title: "确认订单失败", message: "当前没有订单", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            present(errorAlert, animated: true, completion: nil)
            return
        }
        
        var pwdTextField: UITextField? = nil
        
        let conformAlert = UIAlertController(title: "确认订单", message: "请输入密码", preferredStyle: .alert)       //创建警告窗口
        conformAlert.addTextField(configurationHandler: {(textField) in
            textField.isSecureTextEntry = true
            pwdTextField = textField                                                                              //将警告窗口的输入框绑定到外部，方便读取
            textField.placeholder = "Password"
        })
        
        conformAlert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (alertAction) in
            guard pwdTextField!.text != nil else {
                return
            }
            
            let sqlite = SQLiteManager.sharedInstance                                                               //查询密码
            if !sqlite.openDB() {return}
            
            let querryResult = sqlite.execQuerySQL(sql: "SELECT * FROM user WHERE name='\(self.userName)'")
            sqlite.closeDB()
            
            if let rightPwd = querryResult?[0]["pwd"] as? String {                                                  //密码正确时跳转页面
                if rightPwd == pwdTextField!.text! {
                    self.performSegue(withIdentifier: "thanksSegue", sender: nil)
                }
                else
                {
                    let errorAlert = UIAlertController(title: "结账失败", message: "密码错误 ", preferredStyle: .alert) //否则发出警告
                    errorAlert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
            }
        }))
        conformAlert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(conformAlert, animated: true, completion: nil)
        return
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "thanksSegue" {
            let thanksViewController = segue.destination as! ThanksViewController
            thanksViewController.order = order
        } else if segue.identifier == "detailSegue" {
            guard let dishDetailViewController = segue.destination as? DishDetailViewController else {
                return
            }
            
            guard let senderTableViewCell = sender as? OrderTableViewCell else {
                return
            }
            
            dishDetailViewController.dish = senderTableViewCell.dish!
            dishDetailViewController.order = senderTableViewCell.order
            order?.updateDelegates.append(dishDetailViewController as UpdateDataDelegate)
        }
    }
}
