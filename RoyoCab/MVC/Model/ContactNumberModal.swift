//
//  ContactNumberModal.swift
//  Trava
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class ContactNumberModal: NSObject, Mappable {

    var contactNumber: String?
    var name: String?
    var ISO: String?
    var countryCode: String?
    
    required init?(map: Map){}
    
    init(contactNumber: String?, name: String?, ISO: String?, countryCode: String?) {
        self.contactNumber = contactNumber
        self.name = name
        self.ISO = ISO
        self.countryCode = countryCode
    }

    func mapping(map: Map)
    {
        name <- map["name"]
        countryCode <- map["phone_code"]
        contactNumber <- map["phone_number"]
        
    }
}
