//
//  AppSettingModel.swift
//  RoyoRide
//
//  Created by Ankush on 11/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//


import Foundation
import ObjectMapper


class AppSettingModel: Mappable {
    
    var appSettings : Settings?
    var walk_through: [Walkthrough]?
    var registration_forum: RegisterForm?
    var level_values : [LevelValues]?
    var services : [Service]?
    var languages: [LanguagesModel]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appSettings <- map["key_value"]
        walk_through <- map["walk_through"]
        registration_forum <- map["registration_forum"]
        level_values <- map["level_values"]
        services <- map["services"]
        languages <- map["languages"]
    }
    
}

class LanguagesModel: Mappable {
    var language_code: String?
    var language_id: Int?
    var language_name: String?
    var sort_order: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        language_code <- map["language_code"]
        language_id <- map["language_id"]
        language_name <- map["language_name"]
        sort_order <- map["sort_order"]
    }
}



class Settings: Mappable {
    
    var default_country_code : String?
    var app_color_code: String?
    var iso_code: String?
    var Secondary_Btn_Colour: String?
    var app_template: String?
    var secondary_colour: String?
    var Secondary_Btn_Text_colour: String?
    var header_colour: String?
    var heder_txt_colour: String?
    var Btn_Text_Colour: String?
    var Primary_colour: String?
    var is_booking_fee: Bool?
    var is_distance: String?
    var is_level_charge: String?
    var is_load_unload_charge: String?
    var is_time: String?
    var is_waiting: Bool?
    var stripe_public_key:String?
    var stripe_secret_key:String?
    var conekta_api_key:String?
    var gateway_unique_id:String?
    var currency:String?
    var surCharge: String?
    var surChargePercentage: String?
    var is_wallet: String?
    var isChatEnable:Bool? = true
    var is_refer_and_earn: String?
    var level_percentage:String?
    var elevator_percentage:String?
    var razorpaytestkey: String?

    var schedule_ride:String?
    var schedule_fee:String?
    var ios_google_key:String?
    var user_otp_check:String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        user_otp_check <- map["user_otp_check"]
        ios_google_key <- map["ios_google_api"]
        schedule_fee <- map["schedule_fee"]
        schedule_ride <- map["schedule_ride"]
        conekta_api_key <- map["conketa_public_key"]
        isChatEnable <- map["is_chat"]
        default_country_code <- map["default_country_code"]
        app_color_code <- map["app_color_code"]
        iso_code <- map["iso_code"]
        
        level_percentage <- map["level_percentage"]
        elevator_percentage <- map["elevator_percentage"]
        
        Secondary_Btn_Colour <- map["Secondary_Btn_Colour"]
        app_template <- map["app_template"]
        secondary_colour <- map["secondary_colour"]
        
        Secondary_Btn_Text_colour <- map["Secondary_Btn_Text_colour"]
        header_colour <- map["header_colour"]
        heder_txt_colour <- map["heder_txt_colour"]
        
        Btn_Text_Colour <- map["Btn_Text_Colour"]
        Primary_colour <- map["Primary_colour"]
        currency <- map["currency_symbol"]
        is_booking_fee <- map["is_booking_fee"]
        is_distance <- map["is_distance"]
        is_level_charge <- map["is_level_charge"]
        is_load_unload_charge <- map["is_load_unload_charge"]
        is_time <- map["is_time"]
        is_waiting <- map["is_waiting"]
        stripe_secret_key <- map["stripe_secret_key"]
        stripe_public_key <- map["stripe_public_key"]
        gateway_unique_id <- map["gateway_unique_id"]
        surCharge <- map["surCharge"]
        surChargePercentage <- map["surChargePercentage"]
        is_wallet <- map["is_wallet"]
        is_refer_and_earn <- map["is_refer_and_earn"]
        razorpaytestkey <- map["razorpaytestkey"]
    }
}


class Walkthrough: Mappable {
    
    var image_url : String?
    var key_name: String?
    var value: String?
    var description: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image_url <- map["image_url"]
        key_name <- map["key_name"]
        value <- map["value"]
        description <- map["description"]
    }
    
}


class RegisterForm: Mappable {
    
    var gender : String?
    var drop_level: String?
    var pickup_level: String?
    var elevator_pickup: String?
    var elevator_dropoff: String?
    var email: String?
    var template: String?
    var form_details: [FromDetails]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        gender <- map["gender"]
        drop_level <- map["drop_level"]
        pickup_level <- map["pickup_level"]
        elevator_pickup <- map["elevator_pickup"]
        elevator_dropoff <- map["elevator_dropoff"]
        email <- map["email"]
        template <- map["template"]
    }
    
}


class LevelValues: NSObject, Mappable {
    var level_id: Int?
    var created_at: String?
    var level_value: String?
    var blocked: String?
    var is_default: String?
    var updated_at: String?

    
    init(level_id: Int?, created_at: String?, level_value: String?, blocked: String?, is_default: String?, updated_at: String?) {
        self.level_id = level_id
        self.created_at = created_at
        self.level_value = level_value
        self.blocked = blocked
        self.is_default = is_default
        self.updated_at = updated_at
    }
    
    
    
    required init?(map: Map) {
          
    }
    
    
    
    func mapping(map: Map) {
        level_id <- map["level_id"]
        created_at <- map["created_at"]
        level_value <- map["level_value"]
        blocked <- map["blocked"]
        is_default <- map["updated_at"]
    }
}



class FromDetails: Mappable {
    var blocked: Int?
    var created_at: String?
    var description: String?
    var expiry_date: String?
    var id: String?
    var image: String?
    var key_name: String?
    var optional: Int?
    var required: String?
    var terminology: String?
    var updated_at: String?
    var value: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        blocked <- map["blocked"]
        created_at <- map["created_at"]
        description <- map["description"]
        expiry_date <- map["expiry_date"]
        id <- map["id"]
        image <- map["image"]
        key_name <- map["key_name"]
        optional <- map["optional"]
        required <- map["required"]
        terminology <- map["terminology"]
        updated_at <- map["updated_at"]
        value <- map["value"]
    }
}
