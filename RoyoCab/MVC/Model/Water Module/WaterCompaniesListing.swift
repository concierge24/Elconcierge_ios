//
//  WaterCompaniesListing.swift
//  Buraq24
//
//  Created by Apple on 26/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper


class companies: Mappable{

    var name : String?
    var phone_code  : String?
    var phone_number : String?
    var organisation_id : Int?
    var image_url:String?
    var image :String?
    var monday_service:String?
    var tuesday_service:String?
    var wednesday_service:String?
    var thursday_service:String?
    var friday_service:String?
    var saturday_service:String?
    var sunday_service:String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        phone_code <- map["phone_code"]
        phone_number <- map["phone_number"]
        organisation_id <- map["organisation_id"]
        image_url <- map["image_url"]
        image <- map["image"]
        
        monday_service <- map["monday_service"]
        tuesday_service <- map["tuesday_service"]
        wednesday_service <- map["wednesday_service"]
        thursday_service <- map["thursday_service"]
        friday_service <- map["friday_service"]
        saturday_service <- map["saturday_service"]
        sunday_service <- map["sunday_service"]
        
    }
}


