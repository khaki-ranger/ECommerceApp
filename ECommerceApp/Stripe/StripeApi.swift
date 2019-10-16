//
//  StripeApi.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/16.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    // Stripeの一時キーを取得するためのメソッド
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        
        // CloudFunctionsのメソッドを仲介してStripeから一時キーを取得する
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(nil, error)
            }
            
            guard let key = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
        }
    }
}
