//
//  Service.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class Service: Mappable {
    
    var buraqPercentage : Float?
    var serviceDescription : String?
    var brands : [Brand]?
    var serviceCategoryId : Int?
    var serviceName : String?
    var serviceCategoryType : String?
    var defaultBrands : String?
    var brandName:[String]?
    var brandDetails : [BrandDetail]?
    var booking_flow: String?
    var image:String?
    var is_manual_assignment:String?
    var serviceTitle: String?
    var description: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        is_manual_assignment <- map["is_manual_assignment"]
        serviceDescription <- map["description"]
        brands <- map["brands"]
        serviceCategoryId <- map["category_id"]
        serviceName <- map["name"]
        serviceCategoryType <- map["category_type"]
        defaultBrands <- map["default_brands"]
        buraqPercentage <- map["buraq_percentage"]
        booking_flow <- map["booking_flow"]
        image <- map["image"]
        serviceTitle <- map["title"]
        brandName = brands?.map({/$0.brandName })
    }
}
