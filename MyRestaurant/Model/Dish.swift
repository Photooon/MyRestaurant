//
//  Dish.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit
import Foundation

class Dish: NSObject {
    let id: Int
    let restId: Int
    let name: String
    let detail: String
    let price: Double
    //var count: Int
    var img: UIImage?
    
    init(id: Int, restId: Int, name: String, detail: String, price: Double) {
        self.id = id
        self.restId = restId
        self.name = name
        self.detail = detail
        //self.count = 0
        self.price = price
    }
}
