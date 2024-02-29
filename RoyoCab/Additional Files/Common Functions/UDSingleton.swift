//
//  UserDefaultsManager.swift
//  InTheNight
//
//  Created by OSX on 19/02/18.
//  Copyright © 2018 InTheNight. All rights reserved.
//

import UIKit
import ObjectMapper
import CoreLocation



 class UDSingleton: NSObject {
    
    static let shared = UDSingleton()
    private var loginDetail:LoginDetail?
    private var settings: AppSettingModel?
    private var terminology: AppTerminologyModel?
    
    
    //MARK:- User Data
    var userData:LoginDetail? {
        get{
            
            if let obj = self.loginDetail {
                return obj
            }
            
            if let userString = UserDefaults.standard.object(forKey: UDKeys.user) as? String {
                let userJson = Mapper<LoginDetail>.parseJSONStringIntoDictionary(JSONString: userString)
                self.loginDetail = Mapper<LoginDetail>().map(JSON: userJson ?? [:])
                return self.loginDetail
            }
            return nil
        }
        set{
            if let newVal = newValue {
                self.loginDetail = newVal
                let userString:String = /(newVal.toJSONString())
                UserDefaults.standard.set(userString, forKey: UDKeys.user)
               
                
            }else{
                UserDefaults.standard.removeObject(forKey: UDKeys.user)
            }
        }
    }
    
    // App Settings
    var appSettings: AppSettingModel? {
        get{
            
            if let obj = self.settings {
                return obj
            }
            
            if let settingString = UserDefaults.standard.object(forKey: UDKeys.appSetting) as? String {
                let settingJson = Mapper<AppSettingModel>.parseJSONStringIntoDictionary(JSONString: settingString)
                self.settings = Mapper<AppSettingModel>().map(JSON: settingJson ?? [:])
                return self.settings
            }
            return nil
        }
        set{
            if let newVal = newValue {
                self.settings = newVal
                let settingString:String = /(newVal.toJSONString())
                UserDefaults.standard.set(settingString, forKey: UDKeys.appSetting)
                
            }else{
                UserDefaults.standard.removeObject(forKey: UDKeys.appSetting)
            }
        }
    }
    
    // App Terminology
    var appTerminology: AppTerminologyModel? {
        get{
            
            if let obj = self.terminology {
                return obj
            }
            
            if let termString = UserDefaults.standard.object(forKey: UDKeys.appTerminology) as? String {
                let termJson = Mapper<AppTerminologyModel>.parseJSONStringIntoDictionary(JSONString: termString)
                self.terminology = Mapper<AppTerminologyModel>().map(JSON: termJson ?? [:])
                return self.terminology
            }
            return nil
        }
        set{
            if let newVal = newValue {
                self.terminology = newVal
                let termString:String = /(newVal.toJSONString())
                UserDefaults.standard.set(termString, forKey: UDKeys.appTerminology)
                
            }else{
                UserDefaults.standard.removeObject(forKey: UDKeys.appTerminology)
            }
        }
    }
    
    
    //MARK: - Static Methods
    var isOnBoardingDone: Bool {
        
        set{
            UserDefaults.standard.set(newValue, forKey: UDKeys.onboardingRun)
        }
        get{
            return (UserDefaults.standard.value(forKey: UDKeys.onboardingRun) as? Bool)  ?? false
        }
    }
    
    static var deviceToken: String? {
        get {
            return UserDefaults.standard.value(forKey: UDKeys.deviceToken) as? String
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UDKeys.deviceToken)
            }
            else {
                UserDefaults.standard.removeObject(forKey: UDKeys.deviceToken)
            }
        }
    }
    
    
    
    
    
    //MARK:- ======== Functions ========
    func clearData() {
        
        //    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    
    func tokenExpired() {
        
        removeAppData()
        
    }
    
    
    func removeAppData() {
            // needs to unregister notifcations
    //                self.loginDetail = nil
    //                UserDefaults.standard.removeObject(forKey: UDKeys.user)
    //                UserDefaults.standard.synchronize()
    //                SocketIOManager.shared.closeConnection()
    //                UDSingleton.shared.clearData()
    //
            
            self.loginDetail = nil
            UserDefaults.standard.removeObject(forKey: UDKeys.user)
            UserDefaults.standard.synchronize()
            SocketIOManagerCab.shared.closeConnection()
            UDSingleton.shared.clearData()
            
            // LocationSingleton.sharedInstance.selectedAddress = nil
            // LocationSingleton.sharedInstance.searchedAddress = nil //Nitin check
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
            // self.resetDefaults()
            DBManager.sharedManager.cleanCart()
            let cache = YYWebImageManager.shared().cache
            cache?.diskCache.removeAllObjects()
            cache?.memoryCache.removeAllObjects()
            let loginManager = LoginManager()
            loginManager.logOut()
            let address = LocationSingleton.sharedInstance.searchedAddress
            address?.id = ""
            LocationSingleton.sharedInstance.searchedAddress = address
            
            let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
            
            AppDelegate.shared().setLoginAsRootVC()
            
    //        switch template {
    //        case .Moby?:
    //            //prashant
    //            guard let vc = R.storyboard.newTemplateLoginSignUp.ntLoginSignupTypeViewController() else {return}
    //            AppDelegate.shared().setLoginAsRootVC(vc: vc)
    //            break
    //
    //        case .DeliverSome:
    //            //prashant
    ////            guard let vc = R.storyboard.template1_Design.landingAndPhoneInputVCTemplate1() else { return }
    ////            AppDelegate.shared().setLoginAsRootVC(vc: vc)
    //            break
    //
    //        default:
    //            break
    //            //prashant
    ////            guard let vc = R.storyboard.mainCab.landingAndPhoneInputVC() else {return}
    ////            AppDelegate.shared().setLoginAsRootVC(vc: vc)
    //        }
        }
    
    
    //MARK: - Class Methods
    class func isGuestUser()->Bool {
        return /(UserDefaults.standard.value(forKey:UDKeys.user) as? String) == ""
    }
    
    func getService(categoryId : Int?) -> Service? {
        
        guard let services = userData?.services else{ return nil}
        let objCategory = services.filter{($0.serviceCategoryId == categoryId)}
        if !objCategory.isEmpty{
            return  objCategory.first
        }
        return nil
    }
}
