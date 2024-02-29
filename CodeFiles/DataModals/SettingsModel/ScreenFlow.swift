//
//  ScreenFlow.swift
//  Sneni
//
//  Created by MAc_mini on 11/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//


enum ScreenFlowKeys : String {
    case app_type = "app_type"
    case type = "type"
}
import Foundation
import SwiftyJSON
import RMMapper
import ObjectMapper

class ScreenFlow : Mappable {
 
    var app_type : Int?//0- Ecom, 1- Marketplace, 2- Servies
    //New flow ->  1-food, 2-ecom, grocery-3, books-4, car rental-5, product rental-6, space rental-7, home service-8, laundary-9, beauty-10

    var type : Int?// 1 - Food App, 2 - Gym App ///0- Supplier App, // 0-ecom, 1-food, 2-market,3-rental, 4-homeservicr
    var appType : String?
    
    var is_single_vendor: Int?
    var is_multiple_branch: Int?
    
    var isFoodApp: Bool {
        return type == 1
    }
    
    var isSingleVendor : Bool {
        return is_single_vendor == 1
    }
    
    init (attributes : Dictionary<String, JSON>?){
        self.app_type = attributes?[ScreenFlowKeys.app_type.rawValue]?.intValue
        self.type = attributes?[ScreenFlowKeys.type.rawValue]?.intValue
        self.is_single_vendor = attributes?["is_single_vendor"]?.intValue
        self.is_multiple_branch = attributes?["is_multiple_branch"]?.intValue
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        app_type <- map[ScreenFlowKeys.app_type.rawValue]
        type <- map[ScreenFlowKeys.type.rawValue]
        is_single_vendor <- map["is_single_vendor"]
        is_multiple_branch <- map["is_multiple_branch"]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(app_type, forKey: "app_type")
        aCoder.encode(type, forKey: "type")

        aCoder.encode(is_single_vendor, forKey: "is_single_vendor")
        aCoder.encode(is_multiple_branch, forKey: "is_multiple_branch")
    }
    
    required init(coder aDecoder: NSCoder) {
       
        app_type = aDecoder.decodeObject(forKey: "app_type") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? Int

        is_single_vendor = aDecoder.decodeObject(forKey: "is_single_vendor") as? Int
        is_multiple_branch = aDecoder.decodeObject(forKey: "is_multiple_branch") as? Int
    }
}

class DefaultCategotyFlow : Mappable {
    
    var image : String?
    var icon : String?
    var name : String?
    var id : Int??
    
//    init (attributes : Dictionary<String, JSON>?){
//        self.image = attributes?["image"]?.stringValue
//        self.icon = attributes?["icon"]?.stringValue
//        self.name = attributes?["name"]?.stringValue
//        self.id = attributes?["id"]?.intValue
//
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(image, forKey: "image")
//        aCoder.encode(icon, forKey: "icon")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(id, forKey: "id")
//    }
//
//    required init(coder aDecoder: NSCoder) {
//
//        image = aDecoder.decodeObject(forKey: "app_type") as? String
//        icon = aDecoder.decodeObject(forKey: "type") as? String
//        name = aDecoder.decodeObject(forKey: "app_type") as? String
//        id = aDecoder.decodeObject(forKey: "type") as? Int
//    }
//
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        icon <- map["icon"]
        name <- map["name"]
        id <- map["id"]
    }
    
}

class AppThemeData: Mappable {
    var show_tags_for_suppliers: String?
    var brandImage_url : String?
    var banner_one_thumb : String?
    var font_family : String?
    var banner_four : String?
    var app_color : String?
    var waiting_charges : String?
    var banner_two_thumb : String?
    var payment_method : String?
    var ios_app_url : String?
    var header_text_color : String?
    var logo_thumb_url : String?
    var android_app_url : String?
    var favicon_url : String?
    var banner_thumb_url : String?
    var banner_url : String?
    var terminology : TerminologyModalClass?
    var user_location : String?
    var empty_cart : String?
    var banner_three_thumb : String?
    var header_color : String?
    var domain_name : String?
    var order_loader : String?
    var logo_url : String?
    var theme_color : String?
    var element_color : String?
    var agent_ios_app_url : String?
    var banner_three : String?
    var agent_android_app_url : String?
    var logo_background : String?
    var banner_two : String?
    var banner_one : String?
    var banner_four_thumb : String?
    var login_template = false
    var referral_feature: String?
    var stripe_secret_key:String?
    var stripe_publish_key: String?
    var cart_image_upload: String?
    var order_instructions: String?
    var secondary_language: String?

    var app_banner_width: String? //0: full and 1: half
    var chat_enable: String?

    var app_selected_template: String?
    var search_by: String = "0"
    var login_icon_url : String? = ""
    
    
    var pickup_url_one: String?
    var pickup_url_two: String?
    var pickup_url_three: String?
    var delivery_url_one: String?
    var delivery_url_two: String?
    var delivery_url_three: String?
    
    var user_register_flow : String?
    var product_pdf_upload : String?
    var is_return_request : String?
    var pickup_url: UrlModalClass?
    var delivery_url: UrlModalClass?
    var delivery_charge_type: String?
    var is_app_sharing_message:String?
    var app_sharing_message:String?
    var show_prescription_requests: String?
    var show_home_screen_theme: String?
    var is_product_wishlist : String?
    var is_supplier_wishlist : String?
    
    var phone_registration_flag: String?
    
    var bypass_otp: String?
    var show_donate_popup: String = "0"
    var is_product_rating: String?
    var is_supplier_rating: String?
    var is_agent_rating: String?
    var is_health_theme: String?
    var app_custom_domain_theme: String?
    var custom_vertical_theme: String?
    public var signup_declaration: String?
    public var is_dark_mode_enabled: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        stripe_secret_key <- map["stripe_secret_key"]
        stripe_publish_key <- map["stripe_publish_key"]
        show_tags_for_suppliers <- map["show_tags_for_suppliers"]
        brandImage_url <- map["brandImage_url"]
        banner_one_thumb <- map["banner_one_thumb"]
        font_family <- map["font_family"]
        banner_four <- map["banner_four"]
        app_color <- map["app_color"]
        waiting_charges <- map["waiting_charges"]
        banner_two_thumb <- map["banner_two_thumb"]
        payment_method <- map["payment_method"]
        if payment_method == nil {
            var paymentMethod = 0
            paymentMethod <- map["payment_method"]
            payment_method = "\(paymentMethod)"
        }
        ios_app_url <- map["ios_app_url"]
        header_text_color <- map["header_text_color"]
        logo_thumb_url <- map["logo_thumb_url"]
        android_app_url <- map["android_app_url"]
        favicon_url <- map["favicon_url"]
        banner_thumb_url <- map["banner_thumb_url"]
        banner_url <- map["banner_url"]
        var terminologyStr: String = ""
        terminologyStr <- map["terminology"]
        if let dict = terminologyStr.convertToDictionary(){
            if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
                terminology = obj
            }
        }
        user_location <- map["user_location"]
        empty_cart <- map["empty_cart"]
        banner_three_thumb <- map["banner_three_thumb"]
        header_color <- map["header_color"]
        domain_name <- map["domain_name"]
        order_loader <- map["order_loader"]
        logo_url <- map["logo_url"]
        theme_color <- map["theme_color"]
        element_color <- map["element_color"]
        agent_ios_app_url <- map["agent_ios_app_url"]
        banner_three <- map["banner_three"]
        agent_android_app_url <- map["agent_android_app_url"]
        logo_background <- map["logo_background"]
        banner_two <- map["banner_two"]
        banner_one <- map["banner_one"]
        banner_four_thumb <- map["banner_four_thumb"]
        login_template <- map["login_template"]
        if let str = map.JSON["login_template"] as? String, str == "1" {
            login_template = true
        }
        referral_feature <- map["referral_feature"]
        cart_image_upload <- map["cart_image_upload"]
        order_instructions <- map["order_instructions"]
        secondary_language <- map["secondary_language"]
        app_selected_template <- map["app_selected_template"]
        user_register_flow <- map["user_register_flow"]

        app_banner_width <- map["app_banner_width"]
        chat_enable <- map["chat_enable"]
        is_product_rating <- map["is_product_rating"]
        is_supplier_rating <- map["is_supplier_rating"]
        is_agent_rating <- map["is_agent_rating"]

        login_icon_url <- map["login_icon_url"]
        if let dict = (/login_icon_url).convertToDictionary(){
            if let url = dict["app"] as? String {
                login_icon_url = url
            }
        }
        
        
        pickup_url_one <- map["pickup_url_one"]
        pickup_url_two <- map["pickup_url_two"]
        pickup_url_three <- map["pickup_url_three"]
        delivery_url_one <- map["delivery_url_one"]
        delivery_url_two <- map["delivery_url_two"]
        delivery_url_three <- map["delivery_url_three"]
        
        product_pdf_upload <- map["product_pdf_upload"]
        is_return_request <- map["is_return_request"]
        delivery_charge_type <- map["delivery_charge_type"]
        is_app_sharing_message <- map["is_app_sharing_message"]
        app_sharing_message <- map["app_sharing_message"]
        show_prescription_requests <- map["show_prescription_requests"]
        show_home_screen_theme <- map["show_home_screen_theme"]
        search_by <- map["search_by"]
        bypass_otp <- map["bypass_otp"]
        show_donate_popup <- map["show_donate_popup"]
        
        var pickupUrl: String = ""
        pickupUrl <- map["pickup_url"]
        if let dict = pickupUrl.convertToDictionary(){
            if let obj = Mapper<UrlModalClass>().map(JSONObject: dict) {
                pickup_url = obj
            }
        }
        var deliveryUrl: String = ""
        deliveryUrl <- map["delivery_url"]
        if let dict = deliveryUrl.convertToDictionary(){
            if let obj = Mapper<UrlModalClass>().map(JSONObject: dict) {
                delivery_url = obj
            }
        }
        
        is_product_wishlist <- map["is_product_wishlist"]
        is_supplier_wishlist <- map["is_supplier_wishlist"]

        is_health_theme <- map["is_health_theme"]
        app_custom_domain_theme <- map["app_custom_domain_theme"]
        custom_vertical_theme <- map["custom_vertical_theme"]
        signup_declaration <- map["signup_declaration"]
        is_dark_mode_enabled <- map["is_dark_mode_enabled"]

        phone_registration_flag <- map["phone_registration_flag"]
    }

}

//extension Map {
//    func getIntervalToDate(key: String, date:Date?) -> Date? {
//
//        if mappingType == .toJSON {
//            var date: Double? = date?.timeMilliSecondsSince1970
//            date <- self[key]
//            return nil
//        } else {
//            var date: Double?
//            date <- self[key]
//            if /date < 100 {
//                return nil
//            }
//            return date?.toDate()
//        }
//    }
//
//    func getValue(key: String, value:String?) -> String? {
//
//        var str: String? = value
//        str <- self[key]
//        return str
//    }
//}


