//
//  LoginVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func forgotPassClicked(_ sender: Any) {
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty ,
              let password = passwordTxt.text , password.isNotEmpty else { return }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
    
    
}
