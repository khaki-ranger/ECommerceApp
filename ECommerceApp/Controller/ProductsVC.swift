//
//  ProductsVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product(name: "ウエッジパンプス", id: "iejsaefj", category: "パンプス", price: 13750, productDescription: "マットな質感が秋冬らしいウェッジソールパンプス。安定感のある履き心地で、通勤にも◎", imgUrl: "https://img08.magaseek.com/images/item/20170821/0017198130KM.jpg?sr.dw=700", timeStamp: Timestamp(), stock: 0, favorites: false)
        products.append(product)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }

}

extension ProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
