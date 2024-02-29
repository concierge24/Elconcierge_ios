//
//  RoadPickupModal.swift
//  Trava
//
//  Created by Apple on 30/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper


class RoadPickupModal : NSObject, Mappable {

    var accessToken : String?
    var accountStep : Int?
    var adhaarBack : AnyObject?
    var adhaarFront : AnyObject?
    var categoryBrandId : Int?
    var categoryId : Int?
    var governmentBack : String?
    var governmentFront : String?
    var languageId : Int?
    var latitude : Float?
    var longitude : Float?
    var mulkiyaBack : String?
    var mulkiyaFront : String?
    var mulkiyaNumber : String?
    var mulkiyaValidity : String?
    var otherDoc1 : AnyObject?
    var otherDoc2 : AnyObject?
    var otherDoc3 : AnyObject?
    var panBack : AnyObject?
    var panFront : AnyObject?
    var profilePic : String?
    var qrCode : String?
    var rcBack : AnyObject?
    var rcFront : AnyObject?
    var user : RoadPickUpUser?
    var userDetailId : Int?
    var userDriverDetailProducts : [UserDriverDetailProduct]?
    var userDriverDetailServices : [UserDriverDetailService]?
    var userId : Int?
    var userTypeId : Int?
    var vehicleBack : String?
    var vehicleColor : String?
    var vehicleFront : String?
    var vehicleName : String?
    var vehicleNumber : String?
    var vehicleRegistrationNumber : String?


    class func newInstance(map: Map) -> Mappable?{
        return RoadPickupModal()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        accessToken <- map["access_token"]
        accountStep <- map["accountStep"]
        adhaarBack <- map["adhaar_back"]
        adhaarFront <- map["adhaar_front"]
        categoryBrandId <- map["category_brand_id"]
        categoryId <- map["category_id"]
        governmentBack <- map["government_back"]
        governmentFront <- map["government_front"]
        languageId <- map["language_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        mulkiyaBack <- map["mulkiya_back"]
        mulkiyaFront <- map["mulkiya_front"]
        mulkiyaNumber <- map["mulkiya_number"]
        mulkiyaValidity <- map["mulkiya_validity"]
        otherDoc1 <- map["other_doc1"]
        otherDoc2 <- map["other_doc2"]
        otherDoc3 <- map["other_doc3"]
        panBack <- map["pan_back"]
        panFront <- map["pan_front"]
        profilePic <- map["profile_pic"]
        qrCode <- map["qr_code"]
        rcBack <- map["rc_back"]
        rcFront <- map["rc_front"]
        user <- map["user"]
        userDetailId <- map["user_detail_id"]
        userDriverDetailProducts <- map["user_driver_detail_products"]
        userDriverDetailServices <- map["user_driver_detail_services"]
        userId <- map["user_id"]
        userTypeId <- map["user_type_id"]
        vehicleBack <- map["vehicle_back"]
        vehicleColor <- map["vehicle_color"]
        vehicleFront <- map["vehicle_front"]
        vehicleName <- map["vehicle_name"]
        vehicleNumber <- map["vehicle_number"]
        vehicleRegistrationNumber <- map["vehicle_registration_number"]
    }
}

class UserDriverDetailService : NSObject, Mappable{

    var buraqPercentage : Int?
    var categoryId : Int?
    var deleted : String?
    var userDetailId : Int?
    var userDriverDetailServiceId : Int?
    var userId : Int?


    class func newInstance(map: Map) -> Mappable?{
        return UserDriverDetailService()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        buraqPercentage <- map["buraq_percentage"]
        categoryId <- map["category_id"]
        deleted <- map["deleted"]
        userDetailId <- map["user_detail_id"]
        userDriverDetailServiceId <- map["user_driver_detail_service_id"]
        userId <- map["user_id"]
        
    }
}

class UserDriverDetailProduct : NSObject, Mappable{

    var alphaPrice : Int?
    var categoryBrandProductId : Int?
    var deleted : String?
    var pricePerDistance : Int?
    var pricePerHr : Int?
    var pricePerQuantity : Int?
    var pricePerSqMt : Int?
    var pricePerWeight : Int?
    var userDetailId : Int?
    var userDriverDetailProductId : Int?
    var userId : Int?


    class func newInstance(map: Map) -> Mappable?{
        return UserDriverDetailProduct()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        alphaPrice <- map["alpha_price"]
        categoryBrandProductId <- map["category_brand_product_id"]
        deleted <- map["deleted"]
        pricePerDistance <- map["price_per_distance"]
        pricePerHr <- map["price_per_hr"]
        pricePerQuantity <- map["price_per_quantity"]
        pricePerSqMt <- map["price_per_sq_mt"]
        pricePerWeight <- map["price_per_weight"]
        userDetailId <- map["user_detail_id"]
        userDriverDetailProductId <- map["user_driver_detail_product_id"]
        userId <- map["user_id"]
        
    }
}

class RoadPickUpUser : NSObject, Mappable{

    var address : String?
    var addressLatitude : Int?
    var addressLongitude : Int?
    var bottleCharge : String?
    var buraqPercentage : Int?
    var email : String?
    var firstName : AnyObject?
    var gender : String?
    var iso : AnyObject?
    var lastName : AnyObject?
    var name : String?
    var organisationId : Int?
    var password : AnyObject?
    var phoneCode : String?
    var phoneNumber : Int?
    var referralCode : String?
    var stripeConnectId : String?
    var stripeConnectToken : String?
    var stripeCustomerId : String?
    var userId : Int?


    class func newInstance(map: Map) -> Mappable?{
        return RoadPickUpUser()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        address <- map["address"]
        addressLatitude <- map["address_latitude"]
        addressLongitude <- map["address_longitude"]
        bottleCharge <- map["bottle_charge"]
        buraqPercentage <- map["buraq_percentage"]
        email <- map["email"]
        firstName <- map["firstName"]
        gender <- map["gender"]
        iso <- map["iso"]
        lastName <- map["lastName"]
        name <- map["name"]
        organisationId <- map["organisation_id"]
        password <- map["password"]
        phoneCode <- map["phone_code"]
        phoneNumber <- map["phone_number"]
        referralCode <- map["referral_code"]
        stripeConnectId <- map["stripe_connect_id"]
        stripeConnectToken <- map["stripe_connect_token"]
        stripeCustomerId <- map["stripe_customer_id"]
        userId <- map["user_id"]
        
    }

    

}
