//
//  CartitemCell.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/15.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class CartitemCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
    }
}
