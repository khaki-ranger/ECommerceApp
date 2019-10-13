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
        
        // お気に入り商品の情報を格納するサブコレクションのリスナーを作成
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
    
    // お気に入りの追加、削除をするためのメソッド
    func favoriteSelected(product: Product) {
        // Firestoreに、利用中のユーザーのドキュメントのサブコレクションとしてfavoritesコレクションを作成
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
            // 引数で送られたProductが配列の中に含まれている場合は、
            // 既にお気に入りに入っていたものを選択したことになるので、お気に入りから削除する
            favorites.removeAll{ $0 == product }
            // Firestoreのコレクションからも削除
            favsRef.document(product.id).delete()
        } else {
            // お気に入りに追加する
            favorites.append(product)
            // Firestoreのコレクションにも追加
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
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

