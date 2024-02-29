//
//  BrandDetail.swift
//  Buraq24
//
//  Created by MANINDER on 18/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class BrandDetail: Mappable {
    
    var sortOrder : Int?
    var categoryId : Int?
    var categoryBrandId : Int?
    var brandImage : String?
    var brandName : String?
    var image : String?
    var products : [ProductCab]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        sortOrder <- map["sort_order"]
        categoryId <- map["category_id"]
        categoryBrandId <- map["category_brand_id"]
        brandImage <- map["image_url"]
        brandName <- map["name"]
        image <- map["image"]
        products <- map["products"]
    }

}
