//
//  ETokenModel.swift
//  Buraq24
//
//  Created by MANINDER on 31/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper
class ETokenModel: Mappable {
    
    var categoryBrandProductName : String?
    var organisationCouponId : Int?
    var distCount : Int?
    var tokenDescription : String?
    var quantityToken : Int?
    var expiryDays : Int?
    var organisationId : Int?
    var price : Double?
    var categoryBrandProductId : Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
         categoryBrandProductName   <- map["category_brand_product_name"]
        organisationCouponId     <- map["organisation_coupon_id"]
         distCount     <- map["dist_count"]
         tokenDescription   <- map["description"]
         quantityToken <- map["quantity"]
         expiryDays <- map["expiry_days"]
         organisationId <- map["organisation_id"]
         price <- map["price"]
         categoryBrandProductId <- map["category_brand_product_id"]
    }

}

class ETokenPurchased: Mappable {
    
    var customerOrganisationId :Int?
    var categoryId : Int?
    var brandId: Int?
    var price : Double?
    var tokenDescription : String?
    var quantityToken : Int?
    var expiryDays : Int?
    var organisationId : Int?
    var categoryBrandProductId : Int?
    var sellerOrganisationId : Int?
    var customerUserTypeId : Int?
    var paymentId : Int?
    var organisationCouponUserId : Int?
    var organisationCouponId : Int?
    var expiryDate : String?
    var sellerUserTypeId : Int?
    var sellerUserId : Int?
    var sellerUserDetailId : Int?
    var customerUserId : Int?
    var brand : Brand?
  
    required init?(map: Map) {
        
        
    }
    
    func mapping(map: Map) {
        

         customerOrganisationId <- map["customer_organisation_id"]
         categoryId <- map["category_id"]
         brandId <- map["category_brand_id"]
         price <- map["price"]
         quantityToken <- map["quantity"]
         expiryDays <- map["expiry_days"]
         categoryBrandProductId <- map["category_brand_product_id"]
         sellerOrganisationId <- map["seller_organisation_id"]
         customerUserTypeId <- map["customer_user_type_id"]
         paymentId <- map["payment_id"]
         organisationCouponUserId <- map["organisation_coupon_user_id"]
         organisationCouponId <- map["organisation_coupon_id"]
         expiryDate <- map["expires_at"]
         sellerUserTypeId <- map["seller_user_type_id"]
         sellerUserId <- map["seller_user_id"]
         sellerUserDetailId <- map["seller_user_detail_id"]
         customerUserId <- map["customer_user_id"]
         brand <- map["brand"]
    }
    
}


