//
//  ConformViewController.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/29.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {
    
    var order: Order? = nil
    
    @IBOutlet weak var orderSheet: UITextView!
    @IBOutlet weak var priceSheet: UITextView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderSheet.text = ""
        priceSheet.text = ""
        var index: Int = 1
        for (key, value) in order!.orders {
            let dish = order?.getDish(id: key)!
            orderSheet.text += "\(index)：\(dish!.name)✖️\(value)\n"
            priceSheet.text += "\(String(dish!.price * Double(value)))¥\n"
            print("\(String(dish!.price * Double(value)))¥\n")
            index += 1
        }
        totalPriceLabel.text = String(order!.totalPrice()) + "¥"
        order?.clear()          //在谢谢惠顾界面出现时清空购物车，避免一结账瞬间清空的怪异
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
