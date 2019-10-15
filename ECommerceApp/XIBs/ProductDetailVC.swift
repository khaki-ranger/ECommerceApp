//
//  ProductDetailVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    // Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var produecDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    // Veriables
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.name
        productPrice.text = product.price.formattedCurrency()
        produecDescription.text = product.productDescription
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTouchesRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCartClicked(_ sender: Any) {
        // シングルトンオブジェクトのメソッドを実行
        StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
