//
//  RightBarButtonItem.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/11/02.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

protocol CartBarButtonItemDelegate : class {
    func cartButtonClicked()
}

protocol FavoritesButtonItemDelegate : class {
    func favoritesButtonClicked()
}

class RightBarButtonItem {
    
    weak var cartBtnDelegate: CartBarButtonItemDelegate?
    weak var favoritesBtnDelegate: FavoritesButtonItemDelegate?
    var cartBtn: UIButton!
    
    init(navigation: UINavigationItem, cartBtnDelegate: CartBarButtonItemDelegate) {
        self.cartBtnDelegate = cartBtnDelegate
        
        cartBtn = UIButton(type: .system)
        cartBtn.setImage(UIImage(named: "bar_button_cart"), for: .normal)
        cartBtn.contentEdgeInsets.left = 10
        cartBtn.imageEdgeInsets.left = -10
        cartBtn.addTarget(self, action: #selector(cartBtnClicked), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartBtn)
        navigation.rightBarButtonItem = cartBarButtonItem
    }
    
    init(navigation: UINavigationItem, cartBtnDelegate: CartBarButtonItemDelegate, favoritesBtnDelegate: FavoritesButtonItemDelegate) {
        self.cartBtnDelegate = cartBtnDelegate
        self.favoritesBtnDelegate = favoritesBtnDelegate
        
        let favoritesBarButtonItem = UIBarButtonItem(image: UIImage(named: "bar_button_heart"), style: .plain, target: self, action: #selector(favoritesClicked))
        
        cartBtn = UIButton(type: .system)
        cartBtn.setImage(UIImage(named: "bar_button_cart"), for: .normal)
        cartBtn.contentEdgeInsets.left = 10
        cartBtn.imageEdgeInsets.left = -10
        cartBtn.addTarget(self, action: #selector(cartBtnClicked), for: .touchUpInside)
        let cartBarButtonItem = UIBarButtonItem(customView: cartBtn)
        navigation.rightBarButtonItems = [cartBarButtonItem, favoritesBarButtonItem]
    }
    
    // お気に入りボタンが押されたことをプロトコルの適合先に通知する
    @objc func favoritesClicked() {
        favoritesBtnDelegate?.favoritesButtonClicked()
    }
    
    // カートボタンが押されたことをプロトコルの適合先に通知する
    @objc func cartBtnClicked() {
        cartBtnDelegate?.cartButtonClicked()
    }
    
    // カートに入っている商品数を変更するメソッド
    func changeCartItemsText() {
        let cartItemsCount = String(StripeCart.cartItems.count)
        cartBtn.setTitle(cartItemsCount, for: .normal)
    }
}
