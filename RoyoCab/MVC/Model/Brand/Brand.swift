//
//  Brand.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class Brand: Mappable {
    
    var sortOrder : Int?
    var categoryId : Int?
    var categoryBrandId : Int?
    var brandImage : String?
    var brandName : String?
    var image : String?
    var imageURL : URL?
    var products : [ProductCab]?
    var productNames : [String]?
    var brandTokens : [ETokenModel]?
    var etokensCount : Int?
    var buraq_percentage: Float?
    var categoryBrandType : String?
    var icon_image_url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        sortOrder <- map["sort_order"]
        categoryId <- map["category_id"]
        categoryBrandId <- map["category_brand_id"]
        brandImage <- map["image_url"]
        brandName <- map["name"]
        
        if brandName == nil {
            brandName <- map["category_brand_name"]
        }
        image <- map["image"]
        products <- map["products"]
        etokensCount <- map ["etokens_count"]
        brandTokens <- map ["etokens"]
        categoryBrandType <- map["categoryBrandType"]
        icon_image_url <- map["icon_image_url"]
        
        productNames = products?.map({/$0.productName })
         if let imgURL = brandImage {
            imageURL = URL(string: imgURL)
        }
        
        buraq_percentage <- map["buraq_percentage"]
    }
}





