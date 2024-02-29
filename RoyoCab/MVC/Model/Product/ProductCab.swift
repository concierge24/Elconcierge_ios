//
//  Product.swift
//  Buraq24
//
//  Created by MANINDER on 18/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductCab: Mappable {
    
    var productDescription : Int?
    var productSortOrder : Int?
    var productName : String?
    var productBrandId : Int?
    var actualPrice : Float? // Change according to backend
    var pricePerQuantity : Float?
    var pricePerWeight : Float?
    var pricePerDistance : Float?
    var alphaPrice : Float?
    var productImage : String?
    var min_quantity :Int?
    var max_quantity :Int?
    var seating_capacity: Int?
    var price_per_hr: Float?
    
    var imageURL : URL?
    
    var image : String?
    var distance_price_fixed: Float?
    var price_per_min : Float?
    var time_fixed_price: Float?
    var price_per_km: Int?
    var category_brand_id: Int?
    var load_unload_charges: Float?
    var load_unload_time: String?
    var surChargeAdmin: [SurChargeAdmin]?
    var schedule_charge_type: String?
    var pool:String?
    var schedule_charge: Int?
    var pool_price_per_distance: Float?
    var pool_price_per_hr:Float?
    var pool_alpha_price:Float?
    
    
    

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        pool_alpha_price <- map["pool_alpha_price"]
        pool_price_per_hr <- map["pool_price_per_hr"]
        pool_price_per_distance <- map["pool_price_per_distance"]
        schedule_charge <- map["schedule_charge"]
        pool <- map["pool"]
        schedule_charge_type <- map["schedule_charge_type"]
        surChargeAdmin <- map["surChargeAdmin"]
        productDescription <- map["description"]
        productSortOrder <- map["sort_order"]
        productName <- map["name"]
        productBrandId <- map["category_brand_product_id"]
        actualPrice <- map["actual_value"]
        pricePerQuantity <- map["price_per_quantity"]
        pricePerWeight <- map["price_per_weight"]
        pricePerDistance <- map["price_per_distance"]
         alphaPrice <- map["alpha_price"]
        min_quantity <- map["min_quantity"]
        max_quantity <- map["max_quantity"]
        productImage <- map["image_url"]
        
        seating_capacity <- map["seating_capacity"]
        price_per_hr <- map["price_per_hr"]
        
        load_unload_time <- map["load_unload_time"]
        
        image <- map["image"]
        distance_price_fixed <- map["distance_price_fixed"]
        price_per_min <- map["price_per_min"]
        time_fixed_price <- map["time_fixed_price"]
        price_per_km <- map["price_per_km"]
        category_brand_id <- map["category_brand_id"]
        load_unload_charges <- map["load_unload_charges"]
        
        guard let imgeURL = productImage else{return}
        imageURL = URL(string: imgeURL)
        
        
    }
    
}






class SurChargeAdmin:Mappable{
    
    var type:String?
    var slotId:Int?
    var value:String?
    var startTime: String?
    var endTime:String?
    var status:Int?
    
    
    required init?(map: Map){
           
       }
    
    func mapping(map: Map) {
        type <- map["type"]
        slotId <- map["slot_id"]
        value <- map["value"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        status <- map["status"]
    }
}
