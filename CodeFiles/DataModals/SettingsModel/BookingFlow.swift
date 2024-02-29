//
//  BookingFlow.swift
//  Sneni
//
//  Created by MAc_mini on 11/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum BookingFlowKeys : String {
    case vendor_status
    case cart_flow
    case is_scheduled
    case schedule_time
    case admin_order_priority
    case is_pickup_order
    case interval
}


enum CartFlowSettingType : Int {
    case oneToOne = 0
    case oneToMany
    case manyToOne
    case manyToMany
    
    var isOneQty: Bool {
        return self == .oneToOne || self == .manyToOne
    }
    
    var isManyQty: Bool {
        return self == .oneToMany || self == .manyToMany
    }
}

enum VendorStatusSettingType : Int {
    case one = 0
    case many
}
open class DefaultAddress : Mappable {
    public var latitude: Double?
    public var longitude : Double?
    public var address : String?
    
    required public init?(map: Map) {
           
    }
       
    public func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        address <- map["address"]

    }
}
class BookingFlow : Mappable {
    
    var vendorStatus: Int? = 0
    var cartFlow: Int? = 0
    var is_scheduled : Int?
    var schedule_time : Int?
    var admin_order_priority : Int?
    var is_pickup_order : Int?
    var interval: Int? = 30
    var booking_track_status : Int?
    
//    init (attributes : Dictionary<String, JSON>?){
//
//        self.vendorStatus = attributes?["booking_track_status"]?.intValue ?? 0
//        self.vendorStatus = attributes?[BookingFlowKeys.vendor_status.rawValue]?.intValue ?? 0
//        self.cartFlow = attributes?[BookingFlowKeys.cart_flow.rawValue]?.intValue ?? 0
//        self.is_scheduled = attributes?[BookingFlowKeys.is_scheduled.rawValue]?.intValue
//        self.schedule_time = attributes?[BookingFlowKeys.schedule_time.rawValue]?.intValue
//        self.admin_order_priority = attributes?[BookingFlowKeys.admin_order_priority.rawValue]?.intValue
//        self.is_pickup_order = attributes?[BookingFlowKeys.is_pickup_order.rawValue]?.intValue
//        self.interval = attributes?[BookingFlowKeys.interval.rawValue]?.intValue ?? 30
//        if /self.interval <= 0 {
//            self.interval = 1
//        }
//
//        if AppSettings.shared.cartFlow.rawValue != cartFlow {
//             DBManager.sharedManager.cleanCart()
//        }
//
//    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        booking_track_status <- map["booking_track_status"]
        vendorStatus <- map[BookingFlowKeys.vendor_status.rawValue]
        cartFlow <- map[BookingFlowKeys.cart_flow.rawValue]
        is_scheduled <- map[BookingFlowKeys.is_scheduled.rawValue]
        schedule_time <- map[BookingFlowKeys.schedule_time.rawValue]
        admin_order_priority <- map[BookingFlowKeys.admin_order_priority.rawValue]
        is_pickup_order <- map[BookingFlowKeys.is_pickup_order.rawValue]
        interval <- map[BookingFlowKeys.interval.rawValue]
        if /self.interval <= 0 {
            self.interval = 1
        }

    }
    
    
//    func encode(with aCoder: NSCoder) {
//        
//        aCoder.encode(booking_track_status, forKey: "booking_track_status")
//        aCoder.encode(vendorStatus, forKey: "vendor_status")
//        aCoder.encode(cartFlow, forKey: "cart_flow")
//        aCoder.encode(is_scheduled, forKey: "is_scheduled")
//        aCoder.encode(schedule_time, forKey: "schedule_time")
//        aCoder.encode(admin_order_priority, forKey: "admin_order_priority")
//        aCoder.encode(is_pickup_order, forKey: "is_pickup_order")
//        aCoder.encode(interval, forKey: "interval")
//
//        
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//
//        booking_track_status = aDecoder.decodeObject(forKey: "booking_track_status") as? Int
//        vendorStatus = aDecoder.decodeObject(forKey: "vendor_status") as? Int
//        cartFlow = aDecoder.decodeObject(forKey: "cart_flow") as? Int
//        is_scheduled = aDecoder.decodeObject(forKey: "is_scheduled") as? Int
//        schedule_time = aDecoder.decodeObject(forKey: "schedule_time") as? Int
//        is_pickup_order = aDecoder.decodeObject(forKey: "is_pickup_order") as? Int
//        interval = aDecoder.decodeObject(forKey: "interval") as? Int
//        
//    }
}
