//
//  Order.swift
//  Sneni
//
//  Created by MAc_mini on 01/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper

enum OrderKeys : String {
    
    case order = "orderHistory"
    
}

class Order: NSObject, RMMapping, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(orderHistory, forKey: OrderKeys.order.rawValue)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        orderHistory = aDecoder.decodeObject(forKey: OrderKeys.order.rawValue) as? [OrderHistory]
       
    }
    
    
    var orderHistory:[OrderHistory]?
    
     init(sender : SwiftyJSONParameter){
        
//        guard let rawData = sender else { return }
//        
//        let json = JSON(rawData)
//        let dict = json[APIConstants.DataKey]
//        let orderHistory = dict[OrderKeys.order.rawValue].arrayValue
//        
//         self.orderHistory = []
//        for (_ , element) in orderHistory.enumerated(){
//            
//             let orderDict = OrderHistory(attributes: element.dictionaryValue)
//            self.orderHistory?.append(orderDict)
//        }
 
    }
}
