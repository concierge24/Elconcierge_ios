//
//  SendOtp.swift
//  Buraq24
//
//  Created by MANINDER on 16/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit


import ObjectMapper





class SendOtp: Mappable {
    
    var accessToken : String?
    var type : NumberType?
    var otp : Int?
    var version : Version?
    var countryCode : String?
    var mobileNumber : String?
    var iso: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        accessToken <- map["access_token"]
        otp <- map["otp"]
        var strType:String?
        strType <- map["type"]
        type = NumberType(rawValue: /strType)
        version <- map["Versioning"]
        iso <- map["iso"]
    }
}


class Version: Mappable {
    
    var iOSVersion : IosVersion?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        iOSVersion <- map["IOS"]
    }
    
}

class IosVersion : Mappable {
    
    var user : CustomerAppVersion?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        user <- map["user"]
    }
}

class CustomerAppVersion : Mappable {
    
    var normalVersion : String?
    var forceVersion : String?
    required init?(map: Map){}
    
    func mapping(map: Map) {
        forceVersion <- map["force"]
        normalVersion <- map["normal"]
    }
}
