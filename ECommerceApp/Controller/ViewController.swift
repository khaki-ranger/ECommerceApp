//
//  ViewController.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // 先にユーザーログインフローを作成するために、初期表示画面を一時的に変更する
    // 後で削除する
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }


}

