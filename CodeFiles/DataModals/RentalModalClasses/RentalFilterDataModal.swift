//
//  RentalFilterDataModal.swift
//  Sneni
//
//  Created by Apple on 08/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
import SwiftyJSON

class RentalFilterData: NSCoding {
    
    var products : [ProductF]?
    var count : Int?

    init(attributes : SwiftyJSONParameter , key : String){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[key]
        
        self.count = dict["count"].intValue
        let products = dict["product"].arrayValue
        var arrayProduct : [ProductF] = []
        for element in products{
            let supplier = ProductF(attributes: element.dictionaryValue)
            arrayProduct.append(supplier)
        }
        self.products = arrayProduct
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(products, forKey: "product")
        aCoder.encode(count, forKey: "count")
    }
    
    required init(coder aDecoder: NSCoder) {
        count = aDecoder.decodeObject(forKey: "count") as? Int
        products = aDecoder.decodeObject(forKey: "product") as? [ProductF]
    }
    
}

class RentalFilterDataModalClass: Mappable {
    
    var productArray : [RentalFilterProductDataModalClass]?
    var count : Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        productArray <- map ["product"]
        count <- map["count"]
    }
    
}

class RentalFilterProductDataModalClass: Mappable {
    
    var supplier_address : String?
    var product_desc : String?
    var name : String?
    var price_type : Int?
    var detailed_sub_category_id : Int?
    var supplier_name : String?
    var handling_supplier : Int?
    var is_favourite : Int?
    var can_urgent : Int?
    var detailed_name : String?
    var image_path : String?
    var is_product : Int?
    var is_variant : Int?
    var measuring_unit : String?
    var display_price : String?
    var is_agent : Int?
    var avg_rating : Int?
    var duration : Int?
    var distance : Float?
    var price1 : Int?
    var price : String?
    var handling_admin : Int?
    var availability : Int?
    var category_flow : String?
    var pricing_type : Int?
    var interval_flag : Int?
    var delivery_radius : Double?
    var category_id : Int?
    var is_quantity : Int?
    var interval_value : Int?
    var purchased_quantity : Int?
    var product_id : Int?
    var hourly_price : String?
    var fixed_price : String?
    var supplier_id : Int?
    var quantity : Int?
    var urgent_type : Int?
    var agent_list : Int?
    var supplier_branch_id : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        supplier_address <- map ["supplier_address"]
        product_desc <- map["product_desc"]
        name <- map ["name"]
        price_type <- map["price_type"]
        detailed_sub_category_id <- map ["detailed_sub_category_id"]
        supplier_name <- map["supplier_name"]
        handling_supplier <- map ["handling_supplier"]
        is_favourite <- map["is_favourite"]
        can_urgent <- map ["can_urgent"]
        detailed_name <- map["detailed_name"]
        image_path <- map ["image_path"]
        is_product <- map["is_product"]
        is_variant <- map ["is_variant"]
        measuring_unit <- map["measuring_unit"]
        display_price <- map ["display_price"]
        is_agent <- map["is_agent"]
        avg_rating <- map ["avg_rating"]
        duration <- map["duration"]
        distance <- map ["distance"]
        price1 <- map["price1"]
        price <- map ["price"]
        category_flow <- map["category_flow"]
        handling_admin <- map ["handling_admin"] // in percentage
        availability <- map["availability"]
        pricing_type <- map ["pricing_type"]
        interval_flag <- map["interval_flag"]
        delivery_radius <- map ["delivery_radius"]
        category_id <- map["category_id"]
        is_quantity <- map ["is_quantity"]
        interval_value <- map["interval_value"]
        purchased_quantity <- map ["purchased_quantity"] 
        product_id <- map["product_id"]
        hourly_price <- map ["hourly_price"]
        fixed_price <- map["fixed_price"]
        supplier_id <- map ["supplier_id"]
        quantity <- map["quantity"]
        urgent_type <- map["urgent_type"]
        agent_list <- map ["agent_list"]
        supplier_branch_id <- map["supplier_branch_id"]
     
    }
    
}
