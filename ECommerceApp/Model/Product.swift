//
//  Product.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Int
    var productDescription: String
    var imgUrl: String
    var timeStamp: Timestamp
    var stock: Int
    
    init(
        name: String,
        id: String,
        category: String,
        price: Int,
        productDescription: String,
        imgUrl: String,
        timeStamp: Timestamp = Timestamp(),
        stock: Int = 0) {
        
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imgUrl = imgUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Int ?? 0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
    // Product型のインスタンスオブジェクトから、String : Any型の辞書を生成するためのメソッド
    // オブジェクトのデータをFirestoreに登録するために使用する
    static func modelToData(product: Product) -> [String: Any] {
        let data : [String: Any] = [
            "name": product.name,
            "id": product.id,
            "category": product.category,
            "price": product.price,
            "productDescription": product.productDescription,
            "imgUrl": product.imgUrl,
            "timeStamp": product.timeStamp,
            "stock": product.stock
        ]
        
        return data
    }
}

extension Product : Equatable {
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}
