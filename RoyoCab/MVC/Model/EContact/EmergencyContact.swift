//
//  EmergencyContact.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class EmergencyContact: Mappable {
    
    var phoneNumber : Int?
    var name : String?
    var contactId : Int?
    //var icon:String?
    var phone_code:String?
    var image:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        phoneNumber <- map["phone_number"]
        name <- map["name"]
     //   icon <- map["image"]
        contactId <- map["emergency_contact_id"]
        phone_code <- map["phone_code"]
        image <- map["image"]
    }
}
