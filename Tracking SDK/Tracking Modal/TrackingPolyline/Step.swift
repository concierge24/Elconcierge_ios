//
//	Step.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Step : Mappable{

	var distance : Distance?
	var duration : Distance?
	var endLocation : Northeast?
	var htmlInstructions : String?
	var maneuver : String?
	var polyline : Polyline?
	var startLocation : Northeast?
	var travelMode : String?

    required init?(map: Map){
        mapping(map: map)
    }
    

//    class func newInstance(map: Map) -> Mappable?{
//        return Step()
//    }
//    required init?(map: Map){}
//    private override init(){}

	func mapping(map: Map)
	{
		distance <- map["distance"]
		duration <- map["duration"]
		endLocation <- map["end_location"]
		htmlInstructions <- map["html_instructions"]
		maneuver <- map["maneuver"]
		polyline <- map["polyline"]
		startLocation <- map["start_location"]
		travelMode <- map["travel_mode"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         distance = aDecoder.decodeObject(forKey: "distance") as? Distance
         duration = aDecoder.decodeObject(forKey: "duration") as? Distance
         endLocation = aDecoder.decodeObject(forKey: "end_location") as? Northeast
         htmlInstructions = aDecoder.decodeObject(forKey: "html_instructions") as? String
         maneuver = aDecoder.decodeObject(forKey: "maneuver") as? String
         polyline = aDecoder.decodeObject(forKey: "polyline") as? Polyline
         startLocation = aDecoder.decodeObject(forKey: "start_location") as? Northeast
         travelMode = aDecoder.decodeObject(forKey: "travel_mode") as? String

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
		if endLocation != nil{
			aCoder.encode(endLocation, forKey: "end_location")
		}
		if htmlInstructions != nil{
			aCoder.encode(htmlInstructions, forKey: "html_instructions")
		}
		if maneuver != nil{
			aCoder.encode(maneuver, forKey: "maneuver")
		}
		if polyline != nil{
			aCoder.encode(polyline, forKey: "polyline")
		}
		if startLocation != nil{
			aCoder.encode(startLocation, forKey: "start_location")
		}
		if travelMode != nil{
			aCoder.encode(travelMode, forKey: "travel_mode")
		}

	}

}
