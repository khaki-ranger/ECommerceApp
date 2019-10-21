//
//  DetailVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/21.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDeacription: UILabel!
    
    // Variables
    var product: Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitle.text = product.name
        productPrice.text = product.price.formattedCurrency()
        productDeacription.text = product.productDescription
        
        if let url = URL(string: product.imgUrl) {
            productImg.kf.setImage(with: url)
        }
    }

    @IBAction func addCartClicked(_ sender: Any) {
        if UserService.isGuest {
            self.simpleAlert(title: "ようこそゲスト様", msg: "商品のお買い求めには、ログインまたは新規ユーザー登録をお願いいたします。")
            return
        }
        
        // カートの状態を管理するシングルトンオブジェクトのメソッドを実行
        StripeCart.addItemToCart(item: product)
        // NavigationController配下で1つ前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
}
