//
//  Order.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit
import Foundation

protocol UpdateDataDelegate {                                   //更新菜品数据协议，所有要使用菜品数量这个信息的页面均要遵守，以便同步更新
    func updateData()
}

class Order: NSObject {
    var orders: [Int: Int] = [:]                                //[菜品号: 数量]
    var tabBarViewController: TabBarViewController? = nil       //用于更新小红点
    var updateDelegates: [UpdateDataDelegate] = []              //所有使用了Order的ViewController均要在此注册更新函数，以便数据同步更新
    
    /*由于订单使用字典实现，所以实现一个方法用于查询下标所对应的字典的value*/
    func getDish(index: Int) -> Dish? {                         //依据index获取diss
        var dishId = 0
        var temp = 0
        for (key, _) in orders {    //遍历字典
            if temp == index {
                dishId = key
                break
            }
            temp += 1
        }
        
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return nil}
        let querryResult = sqlite.execQuerySQL(sql: "SELECT * FROM dish WHERE id=\(dishId)")
        //print(querryResult)
        var dish: Dish? = nil
        for row in querryResult! {
            dish = Dish(id: row["id"] as! Int, restId: row["restId"] as! Int, name: row["name"] as! String, detail: row["detail"] as! String, price: row["price"] as! Double)
            dish!.img = ImageManager.LoadImage(tableName: "dish", id: row["id"] as! Int)
            break
        }
        sqlite.closeDB()
        
        return dish
    }
    
    /*通过给定菜品的ID，在数据库中查询菜品并转为Dish类后返回*/
    func getDish(id: Int) -> Dish? {
        let sqlite = SQLiteManager.sharedInstance
        if !sqlite.openDB() {return nil}
        let querryResult = sqlite.execQuerySQL(sql: "SELECT * FROM dish WHERE id=\(id)")
        //print(querryResult)
        var dish: Dish? = nil
        for row in querryResult! {
            dish = Dish(id: row["id"] as! Int, restId: row["restId"] as! Int, name: row["name"] as! String, detail: row["detail"] as! String, price: row["price"] as! Double)
            dish!.img = ImageManager.LoadImage(tableName: "dish", id: row["id"] as! Int)
            break
        }
        sqlite.closeDB()
        
        return dish
    }
    
    func addDish(id: Int) {
        if orders.keys.contains(id) {
            orders[id]! += 1
        } else {
            orders[id] = 1
        }
        updateData()
    }
    
    func subDish(id: Int) {
        if orders.keys.contains(id) {
            if orders[id]! == 1 {
                orders.removeValue(forKey: id)
            } else if orders[id]! > 1 {
                orders[id]! -= 1
            }
        }
        updateData()
    }
    
    /*全部清空*/
    func clear() {
        orders.removeAll()
        updateData()
    }
    
    /*总价计算*/
    func totalPrice() -> Double {
        var totalPrice: Double = 0
        for (key, value) in orders {
            let dish = getDish(index: key)
            totalPrice += Double(value) * dish!.price
        }
        return totalPrice
    }
    
    /*订单字典进行CRUD操作时，更新所有展示了菜品数量的页面*/
    func updateData() {
        for delegate in updateDelegates {
            delegate.updateData()
        }
        if let navigationController = tabBarViewController?.viewControllers?[1] as? UINavigationController {
            if orders.count == 0 {
                navigationController.tabBarItem?.badgeValue = nil
            } else {
                var totalCount: Int = 0
                for (_, value) in orders {
                    totalCount += value
                }
                
                navigationController.tabBarItem?.badgeValue = "\(totalCount)"
            }
        }
    }
}
