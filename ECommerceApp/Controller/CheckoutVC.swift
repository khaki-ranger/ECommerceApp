//
//  CheckoutVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/15.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions

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
    
    // Variables
    var paymentContext: STPPaymentContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }
    
    // カートに入れられている商品を表現するテーブルを設定するためのメソッド
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // カートに入れられている商品を表現するセルをtableViewに表示する
        tableView.register(UINib(nibName: Identifiers.CartitemCell, bundle: nil), forCellReuseIdentifier: Identifiers.CartitemCell)
    }
    
    // 請求金額表示部分のUIに金額を表示するためのメソッド
    func setupPaymentInfo() {
        subtotalLbl.text = StripeCart.subtotal.formattedCurrency()
        processingFeeLbl.text = StripeCart.processingFees.formattedCurrency()
        shippingCostLbl.text = StripeCart.shippingFees.formattedCurrency()
        totalLbl.text = StripeCart.total.formattedCurrency()
    }
    
    // 請求に関する設定をするメソッド
    func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        // ユーザーがカードを追加して、Stripeに登録する設定を有効にする
        config.createCardSources = true
        // 請求先住所を入力を求める設定を無効にする
        config.requiredBillingAddressFields = .none
        // 配送先情報の入力でユーザーに求められる項目の設定
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        
        // 請求金額を設定
        paymentContext.paymentAmount = StripeCart.total
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }

    @IBAction func placeOrderClicked(_ sender: Any) {
        paymentContext.requestPayment()
        activityIndicator.startAnimating()
    }
    
    @IBAction func paymentMethodClicked(_ sender: Any) {
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @IBAction func shippingMethodClicked(_ sender: Any) {
        paymentContext.pushShippingViewController()
    }
    
    func removeItemfromCart(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        // ショッピングカートから削除したことを、ショッピングカート画面のUIに反映する
        // ショッピングカートの商品リストテーブルからセルを削除する
        tableView.reloadData()
        // 金額表示にも変更を反映する
        setupPaymentInfo()
        // Stripeの請求金額にも変更を反映する
        paymentContext.paymentAmount = StripeCart.total
    }
}

extension CheckoutVC : STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
        // ユーザーが支払方法を設定した後の処理
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodBtn.setTitle(paymentMethod.label, for: .normal)
        } else {
            paymentMethodBtn.setTitle("お支払い方法", for: .normal)
        }
        
        // ユーザーが配送方法を設定した後の処理
        if let shippingMethid = paymentContext.selectedShippingMethod {
            shippingMethidBtn.setTitle(shippingMethid.label, for: .normal)
            StripeCart.shippingFees = Int(truncating: shippingMethid.amount)
            setupPaymentInfo()
        } else {
            shippingMethidBtn.setTitle("配送方法", for: .normal)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        // ショッピングカート画面に遷移後に、ユーザーがStripeIDを保持していないなどの理由で
        // 一時キーの生成に失敗した場合にエラーが呼び出された際の処理
        activityIndicator.stopAnimating()

        let alertController = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let retry = UIAlertAction(title: "再読み込み", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
        // サーバーとの通信障害に対応するためにユニークなキーを作成(https://stripe.com/jp/blog/idempotency)
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        // StripeAPIの処理を担当するCloudfunctionsのメソッドに渡すためのデータをセット
        let data : [String: Any] = [
            "total" : StripeCart.total,
            "customerId" : UserService.user.stripeId,
            "idempotency" : idempotency
        ]
        
        // StripeAPIの処理を担当するCloudfunctionsのメソッドを呼び出す
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                self.simpleAlert(title: "エラー", msg: "お支払い処理に失敗しました")
                completion(error)
                return
            }
            
            // Stripeの支払処理に成功
            StripeCart.clearCart()
            StripeCart.shippingFees = 0
            self.tableView.reloadData()
            self.setupPaymentInfo()
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        // 支払処理が終了した後に呼び出される処理
        let title: String
        let message: String
        
        activityIndicator.stopAnimating()
        
        switch status {
        case .error:
            title = "エラー"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "購入完了"
            message = "お買い求めありがとうございます！"
        case .userCancellation:
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let request = PKPaymentRequest()
        request.currencyCode = "JPY"
        
        let jp = PKShippingMethod()
        jp.amount = 490
        jp.label = "JP"
        jp.detail = "3-5営業日"
        jp.identifier = "jp"
        
        let yamato = PKShippingMethod()
        yamato.amount = 740
        yamato.label = "ヤマト運輸"
        yamato.detail = "1-2営業日"
        yamato.identifier = "yamato"
        
        if address.country == "JP" {
            completion(.valid, nil, [jp, yamato], jp)
        } else {
            completion(.invalid, nil, nil, nil)
        }
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
