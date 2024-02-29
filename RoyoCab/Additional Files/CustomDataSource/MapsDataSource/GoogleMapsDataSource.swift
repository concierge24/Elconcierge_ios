//
//  GoogleMapsDataSource.swift
//  Wethaq
//
//  Created by Atirek Sharma on 21/02/18.
//  Copyright © 2018 codebrew. All rights reserved.
//

import UIKit
import GoogleMaps

typealias TapCallback = (_ place: CLLocationCoordinate2D) -> ()
typealias MapsDidStopMoving = (_ place: CLLocationCoordinate2D) -> ()
//typealias DidUpdatecurrentLocation = (_ locationManager:CLLocationManager,_ place: [CLLocation]?) -> ()
typealias DidTapMarker = (_ mapView:GMSMapView, _ marker: GMSMarker) -> (UIView?)
typealias DidTapInfoWindow = (_ mapView:GMSMapView, _ marker: GMSMarker) -> ()
typealias DidChangePosition = () -> ()

class GoogleMapsDataSource: NSObject {
  
  let locationManager = CLLocationManager()
  var mapStyleJSON:String?
  var mapView:GMSMapView?
  var tapCallback: TapCallback?
  var mapStopScroll: MapsDidStopMoving?
  var didTapMarker:DidTapMarker?
  var didUpdateCurrentLocation:DidUpdatecurrentLocation?
  var didTapInfoWindow:DidTapInfoWindow?
  var address: String?
  var didChangePosition:DidChangePosition?
  
  init(mapStyleJSON:String? , mapView: GMSMapView){
    super.init()
    
    self.mapStyleJSON = mapStyleJSON
    self.mapView = mapView
    self.getCurrentLocation()
    self.setProperties()
    self.setMapStyle()
  }
  
  //MARK: - Set Properties
  func setProperties(){
    
    self.mapView?.isBuildingsEnabled = false
    self.mapView?.settings.myLocationButton = false
    self.mapView?.animate(toZoom: 12.0)
  }
  
  //MARK: - Set Map Style
  func setMapStyle() {
    
    self.mapView?.mapStyle(withFilename: /self.mapStyleJSON, andType: "json")
    
  }
  
  
  //MARK: - Get Address
  func getAddress(lat:String?, long:String?) -> String? {
    
    let coordinate = CLLocationCoordinate2D(latitude: /lat?.toDouble(), longitude: /long?.toDouble())
    let geocoder = GMSGeocoder()
    geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
      if let address = response?.firstResult() {
        self.address =  /(address.lines?[0]) + ", " + /(address.lines?[1])
      }
    }
    return address
  }
  
    func getAddressFromlatLong(lat: Double, long: Double, completion: @escaping (_ address: String, _ country: String?, _ name: String?) -> Void){
    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    let geocoder = GMSGeocoder()
    var add = ""
    geocoder.reverseGeocodeCoordinate(coordinate) { (response, error) in
      if let address = response?.firstResult() {
        
        guard let arrAddress = address.lines else {return}
        if arrAddress.count > 1 {
            add =  /(arrAddress[0]) + ", " + /(arrAddress[1])
    
        }else if arrAddress.count == 1 {
            add =  /(arrAddress[0])
        }
        completion(add, address.country, address.thoroughfare ?? "Unnamed Road")
      }
    }
  }
    
   class func getDistance( newPosition : CLLocation , previous : CLLocation ) -> Float {
        return Float(newPosition.distance(from: previous))
    }
}

extension GMSMapView {
  
  //MARK: - Map Styling
  func mapStyle(withFilename name: String, andType type: String) {
    do {
      if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
        self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        debugPrint("Unable to find style.json")
      }
    } catch {
      debugPrint("One or more of the map styles failed to load. \(error)")
    }
  }
}

//MARK: - GMSMapViewDelegate
extension GoogleMapsDataSource: GMSMapViewDelegate {
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    self.tapCallback?(coordinate)
  }
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    self.mapStopScroll?(position.target)
    mapView.selectedMarker?.tracksViewChanges = false
  }
  
  func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
    self.didTapInfoWindow?(mapView,marker)
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    
    return false
  }
  
  func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
    return self.didTapMarker?(mapView, marker)
  }
  
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    
    didChangePosition?()
  }
  
  
}

extension GoogleMapsDataSource:CLLocationManagerDelegate{
  
  func getCurrentLocation(){
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    didUpdateCurrentLocation?(manager,locations)
  }
  
}


