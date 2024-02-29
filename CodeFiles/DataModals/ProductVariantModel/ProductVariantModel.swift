//
//	Variant.swift
//
//	Create by Mac_Mini17 on 12/3/2019
//	Copyright © 2019. All rights reserved.


import Foundation

enum ProductVariantModelKey:String {
     case variantname = "variant_name"
     case variantvalues = "variant_values"
    
}

class ProductVariantModel : NSObject, NSCoding{

	var variantName : String!
	var variantValues : [ProductVariantValue]!
    var filteredValues : [ProductVariantValue]!
    var filteredUniqueValues : [ProductVariantValue]!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		variantName = dictionary[ProductVariantModelKey.variantname.rawValue] as? String
		variantValues = [ProductVariantValue]()
		if let variantValuesArray = dictionary[ProductVariantModelKey.variantvalues.rawValue] as? [[String:Any]]{
			for dic in variantValuesArray{
				let value = ProductVariantValue(fromDictionary: dic)
				variantValues.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if variantName != nil{
			dictionary[ProductVariantModelKey.variantname.rawValue] = variantName
		}
		if variantValues != nil{
			var dictionaryElements = [[String:Any]]()
			for variantValuesElement in variantValues {
				dictionaryElements.append(variantValuesElement.toDictionary())
			}
			dictionary[ProductVariantModelKey.variantvalues.rawValue] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         variantName = aDecoder.decodeObject(forKey: ProductVariantModelKey.variantname.rawValue) as? String
         variantValues = aDecoder.decodeObject(forKey :ProductVariantModelKey.variantvalues.rawValue) as? [ProductVariantValue]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if variantName != nil{
			aCoder.encode(variantName, forKey: ProductVariantModelKey.variantname.rawValue)
		}
		if variantValues != nil{
			aCoder.encode(variantValues, forKey: ProductVariantModelKey.variantvalues.rawValue)
		}

	}

}
