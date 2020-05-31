//
//  Restaurant.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit
import Foundation

class Restaurant: NSObject {
    let id: Int
    let name: String
    let distance: Double           //单位: km
    var img: UIImage?
    
    init(id: Int, name: String, distance: Double) {
        self.id = id
        self.name = name
        self.distance = distance
    }
}
