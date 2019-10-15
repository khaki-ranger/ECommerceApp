//
//  CheckoutVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/15.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class CheckoutVC: UIViewController, CartitemCellDelegate {
    
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
        setupTableView()
        setupPaymentInfo()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // カートに入れられている商品を表現するセルをtableViewに表示する
        tableView.register(UINib(nibName: Identifiers.CartitemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartitemCell)
    }
    
    func setupPaymentInfo() {
        subtotalLbl.text = StripeCart.subtotal.formattedCurrency()
        processingFeeLbl.text = StripeCart.processingFees.formattedCurrency()
        shippingCostLbl.text = StripeCart.shippingFees.formattedCurrency()
        totalLbl.text = StripeCart.total.formattedCurrency()
    }

    @IBAction func placeOrderClicked(_ sender: Any) {
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
    }
    
    func removeItemfromCart(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        // ショッピングカートから削除したことを、ショッピングカート画面のUIに反映する
        // ショッピングカートの商品リストテーブルからセルを削除する
        tableView.reloadData()
        // 金額表示にも変更を反映する
        setupPaymentInfo()
    }
}

extension CheckoutVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartitemCell, for: indexPath) as? CartitemCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
