//
//  UserService.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/12.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
    
    // Variables
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListner : ListenerRegistration? = nil
    var favsListner : ListenerRegistration? = nil
    
    // アプリを利用中のユーザーが、ログイン済みかどうかを確認するためのコンピューテッドプロパティ
    var isGuest : Bool {
        guard let authUser = auth.currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    // アプリを利用中のユーザーのリスナーを取得
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        userListner = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            // シングルトンオブジェクトのメンバに設定
            self.user = User.init(data: data)
            print(self.user)
        })
        
        // お気に入り商品の情報を格納するサブコレクションのリスナーを取得
        let favsRef = userRef.collection("favorites")
        favsListner = favsRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product.init(data: document.data())
                // シングルトンオブジェクトのメンバに設定
                self.favorites.append(favorite)
            })
            
        })
    }
    
    func logoutUser() {
        userListner?.remove()
        userListner = nil
        favsListner?.remove()
        favsListner = nil
        user = User()
        favorites.removeAll()
    }
    
}

