//
//	VariantValue.swift
//
//	Create by MAc_mini on 2/3/2019
//	Copyright © 2019. All rights reserved.


import Foundation 
import SwiftyJSON

enum VariantValueKey:String {
    case id = "id"
    case variantvalue = "value"
  
}

class VariantValue : NSObject, NSCoding{

	var id : Int!
	var value : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json[VariantValueKey.id.rawValue].intValue
		value = json[VariantValueKey.variantvalue.rawValue].stringValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary[VariantValueKey.id.rawValue] = id
		}
		if value != nil{
			dictionary[VariantValueKey.variantvalue.rawValue] = value
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: VariantValueKey.id.rawValue) as? Int
         value = aDecoder.decodeObject(forKey: VariantValueKey.variantvalue.rawValue) as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey:VariantValueKey.id.rawValue)
		}
		if value != nil{
			aCoder.encode(value, forKey: VariantValueKey.variantvalue.rawValue)
		}

	}

}
