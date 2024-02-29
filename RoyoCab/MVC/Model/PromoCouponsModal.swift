//
//  PromoCouponsModal.swift
//  Trava
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class PromoCouponsModal : NSObject, Mappable{

    var coupons : [Coupon]?

    class func newInstance(map: Map) -> Mappable?{
        return PromoCouponsModal()
    }
    
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        coupons <- map["coupons"]
        
    }
}

class Coupon : NSObject, Mappable{

    var amountValue : String?
    var code : String?
    var couponId : Int?
    var couponType : String?
    var expiresAt : String?
    var price : Int?
    var purchaseCounts : Int?
    var ridesValue : Int?
    
    var expiry_days: Int?
    var is_referral: Bool?
    var user_id: Int?
    var referral_user_id: Int?

    class func newInstance(map: Map) -> Mappable?{
        return Coupon()
    }
    
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        amountValue <- map["amount_value"]
        code <- map["code"]
        couponId <- map["coupon_id"]
        couponType <- map["coupon_type"]
        expiresAt <- map["expires_at"]
        price <- map["price"]
        purchaseCounts <- map["purchase_counts"]
        ridesValue <- map["rides_value"]
        
        expiry_days <- map["expiry_days"]
        is_referral <- map["is_referral"]
        user_id <- map["user_id"]
        referral_user_id <- map["referral_user_id"]
    }
}
