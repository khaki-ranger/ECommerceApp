//
//  ProductsVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController, ProductCellDelegate, CartBarButtonItemDelegate {
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // Variables
    var products = [Product]()
    var category: Category!
    var db: Firestore!
    var listener: ListenerRegistration!
    var showFavorites = false
    var selectedProduct: Product!
    var rightBarButtonItem: RightBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupTableView()
        rightBarButtonItem = RightBarButtonItem(navigation: navigationItem, cartBtnDelegate: self)
        rightBarButtonItem.changeCartItemsText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setProductListner()
        rightBarButtonItem.changeCartItemsText()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        listener.remove()
        products.removeAll()
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    
    // テーブルに表示されるデータの参照を制御するメソッド
    func setProductListner() {
        
        var ref: Query!
        if showFavorites {
            // お気に入りリストの場合
            ref = db.collection("users").document(UserService.user.id).collection("favorites")
            self.navigationItem.title = "お気に入り"
        } else {
            // 通常のリストの場合
            ref = db.products(category: category.id)
            self.navigationItem.title = category.name
        }
        
        listener = ref.addSnapshotListener({(snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let product = Product.init(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, product: product)
                case .modified:
                    self.onDocumentmodified(change: change, product: product)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
        })
    }
    
    // セルのお気に入りボタンを押した際の挙動を制御するメソッド
    func productFavorited(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "ようこそゲスト様", msg: "お気に入り機能はユーザー専用の機能です。ログインまたは、新規ユーザー登録の上ご利用ください。")
            return
        }
        
        UserService.favoriteSelected(product: product)
        // お気に入りボタンを押した商品が、既にお気に入りリストに含まれている場合(お気に入りから削除する場合)は、
        // indexを返して、お気に入りリスト画面からセルを削除する
        guard let index = products.firstIndex(of: product) else { return }
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    // セルのカートに入れるボタンを押した際の挙動を制御するメソッド
    func productAddtoCart(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "ようこそゲスト様", msg: "商品のお買い求めには、ログインまたは新規ユーザー登録をお願いいたします。")
            return
        }
        
        StripeCart.addItemToCart(item: product)
        rightBarButtonItem.changeCartItemsText()
    }
    
    // ナビゲーションバーのカートボタンを押した際の挙動を制御するメソッド
    func cartButtonClicked() {
        // ショッピングカート画面（CheckoutVC）に遷移
        performSegue(withIdentifier: Segues.ToShoppingCart, sender: self)
    }
}

extension ProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func onDocumentAdded(change: DocumentChange, product: Product) {
        let newIndex = Int(change.newIndex)
        products.insert(product, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }
    
    func onDocumentmodified(change: DocumentChange, product: Product) {
        if change.newIndex == change.oldIndex {
            // Row change, but remained in the same position
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        } else {
            // Row changed and changed position
            let newIndex = Int(change.newIndex)
            let oldIndex = Int(change.oldIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(row: oldIndex, section: 0)], with: .left)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            
            cell.configureCell(product: products[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToDetail, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToDetail {
            if let destination = segue.destination as? DetailVC {
                destination.product = selectedProduct
            }
        }
    }
}
