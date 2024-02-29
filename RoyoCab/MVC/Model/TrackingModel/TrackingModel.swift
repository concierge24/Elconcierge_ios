//
//  TrackingModel.swift
//  Buraq24
//
//  Created by MANINDER on 22/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper


class TrackingModel: NSObject, Mappable {

    var socketType :OrderEventType?
    var orderId : Int?
    var driverId : Int?
    var driverLatitude : Double?
    var driverLongitude : Double?
    var bearing : Double?
    var orderStatus : OrderStatus  = .Searching
    var polyline :String?
    var etaTime :String?
    var updated_at: String?
    var accepted_at : String?
    
    var orderTurn : OrderTurn  = .MyTurn
  
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        var strSocket : String?
        strSocket <- map["type"]
        
        guard let typeOrder = OrderEventType(rawValue: /strSocket) else {return}
        socketType = typeOrder
        orderId <- map["order_id"]
        driverId <- map["driver_id"]
        driverLatitude <- map["latitude"]
        driverLongitude <- map["longitude"]
        bearing <- map["bearing"]
        polyline <- map["polyline.points"]
        etaTime <- map["polyline.timeText"]
        updated_at <- map["updated_at"]
        accepted_at <- map["accepted_at"]
        
        var strOrderStatus : String?
        strOrderStatus <- map["order_status"]
        guard let statusOrder = OrderStatus(rawValue: /strOrderStatus) else {return}
        orderStatus = statusOrder
        
        var strTurnStatus : String?
        strTurnStatus <- map["my_turn"]
        guard let statusTurn = OrderTurn(rawValue: /strTurnStatus) else {return}
        orderTurn = statusTurn
      
    }
}
