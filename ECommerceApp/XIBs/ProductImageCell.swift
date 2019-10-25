//
//  ProductImageCell.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/25.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Kingfisher

class ProductImageCell: UICollectionViewCell {
    
    // Outlets
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            let placeholder = UIImage(named: "placeholder")
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImage.kf.indicatorType = .activity
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }
}
