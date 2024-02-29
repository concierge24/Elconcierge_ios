//
//  BannerServicesModal.swift
//  Trava
//
//  Created by Apple on 08/01/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper


class BannerServicesModal : NSObject, Mappable {

    var banners : [BannerCab]?
    var services : [Service]?


    class func newInstance(map: Map) -> Mappable?{
        return BannerServicesModal()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        banners <- map["banners"]
        services <- map["services"]
        
    }
}

class BannerCab : NSObject,  Mappable{

    var bannerId : Int?
    var bannerUrl : String?
    var createdAt : String?
    var image : String?
    var status : Int?
    var title : String?
    var updatedAt : String?


    class func newInstance(map: Map) -> Mappable?{
        return BannerCab()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        bannerId <- map["banner_id"]
        bannerUrl <- map["banner_url"]
        createdAt <- map["created_at"]
        image <- map["image"]
        status <- map["status"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        
    }
}
