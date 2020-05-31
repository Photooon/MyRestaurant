//
//  OrderTableViewCell.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    var dish: Dish? = nil
    var order: Order? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addBtnPessed(_ sender: Any) {
        order?.addDish(id: dish!.id)
        updateLabel()
    }
    
    @IBAction func subBtnPressed(_ sender: Any) {
        order?.subDish(id: dish!.id)
        updateLabel()
    }
    
    func updateLabel() {
        if order!.orders.keys.contains(dish!.id) {
            countLabel.text = String(order!.orders[dish!.id]!)
            totalPriceLabel.text = String(dish!.price * Double(order!.orders[dish!.id]!))
        } else {
            countLabel.text = "0"
        }
    }
}
