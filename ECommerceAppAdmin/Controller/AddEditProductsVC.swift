//
//  AddEditProductsVC.swift
//  ECommerceAppAdmin
//
//  Created by 寺島 洋平 on 2019/10/10.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class AddEditProductsVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var productNameTxt: UITextField!
    @IBOutlet weak var productPriceTxt: UITextField!
    @IBOutlet weak var productDescTxt: UITextView!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBtn: RoundedButton!
    
    // Variables
    var selectedCategory: Category!
    var productToEdit: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addClicked(_ sender: Any) {
        
    }
}
