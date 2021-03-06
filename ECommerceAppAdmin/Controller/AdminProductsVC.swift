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
    var adminSelectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        let editCategoryBtn = UIBarButtonItem(title: "カテゴリ編集", style: .plain, target: self, action: #selector(editCategory))
        let newProductBtn = UIBarButtonItem(title: "商品追加", style: .plain, target: self, action: #selector(newProduct))
        navigationItem.setRightBarButtonItems([editCategoryBtn, newProductBtn], animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // User側のスーパークラスの実装を継承して、Firestoreのリスナーを解放
        super.viewDidDisappear(true)
        // 商品編集画面から戻った後で、商品追加画面に遷移するために初期化
        adminSelectedProduct = nil
    }
    
    @objc func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
    
    @objc func newProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択されたセルから、商品の情報を取得
        adminSelectedProduct = products[indexPath.row]
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
                destination.productToEdit = adminSelectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            // カテゴリ編集画面への遷移前準備
            if let destination = segue.destination as? AddEditCategoryVC {
                // スーパークラス(ProductsVC)のオブジェクトが渡される
                destination.categoryToEdit = category
            }
        }
    }
    
    override func productFavorited(product: Product) {
        return
    }
    
    override func productAddtoCart(product: Product) {
        return
    }
}
