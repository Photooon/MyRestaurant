//
//  RestaurantTableViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurants: [Restaurant] = []
    var order: Order? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置tableView行高
        tableView.rowHeight = 287
        
        //得到全局订单变量
        if let tabBarViewController = self.tabBarController as? TabBarViewController {
            order = tabBarViewController.order
        }
        
        /*查询DB并将餐厅数据写入内存*/
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() {return}
        
        let querryResult = sqlite.execQuerySQL(sql: "SELECT * FROM restaurant")
        
        for row in querryResult! {
            let restaurant = Restaurant(id: row["id"] as! Int, name: row["name"] as! String, distance: row["distance"] as! Double)
            restaurant.img = ImageManager.LoadImage(tableName: "restaurant", id: row["id"] as! Int)
            restaurants.append(restaurant)
        }
        
        sqlite.closeDB()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return restaurants.count            //这里一个section存放一个餐厅，以便隔开每个餐厅
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurant", for: indexPath) as! RestaurantTableViewCell
        
        cell.restaurant = restaurants[indexPath.section]
        cell.nameLabel.text = cell.restaurant!.name
        cell.distLabel.text = String(cell.restaurant!.distance) + "km"
        cell.img.image = cell.restaurant!.img
        
        return cell
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
        guard let dishViewController = segue.destination as? DishViewController else {
            return
        }
        
        guard let senderTableViewCell = sender as? RestaurantTableViewCell else {
            return
        }
        
        dishViewController.restaurant = senderTableViewCell.restaurant
        dishViewController.order = order
        order?.updateDelegates.append(dishViewController)
    }
}
