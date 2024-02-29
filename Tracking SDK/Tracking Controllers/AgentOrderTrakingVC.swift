//
//  DemoViewController.swift
//  GoogleMapTracking
//
//  Created by cbl24_Mac_mini on 09/05/19.
//  Copyright © 2019 GoogleMapTracking. All rights reserved.
//

import UIKit
import CoreLocation

class AgentOrderTrakingVC: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet weak var viewMap: UIView!
    @IBOutlet weak var lblEta: UILabel!

    //MARK:- PROPERTIES
    var mapController : TrackingViewController?
    var orderDetails : OrderDetails?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocation()
        ///Socket Init
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        initSocket()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
        SocketIOManagerTracking.shared.disconnect()
        
    }
    
    //just for demo to check how map ll update when user app got location from socket
    @IBAction func btnActions(_ sender: UIButton) {
//        switch sender.tag {
//        case 0:
//            mapController?.trackVM = TrackingModal(source: CLLocationCoordinate2D(latitude: 30.7585 , longitude:  76.6626) , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0)
//            mapController?.updateNewLocationsWithBearingOnMap()
//        default:
//            mapController?.trackVM = TrackingModal(source: CLLocationCoordinate2D(latitude: 30.7304 , longitude:76.8015) , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0)
//            mapController?.updateNewLocationsWithBearingOnMap()
//        }
    }
    
}

//MARK:- ======== Socket Handling ========
extension AgentOrderTrakingVC {
    
    func initSocket() {
        SocketIOManagerTracking.shared.addHandlers()
        
//        SocketIOManagerTracking.shared.listenLocation {
//            [weak self] (obj) in
//            guard let self = self else { return }
//
////            let objLoc = CLLocationCoordinate2D(latitude: /obj.latitude , longitude:  /obj.longitude)
////            self.mapController?.trackVM.destination = objLoc
////            self.mapController?.updateNewLocationsWithBearingOnMap()
////            self.mapController?.changeCamera(latitude: objLoc.latitude, longitude: objLoc.longitude)
//
////            self.mapController?.trackVM = TrackingModal(source: objLoc, destination: CLLocationCoordinate2D(latitude: 30.7585 , longitude:  76.6626), sourceBearing: 0, destinationBearing: 0)
//            self.mapController?.updateNewLocationsWithBearingOnMap()
//
//
//        }
        
    }
    
}


//MARK:- ======== Socket Handling ========
extension AgentOrderTrakingVC {
    
    func initLocation() {
        
        mapController = TrackingViewController.getVC(.tracking)
        
        if false {
//            mapController?.trackVM = TrackingModal(source: CLLocationCoordinate2D(latitude: 30.7304 , longitude:76.8015) , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0, isPolyLineEnabled: true)
        } else {
            guard let sourceLat = LocationSingleton.sharedInstance.selectedLatitude else {return}
            guard let sourceLong =  LocationSingleton.sharedInstance.selectedLongitude else {return}
            
            guard let destiLat = orderDetails?.agentArray?.first?.lat else {return}
            guard let destiLong = orderDetails?.agentArray?.first?.long else {return}

            let trakingAdd = TrackingAddressModal(latitude: String(sourceLat), longitude:  String(sourceLong))
            mapController?.trackVM = TrackingModal(client_secret_key: nil, latitude: String(destiLat), longitude: String(destiLong), order_id: nil, status: nil, user_id: nil, address: [trakingAdd])
            mapController?.etaBlock = { [weak self](eta) in
                          
                  DispatchQueue.main.async {
                      self?.lblEta.text = eta
                  }
                  
              }
            
        }
        self.addChildViewController(withChildViewController: mapController ?? UIViewController() , view: viewMap)
    }
    
}
