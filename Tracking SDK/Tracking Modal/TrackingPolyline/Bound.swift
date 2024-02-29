//
//	Bound.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Bound :  Mappable{

	var northeast : Northeast?
	var southwest : Northeast?


//    class func newInstance(map: Map) -> Mappable?{
//        return Bound()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map){
        mapping(map: map)
    }
    
	func mapping(map: Map)
	{
		northeast <- map["northeast"]
		southwest <- map["southwest"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         northeast = aDecoder.decodeObject(forKey: "northeast") as? Northeast
         southwest = aDecoder.decodeObject(forKey: "southwest") as? Northeast

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if northeast != nil{
			aCoder.encode(northeast, forKey: "northeast")
		}
		if southwest != nil{
			aCoder.encode(southwest, forKey: "southwest")
		}

	}

}
