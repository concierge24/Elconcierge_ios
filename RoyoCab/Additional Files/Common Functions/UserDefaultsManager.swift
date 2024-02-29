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

struct UDKeys
{
    static let user = "user"
    static let language = "language"
    static let languageId = "languageId"
    static let languageCode = "languageCode"
    static let deviceToken = "deviceToken"
    static let onboardingRun = "onboardingRun"
    static let fcmId = "fcmId"
    static let mapType = "mapType"
    static let locale = "locale"
    static let appSetting = "appSetting"
    static let appTerminology = "appTerminology"
    
}

class UserDefaultsManager: NSObject{
  static let shared = UserDefaultsManager()
  
 // private var user:User?
    
    
    var mapType : String? {
        get {
             if let savedVal = UserDefaults.standard.value(forKey: UDKeys.mapType) as? String {
               return savedVal
            }
            return BuraqMapType.Hybrid.rawValue
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UDKeys.mapType)
            }
            else {
                UserDefaults.standard.removeObject(forKey: UDKeys.mapType)
            }
            
        }
    }
  
  static var fcmId: String? {
    get {
      return UserDefaults.standard.value(forKey: UDKeys.fcmId) as? String
    }
    set {
      if let value = newValue {
        UserDefaults.standard.set(value, forKey: UDKeys.fcmId)
      }
      else {
        UserDefaults.standard.removeObject(forKey: UDKeys.fcmId)
      }
    }
  }
    
    static var languageId: String? {
        get {
            return UserDefaults.standard.value(forKey: UDKeys.languageId) as? String
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UDKeys.languageId)
            }
            else {
                UserDefaults.standard.removeObject(forKey: UDKeys.languageId)
            }
        }
    }
    
    static var languageCode: String? {
        get {
            return UserDefaults.standard.value(forKey: UDKeys.languageCode) as? String
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UDKeys.languageCode)
            }
            else {
                UserDefaults.standard.removeObject(forKey: UDKeys.languageCode)
            }
        }
    }
    
    static var localeIdentifierCustom:String?{
        get {
            return UserDefaults.standard.value(forKey: UDKeys.locale) as? String
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: UDKeys.locale)
            }
            else {
                UserDefaults.standard.removeObject(forKey: UDKeys.locale)
            }
        }
    }
    
  
  static var isOnBoardingDone:Bool {
    set{
    //  UserDefaults.standard.set(newValue, forKey: UDKeys.onboardingRun)
    }
    get{
        return true
     // return (UserDefaults.standard.value(forKey: UDKeys.onboardingRun) as? Bool)  ?? false
    }
  }

}



extension UserDefaults {
  static let group = UserDefaults(suiteName: "group.com.codebrew.RoyoRide-UserGroup")!
}
