//
//  ApiSucessDataCab.swift
//  Buraq24
//
//  Created by MANINDER on 16/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class ApiSucessDataCab < T: Mappable >: Mappable
{
    var message: String?
    var object: T?
    var array : [T]?
    var statusCode: Int?
    
     required init?(map: Map) { }
    
    func mapping(map: Map) {

        message <- map["msg"]
        object <- map["result"]
        array <- map["result"]
        statusCode <- map["statusCode"]
    }
}
