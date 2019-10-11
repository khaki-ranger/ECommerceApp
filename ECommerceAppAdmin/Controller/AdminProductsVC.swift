//
//  AdminProductsVC.swift
//  ECommerceAppAdmin
//
//  Created by 寺島 洋平 on 2019/10/10.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class AdminProductsVC: ProductsVC {
    
    // Variables
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editCategoryBtn = UIBarButtonItem(title: "カテゴリ編集", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "商品追加", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn, newProductBtn], animated: false)
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func newProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択されたセルから、商品の情報を取得
        selectedProduct = products[indexPath.row]
        // 商品編集画面に遷移
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // セグエによって遷移前準備を分岐
        if segue.identifier == Segues.ToAddEditProduct {
            // 商品編集画面への遷移前準備
            if let destination = segue.destination as? AddEditProductsVC {
                // スーパークラス(ProductsVC)のオブジェクトが渡される
                destination.selectedCategory = category
                // TableViewの商品をタップした場合は商品の情報が渡される
                // NavigationBarの商品追加ボタンが押された場合はnilが渡される
                destination.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            // カテゴリ編集画面への遷移前準備
            if let destination = segue.destination as? AddEditCategoryVC {
                // スーパークラス(ProductsVC)のオブジェクトが渡される
                destination.categoryToEdit = category
            }
        }
    }
}
