//
//  OrderHistory.swift
//  Sneni
//
//  Created by MAc_mini on 01/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper

enum OrderHistoryKeys : String {
    
    case orderHistory = "orderHistory"
   
}

class OrderHistory: NSObject, RMMapping, NSCoding {
    
    var orderDetails:[OrderDetails]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(orderDetails, forKey: OrderHistoryKeys.orderHistory.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        orderDetails = aDecoder.decodeObject(forKey: OrderHistoryKeys.orderHistory.rawValue) as? [OrderDetails]
    }
    
    
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let dict = json[APIConstants.DataKey]
        let orderHistory = dict[OrderHistoryKeys.orderHistory.rawValue].arrayValue
        let agentArray = dict[OrderHistoryKeys.orderHistory.rawValue].arrayValue
        
        
        self.orderDetails = []
        for (_ , element) in orderHistory.enumerated(){
            
            let orderDict = OrderDetails(attributes: element.dictionaryValue)
            self.orderDetails?.append(orderDict)
        }
        
    }
    
//    init (attributes : Dictionary<String, JSON>?){
//
//         orderDetails = []
//
//        if let orderHistory = attributes?[OrderHistoryRelatedKeys.orderDetails.rawValue]?.arrayValue{
//
//            for (_ , element) in orderHistory.enumerated(){
//
//                let orderDict = OrderDetails(attributes: element.dictionaryValue)
//               orderDetails?.append(orderDict)
//            }
//        }
//
//    }
    
}
