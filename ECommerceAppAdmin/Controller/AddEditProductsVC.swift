//
//  AddEditProductsVC.swift
//  ECommerceAppAdmin
//
//  Created by 寺島 洋平 on 2019/10/10.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    @IBOutlet weak var productImgView1: UIImageView!
    @IBOutlet weak var productImgView2: UIImageView!
    @IBOutlet weak var productImgView3: UIImageView!
    @IBOutlet weak var productImgView4: UIImageView!
    @IBOutlet weak var productImgView5: UIImageView!
    
    // Variables
    var selectedCategory: Category!
    var productToEdit: Product?
    var tappedProductImgView: UIImageView?
    var productImgViews: [UIImageView] = []
    
    var name = ""
    var price = 0
    var productDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        productImgViews = [
            productImgView1,
            productImgView2,
            productImgView3,
            productImgView4,
            productImgView5
        ]
        
        // productToEditがnilでない場合は編集
        if let product = productToEdit {
            productNameTxt.text = product.name
            productPriceTxt.text = String(product.price)
            productDescTxt.text = product.productDescription
            addBtn.setTitle("編集を保存", for: .normal)
            
            if let url = URL(string: product.imgUrl) {
                productImgView1.contentMode = .scaleAspectFill
                productImgView1.kf.setImage(with: url)
            }
        }
    }
    
    private func setupTapGesture() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(imgTapped1(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(imgTapped2(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(imgTapped3(_:)))
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(imgTapped4(_:)))
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(imgTapped5(_:)))
        tap1.numberOfTapsRequired = 1
        tap2.numberOfTapsRequired = 1
        tap3.numberOfTapsRequired = 1
        tap4.numberOfTapsRequired = 1
        tap5.numberOfTapsRequired = 1
        productImgView1.isUserInteractionEnabled = true
        productImgView2.isUserInteractionEnabled = true
        productImgView3.isUserInteractionEnabled = true
        productImgView4.isUserInteractionEnabled = true
        productImgView5.isUserInteractionEnabled = true
        productImgView1.addGestureRecognizer(tap1)
        productImgView2.addGestureRecognizer(tap2)
        productImgView3.addGestureRecognizer(tap3)
        productImgView4.addGestureRecognizer(tap4)
        productImgView5.addGestureRecognizer(tap5)
    }
    
    @objc func imgTapped1(_ tap: UITapGestureRecognizer) {
        tappedProductImgView = productImgView1
        launchImgPicker()
    }
    
    @objc func imgTapped2(_ tap: UITapGestureRecognizer) {
        tappedProductImgView = productImgView2
        launchImgPicker()
    }
    
    @objc func imgTapped3(_ tap: UITapGestureRecognizer) {
        tappedProductImgView = productImgView3
        launchImgPicker()
    }
    
    @objc func imgTapped4(_ tap: UITapGestureRecognizer) {
        tappedProductImgView = productImgView4
        launchImgPicker()
    }
    
    @objc func imgTapped5(_ tap: UITapGestureRecognizer) {
        tappedProductImgView = productImgView5
        launchImgPicker()
    }

    @IBAction func addClicked(_ sender: Any) {
        uploadImagesThenDocument()
    }
    
    func uploadImagesThenDocument() {
        //        guard let image = productImgView1.image ,
        //            let name = productNameTxt.text , name.isNotEmpty ,
        //            let description = productDescTxt.text , description.isNotEmpty ,
        //            let priceString = productPriceTxt.text , priceString.isNotEmpty ,
        //            let price = Int(priceString) else {
        //                simpleAlert(title: "エラー", msg: "商品名、価格、説明文および商品画像を設定してください。")
        //                return
        //        }
        //
        //        self.name = name
        //        self.productDescription = description
        //        self.price = price
        //
        //        activityIndicator.startAnimating()
        
        // 選択された画像を取得する
        var images = [UIImage]()
        productImgViews.forEach { (productImgView) in
            if let image = productImgView.image {
                images.append(image)
            }
        }
        
        // 複数のタスクを集約的に扱って同期させる
        let dispatchGroup = DispatchGroup()
        // 直列処理キュー / attribute指定なし
        let dispatchQueue = DispatchQueue(label: "ecommerceapp.queue")
        
        images.forEach { (image) in
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                [weak self] in
                self?.asyncProcess(image: image) {
                    (url: String) -> Void in
                    // 1枚の画像をアップロードする処理が完了
                    print("1枚の画像をアップロードする処理が完了")
                    print(url)
                    dispatchGroup.leave()
                }
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            // 全ての画像をアップロードする処理が完了
            print("全ての画像をアップロードする処理が完了")
            // FirestoreのproductsコレクションにURLをアップロードして更新、および作成する
            //                self.uploadDocument(url: url.absoluteString)
        }
    }
    
    // 非同期処理
    // Firestorageに1枚の画像をアップロードする処理
    private func asyncProcess(image: UIImage, outerCompletion: @escaping (_ url: String) -> Void) {
        // 画像名を作成する
        let imageName = UUID()
        // 画像をデータに変更する
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        // Firestorageのリファレンスを作成する
        let imageRef = Storage.storage().reference().child("/productImages/\(imageName).jpg")
        // メタデータを設定する
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        // データをFirestorageにアップロードする
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            
            if let error = error {
                self.handleError(error: error, msg: "画像のアップロードに失敗しました")
            }
            // アップロードが成功したらURLを取得する
            imageRef.downloadURL(completion: { (url, error) in
                
                if let error = error {
                    self.handleError(error: error, msg: "画像URLの取得に失敗しました")
                }
                // 画像URLの取得に成功
                guard let url = url else { return }
                outerCompletion(url.absoluteString)
            })
        }
    }
    
    func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var product = Product.init(name: name,
                                   id: "",
                                   category: selectedCategory.id,
                                   price: price,
                                   productDescription: productDescription,
                                   imgUrl: url)
        
        // productToEditがnilかどうかで、編集か新規作成かを分岐
        if let productToEdit = productToEdit {
            // 編集
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // 新規作成
            docRef = Firestore.firestore().collection("products").document()
            product.id = docRef.documentID
        }
        
        let data = Product.modelToData(product: product)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, msg: "商品データのアップロードに失敗しました")
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "エラー", msg: msg)
        return
    }
}

extension AddEditProductsVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        if let productImgView = tappedProductImgView {
            productImgView.contentMode = .scaleAspectFill
            productImgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
