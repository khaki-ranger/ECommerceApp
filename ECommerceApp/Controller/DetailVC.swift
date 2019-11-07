//
//  DetailVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/21.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class DetailVC: UIViewController, CartBarButtonItemDelegate {
    
    // Outlets
    @IBOutlet weak var slideImageView: UICollectionView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDeacription: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // Variables
    var product: Product!
    var productImages = [String]()
    var rightBarButtonItem: RightBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // メイン画像とサブ画像の要素を結合
        productImages.append(product.imgUrl)
        productImages += product.subImages
        
        setupCollectionView()
        setupPageControll()
        rightBarButtonItem = RightBarButtonItem(navigation: navigationItem, cartBtnDelegate: self)
        rightBarButtonItem.changeCartItemsText()
        controlOfNextBtnAndPrevBtn()
        
        productTitle.text = product.name
        productPrice.text = product.price.formattedCurrency()
        productDeacription.text = product.productDescription
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rightBarButtonItem.changeCartItemsText()
    }
    
    private func setupCollectionView() {
        slideImageView.delegate = self
        slideImageView.dataSource = self
        slideImageView.register(UINib(nibName: Identifiers.ProductImageCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.ProductImageCell)
    }
    
    private func setupPageControll() {
        pageControl.numberOfPages = productImages.count
        pageControl.currentPage = 0
    }
    
    @IBAction func prevTapped(_ sender: Any) {
        let prev = max(0, pageControl.currentPage - 1)
        let index = IndexPath(item: prev, section: 0)
        pageControl.currentPage = prev
        slideImageView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        controlOfNextBtnAndPrevBtn()
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        let next = min(pageControl.currentPage + 1, productImages.count - 1)
        let index = IndexPath(item: next, section: 0)
        pageControl.currentPage = next
        slideImageView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        controlOfNextBtnAndPrevBtn()
    }

    @IBAction func addCartClicked(_ sender: Any) {
        if UserService.isGuest {
            self.simpleAlert(title: "ようこそゲスト様", msg: "商品のお買い求めには、ログインまたは新規ユーザー登録をお願いいたします。")
            return
        }
        
        // カートの状態を管理するシングルトンオブジェクトのメソッドを実行
        StripeCart.addItemToCart(item: product)
        // NavigationController配下で1つ前の画面に戻る
        navigationController?.popViewController(animated: true)
    }
    
    // nextボタンとprevボタンの表示非表示を制御するメソッド
    private func controlOfNextBtnAndPrevBtn() {
        if productImages.count > 1 {
            switch pageControl.currentPage {
            case 0:
                nextBtn.isHidden = false
                prevBtn.isHidden = true
            case productImages.count - 1:
                nextBtn.isHidden = true
                prevBtn.isHidden = false
            default:
                nextBtn.isHidden = false
                prevBtn.isHidden = false
            }
        } else {
            nextBtn.isHidden = true
            prevBtn.isHidden = true
        }
    }
    
    func cartButtonClicked() {
        // ショッピングカート画面（CheckoutVC）に遷移
        performSegue(withIdentifier: Segues.ToShoppingCart, sender: self)
    }
}

extension DetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = slideImageView.dequeueReusableCell(withReuseIdentifier: Identifiers.ProductImageCell, for: indexPath) as? ProductImageCell {
            cell.configureCell(imageUrl: productImages[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    // セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.width
        let cellHeight = cellWidth * 1.2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // scrollの位置とpageControlのページを合わせる
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let index = Int(x / view.frame.width)
        pageControl.currentPage = index
        controlOfNextBtnAndPrevBtn()
    }
    
}
