//
//  RestImgTableViewCell.swift
//  MyRestaurant
//
//  Created by lw on 2020/5/30.
//  Copyright © 2020 lw. All rights reserved.
//

import UIKit

class RestImgTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
