//
//  AddSaveAddresses.swift
//  Buraq24
//
//  Created by Apple on 04/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class AddSaveAddresses: Mappable {
    
    
    var latitude : Double?
    var longitude: Double?
    var locationName : String?
    var name : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        locationName <- map["locationName"]
        name <- map["name"]

    }

}

