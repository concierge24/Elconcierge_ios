//
//	Data.swift
//
//	Create by Mac_Mini17 on 12/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Data : NSObject, NSCoding{

	var barCode : String!
	var canUrgent : Int!
	var deliveryCharges : Int!
	var displayPrice : String!
	var fixedPrice : String!
	var handlingAdmin : Int!
	var handlingSupplier : Int!
	var id : Int!
	var imagePath : [String]!
	var isPackage : Int!
	var logo : String!
	var measuringUnit : String!
	var name : String!
	var price : String!
	var priceType : Int!
	var productDesc : String!
	var sku : String!
	var supplierBranchId : Int!
	var supplierId : Int!
	var supplierImage : AnyObject!
	var supplierName : String!
	var urgentType : Int!
	var urgentValue : Int!
	var variants : [Variant]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		barCode = dictionary["bar_code"] as? String
		canUrgent = dictionary["can_urgent"] as? Int
		deliveryCharges = dictionary["delivery_charges"] as? Int
		displayPrice = dictionary["display_price"] as? String
		fixedPrice = dictionary["fixed_price"] as? String
		handlingAdmin = dictionary["handling_admin"] as? Int
		handlingSupplier = dictionary["handling_supplier"] as? Int
		id = dictionary["id"] as? Int
		imagePath = dictionary["image_path"] as? [String]
		isPackage = dictionary["is_package"] as? Int
		logo = dictionary["logo"] as? String
		measuringUnit = dictionary["measuring_unit"] as? String
		name = dictionary["name"] as? String
		price = dictionary["price"] as? String
		priceType = dictionary["price_type"] as? Int
		productDesc = dictionary["product_desc"] as? String
		sku = dictionary["sku"] as? String
		supplierBranchId = dictionary["supplier_branch_id"] as? Int
		supplierId = dictionary["supplier_id"] as? Int
		supplierImage = dictionary["supplier_image"] as? AnyObject
		supplierName = dictionary["supplier_name"] as? String
		urgentType = dictionary["urgent_type"] as? Int
		urgentValue = dictionary["urgent_value"] as? Int
		variants = [Variant]()
		if let variantsArray = dictionary["variants"] as? [[String:Any]]{
			for dic in variantsArray{
				let value = Variant(fromDictionary: dic)
				variants.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if barCode != nil{
			dictionary["bar_code"] = barCode
		}
		if canUrgent != nil{
			dictionary["can_urgent"] = canUrgent
		}
		if deliveryCharges != nil{
			dictionary["delivery_charges"] = deliveryCharges
		}
		if displayPrice != nil{
			dictionary["display_price"] = displayPrice
		}
		if fixedPrice != nil{
			dictionary["fixed_price"] = fixedPrice
		}
		if handlingAdmin != nil{
			dictionary["handling_admin"] = handlingAdmin
		}
		if handlingSupplier != nil{
			dictionary["handling_supplier"] = handlingSupplier
		}
		if id != nil{
			dictionary["id"] = id
		}
		if imagePath != nil{
			dictionary["image_path"] = imagePath
		}
		if isPackage != nil{
			dictionary["is_package"] = isPackage
		}
		if logo != nil{
			dictionary["logo"] = logo
		}
		if measuringUnit != nil{
			dictionary["measuring_unit"] = measuringUnit
		}
		if name != nil{
			dictionary["name"] = name
		}
		if price != nil{
			dictionary["price"] = price
		}
		if priceType != nil{
			dictionary["price_type"] = priceType
		}
		if productDesc != nil{
			dictionary["product_desc"] = productDesc
		}
		if sku != nil{
			dictionary["sku"] = sku
		}
		if supplierBranchId != nil{
			dictionary["supplier_branch_id"] = supplierBranchId
		}
		if supplierId != nil{
			dictionary["supplier_id"] = supplierId
		}
		if supplierImage != nil{
			dictionary["supplier_image"] = supplierImage
		}
		if supplierName != nil{
			dictionary["supplier_name"] = supplierName
		}
		if urgentType != nil{
			dictionary["urgent_type"] = urgentType
		}
		if urgentValue != nil{
			dictionary["urgent_value"] = urgentValue
		}
		if variants != nil{
			var dictionaryElements = [[String:Any]]()
			for variantsElement in variants {
				dictionaryElements.append(variantsElement.toDictionary())
			}
			dictionary["variants"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         barCode = aDecoder.decodeObject(forKey: "bar_code") as? String
         canUrgent = aDecoder.decodeObject(forKey: "can_urgent") as? Int
         deliveryCharges = aDecoder.decodeObject(forKey: "delivery_charges") as? Int
         displayPrice = aDecoder.decodeObject(forKey: "display_price") as? String
         fixedPrice = aDecoder.decodeObject(forKey: "fixed_price") as? String
         handlingAdmin = aDecoder.decodeObject(forKey: "handling_admin") as? Int
         handlingSupplier = aDecoder.decodeObject(forKey: "handling_supplier") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         imagePath = aDecoder.decodeObject(forKey: "image_path") as? [String]
         isPackage = aDecoder.decodeObject(forKey: "is_package") as? Int
         logo = aDecoder.decodeObject(forKey: "logo") as? String
         measuringUnit = aDecoder.decodeObject(forKey: "measuring_unit") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         price = aDecoder.decodeObject(forKey: "price") as? String
         priceType = aDecoder.decodeObject(forKey: "price_type") as? Int
         productDesc = aDecoder.decodeObject(forKey: "product_desc") as? String
         sku = aDecoder.decodeObject(forKey: "sku") as? String
         supplierBranchId = aDecoder.decodeObject(forKey: "supplier_branch_id") as? Int
         supplierId = aDecoder.decodeObject(forKey: "supplier_id") as? Int
         supplierImage = aDecoder.decodeObject(forKey: "supplier_image") as? AnyObject
         supplierName = aDecoder.decodeObject(forKey: "supplier_name") as? String
         urgentType = aDecoder.decodeObject(forKey: "urgent_type") as? Int
         urgentValue = aDecoder.decodeObject(forKey: "urgent_value") as? Int
         variants = aDecoder.decodeObject(forKey :"variants") as? [Variant]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if barCode != nil{
			aCoder.encode(barCode, forKey: "bar_code")
		}
		if canUrgent != nil{
			aCoder.encode(canUrgent, forKey: "can_urgent")
		}
		if deliveryCharges != nil{
			aCoder.encode(deliveryCharges, forKey: "delivery_charges")
		}
		if displayPrice != nil{
			aCoder.encode(displayPrice, forKey: "display_price")
		}
		if fixedPrice != nil{
			aCoder.encode(fixedPrice, forKey: "fixed_price")
		}
		if handlingAdmin != nil{
			aCoder.encode(handlingAdmin, forKey: "handling_admin")
		}
		if handlingSupplier != nil{
			aCoder.encode(handlingSupplier, forKey: "handling_supplier")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if imagePath != nil{
			aCoder.encode(imagePath, forKey: "image_path")
		}
		if isPackage != nil{
			aCoder.encode(isPackage, forKey: "is_package")
		}
		if logo != nil{
			aCoder.encode(logo, forKey: "logo")
		}
		if measuringUnit != nil{
			aCoder.encode(measuringUnit, forKey: "measuring_unit")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if price != nil{
			aCoder.encode(price, forKey: "price")
		}
		if priceType != nil{
			aCoder.encode(priceType, forKey: "price_type")
		}
		if productDesc != nil{
			aCoder.encode(productDesc, forKey: "product_desc")
		}
		if sku != nil{
			aCoder.encode(sku, forKey: "sku")
		}
		if supplierBranchId != nil{
			aCoder.encode(supplierBranchId, forKey: "supplier_branch_id")
		}
		if supplierId != nil{
			aCoder.encode(supplierId, forKey: "supplier_id")
		}
		if supplierImage != nil{
			aCoder.encode(supplierImage, forKey: "supplier_image")
		}
		if supplierName != nil{
			aCoder.encode(supplierName, forKey: "supplier_name")
		}
		if urgentType != nil{
			aCoder.encode(urgentType, forKey: "urgent_type")
		}
		if urgentValue != nil{
			aCoder.encode(urgentValue, forKey: "urgent_value")
		}
		if variants != nil{
			aCoder.encode(variants, forKey: "variants")
		}

	}

}