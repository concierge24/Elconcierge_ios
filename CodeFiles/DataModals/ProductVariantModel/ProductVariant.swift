//
//	RootClass.swift
//
//	Create by Mac_Mini17 on 12/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ProductVariant : NSObject, NSCoding{

	var data : ProductVariantData!
    
//    var message : String!
//    var status : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
       
    
		if let dataData = dictionary[APIConstants.DataKey] as? [String:Any]{
			data = ProductVariantData(fromDictionary: dataData)
		}
        
      
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			dictionary[APIConstants.DataKey] = data.toDictionary()
		}
//        if message != nil{
//            dictionary["message"] = message
//        }
//        if status != nil{
//            dictionary["status"] = status
//        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? ProductVariantData
//         message = aDecoder.decodeObject(forKey: "message") as? String
//         status = aDecoder.decodeObject(forKey: "status") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: APIConstants.DataKey)
		}
//        if message != nil{
//            aCoder.encode(message, forKey: "message")
//        }
//        if status != nil{
//            aCoder.encode(status, forKey: "status")
//        }

	}

}
