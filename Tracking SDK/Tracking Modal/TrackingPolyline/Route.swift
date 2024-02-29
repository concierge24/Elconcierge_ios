//
//	Route.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Route : Mappable{

	var bounds : Bound?
	var copyrights : String?
	var legs : [Leg]?
	var overviewPolyline : Polyline?
	var summary : String?
	var warnings : [AnyObject]?
	var waypointOrder : [AnyObject]?


//    class func newInstance(map: Map) -> Mappable?{
//        return Route()
//    }
//    required init?(map: Map){}
//    private override init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }

	func mapping(map: Map)
	{
		bounds <- map["bounds"]
		copyrights <- map["copyrights"]
		legs <- map["legs"]
		overviewPolyline <- map["overview_polyline"]
		summary <- map["summary"]
		warnings <- map["warnings"]
		waypointOrder <- map["waypoint_order"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bounds = aDecoder.decodeObject(forKey: "bounds") as? Bound
         copyrights = aDecoder.decodeObject(forKey: "copyrights") as? String
         legs = aDecoder.decodeObject(forKey: "legs") as? [Leg]
         overviewPolyline = aDecoder.decodeObject(forKey: "overview_polyline") as? Polyline
         summary = aDecoder.decodeObject(forKey: "summary") as? String
         warnings = aDecoder.decodeObject(forKey: "warnings") as? [AnyObject]
         waypointOrder = aDecoder.decodeObject(forKey: "waypoint_order") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bounds != nil{
			aCoder.encode(bounds, forKey: "bounds")
		}
		if copyrights != nil{
			aCoder.encode(copyrights, forKey: "copyrights")
		}
		if legs != nil{
			aCoder.encode(legs, forKey: "legs")
		}
		if overviewPolyline != nil{
			aCoder.encode(overviewPolyline, forKey: "overview_polyline")
		}
		if summary != nil{
			aCoder.encode(summary, forKey: "summary")
		}
		if warnings != nil{
			aCoder.encode(warnings, forKey: "warnings")
		}
		if waypointOrder != nil{
			aCoder.encode(waypointOrder, forKey: "waypoint_order")
		}

	}

}
