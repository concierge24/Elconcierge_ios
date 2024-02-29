//
//  EToken.swift
//  Buraq24
//
//  Created by MANINDER on 31/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class EToken: Mappable {

    
    var myTokens : [ETokenPurchased]?
     var brands : [Brand]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        myTokens <- map["history"]
        brands <- map["brands"]
    }
}
