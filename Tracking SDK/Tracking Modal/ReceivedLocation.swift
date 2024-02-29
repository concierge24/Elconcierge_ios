//
//  ReceivedLocation.swift
//  GoogleMapTracking
//
//  Created by cbl24_Mac_mini on 10/05/19.
//  Copyright © 2019 GoogleMapTracking. All rights reserved.
//

import UIKit
import ObjectMapper


class ReceivedLocation: NSObject, NSCoding, Mappable {
    
    var address : Addres?
    var latitude : String?
    var longitude : String?
    var orderId : Int?
    var status : Int?
    var userId : Int?
    var bearing: String?
    var accuracy: String?
    var estimatedTimeInMinutes: String?
    
    class func newInstance(map: Map) -> Mappable?{
        return ReceivedLocation()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        orderId <- map["order_id"]
        status <- map["status"]
        userId <- map["user_id"]
        bearing <- map["bearing"]
        accuracy <- map["accuracy"]
        estimatedTimeInMinutes <- map["estimatedTimeInMinutes"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? Addres
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        orderId = aDecoder.decodeObject(forKey: "order_id") as? Int
        status = aDecoder.decodeObject(forKey: "status") as? Int
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
         estimatedTimeInMinutes = aDecoder.decodeObject(forKey: "estimatedTimeInMinutes") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if orderId != nil{
            aCoder.encode(orderId, forKey: "order_id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        
        if estimatedTimeInMinutes != nil{
            aCoder.encode(estimatedTimeInMinutes, forKey: "estimatedTimeInMinutes")
        }
        
    }
    
}

class Addres : NSObject, NSCoding, Mappable {
    
    var addressLine1 : String?
    var addressLine2 : String?
    var addressLink : String?
    var city : String?
    var customerAddress : String?
    var directionsForDelivery : String?
    var id : Int?
    var isDeleted : Int?
    var landmark : String?
    var name : String?
    var orderId : Int?
    var pincode : String?
    var type : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Addres()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        addressLine1 <- map["address_line_1"]
        addressLine2 <- map["address_line_2"]
        addressLink <- map["address_link"]
        city <- map["city"]
        customerAddress <- map["customer_address"]
        directionsForDelivery <- map["directions_for_delivery"]
        id <- map["id"]
        isDeleted <- map["is_deleted"]
        landmark <- map["landmark"]
        name <- map["name"]
        orderId <- map["order_id"]
        pincode <- map["pincode"]
        type <- map["type"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        addressLine1 = aDecoder.decodeObject(forKey: "address_line_1") as? String
        addressLine2 = aDecoder.decodeObject(forKey: "address_line_2") as? String
        addressLink = aDecoder.decodeObject(forKey: "address_link") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        customerAddress = aDecoder.decodeObject(forKey: "customer_address") as? String
        directionsForDelivery = aDecoder.decodeObject(forKey: "directions_for_delivery") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? Int
        landmark = aDecoder.decodeObject(forKey: "landmark") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        orderId = aDecoder.decodeObject(forKey: "order_id") as? Int
        pincode = aDecoder.decodeObject(forKey: "pincode") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if addressLine1 != nil{
            aCoder.encode(addressLine1, forKey: "address_line_1")
        }
        if addressLine2 != nil{
            aCoder.encode(addressLine2, forKey: "address_line_2")
        }
        if addressLink != nil{
            aCoder.encode(addressLink, forKey: "address_link")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if customerAddress != nil{
            aCoder.encode(customerAddress, forKey: "customer_address")
        }
        if directionsForDelivery != nil{
            aCoder.encode(directionsForDelivery, forKey: "directions_for_delivery")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if landmark != nil{
            aCoder.encode(landmark, forKey: "landmark")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if orderId != nil{
            aCoder.encode(orderId, forKey: "order_id")
        }
        if pincode != nil{
            aCoder.encode(pincode, forKey: "pincode")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        
    }
    
}

class SearchedLocation: NSObject,NSCoding {
    
    var lat : Double?
    var long : Double?
    var formattedAddress : String {
        if let add = addLine2, !add.isEmpty {
            return /addLine1 + ", " + add
        }
        return /addLine1
    }
    var addLine1 : String?
    var addLine2 : String?
    var placeid : String?
    var locality : String?
    var country : String?
    var placemark: CLPlacemark?
    var id:String?
    
    init(lat : Double?,long : Double?, addLine1 : String?, addLine2 : String?,placeid : String?,locality : String?,country : String?,placemark:CLPlacemark?,id:String? ){
        
        super.init()
        
        self.lat = lat
        self.long = long
        self.addLine1 = addLine1
        self.addLine2 = addLine2
        self.placeid = placeid
        self.locality = locality
        self.country = country
        self.placemark = placemark
        self.id = id
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(long, forKey: "long")
        aCoder.encode(addLine1, forKey: "addLine1")
        aCoder.encode(addLine2, forKey: "addLine2")
        aCoder.encode(placeid, forKey: "placeid")
        aCoder.encode(locality, forKey: "locality")
        aCoder.encode(country, forKey: "country")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        lat = aDecoder.decodeObject(forKey: "lat") as? Double
        long = aDecoder.decodeObject(forKey: "long") as? Double
        addLine1 = aDecoder.decodeObject(forKey: "addLine1") as? String
        addLine2 = aDecoder.decodeObject(forKey: "addLine2") as? String
        placeid = aDecoder.decodeObject(forKey: "placeid") as? String
        locality = aDecoder.decodeObject(forKey: "locality") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        
    }
}
