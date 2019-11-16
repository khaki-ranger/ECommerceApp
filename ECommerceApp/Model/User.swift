//
//  User.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/11.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    var hasSetupAccount: Bool
    
    init(id: String = "",
         email: String = "",
         username: String = "",
         stripeId: String = "",
         hasSetupAccount: Bool = false) {
        
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
        self.hasSetupAccount = hasSetupAccount
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        stripeId = data["stripeId"] as? String ?? ""
        hasSetupAccount = data["hasSetupAccount"] as? Bool ?? false
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "stripeId" : user.stripeId,
            "hasSetupAccount" : user.hasSetupAccount
        ]
        
        return data
    }
}
