//
//  LoginDetail.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginDetail: Mappable {
    
    var userDetails : UserDetail?
    var services : [Service]?
    var support : [SupportCab]?
    var addSaveAddresses : [AddSaveAddresses]?
    var order : [OrderCab]?
    
    init() {
           
       }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userDetails <- map["AppDetail"]
        services <- map["services"]
        support <- map["supports"]
        addSaveAddresses <- map["addSaveAddresses"]

    }
    
}
