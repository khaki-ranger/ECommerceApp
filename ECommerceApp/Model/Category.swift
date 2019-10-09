//
//  Category.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/09.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var order: Int
    var timeStamp: Timestamp
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.imgUrl = data["imgUrl"] as? String ?? ""
        self.isActive = data["isActive"] as? Bool ?? true
        self.order = data["order"] as? Int ?? 0
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
    }
}
