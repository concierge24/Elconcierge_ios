//
//  TrackingConstants.swift
//  GoogleMapTracking
//
//  Created by cbl24_Mac_mini on 09/05/19.
//  Copyright © 2019 GoogleMapTracking. All rights reserved.
//

import UIKit


internal struct TrackingConstants {
    
    static var polyLine = ""
    static var socketUrl = APIConstants.BasePath//"http://45.232.252.46:8081/"//APIConstants.BasePath//"http://45.232.252.46:8006"//"http://45.232.252.46:8081/"
    
    
    static var id = "id"
    static var socketTokenKey = "token"
    static var socketUserIdKey = "user_id"
    static var orderIdKey = "order_id"
    static var latitudeKey = "latitude"
    static var longitudeKey = "longitude"
    static var timestampKey = "timstamp"
    static var accuracyKey = "accuracy"
    static var bearingKey = "bearing"
    static var secretKey = "secretKey"
    static var secretdbkey = "secretdbkey"
    
    static var token = "Bearer asdadsad2341234"
    
    static var userId: Int {
        return /GDataSingleton.sharedInstance.loggedInUser?.id?.toInt()
    }
    
    static var orderId = "9"
    static var secretKeyValue = "9"
    
}
