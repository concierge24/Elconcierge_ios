//
//  TrackingViewController.swift
//  GoogleMapTracking
//
//  Created by cbl24_Mac_mini on 06/05/19.
//  Copyright © 2019 GoogleMapTracking. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class TrackingViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var viewMap: GMSMapView!
    
    //MARK::- PROPERTIES
    var trackVM : TrackingModal?
    var mapVM  = MapRequirementsViewModal()
    var locationManager = CLLocationManager()
    typealias  EtaBlock = ((String)->())
    var etaBlock:EtaBlock?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        listenLocation()
        onLoad()
    }
    
    func onLoad(){
        loadMap()
        socketHandlers()
        updatePolyLine()
    }
    
    func updatePolyLine(){
        trackVM?.updatePolyLine = { [weak self] in
            self?.showPath(polyStr: /self?.trackVM?.polyLine?.routes?.first?.overviewPolyline?.points)
        }
    }
    
}

//MARK::- LOAD MAP
extension TrackingViewController {
    
    func loadMap(){
        viewMap.isHidden = false
        
        guard let lat = trackVM?.latitude else {return}
        guard let long = trackVM?.longitude else {return}
        guard let lati = Double(lat) else {return}
        guard let longi = Double(long) else {return}
        guard let latitude = CLLocationDegrees(exactly: lati) else {return}
        guard let longitude = CLLocationDegrees(exactly: longi) else {return}

        let camera = GMSCameraPosition.camera(withLatitude: latitude , longitude: longitude , zoom: 16.0)
        mapVM.mapView = GMSMapView.map(withFrame: viewMap?.bounds ?? CGRect.zero , camera: camera)
        mapVM.mapView.settings.myLocationButton = false
        mapVM.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        loadSourceDestination()
        moveCameraFocus()
        //mapVM.mapView.padding = trackVM.mapPadding
        viewMap?.addSubview(mapVM.mapView)
        trackVM?.retrievePolyline()
        
        
    }
    
}

//MARK::- POLYLINE SETUPS
extension TrackingViewController {
    
    func showPath(polyStr :String){
        print(polyStr)
        
//        mapVM.polyline?.map = nil
        
        //        updateNewLocationsWithBearingOnMap()
        let path = GMSMutablePath(fromEncodedPath: polyStr)
        if mapVM.polyline == nil {
            mapVM.polyline = GMSPolyline(path: path)
        }
        mapVM.polyline?.path = path
        mapVM.polyline?.geodesic = true
        mapVM.polyline?.strokeWidth = 5.0
        mapVM.polyline?.strokeColor = SKAppType.type.color
        mapVM.polyline?.map = mapVM.mapView
        loadSourceDestination()
    }
    
}


//MARK::- UPDATE NEW LOCATIONS
extension TrackingViewController {
    
    //MARK::- UPDATE MARKER BEARING AND NEW LOCATION
    func updateNewLocationsWithBearingOnMap(){
        updatePolyLine()
        trackVM?.retrievePolyline()
//        mapVM.mapView?.clear()
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        loadSourceDestination()
        CATransaction.commit()
        moveCameraFocus()
    }
    
}

//MARK::- UPDATE MAP
extension TrackingViewController {
    
    //MARK::- SET/UPDATE FOCUS OF CAMERA ON MAP
    func moveCameraFocus(){
        
        guard let sourceLat = trackVM?.latitude else {return}
        guard let sourceLong = trackVM?.longitude else {return}
        guard let sourceLati = Double(sourceLat) else {return}
        guard let sourceLongi = Double(sourceLong) else {return}
        guard let sourceLatitude = CLLocationDegrees(exactly: sourceLati) else {return}
        guard let sourceLongitude = CLLocationDegrees(exactly: sourceLongi) else {return}
        let source = CLLocationCoordinate2D(latitude: sourceLatitude, longitude: sourceLongitude)
       
        guard let destiLat = trackVM?.address?.first?.latitude else {return}
        guard let destiLong = trackVM?.address?.first?.longitude else {return}
        guard let destiLati = Double(destiLat) else {return}
        guard let destiLongi = Double(destiLong) else {return}
        guard let destiLatitude = CLLocationDegrees(exactly: destiLati) else {return}
        guard let destiLongitude = CLLocationDegrees(exactly: destiLongi) else {return}
        let destination = CLLocationCoordinate2D(latitude: destiLatitude, longitude: destiLongitude)
        
        let bounds = GMSCoordinateBounds(coordinate: destination , coordinate: source)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        mapVM.mapView?.moveCamera(update)
    }
    
    func loadSourceDestination(){
        
        guard let sourceLat = trackVM?.latitude else {return}
        guard let sourceLong = trackVM?.longitude else {return}
        guard let sourceLati = Double(sourceLat) else {return}
        guard let sourceLongi = Double(sourceLong) else {return}
        
        guard let destiLat = trackVM?.address?.first?.latitude else {return}
        guard let destiLong = trackVM?.address?.first?.longitude else {return}
        guard let destiLati = Double(destiLat) else {return}
        guard let destiLongi = Double(destiLong) else {return}
       
        loadMarkers(latitude: sourceLati, longitude: sourceLongi, bearing: 0.0, marker: mapVM.startLocMarker, isSource: true)
        
        loadMarkers(latitude: destiLati, longitude: destiLongi, bearing: 0.0, marker: mapVM.endLocMarker, isSource: false)
        
//        loadMarkers(latitude: /trackVM.source?.latitude, longitude: /trackVM.source?.longitude, bearing: /trackVM.sourceBearing, marker: mapVM.startLocMarker, isSource: true)
//        loadMarkers(latitude: /trackVM.destination?.latitude, longitude: /trackVM.destination?.longitude, bearing: /trackVM.destinationBearing, marker: mapVM.endLocMarker, isSource: false)
    }
    
    func loadMarkers(latitude: Double , longitude: Double , bearing: Double , marker: GMSMarker, isSource: Bool){
        
        
        guard let sourceLat = trackVM?.latitude else {return}
        guard let sourceLong = trackVM?.longitude else {return}
        guard let sourceLati = Double(sourceLat) else {return}
        guard let sourceLongi = Double(sourceLong) else {return}
        guard let sourceLatitude = CLLocationDegrees(exactly: sourceLati) else {return}
        guard let sourceLongitude = CLLocationDegrees(exactly: sourceLongi) else {return}
        
        guard let destiLat = trackVM?.address?.first?.latitude else {return}
        guard let destiLong = trackVM?.address?.first?.longitude else {return}
        guard let destiLati = Double(destiLat) else {return}
        guard let destiLongi = Double(destiLong) else {return}
        guard let destiLatitude = CLLocationDegrees(exactly: destiLati) else {return}
        guard let destiLongitude = CLLocationDegrees(exactly: destiLongi) else {return}
        
        marker.position = CLLocationCoordinate2D(latitude: isSource ? sourceLatitude : destiLatitude , longitude: isSource ? sourceLongitude : destiLongitude)
        
//        marker.position = CLLocationCoordinate2D(latitude: isSource ? /trackVM.source?.latitude : /trackVM.destination?.latitude , longitude: isSource ? /trackVM.source?.longitude : /trackVM.destination?.longitude)
        marker.map = mapVM.mapView
        marker.isFlat = true
        marker.icon = isSource ? mapVM.startLocImage : mapVM.endLocImage
        //marker.rotation = isSource ? /trackVM.sourceBearing : /trackVM.destinationBearing
    }
    
}

//MARK::- SOCKET LISTENERS
extension TrackingViewController {
    
    func socketHandlers(){
      //  trackVM.mode == .driver ? makeOnLocationManager() : listenLocation()
    }
    
    func listenLocation(){
        SocketIOManagerTracking.shared.listenLocation {
            [weak self] (location) in
//            let newLoc = CLLocationCoordinate2D(latitude: /location.latitude, longitude: /location.longitude)
//            if (self?.trackVM.source?.latitude == newLoc.latitude && self?.trackVM.source?.longitude == newLoc.longitude) {
//                return
//            }
//            self?.trackVM.source = newLoc
//            self?.trackVM.sourceBearing = location.bearing
//            self?.trackVM.sourceAccuracy = location.horizontalAccuracy
            if let etaBlock = self?.etaBlock{
                etaBlock(/location.estimatedTimeInMinutes)
            }
            self?.updateNewLocationsWithBearingOnMap()
        }
//        makeOnLocationManager()
    }
    
    func sendLocation(locationObj:[String : Any]){
        
        SocketIOManagerTracking.shared.sendCurrentLocation(data: locationObj ) { (status) in
            print("sent location : " + "\(status)")
        }
    }
    
    func makeOnLocationManager(){
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = CLActivityType.automotiveNavigation
        if CLLocationManager.locationServicesEnabled() {
            getLoc()
        }
    }
    
}

//MARK::- LOCATION MANAGER FOR DRIVER SIDE
extension TrackingViewController : CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            getLoc()
        }
    }
    
    //Updated location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
//        if !(location.horizontalAccuracy <= 20) && location.speed < 35 &&  trackVM.source != nil{
//            return
//        }
//        if (trackVM.destination?.latitude == location.coordinate.latitude && trackVM.destination?.longitude == location.coordinate.longitude) {
//            return
//        }
//        trackVM.destination =  location.coordinate
//        trackVM.destinationBearing = location.course
//        trackVM.destinationBearing = location.horizontalAccuracy
        //sendLocation(locationObj: trackVM.locationDetails(location: location))
        updateNewLocationsWithBearingOnMap()
    }
    
    //MARK::- LOCATION SETTINGS
    func getLoc(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.distanceFilter = 10
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
}
