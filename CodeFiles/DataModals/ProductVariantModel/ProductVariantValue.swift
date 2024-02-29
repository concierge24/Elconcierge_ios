//
//	VariantValue.swift
//
//	Create by Mac_Mini17 on 12/3/2019
//	Copyright © 2019. All rights reserved.


import Foundation

enum ProductVariantValueKey:String {
    
    case barcode = "bar_code"
    case measuringunit = "measuring_unit"
    case productdesc = "product_desc"
    case productname = "product_name"
    case productid = "product_id"
    case variantid = "variant_id"
    case variantname = "variant_name"
    case variantvalue = "variant_value"
    case unid = "unid"
    case variantType = "variant_type"
 }

class ProductVariantValue : NSObject, NSCoding{

	var barCode : String!
	var measuringUnit : String!
	var productDesc : String!
	var productId : Int!
	var productName : String!
	var variantId : Int!
    var unid : Int!
	var variantName : String!
	var variantValue : String!
    var variantType: Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		barCode = dictionary[ProductVariantValueKey.barcode.rawValue] as? String
		measuringUnit = dictionary[ProductVariantValueKey.measuringunit.rawValue] as? String
		productDesc = dictionary[ProductVariantValueKey.productdesc.rawValue] as? String
		productId = dictionary[ProductVariantValueKey.productid.rawValue] as? Int
		productName = dictionary[ProductVariantValueKey.productname.rawValue] as? String
		variantId = dictionary[ProductVariantValueKey.variantid.rawValue] as? Int
		variantName = dictionary[ProductVariantValueKey.variantname.rawValue] as? String
		variantValue = dictionary[ProductVariantValueKey.variantvalue.rawValue] as? String
        unid = dictionary[ProductVariantValueKey.unid.rawValue] as? Int
        variantType = dictionary[ProductVariantValueKey.variantType.rawValue] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if barCode != nil{
			dictionary[ProductVariantValueKey.barcode.rawValue] = barCode
		}
        if variantType != nil{
            dictionary[ProductVariantValueKey.variantType.rawValue] = variantType
        }
		if measuringUnit != nil{
			dictionary[ProductVariantValueKey.measuringunit.rawValue] = measuringUnit
		}
		if productDesc != nil{
			dictionary[ProductVariantValueKey.productdesc.rawValue] = productDesc
		}
		if productId != nil{
			dictionary[ProductVariantValueKey.productid.rawValue] = productId
		}
		if productName != nil{
			dictionary[ProductVariantValueKey.productname.rawValue] = productName
		}
		if variantId != nil{
			dictionary[ProductVariantValueKey.variantid.rawValue] = variantId
		}
		if variantName != nil{
			dictionary[ProductVariantValueKey.variantname.rawValue] = variantName
		}
		if variantValue != nil{
			dictionary[ProductVariantValueKey.variantvalue.rawValue] = variantValue
		}
        if unid != nil{
            dictionary[ProductVariantValueKey.unid.rawValue] = unid
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         barCode = aDecoder.decodeObject(forKey: ProductVariantValueKey.barcode.rawValue) as? String
         measuringUnit = aDecoder.decodeObject(forKey: ProductVariantValueKey.measuringunit.rawValue) as? String
         productDesc = aDecoder.decodeObject(forKey: ProductVariantValueKey.productdesc.rawValue) as? String
         productId = aDecoder.decodeObject(forKey: ProductVariantValueKey.productid.rawValue) as? Int
         productName = aDecoder.decodeObject(forKey: ProductVariantValueKey.productname.rawValue) as? String
         variantId = aDecoder.decodeObject(forKey: ProductVariantValueKey.variantid.rawValue) as? Int
         variantName = aDecoder.decodeObject(forKey: ProductVariantValueKey.variantname.rawValue) as? String
         variantValue = aDecoder.decodeObject(forKey: ProductVariantValueKey.variantvalue.rawValue) as? String
         unid = aDecoder.decodeObject(forKey: ProductVariantValueKey.unid.rawValue) as? Int
        variantType = aDecoder.decodeObject(forKey: ProductVariantValueKey.variantType.rawValue) as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if barCode != nil{
			aCoder.encode(barCode, forKey: ProductVariantValueKey.barcode.rawValue)
		}
		if measuringUnit != nil{
			aCoder.encode(measuringUnit, forKey: ProductVariantValueKey.measuringunit.rawValue)
		}
		if productDesc != nil{
			aCoder.encode(productDesc, forKey:  ProductVariantValueKey.productdesc.rawValue)
		}
		if productId != nil{
			aCoder.encode(productId, forKey: ProductVariantValueKey.productid.rawValue)
		}
		if productName != nil{
			aCoder.encode(productName, forKey: ProductVariantValueKey.productname.rawValue)
		}
		if variantId != nil{
			aCoder.encode(variantId, forKey: ProductVariantValueKey.variantid.rawValue)
		}
		if variantName != nil{
			aCoder.encode(variantName, forKey: ProductVariantValueKey.variantname.rawValue)
		}
		if variantValue != nil{
			aCoder.encode(variantValue, forKey: ProductVariantValueKey.variantvalue.rawValue)
		}
        if unid != nil{
            aCoder.encode(variantValue, forKey: ProductVariantValueKey.unid.rawValue)
        }
        if variantType != nil{
            aCoder.encode(variantValue, forKey: ProductVariantValueKey.variantType.rawValue)
        }
	}

}
