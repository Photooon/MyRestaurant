//
//  TabBarViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var userName: String = ""               //全局用户名变量
    var order: Order = Order()              //全局的订单变量
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        order.tabBarViewController = self
        
        InitDB.initRestaurant()
        InitDB.initDish()
    }
}
