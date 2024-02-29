
//
//	Create by MAc_mini on 2/3/2019
//	Copyright © 2019. All rights reserved.

import Foundation 
import SwiftyJSON

enum VariantRelatedKey:String {
    case data = "data"
    case brands = "brands"
}

class Variant : NSObject, NSCoding{

	var variantData : [VariantData]!
     var brands : [Brands]!
 
	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
        
		variantData = [VariantData]()

        let dataArray = json?[VariantRelatedKey.data.rawValue].arrayValue
        for dataJson in dataArray ?? []{
			let value = VariantData(fromJson: dataJson)
			variantData.append(value)
		}
        
        
        brands = [Brands]()
        let brandsArray = json?[VariantRelatedKey.brands.rawValue].arrayValue
        for brandsJson in brandsArray ?? []{
            let value = Brands(fromJson: brandsJson)
            brands.append(value)
        }
  
        
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if variantData != nil{
			var dictionaryElements = [[String:Any]]()
			for dataElement in variantData {
                dictionaryElements.append(dataElement.toDictionary())
			}
			dictionary[VariantRelatedKey.data.rawValue] = dictionaryElements
		}
	
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         variantData = aDecoder.decodeObject(forKey: VariantRelatedKey.data.rawValue) as? [VariantData]
         brands = aDecoder.decodeObject(forKey: VariantRelatedKey.brands.rawValue) as? [Brands]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if variantData != nil{
			aCoder.encode(variantData, forKey: VariantRelatedKey.data.rawValue)
		}
        
        if brands != nil{
            aCoder.encode(brands, forKey: VariantRelatedKey.brands.rawValue)
        }
		

	}

}
