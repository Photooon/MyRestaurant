//
//  DishTableViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class DishViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateDataDelegate {

    var restaurant: Restaurant? = nil
    var dishes: [Dish] = []
    var order: Order? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = restaurant?.name
        
        //获取此餐厅的菜品
        let sqlite = SQLiteManager.sharedInstance
        
        if !sqlite.openDB() {return}
        
        let querryResult = sqlite.execQuerySQL(sql: "SELECT id, restId, name, detail, price FROM dish WHERE restId=\(restaurant!.id)")
        
        for row in querryResult! {
            let dish = Dish(id: row["id"] as! Int, restId: row["restId"] as! Int, name: row["name"] as! String, detail: row["detail"] as! String, price: row["price"] as! Double)
            dish.img = ImageManager.LoadImage(tableName: "dish", id: row["id"] as! Int)
            dishes.append(dish)
        }
        
        sqlite.closeDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dishes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restImg", for: indexPath) as! RestImgTableViewCell
            cell.img.image = ImageManager.LoadImage(tableName: "restaurant", id: restaurant!.id)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dish", for: indexPath) as! DishTableViewCell
            
            cell.dish = dishes[indexPath.row]
            cell.order = order
            cell.dishNameLabel.text = cell.dish!.name
            cell.priceLabel.text = String(cell.dish!.price) + "¥"
            cell.img.image = cell.dish!.img
            
            if order!.orders.keys.contains(cell.dish!.id) {
                cell.countLabel.text = String(order!.orders[cell.dish!.id]!)
            } else {
                cell.countLabel.text = "0"
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            return 160
        }
    }
    
    func updateData() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dishDetailViewController = segue.destination as? DishDetailViewController else {
            return
        }
        
        guard let senderTableViewCell = sender as? DishTableViewCell else {
            return
        }
        
        dishDetailViewController.dish = senderTableViewCell.dish!
        dishDetailViewController.order = senderTableViewCell.order
        order?.updateDelegates.append(dishDetailViewController as UpdateDataDelegate)
    }
}
