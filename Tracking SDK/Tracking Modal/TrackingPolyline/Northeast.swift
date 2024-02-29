//
//	Northeast.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Northeast :  Mappable{

	var lat : Float?
	var lng : Float?


//    class func newInstance(map: Map) -> Mappable?{
//        return Northeast()
//    }
//    required init?(map: Map){}
//    private override init(){}
    
    required init?(map: Map){
        mapping(map: map)
    }

	func mapping(map: Map)
	{
		lat <- map["lat"]
		lng <- map["lng"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         lat = aDecoder.decodeObject(forKey: "lat") as? Float
         lng = aDecoder.decodeObject(forKey: "lng") as? Float

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if lat != nil{
			aCoder.encode(lat, forKey: "lat")
		}
		if lng != nil{
			aCoder.encode(lng, forKey: "lng")
		}

	}

}
