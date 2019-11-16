//
//  LoginVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginVC: UIViewController {

    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Variables
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "ログイン"
    }

    @IBAction func forgotPassClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        
        guard let email = emailTxt.text , email.isNotEmpty ,
              let password = passwordTxt.text , password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func fbLoginClicked(_ sender: Any) {
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else if result?.isCancelled ?? true {
                // do something
            } else {
                self.signinFirebaseFacebook()
            }
        }
    }
    
    private func signinFirebaseFacebook() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let firUser = result?.user else { return }
            
            // Facebookでログインしたユーザーが新規ユーザーかどうかを判定
            if let isNewUser = result?.additionalUserInfo?.isNewUser {
                if isNewUser {
                    guard let email = firUser.email, email.isNotEmpty,
                        let username = firUser.displayName, username.isNotEmpty else { return }
                    
                    let appUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "", hasSetupAccount: false)
                    self.handleNewUser(user: appUser)
                } else {
                    
                }
            }
        }
    }
    
    // Facebookでログインしたユーザーが新規ユーザーだった場合の処理を行うメソッド
    private func handleNewUser(user: User) {
        // FirestoreのDocumentReferenceを作成
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        // Firestoreにアップロードするために、オブジェクトのデータをString : Any型の辞書に変換
        let data = User.modelToData(user: user)
        // Firestoreにアップロードする
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error.localizedDescription)
            } else {
                self.presentFirstTimeAlert()
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // Facebookでログインしたユーザーのアカウント連携が完了していない場合の処理を行うメソッド
    private func presentFirstTimeAlert() {
        let alert = UIAlertController(title: "ようこそ！", message: "ユーザー情報の設定がまだのようです。ユーザー情報を設定しませんか？", preferredStyle: .alert)
        let notNow = UIAlertAction(title: "今はしない", style: .default) { (alert) in
            
        }
        let okAction = UIAlertAction(title: "設定する", style: .default) { (alear) in
            self.performSegue(withIdentifier: Segues.ToConnectAcount, sender: self)
        }
        alert.addAction(notNow)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
