//
//  User.swift
//  Clikat
//
//  Created by cblmacmini on 5/18/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON
enum UserKeys : String {
    case user_created_id = "user_created_id"

    case id = "id"
    case accessToken = "access_token"
    case email = "email"
    case user_image = "user_image"
    case firstname = "firstname"
    case mobile_no = "mobile_no"
    case otp_verified = "otp_verified"
    case facebookToken = "facebookToken"
    case lastName = "last_name"
    case referral_id = "referral_id"
    case receive_price = "receive_price"
    case customer_payment_id = "customer_payment_id"
    case apple_id
}

class User: NSObject,NSCoding {
    
    var id : String?
    var token : String?
    var email : String?
    var userImage : String?
    var firstName : String?
    var mobileNo : String?
    var otpVerified : String?
    var fbId : String?
    var last_name:String?
    var countryCode : String?
    var referral_id : String?
    var receive_price: Float?
    var user_created_id : String?
    var customer_payment_id : String?
    var appleId: String?
    
    init(attributes : SwiftyJSONParameter) {
        super.init()
        self.user_created_id = attributes?["user_created_id"]?.stringValue

        self.last_name = attributes?[UserKeys.lastName.rawValue]?.stringValue
        self.id = attributes?[UserKeys.id.rawValue]?.stringValue
        self.token = attributes?[UserKeys.accessToken.rawValue]?.stringValue
        self.email = attributes?[UserKeys.email.rawValue]?.stringValue
        self.userImage = attributes?[UserKeys.user_image.rawValue]?.stringValue
        self.firstName = attributes?[UserKeys.firstname.rawValue]?.stringValue
        if self.firstName == nil || self.firstName == "" {
            self.firstName = attributes?["first_name"]?.stringValue
        }
        self.mobileNo = attributes?[UserKeys.mobile_no.rawValue]?.stringValue
        self.otpVerified = attributes?[UserKeys.otp_verified.rawValue]?.stringValue
        self.referral_id = attributes?[UserKeys.referral_id.rawValue]?.stringValue
        self.receive_price = attributes?[UserKeys.receive_price.rawValue]?.floatValue
        self.customer_payment_id = attributes?[UserKeys.customer_payment_id.rawValue]?.stringValue
        self.appleId = attributes?[UserKeys.apple_id.rawValue]?.stringValue
    }
    
    init(attributes : SwiftyJSONParameter,params : OptionalDictionary) {
        super.init()
        self.user_created_id = UserKeys.user_created_id.rawValue => attributes

        self.id = UserKeys.id.rawValue => attributes
        self.id = attributes?[UserKeys.id.rawValue]?.stringValue
        self.token = attributes?[UserKeys.accessToken.rawValue]?.stringValue
        self.email = attributes?[UserKeys.email.rawValue]?.stringValue
        self.userImage = attributes?[UserKeys.user_image.rawValue]?.stringValue
        self.firstName = attributes?[UserKeys.firstname.rawValue]?.stringValue
        if self.firstName == nil || self.firstName == "" {
            self.firstName = attributes?["first_name"]?.stringValue
        }
        self.mobileNo = attributes?[UserKeys.mobile_no.rawValue]?.stringValue
        self.otpVerified = attributes?[UserKeys.otp_verified.rawValue]?.stringValue
        self.fbId = params?[UserKeys.facebookToken.rawValue] as? String
        self.last_name = attributes?[UserKeys.lastName.rawValue]?.stringValue
        self.referral_id = attributes?[UserKeys.referral_id.rawValue]?.stringValue
        self.receive_price = attributes?[UserKeys.receive_price.rawValue]?.floatValue
        self.customer_payment_id = attributes?[UserKeys.customer_payment_id.rawValue]?.stringValue
        self.appleId = attributes?[UserKeys.apple_id.rawValue]?.stringValue
        print(self.id|)
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(user_created_id, forKey: "user_created_id")

        aCoder.encode(referral_id, forKey: "referral_id")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(userImage, forKey: "userImage")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(mobileNo, forKey: "mobileNo")
        aCoder.encode(otpVerified, forKey: "otpVerified")
        aCoder.encode(fbId, forKey: "fbId")
        aCoder.encode(customer_payment_id, forKey: "customer_payment_id")
        aCoder.encode(appleId, forKey: "apple_id")
    }
    
    required init(coder aDecoder: NSCoder) {
        user_created_id = aDecoder.decodeObject(forKey: "user_created_id") as? String

        referral_id = aDecoder.decodeObject(forKey: "referral_id") as? String
        last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        userImage = aDecoder.decodeObject(forKey: "userImage") as? String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        mobileNo = aDecoder.decodeObject(forKey: "mobileNo") as? String
        otpVerified = aDecoder.decodeObject(forKey: "otpVerified") as? String
        fbId = aDecoder.decodeObject(forKey: "fbId") as? String
        customer_payment_id = aDecoder.decodeObject(forKey: "customer_payment_id") as? String
        appleId = aDecoder.decodeObject(forKey: "apple_id") as? String
    }
    
    class func validateChangePassword(passwords : [String]?) -> String?{
        guard let tempArr = passwords else { return nil }
        for str in tempArr {
            if str.isEmpty {
                return L10n.PleaseFillAllDetails.string
            }
        }
        let old = /passwords?[0]
        let new = /passwords?[1]
        let confirm = /passwords?[2]
        
        if old == new {
            return L10n.NewPasswordMustNotBeSameAsOldPassword.string
        } else if new.count < 6 {
         return L10n.PasswordShouldBeMinimum6Characters.string
        } else if new != confirm {
            return L10n.PasswordsDoNotMatch.string
        }
        return ""
    }
    
}

precedencegroup ComparisonPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator => : ComparisonPrecedence
infix operator =| : ComparisonPrecedence


func =>(key : String, json : Dictionary<String, JSON>?) -> String?{
    return json?[key]?.stringValue
}
func =|(key : String, json : Dictionary<String, JSON>?) -> [JSON]?{
    return json?[key]?.arrayValue
}

postfix operator |
postfix func |(value : String?) -> String {
    return value.unwrap()
}

class AgentCode : Codable {
    
    var data : AgentCodeNewData?
    
    init(attributes : SwiftyJSONParameter){
        let tempDict = attributes?["data"]?.dictionaryValue
        self.data = AgentCodeNewData(attributes: tempDict)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
    }
    
    required init(coder aDecoder: NSCoder) {
        data = aDecoder.decodeObject(forKey: "data") as? AgentCodeNewData
    }
    
}

class AgentCodeNewData:Codable {
    
    var data : [AgentCodeData]?
    var currency : [CurrencyData]?
    var featureData : [FeatureDataModal]?
    var settingsData : SettingsData?
    
    init(attributes : SwiftyJSONParameter){
        
        let tempArr = attributes?["data"]?.arrayValue ?? []
        data = []
        for product in tempArr {
            data?.append(AgentCodeData(attributes: product.dictionaryValue))
        }
        
        let currencyArr = attributes?["currency"]?.arrayValue ?? []
        currency = []
        for product in currencyArr {
            currency?.append(CurrencyData(attributes: product.dictionaryValue))
        }
        
        let featureArr = attributes?["featureData"]?.arrayValue ?? []
        featureData = []
        for product in featureArr {
            featureData?.append(FeatureDataModal(attributes: product.dictionaryValue))
        }
        
        let tempDict = attributes?["settingsData"]?.dictionaryValue
        settingsData = SettingsData(attributes: tempDict)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(data, forKey: "data")
        aCoder.encode(currency, forKey: "currency")
        aCoder.encode(featureData, forKey: "featureData")
        aCoder.encode(settingsData, forKey: "settingsData")
    }
    
    required init(coder aDecoder: NSCoder) {
        data = aDecoder.decodeObject(forKey: "data") as? [AgentCodeData]
        currency = aDecoder.decodeObject(forKey: "currency") as? [CurrencyData]
        featureData = aDecoder.decodeObject(forKey: "featureData") as? [FeatureDataModal]
        settingsData = aDecoder.decodeObject(forKey: "settingsData") as? SettingsData
    }
    
}

class FeatureDataModal: Codable {
    
    var name: String?
    var id: Int?
    var customer_feature_id: Int?
    var type_name: String?
    var type_id: Int?
    var is_active : Int?
    var key_value: [KeyValueModal]?
    var key_value_front: [KeyValueFrontModal]?

    init(attributes : SwiftyJSONParameter){
        
        name = attributes?["name"]?.stringValue ?? ""
        id = attributes?["id"]?.intValue ?? 0
        customer_feature_id = attributes?["customer_feature_id"]?.intValue ?? 0
        type_name = attributes?["type_name"]?.stringValue ?? ""
        type_id = attributes?["type_id"]?.intValue ?? 0
        is_active = attributes?["is_active"]?.intValue ?? 0

        let keyValueArray = attributes?["key_value"]?.arrayValue ?? []
        key_value = []
        for product in keyValueArray {
            key_value?.append(KeyValueModal(attributes: product.dictionaryValue))
        }
        
        let keyValueFrontArray = attributes?["key_value_front"]?.arrayValue ?? []
        key_value_front = []
        for product in keyValueFrontArray {
            key_value_front?.append(KeyValueFrontModal(attributes: product.dictionaryValue))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(customer_feature_id, forKey: "customer_feature_id")
        aCoder.encode(type_name, forKey: "type_name")
        aCoder.encode(type_id, forKey: "type_id")
        aCoder.encode(is_active, forKey: "is_active")
        aCoder.encode(key_value, forKey: "key_value")
        aCoder.encode(key_value_front, forKey: "key_value_front")

    }
    
    required init(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        customer_feature_id = aDecoder.decodeObject(forKey: "customer_feature_id") as? Int
        type_name = aDecoder.decodeObject(forKey: "type_name") as? String
        type_id = aDecoder.decodeObject(forKey: "type_id") as? Int
        is_active = aDecoder.decodeObject(forKey: "is_active") as? Int
        key_value = aDecoder.decodeObject(forKey: "key_value") as? [KeyValueModal]
        key_value_front = aDecoder.decodeObject(forKey: "key_value_front") as? [KeyValueFrontModal]

    }
    
}

class KeyValueModal: Codable {
    
    var value: String?
    var for_front: Int?
    var key: String?
    
    init(attributes : SwiftyJSONParameter){
        
        value = attributes?["value"]?.stringValue ?? ""
        for_front = attributes?["for_front"]?.intValue ?? 0
        key = attributes?["key"]?.stringValue ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(value, forKey: "value")
        aCoder.encode(for_front, forKey: "for_front")
        aCoder.encode(key, forKey: "key")
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as? String
        for_front = aDecoder.decodeObject(forKey: "for_front") as? Int
        key = aDecoder.decodeObject(forKey: "key") as? String

    }
    
}

class KeyValueFrontModal: Codable {
    
    var for_front: Int?
    var key: String?
    var value: String?
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var customer_feature_id: Int?

    init(attributes : SwiftyJSONParameter){
        
        for_front = attributes?["for_front"]?.intValue ?? 0
        key = attributes?["key"]?.stringValue ?? ""
        value = attributes?["value"]?.stringValue ?? ""
        id = attributes?["id"]?.intValue ?? 0
        created_at = attributes?["created_at"]?.stringValue ?? ""
        updated_at = attributes?["updated_at"]?.stringValue ?? ""
        customer_feature_id = attributes?["customer_feature_id"]?.intValue ?? 0
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(value, forKey: "value")
        aCoder.encode(for_front, forKey: "for_front")
        aCoder.encode(key, forKey: "key")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(created_at, forKey: "created_at")
        aCoder.encode(updated_at, forKey: "updated_at")
        aCoder.encode(customer_feature_id, forKey: "customer_feature_id")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as? String
        for_front = aDecoder.decodeObject(forKey: "for_front") as? Int
        key = aDecoder.decodeObject(forKey: "key") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        created_at = aDecoder.decodeObject(forKey: "created_at") as? String
        updated_at = aDecoder.decodeObject(forKey: "updated_at") as? String
        customer_feature_id = aDecoder.decodeObject(forKey: "customer_feature_id") as? Int

    }
    
}

class CurrencyData : Codable {
    
    var currency_description: String?
    var id: Int?
    var currency_symbol: String?
    var conversion_rate : Int?
    var currency_name : String?

    init(attributes : SwiftyJSONParameter){
        
        guard let data = attributes else { return }
        
        currency_description = data["currency_description"]?.stringValue ?? ""
        id = data["id"]?.intValue ?? 0
        conversion_rate = data["conversion_rate"]?.intValue ?? 0
        currency_symbol = data["currency_symbol"]?.stringValue ?? ""
        currency_name = data["currency_name"]?.stringValue ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currency_description, forKey: "currency_description")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(currency_symbol, forKey: "currency_symbol")
        aCoder.encode(conversion_rate, forKey: "conversion_rate")
        aCoder.encode(currency_name, forKey: "currency_name")

    }
    
    required init(coder aDecoder: NSCoder) {
        currency_description = aDecoder.decodeObject(forKey: "currency_description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        currency_symbol = aDecoder.decodeObject(forKey: "currency_symbol") as? String
        conversion_rate = aDecoder.decodeObject(forKey: "conversion_rate") as? Int
        currency_name = aDecoder.decodeObject(forKey: "currency_name") as? String

    }
}

class SettingsData: Codable{
    var user_service_fee: String?
    var email:String?
    var referral_given_price:String?
    var referral_receive_price:String?
    
    init(attributes : SwiftyJSONParameter){
       user_service_fee = attributes?["user_service_fee"]?.stringValue ?? ""
        email = attributes?["email"]?.stringValue ?? ""
        referral_given_price = attributes?["referral_given_price"]?.stringValue ?? ""
        referral_receive_price = attributes?["referral_receive_price"]?.stringValue ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(user_service_fee, forKey: "user_service_fee")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(referral_given_price, forKey: "referral_given_price")
        aCoder.encode(referral_receive_price, forKey: "referral_receive_price")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        user_service_fee = aDecoder.decodeObject(forKey: "user_service_fee") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
referral_given_price = aDecoder.decodeObject(forKey: "referral_given_price") as? String
        referral_receive_price = aDecoder.decodeObject(forKey: "referral_receive_price") as? String
    }
    
}

class AgentCodeData: Codable {
    
    var uniqueId: String?
    var app_type: Int?
    var business_name: String?
    var name : String?
    var id: Int?
    var cbl_customer_domains: [CblCustomerDomains]?
    
    init(attributes : SwiftyJSONParameter){
        
        id = attributes?["id"]?.intValue ?? 0
        uniqueId = attributes?["uniqueId"]?.stringValue ?? ""
        app_type = attributes?["app_type"]?.intValue ?? 0
        business_name = attributes?["business_name"]?.stringValue ?? ""
        name = attributes?["name"]?.stringValue ?? ""

        let tempArr = attributes?["cbl_customer_domains"]?.arrayValue ?? []
        cbl_customer_domains = []
        for product in tempArr {
            cbl_customer_domains?.append(CblCustomerDomains(attributes: product.dictionaryValue))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(uniqueId, forKey: "uniqueId")
        aCoder.encode(cbl_customer_domains, forKey: "cbl_customer_domains")

    }
    
    required init(coder aDecoder: NSCoder) {
        uniqueId = aDecoder.decodeObject(forKey: "uniqueId") as? String
        cbl_customer_domains = aDecoder.decodeObject(forKey: "cbl_customer_domains") as? [CblCustomerDomains]
    }
}

class CblCustomerDomains : Codable {
    
    var db_secret_key : String?
    var agent_db_secret_key: String?
    var admin_domain : String?
    var supplier_domain : String?
    var site_domain : String?
    var client_secret_key: String?
    var logo_image:String?
    
    init(attributes : SwiftyJSONParameter){
        
        logo_image = attributes?["logo_image"]?.stringValue ?? ""

        db_secret_key = attributes?["db_secret_key"]?.stringValue ?? ""
        agent_db_secret_key = attributes?["agent_db_secret_key"]?.stringValue ?? ""
        admin_domain = attributes?["admin_domain"]?.stringValue ?? ""
        supplier_domain = attributes?["supplier_domain"]?.stringValue ?? ""
        site_domain = attributes?["site_domain"]?.stringValue ?? ""
        client_secret_key = attributes?["client_secret_key"]?.stringValue ?? ""

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(logo_image, forKey: "logo_image")

        aCoder.encode(db_secret_key, forKey: "db_secret_key")
        aCoder.encode(agent_db_secret_key, forKey: "agent_db_secret_key")
        aCoder.encode(admin_domain, forKey: "admin_domain")
        aCoder.encode(supplier_domain, forKey: "supplier_domain")
        aCoder.encode(site_domain, forKey: "site_domain")
        aCoder.encode(client_secret_key, forKey: "client_secret_key")

    }
    
    required init(coder aDecoder: NSCoder) {
        logo_image = aDecoder.decodeObject(forKey: "logo_image") as? String

        db_secret_key = aDecoder.decodeObject(forKey: "db_secret_key") as? String
        agent_db_secret_key = aDecoder.decodeObject(forKey: "agent_db_secret_key") as? String
        admin_domain = aDecoder.decodeObject(forKey: "admin_domain") as? String
        supplier_domain = aDecoder.decodeObject(forKey: "supplier_domain") as? String
        site_domain = aDecoder.decodeObject(forKey: "site_domain") as? String
        client_secret_key = aDecoder.decodeObject(forKey: "client_secret_key") as? String

    }

}
