//
//  CoronaAreas.swift
//  Sneni
//
//  Created by Pankaj Sharma on 06/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation

import ObjectMapper

// MARK: - UserServices
class CoronaAreas:NSObject,Mappable {
    var success, statusCode, maximumDistance: Int?
    var msg: String?
    var coronaArea:[CoronaDetails]?
    var quarantineArea:[QuarantineDetails]?
  
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        msg <- map ["msg"]
        statusCode <- map["statusCode"]
        success <- map["success"]
        maximumDistance <- map["maximum_distance"]
        quarantineArea <- map["quarantineArea"]
        coronaArea <- map["coronaArea"]
        
    }
}

// MARK: - Result
class CoronaDetails:NSObject,Mappable {
    var coronaID: Int?
    var city_latitude:Double?
    var city_longitude: Double?
    var type: String?
    var isSealed: String?
    var corona_count:Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
     
    func mapping(map: Map) {
        coronaID <- map ["corona_id"]
        city_latitude <- map ["city_latitude"]
        city_longitude <- map ["city_longitude"]
        type <- map ["type"]
        isSealed <- map["is_sealed"]
        corona_count <- map["corona_count"]
    }
}

class QuarantineDetails:NSObject,Mappable {
    var coronaID: Int?
    var city_latitude:Double?
    var city_longitude: Double?
    var type: String?
    var isSealed: String?
    var quarantine_count:Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
     
    func mapping(map: Map) {
        coronaID <- map ["corona_id"]
        city_latitude <- map ["city_latitude"]
        city_longitude <- map ["city_longitude"]
        type <- map ["type"]
        isSealed <- map["is_sealed"]
        quarantine_count <- map["quarantine_count"]
    }
}
