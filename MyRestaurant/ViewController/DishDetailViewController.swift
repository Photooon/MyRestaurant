//
//  DetailViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController, UpdateDataDelegate {

    var dish: Dish? = nil
    var order: Order? = nil
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = dish?.name
        
        priceLabel.text = String(dish!.price) + "¥"
        detailTextView.text = dish!.detail
        img.image = dish!.img
        
        if order!.orders.keys.contains(dish!.id) {
            countLabel.text = String(order!.orders[dish!.id]!)
        } else {
            countLabel.text = "0"
        }
    }
    
    func updateData() {
        updateLabel()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addBtnPressed(_ sender: Any) {
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
        } else {
            countLabel.text = "0"
        }
    }
}
