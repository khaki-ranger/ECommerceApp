//
//  ViewController.swift
//  ECommerceAppAdmin
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.leftBarButtonItem?.isEnabled = false
        hiddenRightBarButtonItem()
        
        let addCategoryBtn = UIBarButtonItem(title: "カテゴリ追加", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    // CustomerFaceのカートボタンとお気に入りボタンを非表示にするためのメソッド
    private func hiddenRightBarButtonItem() {
        rightBarButtonItem.cartBtn.isHidden = true
        rightBarButtonItem.favoritesBarButtonItem.isEnabled = false
        rightBarButtonItem.favoritesBarButtonItem.tintColor = UIColor.clear
    }
    
    @objc func addCategory() {
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }

}

