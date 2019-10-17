//
//  StripeCart.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/15.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation

let StripeCart = _StripeCart()

final class _StripeCart {
    
    var cartItems = [Product]()
    // Stripeの決済手数料 (https://stripe.com/jp/pricing#pricing-details)
    // 日本円に対する決済手数料 3.6%
    private let stripeCreditCartCut = 0.036
    // 日本円に対する基本料金は無し
    private let flatFeeCents = 0
    var shippingFees = 0
    
    // variables for subtotal, processing fees, total
    
    // 小計
    var subtotal: Int {
        var amount = 0
        for item in cartItems {
            amount += item.price
        }
        return amount
    }
    
    // 決済手数料
    var processingFees: Int {
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCartCut) + flatFeeCents
        return feesAndSub
    }
    
    // 合計 = 小計 + 決済手数料 + 送料
    var total: Int {
        return subtotal + processingFees + shippingFees
    }
    
    // ショッピングカートに入れた際に実行するメソッド
    func addItemToCart(item: Product) {
        cartItems.append(item)
    }
    
    // ショッピングカートから削除した際に実行するメソッド
    func removeItemFromCart(item: Product) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    // ログアウトした際など、カートの中身を空にするためのメソッド
    func clearCart() {
        cartItems.removeAll()
    }
}
