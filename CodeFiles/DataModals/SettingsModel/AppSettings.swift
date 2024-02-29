//
//  AppSettings.swift
//  Sneni
//
//  Created by MAc_mini on 11/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum SettingKeys : String {
    
    case dialogToken = "dialog_token"
    case bookingFlow = "bookingFlow"
    case screenFlow = "screenFlow"
    case settingData = "settingData"
    case default_category
    case key_value
    case supplier_id
    case supplier_branch_id

}

class ApiSucessData <T: Mappable>: Mappable {
    
    var message: String?
    var object: T?
    var array : [T]?
    var statusCode: Int?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        message <- map["msg"]
        object <- map["data"]
        array <- map["data"]
        statusCode <- map["statusCode"]
    }
    
}

class AppSettings : NSObject , Mappable {

    static var shared: AppSettings = AppSettings()
    
    var supplier_id: Int?
    var defaultAddress : [DefaultAddress]?
    var supplier_branch_id:Int?
    var arrayBookingFlow : [BookingFlow]?
    var dialogToken : String?
    var arrayScreenFlow : [ScreenFlow]?
    var arrayDefaultCategory : [DefaultCategotyFlow]?
    var appThemeData : AppThemeData?
    var showReferral: Bool {
        return appThemeData?.referral_feature == "1"
    }
    var showChangeLanguage: Bool {
        if (appThemeData?.secondary_language ?? "") == "ar" || (appThemeData?.secondary_language ?? "") == "es" || (appThemeData?.secondary_language ?? "") == "SQ" || (appThemeData?.secondary_language ?? "") == "sq" {
            return true
        }
        return false
    }
    var showPrescriptionRequests: Bool {
        return (appThemeData?.show_prescription_requests ?? "") == "1"
    }
    var app_type : Int {
        return arrayScreenFlow?.first?.app_type ?? 0
    }
    var halfWidthBanner: Bool {
        return appThemeData?.app_banner_width == "1" //0: full and 1: half
    }
    var isSingleProduct: Bool {
        return SKAppType.type == .home
    }
    
    var appType : Int? {
        //Nitin
      //  return arrayScreenFlow?.first?.type ?? 1
        get {
            guard let mode = UserDefaults.standard.object(forKey: APIConstants.modeKey) as? Int else {return arrayScreenFlow?.first?.app_type ?? 1}
            return mode

        } set {

            if let value = newValue {
                UserDefaults.standard.set(value, forKey: APIConstants.modeKey)
                UserDefaults.standard.synchronize()
            }else{
                UserDefaults.standard.removeObject(forKey:  APIConstants.modeKey)
            }
        }

    }
    
    var cartImageUpload : Bool {
        get {
            if app_type > 10 { // for doctor app return saved from category
                if let bool = UserDefaults.standard.object(forKey: "cartImageUpload") as? Bool {
                    return bool
                }
            }
            else {
                return AppSettings.shared.appThemeData?.cart_image_upload == "1"
            }
            return false
            
        } set {
            UserDefaults.standard.set(newValue, forKey: "cartImageUpload")
            UserDefaults.standard.synchronize()
        }
    }
    
    var orderInstructions : Bool {
        get {
            if app_type > 10 { // for doctor app return saved from category
                if let bool = UserDefaults.standard.object(forKey: "orderInstructions") as? Bool {
                    return bool
                }
            }
            else {
                return AppSettings.shared.appThemeData?.order_instructions == "1"
            }
            return false
            
        } set {
            UserDefaults.standard.set(newValue, forKey: "orderInstructions")
            UserDefaults.standard.synchronize()
        }
    }
    
    var selectedCategoryId: String?
    
    
// askLocationDone
//Nitin
    var supplierId: Int {
        return supplier_id ?? 0
    }

    var isPickupOrder:Int {
        return /arrayBookingFlow?[0].is_pickup_order
    }

    var botChatToken : String {
        return /dialogToken
    }

    var isFoodApp : Bool {
        return arrayScreenFlow?.first?.isFoodApp ?? false
    }

    //Nitin
    var isSingleVendor :Bool {
        return arrayScreenFlow?.first?.isSingleVendor ?? false
    }

    var is_scheduled : Int {
        return arrayBookingFlow?.first?.is_scheduled ?? 0
    }

    var schedule_time : Int {
        return arrayBookingFlow?.first?.schedule_time ?? 0
    }

    var vendorStatus: VendorStatusSettingType {
        let v = VendorStatusSettingType(rawValue: /arrayBookingFlow?.first?.vendorStatus)
        return .one//v ?? .one
    }

    var cartFlow : CartFlowSettingType {
        let v = CartFlowSettingType(rawValue: /arrayBookingFlow?.first?.cartFlow)
        return v ?? .oneToOne
    }

    var intervalServiceHourly: Double {
        return Double(arrayBookingFlow?.first?.interval ?? 1)
    }
    
    
    var isScheduled: Bool {
        return arrayBookingFlow?.first?.is_scheduled == 1
    }
    
    
    override init() {
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        supplier_id <- map["supplier_id"]
        supplier_branch_id <- map["supplier_branch_id"]
        arrayBookingFlow <- map["bookingFlow"]
        dialogToken <- map["dialog_token"]
        arrayScreenFlow <- map["screenFlow"]
        arrayDefaultCategory <- map["default_category"]
        appThemeData <- map["key_value"]
        defaultAddress <- map["default_address"]

    }
    
//    init(sender : SwiftyJSONParameter){
//
//        guard let rawData = sender else { return }
//        let json = JSON(rawData)
//
//        let dict = json[APIConstants.DataKey]
//
//        supplier_id = dict[SettingKeys.supplier_id.rawValue].intValue
//        supplier_branch_id = dict[SettingKeys.supplier_branch_id.rawValue].intValue
//        key_value = dict[SettingKeys.key_value.rawValue].dictionaryObject
//        dialogToken = dict[SettingKeys.dialogToken.rawValue].string
//
//        let arrBookingFlow = dict[SettingKeys.bookingFlow.rawValue].arrayValue
//        let arrScreenFlow = dict[SettingKeys.screenFlow.rawValue].arrayValue
//        let defaultFlow = dict[SettingKeys.default_category.rawValue].arrayValue
//
//        arrayBookingFlow = []
//        arrayScreenFlow = []
//        arrayDefaultCategory = []
//
//        for (_ , element) in arrBookingFlow.enumerated(){
//             let bookingFlow = BookingFlow(attributes: element.dictionaryValue)
//             arrayBookingFlow?.append(bookingFlow)
//        }
//
//        for (_ , element) in arrScreenFlow.enumerated(){
//            let screenFlow = ScreenFlow(attributes: element.dictionaryValue)
//              arrayScreenFlow?.append(screenFlow)
//        }
//
//        for (_ , element) in defaultFlow.enumerated(){
//            let screenFlow = DefaultCategotyFlow(attributes: element.dictionaryValue)
//            arrayDefaultCategory?.append(screenFlow)
//        }
//    }
//
//    func encode(with aCoder: NSCoder) {
//
//        aCoder.encode(key_value, forKey: "key_value")
//
//        aCoder.encode(supplier_id, forKey: "supplier_id")
//        aCoder.encode(supplier_branch_id, forKey: "supplier_branch_id")
//
//        aCoder.encode(arrayBookingFlow, forKey: "arrayBookingFlow")
//        aCoder.encode(arrayScreenFlow, forKey: "arrayscreenFlow")
//        aCoder.encode(dialogToken, forKey: SettingKeys.dialogToken.rawValue)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//
//        key_value = aDecoder.decodeObject(forKey: SettingKeys.key_value.rawValue) as?  Dictionary<String,Any>
//        arrayBookingFlow = aDecoder.decodeObject(forKey: "arrayBookingFlow") as? [BookingFlow]
//        arrayScreenFlow = aDecoder.decodeObject(forKey: "arrayscreenFlow") as? [ScreenFlow]
//        dialogToken = aDecoder.decodeObject(forKey: SettingKeys.dialogToken.rawValue) as? String
//        supplier_id = aDecoder.decodeObject(forKey: "supplier_id") as? Int
//        supplier_branch_id = aDecoder.decodeObject(forKey: "supplier_branch_id") as? Int
//
//    }
    
//    func returnValueForKey(keyValue:String) -> String? {
//        
//        guard let dict = self.key_value else { return nil }
//        var newKeyValue = ""
//        for (key,value) in dict {
//            if key == keyValue {
//                guard let newValue = value as? String else {return nil}
//                newKeyValue = newValue
//                break
//            }
//        }
//        return newKeyValue
//    }
//    
//    func returnKeys() -> [String] {
//        
//        var keyArray = [String]()
//        
//        guard let dict = self.key_value else { return [] }
//        for (key,_) in dict {
//            keyArray.append(key)
//        }
//        return keyArray
//    }
}
