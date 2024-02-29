//
//  Home.swift
//  Buraq24
//
//  Created by MANINDER on 18/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class HomeCab: Mappable {
    
    var userDetail : UserDetail?
    var drivers : [Driver]?
    var orders: [OrderCab] = [OrderCab]()
    var orderLastCompleted: [OrderCab] = [OrderCab]()
    var brands : [Brand]?
    var support : [SupportCab]?
    var services : [Service]?
    var version : Version?
    var addresses: RecentLocations?
    
    
     required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        userDetail <- map["AppDetail"]
        drivers <- map["drivers"]
        orders <- map["currentOrders"]
         orderLastCompleted <- map["lastCompletedOrders"]
        brands <- map["categories"] // brands with products
     
        version <- map["Versioning"]
        support <- map["supports"]
         services <- map["services"]
        addresses <- map["addresses"]
        
    }
}

class RecentLocations : Mappable {

    var home : AddressCab?
    var recent : [AddressCab]?
    var work : AddressCab?

    
    required init?(map: Map){}

    func mapping(map: Map)
    {
        home <- map["home"]
        recent <- map["recent"]
        work <- map["work"]
        
    }
}

class AddressCab : Mappable {

    var address : String?
    var addressLatitude : Double?
    var addressLongitude : Double?
    var addressName : String?
    var blocked : String?
    var category : String?
    var createdAt : String?
    var updatedAt : String?
    var userAddressId : Int?
    var userId : Int?


    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        address <- map["address"]
        addressLatitude <- map["address_latitude"]
        addressLongitude <- map["address_longitude"]
        addressName <- map["address_name"]
        blocked <- map["blocked"]
        category <- map["category"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        userAddressId <- map["user_address_id"]
        userId <- map["user_id"]
        
    }
}
