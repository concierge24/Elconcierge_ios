//
//  TerminologyModel.swift
//  RoyoRide
//
//  Created by Ankush on 11/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class AppTerminologyModel: Mappable {
    
    var categoryData : TerminologyCategoryData?
    var key_value: KeyValue?
    
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        categoryData <- map["categoryData"]
        key_value <- map["key_value"]
        
    }
}

class TerminologyCategoryData: Mappable {
    
    var category_id : Int?
    var text: String?
    var fragile: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        category_id <- map["category_id"]
        text <- map["text"]
        fragile <- map["fragile"]
    }
    
}

class KeyValue: Mappable {
    
    var halfway_ride_stop : String?
    var breakdown_stop: String?
    var panic_button: String?
    var schedule: String?
    var template: String?
    var check_list: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        halfway_ride_stop <- map["halfway_ride_stop"]
        breakdown_stop <- map["breakdown_stop"]
        panic_button <- map["panic_button"]
        schedule <- map["schedule"]
        template <- map["template"]
        check_list <- map["check_list"]
    }
}



