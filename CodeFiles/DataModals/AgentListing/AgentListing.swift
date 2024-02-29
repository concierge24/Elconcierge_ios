//
//  AgentListing.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation


import SwiftyJSON
import RMMapper

class AgentListing : NSObject , RMMapping, NSCoding {
    
    var agentListingData : [AgentListingData]?
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        let json = JSON(rawData)
        
        let array = json[APIConstants.DataKey].arrayValue
        
        agentListingData = [AgentListingData]()
        
        for (_ , element) in array.enumerated(){
            
            let agentData = AgentListingData(attributes: element.dictionaryValue)
            agentListingData?.append(agentData)
            
        }
        
    }
    
    
    override init(){
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(agentListingData, forKey: APIConstants.DataKey)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        agentListingData = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [AgentListingData]
        
    }
    
}

class AgentSlotListing : NSObject , RMMapping, NSCoding {
    
    var array : [String] = []
    
    init(sender : SwiftyJSONParameter) {
        
        guard let rawData = sender else { return }
        let json = JSON(rawData)
        
        for obj in json[APIConstants.DataKey].arrayValue {
            if let slot = obj.string {
                array.append(slot)
            }
        }
    }
    
    override init(){
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(array, forKey: APIConstants.DataKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        array = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [String] ?? []
    }
}

class AgentCodeClass {
    
    let DEFAULTS_KEY = "agentData"
    let CURRENCY_DEFAULTS_KEY = "agentCurrencyData"
    let FEATURE_DEFAULTS_KEY = "agentFeatureData"
    let SETTINGS_DEFAULTS_KEY = "settingsData"
    
    static let shared = AgentCodeClass()
    
    private init() {
        
    }
    
    var loggedAgent: AgentCodeData? {
        get{
            return fetchData()
        }
        set{
            if let value = newValue {
                saveData(value)
            } else {
                removeData()
            }
        }
    }
    
    var loggedCurrency : CurrencyData? {
        get{
            return fetchCurrencyData()
        }
        set{
            if let value = newValue {
                saveCurrencyData(value)
            } else {
                removeCurrencyData()
            }
        }
    }
    var paypalToken = ""
    var agentFeatureData : [FeatureDataModal]? {
        get{
            return fetchFeatureData()
        }
        set{
            if let value = newValue {
                saveFeatureData(value)
            } else {
                removeFeatureData()
            }
        }

    }
    
    var settingData: SettingsData?{
        get{
            return fetchSettingData()
        }
        set{
            if let value = newValue {
                saveSettingsData(value)
            } else {
                removeFeatureData()
            }
        }
    }
    
    var clientSecretKey : String {
        return loggedAgent?.cbl_customer_domains?.first?.db_secret_key ?? "605507f0ff3ed2149207231a68786192"
       // "de19d1d45ff3bf2538f0db21c094a8e3" // 07bce98805a7b9ac6226c3acc43527e3 // for food
       // "f9dad48c891fc13b2e9009f86839d51e" // for rental
    }
    
    var agentSecretKey : String {
           return loggedAgent?.cbl_customer_domains?.first?.agent_db_secret_key ?? "605507f0ff3ed2149207231a68786192"
          // "de19d1d45ff3bf2538f0db21c094a8e3" // 07bce98805a7b9ac6226c3acc43527e3 // for food
          // "f9dad48c891fc13b2e9009f86839d51e" // for rental
       }
       
    
    private func saveData(_ value: AgentCodeData) {
        guard let data: Data = try? JSONEncoder().encode(value) else {
            UserDefaults.standard.removeObject(forKey: DEFAULTS_KEY)
            return
        }
        UserDefaults.standard.set(data, forKey: DEFAULTS_KEY)
    }
    
    private func saveCurrencyData(_ value: CurrencyData) {
       guard let data: Data = try? JSONEncoder().encode(value) else {
           UserDefaults.standard.removeObject(forKey: CURRENCY_DEFAULTS_KEY)
           return
       }
       UserDefaults.standard.set(data, forKey: CURRENCY_DEFAULTS_KEY)
    }
    
    private func saveFeatureData(_ value: [FeatureDataModal]) {
       guard let data: Data = try? JSONEncoder().encode(value) else {
           UserDefaults.standard.removeObject(forKey: FEATURE_DEFAULTS_KEY)
           return
       }
       UserDefaults.standard.set(data, forKey: FEATURE_DEFAULTS_KEY)
    }
    
    private func saveSettingsData(_ value: SettingsData) {
       guard let data: Data = try? JSONEncoder().encode(value) else {
           UserDefaults.standard.removeObject(forKey: SETTINGS_DEFAULTS_KEY)
           return
       }
       UserDefaults.standard.set(data, forKey: SETTINGS_DEFAULTS_KEY)
    }
    
    private func fetchData() -> AgentCodeData? {
        guard let data = UserDefaults.standard.data(forKey: DEFAULTS_KEY) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(AgentCodeData.self, from: data) else {
            return nil
        }
        return model
    }
    
    private func fetchCurrencyData() -> CurrencyData? {
        guard let data = UserDefaults.standard.data(forKey: CURRENCY_DEFAULTS_KEY) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(CurrencyData.self, from: data) else {
            return nil
        }
        return model
    }
    
    private func fetchFeatureData() -> [FeatureDataModal]? {
        guard let data = UserDefaults.standard.data(forKey: FEATURE_DEFAULTS_KEY) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode([FeatureDataModal].self, from: data) else {
            return nil
        }
        return model
    }
    
    private func fetchSettingData() -> SettingsData? {
        guard let data = UserDefaults.standard.data(forKey: SETTINGS_DEFAULTS_KEY) else {
            return nil
        }
        guard let model = try? JSONDecoder().decode(SettingsData.self, from: data) else {
            return nil
        }
        return model
    }
    
    private func removeData() {
        UserDefaults.standard.removeObject(forKey: DEFAULTS_KEY)
    }
    
    private func removeCurrencyData() {
        UserDefaults.standard.removeObject(forKey: CURRENCY_DEFAULTS_KEY)
    }
    
    private func removeFeatureData() {
        UserDefaults.standard.removeObject(forKey: FEATURE_DEFAULTS_KEY)
    }
}

enum FeatureType: String {
    
    case PaymentGateway = "payment_gateway"
    case SocialLogin = "social_login"
    case Map = "map"
    case ChatService = "chat_service"
    
    func getAllServices() -> [FeatureDataModal]? {
        guard let featuredData = AgentCodeClass.shared.agentFeatureData else {return nil}
        var filteredArray = featuredData.filter({$0.type_name == self.rawValue})
        if self == .PaymentGateway {
            filteredArray = filteredArray.filter({$0.is_active == 1})
        }
        return filteredArray
    }
    
    func getService(name: String, key: String) -> String? {
        guard let services = getAllServices() else { return nil }
        let service = services.filter({$0.name == name}).first
        if let kvf = service?.key_value, let obj = kvf.filter({$0.key == key}).first {
            return "\(obj.for_front ?? 0)"
        }
        if let kvf = service?.key_value_front, let obj = kvf.filter({$0.key == key}).first {
            return obj.value
        }
        return nil
    }
    
    static var googleMapsKey: String {
        print(FeatureType.Map.getService(name: "Google maps", key: "google_map_key") ?? "AIzaSyDFfLXKDcENGjXYyM_ekHDHeEncJR0rqRw")
        return FeatureType.Map.getService(name: "Google maps", key: "google_map_key") ?? "AIzaSyDFfLXKDcENGjXYyM_ekHDHeEncJR0rqRw"
    }
    static var facebookKey: String {
        return FeatureType.SocialLogin.getService(name: "Facebook", key: "app_id") ?? "123"
    }
    
}
