//
//  Constants.swift
//  HutchDecor
//
//  Created by Aseem 13 on 14/09/16.
//  Copyright © 2016 Taran. All rights reserved.
//

import UIKit
import SwiftyJSON

let minimumZoom : Float = 2.0
let maximumZoom : Float = 20.0
let vehicleSize : CGSize = CGSize(width: 24.0, height: 38.0)

var vehicleCurrentSize : CGSize = CGSize(width: 24.0, height: 38.0)
var previousZoom : Float = 14


let Comment_Text_Limit = 255



//let customerCare1 = "+968 24453336"
//let customerCare2 = "+968 90630609"

let customerCareGoMove = "+15144166606"
let customerCare1 = "+123456789"
let customerCare2 = "+123456789"
let customerSupportEmailGoMove = "gomove@gomove.co"
let customerSupportEmail = "support@yopmail.com"

struct RequestTimeOut {
    
    static var timeOut : Float = 50.0
}

struct ApplicationTimeout {
    static var isTimedOut = false
}

//enum ApiKeys:String {
//
////    case googleMaps = "AIzaSyBiBi-y-jreGQjQfu1M1Fnr8WYZxIZIrxw"//"AIzaSyBJ--xhuftJS-r48lPXdvYN7nrvJnOpsk0"
//    case googleLocationKey = "AIzaSyBiBi-y-jreGQjQfu1M1Fnr8WYZxIZIrxw"//"AIzaSyCKx1fqDWY8Kdcqx5wknwjOlzB9Bej4U6Q"//"AIzaSyBcpsJb8dpHMZPN91DMZjenlj3pbR7m-4M"
//}

enum LocalNotifications  : String {
    
    case eTokenSelected = "eTokenSelected"
    case AppInForground = "AppInforground"
    case DismissCancelPopUp = "DismissCancelPopUp"
    
    case InternetConnected = "InternetConnected"
    case InternetDisconnected = "InternetDisconnected"
    
    case ETokenRefresh = "Etokenrefresh"
     case ETokenTrackingRefresh = "ETokenTrackingRefresh"
    
    case nCancelFromBookinScreen = "CancelFromBookinScreen"
    case SerCheckList = "SerCheckList"
     case updateWallet = "updateWallet"

}

enum RemoteNotificationType  : String {
    
    case DriverAccepted = "SerAccept"
    case AppInForground = "AppInforground"
    
}

enum ParamKeys : String {
    
    case phoneNo = "phone_no"
    case email = "email"
    case images = "images"
    case lat = "lat"
    case lng = "lng"
    case userId = "user_id"
    case name = "name"
    case apiToken = "api_token"
    case image = "image"
    case gender = "gender"
    case dob = "dob"
    
    case featuredBusiness = "featured_business"
    case businessId = "business_id"
    case imagelogo = "logo_image"
    case category = "category"
    case distance = "distance"
    case followerCount = "f_count"
    case offerCount = "o_count"
    case ratingCount = "r_count"
}

//
//enum Alert : String{
//    case success = "Success"
//    case oops = "Oops"
//    case login = "Login Successfull"
//    case ok = "Ok"
//    case cancel = "Cancel"
//    case error = "Error"
//}

infix operator =>
infix operator =|
infix operator =<

typealias OptionalJSON = [String : JSON]?

func =>(key : ParamKeys, json : OptionalJSON) -> String?{
    return json?[key.rawValue]?.stringValue
}

func =<(key : ParamKeys, json : OptionalJSON) -> [String : JSON]?{
    return json?[key.rawValue]?.dictionaryValue
}

func =|(key : ParamKeys, json : OptionalJSON) -> [JSON]?{
    return json?[key.rawValue]?.arrayValue
}

prefix operator /
prefix func /(value : String?) -> String {
    return value.unwrap()
}



struct CountryUtility {
    
    static private func loadCountryListISO() -> Dictionary<String, String>? {
        let pListFileURL = Bundle.main.url(forResource: "ISO3-TO-ISO2", withExtension: "plist", subdirectory: "")
        if let pListPath = pListFileURL?.path,
            let pListData = FileManager.default.contents(atPath: pListPath) {
            do {
                let pListObject = try PropertyListSerialization.propertyList(from: pListData, options:PropertyListSerialization.ReadOptions(), format:nil)
                guard let pListDict = pListObject as? Dictionary<String, String> else {
                    return nil
                }
                return pListDict
            } catch {
                print("Error reading regions plist file: \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func getISOAlpha2(isoAlpha3: String) -> String? {
        guard let countryList = CountryUtility.loadCountryListISO() else {
            return nil
        }
        if let isoAlpha2 = countryList[isoAlpha3]{
            return isoAlpha2
        }
        return nil
    }
}

