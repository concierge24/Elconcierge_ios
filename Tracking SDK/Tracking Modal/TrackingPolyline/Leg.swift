//
//	Leg.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Leg : Mappable{

	var distance : Distance?
	var duration : Distance?
	var endAddress : String?
	var endLocation : Northeast?
	var startAddress : String?
	var startLocation : Northeast?
	var steps : [Step]?
	var trafficSpeedEntry : [AnyObject]?
	var viaWaypoint : [AnyObject]?

    required init?(map: Map){
        mapping(map: map)
    }
    
//    class func newInstance(map: Map) -> Mappable?{
//        return Leg()
//    }
//    required init?(map: Map){}
//    private override init(){}

	func mapping(map: Map)
	{
		distance <- map["distance"]
		duration <- map["duration"]
		endAddress <- map["end_address"]
		endLocation <- map["end_location"]
		startAddress <- map["start_address"]
		startLocation <- map["start_location"]
		steps <- map["steps"]
		trafficSpeedEntry <- map["traffic_speed_entry"]
		viaWaypoint <- map["via_waypoint"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         distance = aDecoder.decodeObject(forKey: "distance") as? Distance
         duration = aDecoder.decodeObject(forKey: "duration") as? Distance
         endAddress = aDecoder.decodeObject(forKey: "end_address") as? String
         endLocation = aDecoder.decodeObject(forKey: "end_location") as? Northeast
         startAddress = aDecoder.decodeObject(forKey: "start_address") as? String
         startLocation = aDecoder.decodeObject(forKey: "start_location") as? Northeast
         steps = aDecoder.decodeObject(forKey: "steps") as? [Step]
         trafficSpeedEntry = aDecoder.decodeObject(forKey: "traffic_speed_entry") as? [AnyObject]
         viaWaypoint = aDecoder.decodeObject(forKey: "via_waypoint") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if distance != nil{
			aCoder.encode(distance, forKey: "distance")
		}
		if duration != nil{
			aCoder.encode(duration, forKey: "duration")
		}
		if endAddress != nil{
			aCoder.encode(endAddress, forKey: "end_address")
		}
		if endLocation != nil{
			aCoder.encode(endLocation, forKey: "end_location")
		}
		if startAddress != nil{
			aCoder.encode(startAddress, forKey: "start_address")
		}
		if startLocation != nil{
			aCoder.encode(startLocation, forKey: "start_location")
		}
		if steps != nil{
			aCoder.encode(steps, forKey: "steps")
		}
		if trafficSpeedEntry != nil{
			aCoder.encode(trafficSpeedEntry, forKey: "traffic_speed_entry")
		}
		if viaWaypoint != nil{
			aCoder.encode(viaWaypoint, forKey: "via_waypoint")
		}

	}

}
