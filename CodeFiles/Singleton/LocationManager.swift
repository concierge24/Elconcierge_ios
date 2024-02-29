//
//  RKLocationManager.swift
//  InPerson
//
//  Created by CB Macmini_3 on 17/12/15.
//  Copyright © 2015 Rico. All rights reserved.
//

import Foundation
import CoreLocation
import AFNetworking
import GoogleMaps

struct Location {
    var currentLat : String?
    var currentLng : String?
    var currentFormattedAddr : String?
    var currentCity : String?
}

struct DeviceTime {
    
    var currentTime : String {
        get{
            return  localTimeFormatter.string(from: Date())
        }
    }
    
    var currentDate : String{
        get{
            return localDateFormatter.string(from: Date())
        }
    }
    
    var currentZone : String {
        get {
            return NSTimeZone.local.identifier
        }
    }
    
    func convertCreatedAt (createdAt : String?) -> Date?{
        return localDateTimeFormatter.date(from: createdAt ?? "")
    }
    
    var localTimeZoneFormatter = DateFormatter()
    var localTimeFormatter = DateFormatter()
    var localDateFormatter = DateFormatter()
    var localDateTimeFormatter = DateFormatter()
    
    func setUpTimeFormatters(){
        localTimeFormatter.dateFormat = "h:mm a"
        localDateFormatter.dateFormat = "MMM dd yyyy"
        localDateTimeFormatter.dateFormat = "MMM dd yyyy h:mm a Z"
        
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation : Location? = Location()
    var currentTime : DeviceTime? = DeviceTime()
    var currentPlacemark: CLPlacemark?
    static let sharedInstance = LocationManager()
    var isFirstTime : Bool = true
    var isLocationServicesEnabled : Bool {
        get {
            return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .denied
        }
    }
    
    func fireObserver() {
        NotificationCenter.default.post(name: NSNotification.Name("LocationFetched"), object: nil)
    }
    
    func startTrackingUser(){
        
//        if SKAppType.type.isJNJ {
//            return
//        }
        currentTime?.setUpTimeFormatters()
        // Ask for Authorisation from the User.
//        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
       
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
            self.isFirstTime = true
        } else {
            print("Location not on")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        NotificationCenter.default.post(name: NSNotification.Name("LocationNotFetched"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if self.isFirstTime {
            
            let locValue = (manager.location?.coordinate) ?? CLLocationCoordinate2D()
            self.currentLocation?.currentLat = "\(locValue.latitude)"
            self.currentLocation?.currentLng = "\(locValue.longitude)"
            
            guard let location = locations.last else{
                return
            }
            self.currentLocation?.currentLat = "\(location.coordinate.latitude)"
            self.currentLocation?.currentLng = "\(location.coordinate.longitude)"
            LocationSingleton.sharedInstance.selectedLatitude = location.coordinate.latitude
            LocationSingleton.sharedInstance.selectedLongitude = location.coordinate.longitude
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
                if let placeMark = placemarks?.first {
                    self.formatAddress(placeMark: placeMark)
                    
                    NotificationCenter.default.post(name: NSNotification.Name("LocationFetched"), object: nil)
                }
            }
            
            locationManager.stopUpdatingLocation()
            self.isFirstTime = false
            
        }

    }
       
    private func formatAddress (placeMark : CLPlacemark){
        
        let address = "\(/placeMark.thoroughfare), \(/placeMark.locality), \(/placeMark.subLocality), \(/placeMark.administrativeArea), \(/placeMark.postalCode), \(/placeMark.country)"

        //Nitin
       // let address = "\(/placeMark.name), \(/placeMark.locality)"

        self.currentLocation?.currentFormattedAddr = address
        self.currentPlacemark = placeMark
        if let place = LocationSingleton.sharedInstance.selectedAddress {
            print(place)
        } else {
            LocationSingleton.sharedInstance.selectedAddress = placeMark
        }
        
        guard let city = placeMark.addressDictionary?["City"] as? String else{
            if let city = placeMark.subAdministrativeArea{
                self.currentLocation?.currentCity = city
            }
            else if let city = placeMark.administrativeArea{
                self.currentLocation?.currentCity = city
            }
            else if let city = placeMark.country{
                self.currentLocation?.currentCity = city
            }
            return
        }
        self.currentLocation?.currentCity = city
        
    }
 
}

extension LocationManager  {
    
    
   
}
    


