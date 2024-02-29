//
//  LocationManager.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 18/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit
import CoreLocation


protocol LocationManagerCabDelegate {
    func updateLocationCity(cityName : String?)
}

class LocationManagerCab: NSObject,CLLocationManagerDelegate {
    
    var locationManager : CLLocationManager?
    var currentLoc : CLLocation?
    
    lazy var latitude = CLLocationDegrees()
    lazy var longitude = CLLocationDegrees()
    
    
    var delegate : LocationManagerCabDelegate?
    var currentCity : String?
    
    
    override init() {
        super.init()
        
        locationInitializer()
        updateLocation()
    }
    
    static let shared = LocationManagerCab()
    
    func updateUserLocation() {
        locationInitializer()
        updateLocation()
    }
    
    func updateLocation() {
        locationManager?.delegate = self
        locationManager?.startUpdatingLocation()
    }
    
    func locationInitializer() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedWhenInUse,.authorizedAlways:
            locationManager?.startUpdatingLocation()
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            
        case .restricted,.denied:
            settingsAlert()
        }
    }
    
    func settingsAlert() {
        
       //  Alerts.shared.showAlertView(alert: Alert.alert.getLocalised(), message: "To find your pick-up location automatically, turn on location services", buttonTitles: ["Settings"], viewController: ez.topMostVC!)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLoc = locations.last
        
        if let lat = currentLoc?.coordinate.latitude ,let lng = currentLoc?.coordinate.longitude {
            latitude = lat
            longitude = lng
            getUserCurrentCity()
        }
    }
    
    func stopUpdatingLocation () {
        
        locationManager?.stopUpdatingLocation()
        locationManager?.delegate = nil
    }
    
    //MARK: - Delegate City Fire
    func updateLocationForCurrentCity() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch(CLLocationManager.authorizationStatus()) {
                
            case  .restricted, .denied:
                settingsAlert()
                
            case .authorizedAlways, .authorizedWhenInUse:
                self.getUserCurrentCity()
                
            case .notDetermined:
                break
            }
        } else {
            
            print("Location services are not enabled")
            
        }
    }
    
    
    func getUserCurrentCity() {
        
        if latitude == 0  || longitude == 0  {
            
            ez.runThisAfterDelay(seconds: 0.1, after: { [weak self] in
                self?.getUserCurrentCity()
            })
            
        } else {
            
//            Utility.shared.calculateAddress(lat: LocationManager.shared.latitude, long: LocationManager.shared.longitude, responseBlock: { [weak self] (coordinate, fullAddress, name, city, state, subLocality) in
//
//                self?.currentCity = city
//                self?.delegate?.updateLocationCity(cityName: city)
//                self?.delegate = nil // remove strong reference of the current
//            })
            
            return
        }
    }
}
