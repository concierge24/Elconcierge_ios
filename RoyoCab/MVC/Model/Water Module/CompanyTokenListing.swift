//
//  CompanyTokenListing.swift
//  Buraq24
//
//  Created by Apple on 27/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper
class CompanyTokenListing: Mappable {
    
    var organisation : TokenOrganisation?
    var eTokens : [Tokens]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        organisation <- map["org"]
        eTokens <- map["etokens"]
    }
}

class TokenOrganisation: Mappable{
    var organisation_id :String?
    var  name :String?
    var image: String?
    var image_url:String?
    var buraq_percentage:Int?
    var bottle_charge:Int?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        organisation_id <- map["organisation_id"]
        name <- map["name"]
        image <- map ["image"]
        image_url <- map ["image_url"]
        buraq_percentage <- map["buraq_percentage"]
        bottle_charge <- map ["bottle_charge"]
    }
}

class Tokens:Mappable{
    
    var category_brand_id :Int?
    var  category_brand_product_id :Int?
    var category_id: Int?
    var organisation_coupon_id:Int?
    var organisation_id:Int?
    var price:Int?
    var quantity :Int?
    var categoryBrand : TokenCategoryBrand?
    var categoryBrandProduct :TokenCategoryBrandProduct?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category_brand_id <- map["category_brand_id"]
        category_brand_product_id <- map["category_brand_product_id"]
        category_id <- map ["category_id"]
        organisation_coupon_id <- map ["organisation_coupon_id"]
        organisation_id <- map["organisation_id"]
        price <- map ["price"]
        quantity <- map["quantity"]
        categoryBrand <- map["categoryBrand"]
        categoryBrandProduct <- map["categoryBrandProduct"]
    }
}


class TokenCategoryBrand:Mappable{
    var category_brand_detail_id:Int?
    var category_brand_id:Int?
    var description:String?
    var image:String?
    var image_url:String?
    var name:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category_brand_detail_id <- map["category_brand_detail_id"]
        category_brand_id <- map["category_brand_id"]
        description <- map ["description"]
        image <- map ["image"]
        image_url <- map["image_url"]
        name <- map ["name"]
    }
}

class TokenCategoryBrandProduct:Mappable{
    var category_brand_product_id:Int?
    var description:String?
    var name:String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category_brand_product_id <- map["category_brand_product_id"]
        description <- map ["description"]
        name <- map ["name"]
    }
}




//MARK: Purchased token Model -------------------------------------------------!

class PurchasedTokens:Mappable{
    
    var address :String?
    var address_latitude:Double?
    var address_longitude:Double?
    var bottle_quantity:Int?
    
    var category_brand_id:Int?
    var  category_brand_product_id :Int?
    var category_id:Int?
    var created_at:String?
    
    var customer_user_detail_id:Int?
    var customer_user_id :Int?
    var organisation_coupon_id:Int?
    var organisation_coupon_user_id:Int?
    
    var paidPaymentAmount:Int?
    var pendingPaymentAmount:Int?
    var quantity:Int?
    var quantity_left:Int?
    
    var sellerOrg:SellerOrg?
    var seller_organisation_id:Int?
    var seller_user_detail_id:Int?
    var seller_user_id:Int?
    
    var seller_user_type_id:Int?
    var updated_at:Int?
    var categoryBrandProduct :soldCategoryBrandProduct?
    var categoryBrand :categoryBrand?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        address_latitude <- map["address_latitude"]
        address_longitude <- map["address_longitude"]
        bottle_quantity <- map["bottle_quantity"]
        
        category_brand_id <- map["category_brand_id"]
        category_brand_product_id <- map["category_brand_id"]
        category_id <- map["category_id"]
        created_at <- map["created_at"]
        
        customer_user_detail_id <- map["customer_user_detail_id"]
        customer_user_id <- map["customer_user_id"]
        organisation_coupon_id <- map["organisation_coupon_id"]
        organisation_coupon_user_id <- map["organisation_coupon_user_id"]
        
        paidPaymentAmount <- map["paidPaymentAmount"]
        pendingPaymentAmount <- map["pendingPaymentAmount"]
        quantity <- map["quantity"]
        quantity_left <- map["quantity_left"]
        
        sellerOrg <- map["sellerOrg"]
        seller_organisation_id <- map["seller_organisation_id"]
        seller_user_detail_id <- map["seller_user_detail_id"]
        seller_user_id <- map["seller_user_id"]
        
        
        seller_user_type_id <- map["seller_user_type_id"]
        updated_at <- map["updated_at"]
        categoryBrandProduct <- map["categoryBrandProduct"]
        categoryBrand <- map["categoryBrand"]
        
    }
}


class SellerOrg:Mappable{
    
    var name : String?
     var username : String?
    var phone_code  : String?
    var phone_number : String?
    var organisation_id : Int?
    var image_url: String?
    var image :String?
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        phone_code <- map["phone_code"]
        phone_number <- map["phone_number"]
        organisation_id <- map["organisation_id"]
        image <- map["image"]
    }
}



class soldCategoryBrandProduct:Mappable{
    var category_brand_product_id:Int?
    var description :String?
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        category_brand_product_id <- map["category_brand_product_id"]
        description <- map["description"]
        name <- map["name"]
    }
    
}


class categoryBrand:Mappable{
    var name :String?
    var image_url:String?
    var image :String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        image_url <- map["image_url"]
        image <- map["image"]
    }
    
    
    
}






