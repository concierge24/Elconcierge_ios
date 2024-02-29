//
//  GDataSingleton.swift
//  Real Estate
//
//  Created by Gagan on 08/04/15.
//  Copyright (c) 2015 Gagan. All rights reserved.
//

import Foundation
import ObjectMapper
import SupportSDK
import ZendeskCoreSDK

enum SingletonKeys : String {
    case Home = "ClikatHome"
    case User = "ClikatUser"
    case SupplierId = "ClikatSupplierId"
    case supplier = "ClikatSupplier"
    case PickupDate = "ClikatPickupDate"
    case PickupAddress = "ClikatPickupAddress"
    case PickupAddressId = "ClikatPickupAddressID"
    case DeviceToken = "ClikatDeviceToken"
    case ShowPopUp = "ClikatShowPopUp"
    case categoryId = "ClikatCategoryId"
    case settingApp = "SettingApp"
    case autoSearched = "autoSearched"
    case agentDbKey = "agentDbKey"
    case onBoardingDone = "onBoardingDone"
    case deliveryType = "DeliveryType"
    //Nitin
    case fcmToken = "fcmToken"
    case askLocationDone = "askLocationDone"
    case isFacebookLogin = "isFacebookLogin"
    case cartAppType
//    case element_color
//    case theme_color
//    case font_family
//    case header_color
//    case header_text_color
//    case logo_background
//    case terminology
//    case terminologyEnglish
//    case terminologyOther
    case profilePicDone
    case fromCart
    case agentUniqueId
    case termsAndConditions
    case tipAmount
    case userId
    case customerPaymentId
}

class GDataSingleton {
    
    static let sharedInstance = GDataSingleton()
    
    static var isOnBoardingDone: Bool {
        get {
            return /(UserDefaults.standard.value(forKey: SingletonKeys.onBoardingDone.rawValue) as? Bool)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: SingletonKeys.onBoardingDone.rawValue)
            defaults.synchronize()
        }
    }
    
    static var isAskLocationDone: Bool {
        get {
            return /(UserDefaults.standard.value(forKey: SingletonKeys.askLocationDone.rawValue) as? Bool)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: SingletonKeys.askLocationDone.rawValue)
            defaults.synchronize()
        }
    }
    
    static var isProfilePicDone: Bool {
        get {
            return /(UserDefaults.standard.value(forKey: SingletonKeys.profilePicDone.rawValue) as? Bool)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: SingletonKeys.profilePicDone.rawValue)
            defaults.synchronize()
        }
    }

    var zendeskEnabled = false
    
    var languageId : String {
        if /homeData?.arrayLanguages?.count > 0 {
           // return homeData?.arrayLanguages?[L102Language.currentAppleLanguage() == Languages.English ? 0 : 1].id ?? "14"
            return homeData?.arrayLanguages?[L102Language.kapilAppleLanguage() == Languages.English ? 0 : 1].id ?? "14"
        }else {
            return L102Language.kapilAppleLanguage() == Languages.English ? "14" : "15"
        }
        
    }

    var languageEnId : String {
        return homeData?.arrayLanguages?[0].id ?? ""
    }
    
    var languageArId : String {
        return homeData?.arrayLanguages?[1].id ?? ""
    }
    
    static var agentUniqueId: String {
        get {
            return /(UserDefaults.standard.value(forKey: SingletonKeys.agentUniqueId.rawValue) as? String)
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: SingletonKeys.agentUniqueId.rawValue)
            defaults.synchronize()
        }
    }

    var appSettingsData : AppSettings? {
        get{
            if AppSettings.shared.appThemeData != nil {
                return AppSettings.shared
            }
            var appSettings : AppSettings?
            if let userString = UserDefaults.standard.object(forKey: SingletonKeys.settingApp.rawValue) as? String {
                let userJson = Mapper<AppSettings>.parseJSONStringIntoDictionary(JSONString: userString)
                appSettings = Mapper<AppSettings>().map(JSON: userJson ?? [:])
            }
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.settingApp.rawValue) as? AppSettings{
//                appSettings = data
//            }
            return appSettings
        }
        set{
            AppSettings.shared = newValue ?? AppSettings()
            let defaults = UserDefaults.standard
            if let value = newValue{
                let userString = /(value.toJSONString())
                UserDefaults.standard.set(userString, forKey: SingletonKeys.settingApp.rawValue)
                //defaults.rm_setCustomObject(value, forKey: SingletonKeys.settingApp.rawValue)
            }
            else{
                defaults.removeObject(forKey: SingletonKeys.settingApp.rawValue)
            }
            defaults.synchronize()
        }
    }
//
//    var terminology : TerminologyModalClass? {
//        get {
//            var terms : TerminologyModalClass?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.terminology.rawValue) as? Data{
//                if let decodedItem = NSKeyedUnarchiver.unarchiveObject(with: data) as? TerminologyModalClass {
//                    terms = decodedItem
//                }
//            }
//            return terms
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                let encodedData = NSKeyedArchiver.archivedData(withRootObject: value)
//                defaults.rm_setCustomObject(encodedData, forKey: SingletonKeys.terminology.rawValue)
//
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.terminology.rawValue)
//            }
//            defaults.synchronize()
//        }
//
//    }
    
//    var terminologyEnglishStatus : Dictionary<String,Any>? {
//        get {
//            var terms : Dictionary<String,Any>?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.terminologyEnglish.rawValue) as? Dictionary<String,Any>{
//                terms = data
//            }
//            return terms
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.terminologyEnglish.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.terminologyEnglish.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
    
    var supplierAddress : String? {
        get {
            var terms : String?
            if let data = UserDefaults.standard.rm_customObject(forKey: "supplierAddress") as? String{
                terms = data
            }
            return terms
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "supplierAddress")
            } else{
                defaults.removeObject(forKey: "supplierAddress")
            }
            defaults.synchronize()
        }
    }
    
    var userServiceCharge : String? {
        get {
            if AgentCodeClass.shared.settingData?.user_service_fee != "1" {
                return ""
            }
            var terms : String?
            if let data = UserDefaults.standard.rm_customObject(forKey: "userServiceCharge") as? String{
                terms = data
            }
            return terms
        }
        set {
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: "userServiceCharge")
            } else{
                defaults.removeObject(forKey: "userServiceCharge")
            }
            defaults.synchronize()
        }
    }
    
//    var terminologyOtherStatus : Dictionary<String,Any>? {
//        get {
//            var terms : Dictionary<String,Any>?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.terminologyOther.rawValue) as? Dictionary<String,Any>{
//                terms = data
//            }
//            return terms
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.terminologyOther.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.terminologyOther.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
    
//    var elementColor : String? {
//        get {
//            var tempColor : String?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.element_color.rawValue) as? String{
//                tempColor = data
//            }
//            return tempColor
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.element_color.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.element_color.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
//
//    var themeColor : String? {
//        get {
//            var tempColor : String?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.theme_color.rawValue) as? String{
//                tempColor = data
//            }
//            return tempColor
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.theme_color.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.theme_color.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
//
//    var headerColor : String? {
//        get {
//            var tempColor : String?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.header_color.rawValue) as? String{
//                tempColor = data
//            }
//            return tempColor
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.header_color.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.header_color.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
//
//    var headerTextColor : String? {
//        get {
//            var tempName : String?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.header_text_color.rawValue) as? String{
//                tempName = data
//            }
//            return tempName
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.header_text_color.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.header_text_color.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
//
//    var logoBackground : String? {
//        get {
//            var tempName : String?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.logo_background.rawValue) as? String{
//                tempName = data
//            }
//            return tempName
//        }
//        set {
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.logo_background.rawValue)
//            } else{
//                defaults.removeObject(forKey: SingletonKeys.logo_background.rawValue)
//            }
//            defaults.synchronize()
//        }
//    }
//
//    var fontName : String? {
//       get {
//           var tempName : String?
//           if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.font_family.rawValue) as? String{
//               tempName = data
//           }
//           return tempName
//       }
//       set {
//           let defaults = UserDefaults.standard
//           if let value = newValue{
//               defaults.rm_setCustomObject(value, forKey: SingletonKeys.font_family.rawValue)
//           } else{
//               defaults.removeObject(forKey: SingletonKeys.font_family.rawValue)
//           }
//           defaults.synchronize()
//       }
//
//    }
//
    var customerPaymentId : String{
            get{
                return UserDefaults.standard.object(forKey: SingletonKeys.customerPaymentId.rawValue) as? String ?? ""
            }
             set{
                           UserDefaults.standard.set(newValue, forKey: SingletonKeys.customerPaymentId.rawValue)
                   }
        }
    

     var tipAmount : Int{
            get{
                return UserDefaults.standard.object(forKey: SingletonKeys.tipAmount.rawValue) as? Int ?? 0
            }
             set{
    //                   if let value = newValue {
                           UserDefaults.standard.set(newValue, forKey: SingletonKeys.tipAmount.rawValue)
                   }
        }
    
     var userId : Int{
            get{
                return UserDefaults.standard.object(forKey: SingletonKeys.userId.rawValue) as? Int ?? 0
            }
             set{
    //                   if let value = newValue {
                           UserDefaults.standard.set(newValue, forKey: SingletonKeys.userId.rawValue)
                   }
        }
    
    var arrayServiceType:[ServiceType]?{
        return (Localize.currentLanguage() == Languages.Arabic ? homeData?.arrayServiceTypesAR : homeData?.arrayServiceTypesEN)
    }
    
    var referalAmount: Float?
    var botResponce : BotResponce?
    var homeData : Home?
//    {
//        get{
//            var home : Home?
//            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.Home.rawValue) as? Home {
//                home = data
//            }
//            return home
//        }
//        set{
//            let defaults = UserDefaults.standard
//            if let value = newValue{
//                defaults.rm_setCustomObject(value, forKey: SingletonKeys.Home.rawValue)
//            }
//            else{
//                defaults.removeObject(forKey: SingletonKeys.Home.rawValue)
//            }
//        }
//    }
    //set when user search
    static var filteredProducts: [ProductList]?
    static var isSearching = false
    var homeProductList: [ProductList]? {
        get {
            !GDataSingleton.isSearching ?  GDataSingleton.sharedInstance.homeData?.arrProductsList : GDataSingleton.filteredProducts
        }
    }
    
    var getOfferByCategory: [OffersByCategory]?
    var doctorHomeProviders: [Supplier]?
    var doctorCategories: [ServiceType]?
    var cartAppType: Int?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.cartAppType.rawValue) as? Int
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.cartAppType.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.cartAppType.rawValue)
            }
        }
    }
    
    var loggedInUser : User?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.User.rawValue) as? User
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.User.rawValue)
                if GDataSingleton.sharedInstance.zendeskEnabled {
                    let ident = Identity.createAnonymous(name: /value.firstName, email: value.email)//Identity.createJwt(token: /value.token)
                    Zendesk.instance?.setIdentity(ident)
                    Support.initialize(withZendesk: Zendesk.instance)
                }
                
                let model = LoginDetail()
                let userDetail = UserDetail()
                userDetail.firstName = newValue?.firstName
                userDetail.profilePic = newValue?.userImage
                userDetail.accessToken = newValue?.token
                //userDetail.user =
                model.userDetails = userDetail
                UDSingleton.shared.userData = model

            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.User.rawValue)
                if GDataSingleton.sharedInstance.zendeskEnabled {
                    let ident = Identity.createAnonymous()
                    Zendesk.instance?.setIdentity(ident)
                    Support.initialize(withZendesk: Zendesk.instance)
                }
            }

        }
    }
    
    var isLoggedIn: Bool {
        guard let user = GDataSingleton.sharedInstance.loggedInUser, !(/user.firstName).isEmpty, let otpVerified = user.otpVerified, otpVerified == "1" else {
                      return false
                  }
        return true
    }
    
//    var isFacebookLogin : Bool?{
//        get{
//            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.isFacebookLogin.rawValue) as? Bool
//        }
//        set{
//            if let value = newValue {
//                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.isFacebookLogin.rawValue)
//            }else{
//                UserDefaults.standard.removeObject(forKey: SingletonKeys.isFacebookLogin.rawValue)
//            }
//        }
//    }
    
    var currentSupplierId : String?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.SupplierId.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.SupplierId.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.SupplierId.rawValue)
            }
        }
    }
    
    var currentCategoryId : String?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.categoryId.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.categoryId.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.categoryId.rawValue)
            }
        }
    }
    
    
    var currentSupplier : Supplier?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.supplier.rawValue) as? Supplier
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.supplier.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.supplier.rawValue)
            }
        }
    }
    
    var termsAndConditions : [TermsModel]?{
           get{
               return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.termsAndConditions.rawValue) as? [TermsModel]
           }
           set{
               if let value = newValue {
                   UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.termsAndConditions.rawValue)
               }else{
                   UserDefaults.standard.removeObject(forKey: SingletonKeys.termsAndConditions.rawValue)
               }
           }
       }
    
    //MARK: - Pickup Details
    var pickupDate : Date?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.PickupDate.rawValue) as? Date
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.PickupDate.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.PickupDate.rawValue)
            }
        }
    }
    
    var pickupAddressId : String?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.PickupAddressId.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.PickupAddressId.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.PickupAddressId.rawValue)
            }
        }
    }
    
    var pickupAddress : Address?{
        get{
            return UserDefaults.standard.rm_customObject(forKey: SingletonKeys.PickupAddress.rawValue) as? Address
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: SingletonKeys.PickupAddress.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.PickupAddress.rawValue)
            }
        }
    }
    
    //MARK: - Device Token
    
    var deviceToken : String?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.DeviceToken.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.DeviceToken.rawValue)
            }else {
                UserDefaults.standard.removeObject(forKey: SingletonKeys.DeviceToken.rawValue)
            }
        }
    }
    
    var fcmToken : String?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.fcmToken.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.fcmToken.rawValue)
                UserDefaultsManager.fcmId = fcmToken
            }else {
                UserDefaults.standard.removeObject(forKey: SingletonKeys.fcmToken.rawValue)
            }
        }
    }
    
    var pushDict : Any? {
        get{
            return UserDefaults.standard.rm_customObject(forKey: RemoteNotification) as Any
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: RemoteNotification)
            }else{
                UserDefaults.standard.removeObject(forKey: RemoteNotification)
            }
        }
    }
    
    //MARK: - Rate Order
    
    var showRatingPopUp : String?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.ShowPopUp.rawValue) as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.ShowPopUp.rawValue)
            }else {
                UserDefaults.standard.removeObject(forKey: SingletonKeys.ShowPopUp.rawValue)
            }
        }
        
    }
    
    var autoSearchedArray : [String]?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.autoSearched.rawValue) as? [String]
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.autoSearched.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.autoSearched.rawValue)
            }
        }
    }
    
    var fromCart : Bool?{
        get{
            return UserDefaults.standard.object(forKey: SingletonKeys.fromCart.rawValue) as? Bool
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: SingletonKeys.fromCart.rawValue)
            }else{
                UserDefaults.standard.removeObject(forKey: SingletonKeys.fromCart.rawValue)
            }
        }
    }
    
    //AgentDbSecretKey
   var agentDBSecretKey : AgentDBSecretKey?{
        get{
            var agentDBSecretKey : AgentDBSecretKey?
            if let data = UserDefaults.standard.rm_customObject(forKey: SingletonKeys.agentDbKey.rawValue) as? AgentDBSecretKey{
                agentDBSecretKey = data
            }
            return agentDBSecretKey
        }
        set{
            let defaults = UserDefaults.standard
            if let value = newValue{
                defaults.rm_setCustomObject(value, forKey: SingletonKeys.agentDbKey.rawValue)
            }
            else{
                defaults.removeObject(forKey: SingletonKeys.agentDbKey.rawValue)
            }
        }
    }
    
    func clearAllSavedData() {
        LocationSingleton.sharedInstance.tempAddAddress = nil
        LocationSingleton.sharedInstance.scheduledOrders = "0"
        GDataSingleton.sharedInstance.loggedInUser = nil
        //  GDataSingleton.sharedInstance.agentDBSecretKey = nil
        GDataSingleton.sharedInstance.autoSearchedArray = nil
        GDataSingleton.sharedInstance.showRatingPopUp = nil
        GDataSingleton.sharedInstance.pushDict = nil
        GDataSingleton.sharedInstance.deviceToken = nil
        GDataSingleton.sharedInstance.pickupAddress = nil
        //            GDataSingleton.isOnBoardingDone = false
        //            GDataSingleton.isAskLocationDone = false
        GDataSingleton.isProfilePicDone = false
        GDataSingleton.sharedInstance.fromCart = false
        AppSettings.shared.appType = nil
        let address = LocationSingleton.sharedInstance.searchedAddress
        address?.id = ""
        LocationSingleton.sharedInstance.searchedAddress = address
        
        // self.resetDefaults()
        DBManager.sharedManager.cleanCart()
        let cache = YYWebImageManager.shared().cache
        cache?.diskCache.removeAllObjects()
        cache?.memoryCache.removeAllObjects()
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
    //Midex domain
    
    var selectedCatId: String?
    var selectedServiceIndex: SelectedServiceType?
    static var arrayMixedItems : [ServiceType] = []
    static var arrayMixedBanners : [Banner]?


}

extension UserDefaults {

    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }

    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
