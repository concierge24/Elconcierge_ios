//
//	Data.swift
//
//	Create by MAc_mini on 2/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON

enum VariantDataKey:String {
    
    case id = "id"
    case variantName = "variant_name"
    case variantValues = "variant_values"
   
}

class VariantData : NSObject, NSCoding{

	var id : Int!
	var variantName : String!
	var variantValues : [VariantValue]!
    var brands : [Brands]!
    

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json[VariantDataKey.id.rawValue].intValue
		variantName = json[VariantDataKey.variantName.rawValue].stringValue
		variantValues = [VariantValue]()
		let variantValuesArray = json[VariantDataKey.variantValues.rawValue].arrayValue
		for variantValuesJson in variantValuesArray{
			let value = VariantValue(fromJson: variantValuesJson)
			variantValues.append(value)
		}
     
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary[VariantDataKey.id.rawValue] = id
		}
		if variantName != nil{
			dictionary[VariantDataKey.variantName.rawValue] = variantName
		}
		if variantValues != nil{
			var dictionaryElements = [[String:Any]]()
			for variantValuesElement in variantValues {
				dictionaryElements.append(variantValuesElement.toDictionary())
			}
			dictionary[VariantDataKey.variantValues.rawValue] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: VariantDataKey.id.rawValue) as? Int
         variantName = aDecoder.decodeObject(forKey: VariantDataKey.variantName.rawValue) as? String
         variantValues = aDecoder.decodeObject(forKey: VariantDataKey.variantValues.rawValue) as? [VariantValue]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: VariantDataKey.id.rawValue)
		}
		if variantName != nil{
			aCoder.encode(variantName, forKey: VariantDataKey.variantName.rawValue)
		}
		if variantValues != nil{
			aCoder.encode(variantValues, forKey: VariantDataKey.variantValues.rawValue)
		}

	}

}
