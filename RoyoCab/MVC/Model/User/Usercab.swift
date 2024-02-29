//
//  User.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper


enum NotificationStatus : String  {
    case On = "1"
    case Off = "0"
}



class UserDetail: Mappable {
    
    var user : Usercab?
    var profilePic : String?
    var userType : UserType?
    var mulkiyaValidity : String?
    var mulkiyaNumber : String?
    var fcmId : String?
    var mulkiyaBack : String?
    var userDetailId : Int?
    var socketId : String?
    var latitude : Float?
    var longitude : Float?
    var organisationId : Int?
    var categoryBrandId : Int?
    var categoryId : Int?
    var timezoneDifference : String?
    var timezoneName : String?
    var accessToken : String?
    var onlineStatus : UserOnlineStatus?
    var lanuageId : Int?
    var userId : Int?
    var maximumRides : Int?
    var mulkiyaFront : String?
    var myRatingCount : Int?
    var myRatingAverage: Int?
    var gender:String?
    var firstName:String?
    var lastName:String?
    var credit_points: Float?
    var url: String? // Add Card URL
    var cards: [CardCab]?
    
    var notificationStatus : NotificationStatus  = .Off
    
    
    init() {
           
       }
    
   
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        user <- map["user"]
        profilePic <- map["profile_pic_url"]
        var userValue:Int?
        userValue <- map["user_type_id"]
        userType = UserType(rawValue: /userValue)
        mulkiyaNumber <- map["mulkiya_number"]
        fcmId <- map["fcm_id"]
        mulkiyaBack <- map["mulkiya_back"]
        userDetailId <- map["user_detail_id"]
        socketId <- map["socket_id"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        organisationId <- map["organisation_id"]
        categoryBrandId <- map["category_brand_id"]
        categoryId <- map["category_id"]
        timezoneDifference <- map["timezonez"]
        timezoneName <- map["timezone"]
        accessToken <- map["access_token"]
        lanuageId <- map["language_id"]
        userId <- map["user_id"]
        maximumRides <- map["maximum_rides"]
        mulkiyaFront <- map["mulkiya_front"]
        myRatingCount <- map["rating_count"]
        myRatingAverage <- map["ratings_avg"]
        gender <- map["gender"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        
        notificationStatus <- (map["notifications"],EnumTransform<NotificationStatus>())
        onlineStatus <- (map["online_status"],EnumTransform<UserOnlineStatus>())
        credit_points <- map["credit_points"]
        url <- map["url"]
        cards <- map["cards"]
        
    }
}



class Usercab: Mappable {
    
    var name : String?
    var email : String?
    var stripeConnectToken : String?
    var stripeCustomerId : String?
    var phoneNumber : Int?
    var countryCode : String?
    var userId : Int?
    var organisationId : Int?
    var stripeConnectId : String?
    var iso : String?
    
    var currentCountry: String?// set from current location in Home VC (Configure Map View)
    var currentCountryCode: String?
    var referral_code: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        stripeConnectToken <- map["stripe_connect_token"]
        stripeCustomerId <- map["stripe_customer_id"]
        countryCode <- map["phone_code"]
        phoneNumber <- map["phone_number"]
        userId <- map["user_id"]
        organisationId <- map["organisation_id"]
        stripeConnectId <- map["stripe_connect_id"]
        iso <- map["iso"]
        referral_code <- map["referral_code"]
    }
}


class CardResponse: Mappable{
    
  
    var result:[CardCab]?
    
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        
     
        result  <- map["result"]
    }
    
}

class CardCab : Mappable {

    var cardExpiry : String?
    var cardHolderName : String?
    var cardNo : String?
    var createdAt : String?
    var customerToken : String?
    var deleted : String?
    var isDefault : String?
    var orderIdPayment : String?
    var paymentId : String?
    var updatedAt : String?
    var userCardId : Int?
    var userId : Int?
    var expYear:String?
    var expMonth:String?
    var lastDigit:String?
    var last4: String?

    required init?(map: Map){}

    func mapping(map: Map)
    {
        cardExpiry <- map["card_expiry"]
        cardHolderName <- map["card_holder_name"]
        cardNo <- map["card_no"]
        createdAt <- map["created_at"]
        customerToken <- map["customer_token"]
        deleted <- map["deleted"]
        isDefault <- map["is_default"]
        orderIdPayment <- map["order_id_payment"]
        paymentId <- map["payment_id"]
        updatedAt <- map["updated_at"]
        userCardId <- map["user_card_id"]
        userId <- map["user_id"]
        expYear <- map["exp_year"]
        expMonth <- map["exp_month"]
        lastDigit <- map["last4"]
        last4 <- map["last4"]
        
    }

}


class imgeUpload: Mappable {
    
    var original : String?
    var thumbnail : String?
    
    
    init(original: String?, thumbnail: String?) {
        self.original = original
        self.thumbnail = thumbnail
        
        
    }
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        original <- map["original"]
        thumbnail <- map["thumbnail"]
        
        
        
    }
}
