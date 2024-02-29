//
//  RideShareModal.swift
//  Trava
//
//  Created by Apple on 16/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//


import Foundation
import ObjectMapper


class RideShareModal : NSObject, Mappable {

    var accessToken : String?
    var appLanguageId : String?
    var createdAt : String?
    var orderId : String?
    var shareWith : [ShareWith]?
    var userDetailId : Int?
    var userId : Int?
    var userOrganisationId : Int?
    var userTypeId : Int?

    class func newInstance(map: Map) -> Mappable?{
        return RideShareModal()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        accessToken <- map["access_token"]
        appLanguageId <- map["app_language_id"]
        createdAt <- map["created_at"]
        orderId <- map["order_id"]
        shareWith <- map["shareWith"]
        userDetailId <- map["user_detail_id"]
        userId <- map["user_id"]
        userOrganisationId <- map["user_organisation_id"]
        userTypeId <- map["user_type_id"]
        
    }
}


