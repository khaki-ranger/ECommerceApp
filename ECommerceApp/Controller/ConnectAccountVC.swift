//
//  ConnectAccountVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/11/16.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Kingfisher

class ConnectAccountVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fbAvatar: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "アカウント設定"
        
        fetchFbData()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    // ログインユーザーのFacebook登録情報を取得するためのメソッド
    private func fetchFbData() {
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: Settings.defaultGraphAPIVersion, httpMethod: HTTPMethod.get)
        
        graphRequest.start { (connection, result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            // 取得したFacebook登録情報から辞書型のデータを作成
            guard let dictionary = result as? [String: Any] else { return }
            guard let name = dictionary["name"] as? String,
                let email = dictionary["email"] as? String else { return }
            guard let pictureObject = dictionary["picture"] as? [String: Any],
                let pictureData = pictureObject["data"] as? [String: Any],
                let urlString = pictureData["url"] as? String else { return }
            
            self.usernameTxt.text = name
            self.emailTxt.text = email
            if let url = URL(string: urlString) {
                let placeholder = UIImage(named: "placeholder")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                self.fbAvatar.kf.indicatorType = .activity
                self.fbAvatar.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else { return }
        
        // 確認用パスワード入力欄に文字が入力されたら、チェックマークを表示させる
        if textField == confirmPasswordTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPasswordTxt.text = ""
            }
        }
        
        // パスワードが一致していたら、チェックマークを緑色にする
        if passwordTxt.text == confirmPasswordTxt.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
        }
    }
    
    @IBAction func connectClicked(_ sender: Any) {
        guard let email = emailTxt.text , email.isNotEmpty ,
            let username = usernameTxt.text , username.isNotEmpty ,
            let password = passwordTxt.text , password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confirmPasswordTxt.text , confirmPass == password else {
            simpleAlert(title: "Error", msg: "Password do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let user = result?.user else { return }
            var stripeId: String?
            
            Firestore.firestore().collection("users").document(user.uid).getDocument { (snap, error) in
                guard let snap = snap else { return }
                if snap.exists {
                    if let data = snap.data() {
                        stripeId = data["stripeId"] as? String
                    }
                }
            }
            
            let newUser = User.init(id: user.uid,
                                    email: email,
                                    username: username,
                                    stripeId: stripeId ?? "",
                                    hasSetupAccount: true)
            self.updateFirestoreUser(user: newUser)
        }
    }
    
    private func updateFirestoreUser(user: User) {
        // FirestoreのDocumentReferenceを作成
        let userRef = Firestore.firestore().collection("users").document(user.id)
        // Firestoreにアップロードするために、オブジェクトのデータをString : Any型の辞書に変換
        let data = User.modelToData(user: user)
        // Firestoreにアップロードする
        userRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}
