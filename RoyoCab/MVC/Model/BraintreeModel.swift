//
//  BraintreeModel.swift
//  RoyoRide
//
//  Created by Prashant on 08/08/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class BraintreeModel: NSObject,Mappable {
    
    var message: String?
    var token:String?
    var statusCode: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        statusCode <- map["statusCode"]
        token <- map["client_token"]
        message <- map["message"]
       
    }
}
