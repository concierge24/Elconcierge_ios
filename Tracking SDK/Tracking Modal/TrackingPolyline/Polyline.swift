//
//	Polyline.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Polyline :  Mappable{

	var points : String?


//    class func newInstance(map: Map) -> Mappable?{
//        return Polyline()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map){
        mapping(map: map)
    }
    
	func mapping(map: Map)
	{
		points <- map["points"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         points = aDecoder.decodeObject(forKey: "points") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if points != nil{
			aCoder.encode(points, forKey: "points")
		}

	}

}
