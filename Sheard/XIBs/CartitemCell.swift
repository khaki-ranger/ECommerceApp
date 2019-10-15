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
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product) {
        productTitleLbl.text = product.name
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productPriceLbl.text = price
        }
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
        
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
    }
}
