//
//  Driver.swift
//  Buraq24
//
//  Created by MANINDER on 18/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//


import UIKit
import ObjectMapper



class DriverList: Mappable {
    
    var drivers : [HomeDriver]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        drivers <- map["drivers"]
    }
}



class HomeDriver : Mappable {
    
    var latitude : Double?
    var longitude : Double?
    var driverServiceId : Int?
    var driverUserId : Int?
    var bearingValue : Float?
    
    var category_brand_id: Int?
    var category_id: Int?
    var distance: Float?
    var icon_image_url: String?

    
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
      latitude <- map["latitude"]
         longitude <- map["longitude"]
          driverServiceId <- map["category_id"]
        driverUserId <- map["user_detail_id"]
        bearingValue <- map["bearing"]
        
        category_brand_id <- map["category_brand_id"]
        category_id <- map["category_id"]
        distance <- map["distance"]
        icon_image_url <- map["icon_image_url"]
    }
}



class Driver: Mappable {
    var driverName : String?
    var driverCountryCode : String?
    var driverPhoneNumber : Int?
    var driverLatitude : Double?
    var driverLongitude : Double?
    var driverTimeZone : String?
    var driverProfilePic : String?
    var driverEmail : String?
    var driverAddress : String?
    var driverOrganisationId : Int?
    var driverSocketId : String?
    var driverUserId : Int?
    var driverUserDetailId : Int?
    var driverOnlineStatus : UserOnlineStatus?
    var driverLanguageId : Int?
    var driverRatingCount : Int?
    var driverRatingAverage : String?
    var vehicle_name: String?
    var vehicle_number: String?
    var icon_image_url: String?
    
required init?(map: Map){
    

    }
    
    func mapping(map: Map) {
        
       driverName <- map["name"]
       driverCountryCode <- map["phone_code"]
       driverPhoneNumber <- map["phone_number"]
       driverLatitude <- map["latitude"]
       driverLongitude <- map["longitude"]
       driverTimeZone <- map["timezone"]
       driverProfilePic <- map["profile_pic_url"]
       driverEmail <- map["email"]
       driverAddress <- map["address"]
       driverOrganisationId <- map["organisation_id"]
       driverSocketId <- map["socket_id"]
       driverUserId <- map["user_id"]
        driverUserDetailId <- map["user_detail_id"]
        driverRatingCount <- map["rating_count"]
        driverRatingAverage <- map["rating_avg"]
        var onlStatus:String?
        onlStatus <- map["online_status"]
        driverOnlineStatus = UserOnlineStatus(rawValue: /onlStatus)
        driverLanguageId <- map["language_id"]
        vehicle_name <- map["vehicle_name"]
        vehicle_number <- map["vehicle_number"]
        icon_image_url <- map["icon_image_url"]
        
    }
}
