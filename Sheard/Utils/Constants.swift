//
//  Constants.swift
//  ECommerceApp
//
//  Created by 寺島 洋平 on 2019/10/07.
//  Copyright © 2019 YoheiTerashima. All rights reserved.
//

import Foundation
import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}

struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FillHeart = "heart_filled"
    static let EmptyHeart = "heart_empty"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let Themecolor = #colorLiteral(red: 0.8470588235, green: 0.262745098, blue: 0.08235294118, alpha: 1)
    static let BackgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9137254902, blue: 0.9058823529, alpha: 1)
    static let TextColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let ClikableTextColor = #colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 0.6078431373, alpha: 1)
    static let SubmitButtonColor = #colorLiteral(red: 0.8470588235, green: 0.262745098, blue: 0.08235294118, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartitemCell = "CartitemCell"
    static let ProductImageCell = "ProductImageCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToDetail = "ToDetail"
    static let ToAddEditCategory = "toAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "toFavorites"
    static let ToShoppingCart = "ToShoppingCart"
}
