//
//	RootClass.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

class DictionaryResponse <T : Mappable> :  Mappable{
    
    var message: String?
    var data : T?
    var success: String?
    var array : [T]?
    
    required init?(map: Map){
    }
    func mapping(map: Map){
        message <- map["message"]
        data <- map["data"]
        success <- map["success"]
        array <- map["data"]
        array <- map["results"]
    }
}


class PolyRootClass :  Mappable{

	var geocodedWaypoints : [GeocodedWaypoint]?
	var routes : [Route]?
	var status : String?


//    class func newInstance(map: Map) -> Mappable?{
//        return PolyRootClass()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map){
        mapping(map: map)
    }
    
	func mapping(map: Map)
	{
		geocodedWaypoints <- map["geocoded_waypoints"]
		routes <- map["routes"]
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         geocodedWaypoints = aDecoder.decodeObject(forKey: "geocoded_waypoints") as? [GeocodedWaypoint]
         routes = aDecoder.decodeObject(forKey: "routes") as? [Route]
         status = aDecoder.decodeObject(forKey: "status") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if geocodedWaypoints != nil{
			aCoder.encode(geocodedWaypoints, forKey: "geocoded_waypoints")
		}
		if routes != nil{
			aCoder.encode(routes, forKey: "routes")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
