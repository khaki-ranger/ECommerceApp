//
//  ForgotPasswordVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty else {
            simpleAlert(title: "Error", msg: "メールアドレスを入力してください")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
