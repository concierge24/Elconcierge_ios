//
//	Distance.swift
//
//	Create by cbl24_Mac_mini on 9/5/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Distance :  Mappable{

	var text : String?
	var value : Int?


//    class func newInstance(map: Map) -> Mappable?{
//        return Distance()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map){
        mapping(map: map)
    }
    
	func mapping(map: Map)
	{
		text <- map["text"]
		value <- map["value"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         text = aDecoder.decodeObject(forKey: "text") as? String
         value = aDecoder.decodeObject(forKey: "value") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}
		if value != nil{
			aCoder.encode(value, forKey: "value")
		}

	}

}
