//
//  ConnectAccountVC.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/11/16.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher

class ConnectAccountVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var userNameTxt: UITextField!
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
            
            self.userNameTxt.text = name
            self.emailTxt.text = email
            if let url = URL(string: urlString) {
                let placeholder = UIImage(named: "placeholder")
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                self.fbAvatar.kf.indicatorType = .activity
                self.fbAvatar.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            
        }
    }
    
}
