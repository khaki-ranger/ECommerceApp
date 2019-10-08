//
//  ViewController.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error  {
                    debugPrint(error)
                    self.handleFireAuthError(error: error)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser , !user.isAnonymous {
            // We are logged in
            loginOutBtn.title = "ログアウト"
        } else {
            loginOutBtn.title = "ログイン"
        }
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        self.handleFireAuthError(error: error)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
                self.handleFireAuthError(error: error)
            }
        }
    }
}

