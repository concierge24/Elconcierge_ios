//
//  TrackingModal.swift
//  GoogleMapTracking
//
//  Created by cbl24_Mac_mini on 10/05/19.
//  Copyright © 2019 GoogleMapTracking. All rights reserved.
//


import UIKit
import CoreLocation
import GoogleMaps

class TrackingAddressModal : NSObject {

    var address_line_1 : String?
    var address_line_2 : String?
    var address_link : String?
    var city : String?
    var customer_address : String?
    var directions_for_delivery : String?
    var id : Int?
    var is_deleted : Int?
    var landmark : String?
    var latitude : String?
    var longitude : String?
    var name : String?
    var order_id : Int?
    var pincode : String?
    var type : Int?

    //MARK::- INITIALIZERS
    override init() {
        super.init()
    }
    
    init(latitude: String?,longitude:String?) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

class TrackingModal : NSObject{
    
    var client_secret_key: String?
    var latitude: String?
    var longitude: String?
    var order_id: String?
    var status: Int?
    var user_id: Int?
    var address : [TrackingAddressModal]?
    var polyLine : PolyRootClass?
    var updatePolyLine : (() -> ())?

    //MARK::- INITIALIZERS
    override init() {
        super.init()
    }
    
    init(client_secret_key: String?,latitude: String?,longitude: String?,order_id: String?,status: Int?,user_id: Int?,address: [TrackingAddressModal]?) {
        
        self.client_secret_key = client_secret_key
        self.latitude = latitude
        self.longitude = longitude
        self.order_id = order_id
        self.status = status
        self.user_id = user_id
        self.address = address

    }
//    //MARK::- OUTLETS
//    var source: CLLocationCoordinate2D?
//    var sourceBearing: Double?
//    var sourceAccuracy : Double?
//
//    var destination: CLLocationCoordinate2D?
//    var destinationBearing: Double?
//
//    var oldCordinates : CLLocationCoordinate2D?
//
//    var mode :TrackingMode?
//
//    var polyLine : PolyRootClass?
//    var updatePolyLine : (() -> ())?
//    var mapPadding = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
//    var isPolyLineEnabled = false
//

//
//    init(source:CLLocationCoordinate2D? , destination:CLLocationCoordinate2D? , sourceBearing: Double? , destinationBearing: Double? , mode: TrackingMode = .user , mapPadding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) , isPolyLineEnabled: Bool = false) {
//        self.source = source
//        self.destination = destination
//        self.sourceBearing = sourceBearing
//        self.destinationBearing = destinationBearing
//        self.mode = mode
//        self.isPolyLineEnabled = isPolyLineEnabled
//        self.mapPadding = mapPadding //to set padding for Google label
//    }
    
    //THIS IS THE OBJECT WHICH WE WANT TO SEND IN SOCKETS
    func locationDetails(location: CLLocation?) -> [String:Any] {
        //this dictionary object must contain - lat , long, bearing, accuracy, timestamp
        var locationObj = [String:String]()
        locationObj[TrackingConstants.socketTokenKey] = TrackingConstants.token
        locationObj[TrackingConstants.socketUserIdKey] = TrackingConstants.userId.toString
        locationObj[TrackingConstants.orderIdKey] = TrackingConstants.orderId
        locationObj[TrackingConstants.latitudeKey] = "\(/location?.coordinate.latitude)"
        locationObj[TrackingConstants.longitudeKey] = "\(/location?.coordinate.longitude)"
        locationObj[TrackingConstants.accuracyKey] = "\(/location?.horizontalAccuracy)"
        locationObj[TrackingConstants.bearingKey] = "\(/location?.course)"
        if /TrackingConstants.secretKey != ""{
            locationObj[TrackingConstants.secretKey] = TrackingConstants.secretKeyValue
        }
        return locationObj
    }
    
}

//MARK::- MAP PROPERTIES
class MapRequirementsViewModal  {
    
    var mapView: GMSMapView!
    var startLocMarker = GMSMarker()
    var endLocMarker = GMSMarker()
    var polyline: GMSPolyline?
    lazy var startLocImage: UIImage? = {
        if SKAppType.type == .food {
            return UIImage(named: "img_DriveryBoy")
        }
        return UIImage(named: "img_truck")
    }()
    var endLocImage = UIImage(named: "dotPurple")
    
}



//MODES OF TRACKING
enum TrackingMode {
    case user
    case driver
}


extension TrackingModal {
    
    //MARK::- RETRIEVE POLYLINE
    
    func retrievePolyline(){
//        if !isPolyLineEnabled { return }
//        if source == nil { return }
        TrackingConstants.polyLine = "json"
        OtherEP.polyLineRoutes(sourceLat: "\(/latitude)" , sourceLng: "\(/longitude)" , destLat: "\(/address?.first?.latitude)" , destLng: "\(/address?.first?.longitude)" ).request(success: { [weak self] (response) in
            guard let polyLineData = response as? PolyRootClass else { return }
            self?.polyLine = polyLineData
            self?.updatePolyLine?()
        }, error: { (_) in }) { (_) in }
        
    }
}
