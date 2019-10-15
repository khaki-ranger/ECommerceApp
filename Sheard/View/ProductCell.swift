//
//  ProductCell.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate : class {
    func productFavorited(product: Product)
    func productAddtoCart(product: Product)
}

class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImg: RoundedImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    weak var delegate : ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.delegate = delegate
        self.product = product
        
        if let url = URL(string: product.imgUrl) {
            let placeholder = UIImage(named: AppImages.Placeholder)
            let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.indicatorType = .activity
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        productTitle.text = product.name
        productPrice.text = product.price.formattedCurrency()
        
        // この商品がユーザーのお気に入りリストの中に含まれているかどうかを判定
        if UserService.favorites.contains(product) {
            favoriteBtn.setImage(UIImage(named: AppImages.FillHeart), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyHeart), for: .normal)
        }
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        delegate?.productAddtoCart(product: product)
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        delegate?.productFavorited(product: product)
    }
}
