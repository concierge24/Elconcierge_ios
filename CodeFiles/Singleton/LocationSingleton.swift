//
//  LocationSingleton.swift
//  Clikat
//
//  Created by cblmacmini on 5/26/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSingleton: NSObject {
    
    static let sharedInstance = LocationSingleton()
    private let keyApplicationLocation = "ClikatApplicationLocation"
    private let selectedLatitudeKey = "selectedLatitude"
    private let selectedLongitudeKey = "selectedLongitude"
    private let selectedAddressKey = "selectedAddres"
    private let searchedAddressKey = "searchedAddres"
    private let tempAddAddressKey = "tempAddAddress"

    var selectedLatitude: Double? {
        get {
            if let coord = UserDefaults.standard.rm_customObject(forKey: selectedLatitudeKey) as? Double {
                return coord
            } else {
                return 0.0
            }
        } set {
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: selectedLatitudeKey)
            }else{
                UserDefaults.standard.removeObject(forKey: selectedLatitudeKey)
            }
        }
        
    }
 
    var selectedLongitude: Double? {
        get {
            if let coord = UserDefaults.standard.rm_customObject(forKey: selectedLongitudeKey) as? Double {
                return coord
            } else {
                return 0.0
            }
        } set {
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: selectedLongitudeKey)
            }else{
                UserDefaults.standard.removeObject(forKey: selectedLongitudeKey)
            }
        }
        
    }
    
    //Set from Location manager and home - current location address
    var selectedAddress : CLPlacemark? {
        
        get {
            if let placemark = UserDefaults.standard.rm_customObject(forKey: selectedAddressKey) as? CLPlacemark {
                return placemark
            } else {
                return nil
            }
        } set {
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: selectedAddressKey)
            }else{
                UserDefaults.standard.removeObject(forKey: selectedAddressKey)
            }
        }
        
    }
    
    //Set from location picker - NewLocationViewController
    var searchedAddress : SearchedLocation? {
        
        get {
            if let address = UserDefaults.standard.rm_customObject(forKey: searchedAddressKey) as? SearchedLocation {
                return address
            } else {
                return nil
            }
        } set {
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: searchedAddressKey)
            }else{
                UserDefaults.standard.removeObject(forKey: searchedAddressKey)
            }
        }
    }
    
    //Currenty saved address from MapViewController
    var tempAddAddress : SearchedLocation? {
        
        get {
            if let address = UserDefaults.standard.rm_customObject(forKey: tempAddAddressKey) as? SearchedLocation {
                return address
            } else {
                return nil
            }
        } set {
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: tempAddAddressKey)
            }else{
                UserDefaults.standard.removeObject(forKey: tempAddAddressKey)
            }
        }
        
    }
    
    var location : ApplicationLocation? {
        get {
            return UserDefaults.standard.rm_customObject(forKey: keyApplicationLocation) as? ApplicationLocation
        }
        set{
            if let value = newValue {
                UserDefaults.standard.rm_setCustomObject(value, forKey: keyApplicationLocation)
            }else{
                UserDefaults.standard.removeObject(forKey: keyApplicationLocation)
            }
        }
    }
    
    func isLocationSelected() -> Bool{
        
        guard let _ = location?.area?.id else {
            return false
        }
        
//        guard let _ = location?.countryEN, let _ = location?.cityEN, let _ = location?.areaEN,let _ = location?.countryAR, let _ = location?.cityAR, let _ = location?.areaAR else {
//            return false
//        }
        return true
    }
    
    var scheduledOrders : String?{
        get {
            return UserDefaults.standard.object(forKey: "ClikatScheduledOrders") as? String
        }
        set{
            guard let value = newValue else {
                UserDefaults.standard.removeObject(forKey: "ClikatScheduledOrders")
                return
            }
            
            UserDefaults.standard.set(value, forKey: "ClikatScheduledOrders")
        }
    }
    
}
