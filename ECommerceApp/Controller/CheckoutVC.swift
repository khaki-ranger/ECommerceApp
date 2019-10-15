//
//  CheckoutVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/15.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var paymentMethodBtn: UIButton!
    @IBOutlet weak var shippingMethidBtn: UIButton!
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var processingFeeLbl: UILabel!
    @IBOutlet weak var shippingCostLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
    }
}
