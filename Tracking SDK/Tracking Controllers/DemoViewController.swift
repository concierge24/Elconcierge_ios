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
    
    //MARK:- PROPERTIES
    var mapController : TrackingViewController?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        mapController = TrackingViewController.getVC(.tracking)
        mapController?.trackVM = TrackingModal(source: nil , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0)
        self.addChildViewController(withChildViewController: mapController ?? UIViewController() , view: viewMap)
    }
    
    //just for demo to check how map ll update when user app got location from socket
    @IBAction func btnActions(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            mapController?.trackVM = TrackingModal(source: CLLocationCoordinate2D(latitude: 30.7585 , longitude:  76.6626) , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0)
            mapController?.updateNewLocationsWithBearingOnMap()
        default:
            mapController?.trackVM = TrackingModal(source: CLLocationCoordinate2D(latitude: 30.7304 , longitude:76.8015) , destination: CLLocationCoordinate2D(latitude: 30.7055 , longitude: 76.8013), sourceBearing: 0, destinationBearing: 0)
            mapController?.updateNewLocationsWithBearingOnMap()
        }
    }
    
}


