//
//  DetailVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/21.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // Variables
    var product: Product!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(product.name)
    }

}
