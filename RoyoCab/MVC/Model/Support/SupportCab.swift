//
//  Support.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

 class SupportCab: Mappable {
    
    var name : String?
    var imageURL : String?
    var actualURL : URL?
    var categoryType : String?
    var supportId : Int?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
     
         name <- map["name"]
         supportId <- map["category_id"]
         imageURL <- map["image_url"]
        categoryType <- map["category_type"]
        if let urlImage = imageURL {
            actualURL = URL(string : urlImage)
        }
    }

}
