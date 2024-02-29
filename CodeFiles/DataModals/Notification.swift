//
//  Notification.swift
//  Clikat
//
//  Created by Night Reaper on 26/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum NotificationKeys : String {
    case id = "id"
    case notification_message = "notification_message"
    case time = "time"
    case logo = "logo"
    case is_read = "is_read"
    case order_id = "order_id"
    case notification_status = "notification_status"
}



class NotificationClass{

    var id : String?
    var message : String?
    var time : String?
    var image : String?
    var isRead : String?
    var orderId : String?
    var status : String?
    
    init (attributes : SwiftyJSONParameter){
        self.id = attributes?[NotificationKeys.id.rawValue]?.stringValue
        self.message = attributes?[NotificationKeys.notification_message.rawValue]?.stringValue
        self.time = attributes?[NotificationKeys.time.rawValue]?.stringValue
        self.image = attributes?[NotificationKeys.logo.rawValue]?.stringValue
        self.image = self.image?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        self.isRead = attributes?[NotificationKeys.is_read.rawValue]?.stringValue
        self.orderId = attributes?[NotificationKeys.order_id.rawValue]?.stringValue
        self.status = attributes?[NotificationKeys.notification_status.rawValue]?.stringValue
    }
}



class NotificationListing {
    
    var arrayNotifications : [NotificationClass]?
    var totalCount: Int?
    
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json["notification"]
        let unformattedNotifications = dict.arrayValue
        var notifications : [NotificationClass] = []
        
        for element in unformattedNotifications{
            let supplier = NotificationClass(attributes: element.dictionaryValue)
            notifications.append(supplier)
        }
        self.arrayNotifications = notifications
        self.totalCount = json["count"].intValue
    }
    
}
