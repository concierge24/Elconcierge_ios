//
//  TrackEtokenViewController.swift
//  Buraq24
//
//  Created by Apple on 04/01/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class TrackEtokenViewController: UIViewController {
    
    //MARK:- Outlets
    
    var currentLocation : CLLocation?
    
    var isMapLoaded : Bool = false
    var timerMovingVehicle : Timer?
    var currentSeconds: Float  = 0
    
    var polyline : GMSPolyline?
    var isPolylineFirstCreated = false
    
    
    
    lazy var driverMarker = GMSMarker()
    lazy  var userMarker  = GMSMarker()
    
    var durationLeft : String = ""
    
    
    var source : CLLocationCoordinate2D?
    var OrderDestination : CLLocationCoordinate2D?

    
    var isDoneCurrentPolyline : Bool = true
    
    var isCurrent : Bool = false
    var isFocus  : Bool = false
    var lastPoints : String = ""
    var driverBearing : Double?
    var isSearching : Bool = false
    
    var locationLatest : String = ""
    var latitudeLatest : Double?
    var longitudeLatest : Double?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK:- Properties

    var model:TrackingModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let updatedDriver = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model?.driverLatitude) , longitude: CLLocationDegrees(/model?.driverLongitude))
        self.getPolylineRoute(source: updatedDriver , destination: OrderDestination, model: model)
        
        print("\(LocalNotifications.ETokenTrackingRefresh.rawValue)\(/model?.orderId)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(getOrderDetails), name: NSNotification.Name(rawValue: "\(LocalNotifications.ETokenRefresh.rawValue)\(/model?.orderId)"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapView), name: NSNotification.Name(rawValue: "\(LocalNotifications.ETokenTrackingRefresh.rawValue)\(/model?.orderId)"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func  updateMapView(){
        
        let oldLocation:CLLocation = CLLocation.init(latitude: /self.model?.driverLatitude, longitude: /self.model?.driverLongitude)
        let newLocation:CLLocation = CLLocation.init(latitude: /AllOrdersOngoing.ordersOngoing["\(model?.orderId)"]?.driverLatitude, longitude: /AllOrdersOngoing.ordersOngoing["\(model?.orderId)"]?.driverLongitude)
        
        let distance = self.getDistance(newPosition: newLocation, previous: oldLocation)
        
        if distance < 10  && isPolylineFirstCreated{
            return
        }
        
        self.model =  AllOrdersOngoing.ordersOngoing["\(/model?.orderId)"]
        
        let updatedDriver = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model?.driverLatitude) , longitude: CLLocationDegrees(/model?.driverLongitude))
        
        self.getPolylineRoute(source: updatedDriver , destination: OrderDestination, model: model)
        
    }
    
    //MARK:- Action methods

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TrackEtokenViewController: GMSMapViewDelegate {
    
    func getDistance( newPosition : CLLocation , previous : CLLocation ) -> Float {
        return Float(newPosition.distance(from: previous))
    }
    
    func  getPolylineRoute(source: CLLocationCoordinate2D? , destination: CLLocationCoordinate2D?, model: TrackingModel? ){
        
        if isDoneCurrentPolyline {
            
            isDoneCurrentPolyline = false
            
            // driver giving direction data, and time
            
            if model != nil && model?.polyline != ""  {
                if self.model?.orderStatus == .CustomerCancel  {return}
                self.durationLeft = /model?.etaTime
                self.updateDriverCustomerMarker(driverLocation: self.source, customerLocation: OrderDestination , trackString: model?.polyline)
                self.isDoneCurrentPolyline = true
                return
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(/source?.latitude),\(/source?.longitude)&destination=\(/destination?.latitude),\(/destination?.longitude)&sensor=true&mode=driving&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)")!
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    
                    self.isDoneCurrentPolyline = true
                    debugPrint(error!.localizedDescription)
                    
                }else {
                    do {
                        
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                                guard let routes = json["routes"] as? NSArray else {return}
                                
                                if (routes.count > 0) {
                                    
                                    let overview_polyline = routes[0] as? NSDictionary
                                    let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                    
                                    guard let points = dictPolyline?.object(forKey: "points") as? String else { return }
                                    
                                    guard let legs  = routes[0] as? NSDictionary , let legsJ = legs["legs"] as? NSArray , let lg = legsJ[0] as? NSDictionary else { return }
                                    let duration = lg["duration"] as? NSDictionary
                                    let durationLeft1 = duration?.object(forKey: "text") as? String
                                    
                                    if self?.model?.orderStatus == .CustomerCancel  {return}
                                    
                                    self?.durationLeft = /durationLeft1
                                    
                                    let updatedDriver = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model?.driverLatitude) , longitude: CLLocationDegrees(/model?.driverLongitude))
                                    self?.updateDriverCustomerMarker(driverLocation: updatedDriver, customerLocation: self?.OrderDestination , trackString: points)
                                    self?.isDoneCurrentPolyline = true
                                }
                            }
                        }
                    }catch {
                        debugPrint("error in JSONSerialization")
                    }
                }
            })
            task.resume()
        }
    }
    
    func showPath(polyStr :String){
        
        ez.runThisInMainThread { [weak self] in
            
            let path = GMSMutablePath(fromEncodedPath: polyStr) // Path
            self?.polyline = GMSPolyline(path: path)
            self?.polyline?.geodesic = true
            self?.polyline?.strokeWidth = 4
            
            if let mapType = UserDefaultsManager.shared.mapType {
                guard let mapEnum = BuraqMapType(rawValue: mapType) else { return }
                self?.polyline?.strokeColor  = mapEnum == .Hybrid ? .darkGray : .white
            }
            self?.polyline?.map = self?.mapView
            
            guard let path1 = GMSMutablePath(fromEncodedPath: /polyStr) else { return }
            let bounds = GMSCoordinateBounds(path: path1)
            self?.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            
            
        }
    }
    
    func updateDriverCustomerMarker( driverLocation : CLLocationCoordinate2D? , customerLocation  : CLLocationCoordinate2D? , trackString : String?) {
        
        ez.runThisInMainThread { [weak self] in
            
            guard let source = driverLocation , let destination = customerLocation  else { return }
//            guard let currOrder = self?.model else {return}
       
                self?.userMarker.icon = #imageLiteral(resourceName: "DropMarker")
            self?.mapView.clear()
            
            self?.userMarker.isFlat = false
            self?.userMarker.map = self?.mapView
            self?.userMarker.position = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
            
            self?.driverMarker.icon = UIImage().getDriverImage(type:2)
            self?.driverMarker.isFlat = false
            self?.driverMarker.map = self?.mapView
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.5)
            
            self?.isPolylineFirstCreated = true
            
            self?.driverMarker.position = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
            self?.driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            if let degrees = self?.driverBearing  {
                self?.driverMarker.rotation = /CLLocationDegrees(degrees)
            }
            CATransaction.commit()
            guard let lineTrack = trackString  else { return }
            self?.showPath(polyStr: lineTrack)
        }
    }
    
    //MARK:- Network Request
    
    @objc func getOrderDetails() {
        
         self.popVC()
        
//        guard let orderID = self.model?.orderId else {  return }
//        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
//
//        let objDetail = BookServiceEndPoint.orderDetails(orderID: orderID)
//
//        objDetail.request(header: ["access_token" :  token]) { [weak self] (response) in
//            switch response {
//            case .success(let data):
//
//                if let order = data as? Order {
//                        self?.popVC()
//                }
//            case .failure(let strError):
//                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
//            }
//        }
    }

}

