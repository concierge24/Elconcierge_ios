//
//	GeocodedWaypoint.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class GeocodedWaypoint :  Mappable{

	var geocoderStatus : String?
	var placeId : String?
	var types : [String]?


//    class func newInstance(map: Map) -> Mappable?{
//        return GeocodedWaypoint()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map){
        mapping(map: map)
    }
    
	func mapping(map: Map)
	{
		geocoderStatus <- map["geocoder_status"]
		placeId <- map["place_id"]
		types <- map["types"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         geocoderStatus = aDecoder.decodeObject(forKey: "geocoder_status") as? String
         placeId = aDecoder.decodeObject(forKey: "place_id") as? String
         types = aDecoder.decodeObject(forKey: "types") as? [String]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if geocoderStatus != nil{
			aCoder.encode(geocoderStatus, forKey: "geocoder_status")
		}
		if placeId != nil{
			aCoder.encode(placeId, forKey: "place_id")
		}
		if types != nil{
			aCoder.encode(types, forKey: "types")
		}

	}

}
