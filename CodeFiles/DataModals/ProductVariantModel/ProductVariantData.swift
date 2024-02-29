//
//	Data.swift
//
//	Create by Mac_Mini17 on 12/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
enum ProductVariantDataKey:String {
    case barcode = "bar_code"
    case canurgent = "can_urgent"
    case deliverycharges = "delivery_charges"
    case displayprice = "display_price"
    case fixedprice = "fixed_price"
    case handlingadmin = "handling_admin"
    case handlingsupplier = "handling_supplier"
    case id = "id"
    case imagepath = "image_path"
    case ispackage = "is_package"
    case logo = "logo"
    case measuringunit = "measuring_unit"
    case name = "name"
    case price = "price"
    case pricetype = "price_type"
    case productdesc = "product_desc"
    case sku = "sku"
    case supplierbranchid = "supplier_branch_id"
    case supplierid = "supplier_id"
    case supplierimage = "supplier_image"
    case suppliername = "supplier_name"
    case urgenttype = "urgent_type"
    case urgentvalue = "urgent_value"
    case variants = "variants"
    case rating = "rating"
    
    
}

class ProductVariantData : NSObject, NSCoding{

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
	var variants : [ProductVariantModel]!
    var ratingModel : [RatingModel]!
    
    
   


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        
		barCode = dictionary[ProductVariantDataKey.barcode.rawValue] as? String
		canUrgent = dictionary[ProductVariantDataKey.canurgent.rawValue] as? Int
		deliveryCharges = dictionary[ProductVariantDataKey.deliverycharges.rawValue] as? Int
		displayPrice = dictionary[ProductVariantDataKey.displayprice.rawValue] as? String
		fixedPrice = dictionary[ProductVariantDataKey.fixedprice.rawValue] as? String
		handlingAdmin = dictionary[ProductVariantDataKey.handlingadmin.rawValue] as? Int
		handlingSupplier = dictionary[ProductVariantDataKey.handlingsupplier.rawValue] as? Int
		id = dictionary[ProductVariantDataKey.id.rawValue] as? Int
		imagePath = dictionary[ProductVariantDataKey.imagepath.rawValue] as? [String]
		isPackage = dictionary[ProductVariantDataKey.ispackage.rawValue] as? Int
		logo = dictionary[ProductVariantDataKey.logo.rawValue] as? String
		measuringUnit = dictionary[ProductVariantDataKey.measuringunit.rawValue] as? String
		name = dictionary[ProductVariantDataKey.name.rawValue] as? String
		price = dictionary[ProductVariantDataKey.price.rawValue] as? String
		priceType = dictionary[ProductVariantDataKey.pricetype.rawValue] as? Int
		productDesc = dictionary[ProductVariantDataKey.productdesc.rawValue] as? String
		sku = dictionary[ProductVariantDataKey.sku.rawValue] as? String
		supplierBranchId = dictionary[ProductVariantDataKey.supplierbranchid.rawValue] as? Int
		supplierId = dictionary[ProductVariantDataKey.supplierid.rawValue] as? Int
		supplierImage = dictionary[ProductVariantDataKey.supplierimage.rawValue] as? AnyObject
		supplierName = dictionary[ProductVariantDataKey.suppliername.rawValue] as? String
		urgentType = dictionary[ProductVariantDataKey.urgenttype.rawValue] as? Int
		urgentValue = dictionary[ProductVariantDataKey.urgentvalue.rawValue] as? Int
		variants = [ProductVariantModel]()
        
        
		if let variantsArray = dictionary[ProductVariantDataKey.variants.rawValue] as? [[String:Any]]{
			for dic in variantsArray{
                
                print(dic)
				let value = ProductVariantModel(fromDictionary: dic)
				variants.append(value)
			}
		}
        
        ratingModel = [RatingModel]()
        
        if let ratingArray = dictionary[ProductVariantDataKey.rating.rawValue] as? [[String:Any]]{
            for dic in ratingArray{
                
                 let rating = RatingModel(fromDictionary: dic)
                ratingModel.append(rating)
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
			dictionary[ProductVariantDataKey.barcode.rawValue] = barCode
		}
		if canUrgent != nil{
			dictionary[ProductVariantDataKey.canurgent.rawValue] = canUrgent
		}
		if deliveryCharges != nil{
			dictionary[ProductVariantDataKey.deliverycharges.rawValue] = deliveryCharges
		}
		if displayPrice != nil{
			dictionary[ProductVariantDataKey.displayprice.rawValue] = displayPrice
		}
		if fixedPrice != nil{
			dictionary[ProductVariantDataKey.fixedprice.rawValue] = fixedPrice
		}
		if handlingAdmin != nil{
			dictionary[ProductVariantDataKey.handlingadmin.rawValue] = handlingAdmin
		}
		if handlingSupplier != nil{
			dictionary[ProductVariantDataKey.handlingsupplier.rawValue] = handlingSupplier
		}
		if id != nil{
			dictionary[ProductVariantDataKey.id.rawValue] = id
		}
		if imagePath != nil{
			dictionary[ProductVariantDataKey.imagepath.rawValue] = imagePath
		}
		if isPackage != nil{
			dictionary[ProductVariantDataKey.ispackage.rawValue] = isPackage
		}
		if logo != nil{
			dictionary[ProductVariantDataKey.logo.rawValue] = logo
		}
		if measuringUnit != nil{
			dictionary[ProductVariantDataKey.measuringunit.rawValue] = measuringUnit
		}
		if name != nil{
			dictionary[ProductVariantDataKey.name.rawValue] = name
		}
		if price != nil{
			dictionary[ProductVariantDataKey.price.rawValue] = price
		}
		if priceType != nil{
			dictionary[ProductVariantDataKey.pricetype.rawValue] = priceType
		}
		if productDesc != nil{
			dictionary[ProductVariantDataKey.productdesc.rawValue] = productDesc
		}
		if sku != nil{
			dictionary[ProductVariantDataKey.sku.rawValue] = sku
		}
		if supplierBranchId != nil{
			dictionary[ProductVariantDataKey.supplierbranchid.rawValue] = supplierBranchId
		}
		if supplierId != nil{
			dictionary[ProductVariantDataKey.supplierid.rawValue] = supplierId
		}
		if supplierImage != nil{
			dictionary[ProductVariantDataKey.supplierimage.rawValue] = supplierImage
		}
		if supplierName != nil{
			dictionary[ProductVariantDataKey.suppliername.rawValue] = supplierName
		}
		if urgentType != nil{
			dictionary[ProductVariantDataKey.urgenttype.rawValue] = urgentType
		}
		if urgentValue != nil{
			dictionary[ProductVariantDataKey.urgentvalue.rawValue] = urgentValue
		}
		if variants != nil{
			var dictionaryElements = [[String:Any]]()
			for variantsElement in variants {
				dictionaryElements.append(variantsElement.toDictionary())
			}
			dictionary[ProductVariantDataKey.variants.rawValue] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         barCode = aDecoder.decodeObject(forKey: ProductVariantDataKey.barcode.rawValue) as? String
         canUrgent = aDecoder.decodeObject(forKey: ProductVariantDataKey.canurgent.rawValue) as? Int
         deliveryCharges = aDecoder.decodeObject(forKey: ProductVariantDataKey.deliverycharges.rawValue) as? Int
         displayPrice = aDecoder.decodeObject(forKey: ProductVariantDataKey.displayprice.rawValue) as? String
         fixedPrice = aDecoder.decodeObject(forKey: ProductVariantDataKey.fixedprice.rawValue) as? String
         handlingAdmin = aDecoder.decodeObject(forKey: ProductVariantDataKey.handlingadmin.rawValue) as? Int
         handlingSupplier = aDecoder.decodeObject(forKey: ProductVariantDataKey.handlingsupplier.rawValue) as? Int
         id = aDecoder.decodeObject(forKey: ProductVariantDataKey.id.rawValue) as? Int
         imagePath = aDecoder.decodeObject(forKey:  ProductVariantDataKey.imagepath.rawValue) as? [String]
         isPackage = aDecoder.decodeObject(forKey: ProductVariantDataKey.ispackage.rawValue) as? Int
         logo = aDecoder.decodeObject(forKey: ProductVariantDataKey.logo.rawValue) as? String
         measuringUnit = aDecoder.decodeObject(forKey: ProductVariantDataKey.measuringunit.rawValue) as? String
         name = aDecoder.decodeObject(forKey: ProductVariantDataKey.name.rawValue) as? String
         price = aDecoder.decodeObject(forKey: ProductVariantDataKey.price.rawValue) as? String
         priceType = aDecoder.decodeObject(forKey: ProductVariantDataKey.pricetype.rawValue) as? Int
         productDesc = aDecoder.decodeObject(forKey: ProductVariantDataKey.productdesc.rawValue) as? String
         sku = aDecoder.decodeObject(forKey: ProductVariantDataKey.sku.rawValue) as? String
         supplierBranchId = aDecoder.decodeObject(forKey: ProductVariantDataKey.supplierbranchid.rawValue) as? Int
         supplierId = aDecoder.decodeObject(forKey: ProductVariantDataKey.supplierid.rawValue) as? Int
         supplierImage = aDecoder.decodeObject(forKey: ProductVariantDataKey.supplierimage.rawValue) as? AnyObject
         supplierName = aDecoder.decodeObject(forKey: ProductVariantDataKey.suppliername.rawValue) as? String
         urgentType = aDecoder.decodeObject(forKey: ProductVariantDataKey.urgenttype.rawValue) as? Int
         urgentValue = aDecoder.decodeObject(forKey: ProductVariantDataKey.urgentvalue.rawValue) as? Int
         variants = aDecoder.decodeObject(forKey :ProductVariantDataKey.variants.rawValue) as? [ProductVariantModel]
         ratingModel = aDecoder.decodeObject(forKey :ProductVariantDataKey.rating.rawValue) as? [RatingModel]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if barCode != nil{
			aCoder.encode(barCode, forKey: ProductVariantDataKey.barcode.rawValue)
		}
		if canUrgent != nil{
			aCoder.encode(canUrgent, forKey: ProductVariantDataKey.canurgent.rawValue)
		}
		if deliveryCharges != nil{
			aCoder.encode(deliveryCharges, forKey: ProductVariantDataKey.deliverycharges.rawValue)
		}
		if displayPrice != nil{
			aCoder.encode(displayPrice, forKey: ProductVariantDataKey.displayprice.rawValue)
		}
		if fixedPrice != nil{
			aCoder.encode(fixedPrice, forKey: ProductVariantDataKey.fixedprice.rawValue)
		}
		if handlingAdmin != nil{
			aCoder.encode(handlingAdmin, forKey: ProductVariantDataKey.handlingadmin.rawValue)
		}
		if handlingSupplier != nil{
			aCoder.encode(handlingSupplier, forKey: ProductVariantDataKey.handlingsupplier.rawValue)
		}
		if id != nil{
			aCoder.encode(id, forKey: ProductVariantDataKey.id.rawValue)
		}
		if imagePath != nil{
			aCoder.encode(imagePath, forKey: ProductVariantDataKey.imagepath.rawValue)
		}
		if isPackage != nil{
			aCoder.encode(isPackage, forKey: ProductVariantDataKey.ispackage.rawValue)
		}
		if logo != nil{
			aCoder.encode(logo, forKey: ProductVariantDataKey.logo.rawValue)
		}
		if measuringUnit != nil{
			aCoder.encode(measuringUnit, forKey: ProductVariantDataKey.measuringunit.rawValue)
		}
		if name != nil{
			aCoder.encode(name, forKey: ProductVariantDataKey.name.rawValue)
		}
		if price != nil{
			aCoder.encode(price, forKey: ProductVariantDataKey.price.rawValue)
		}
		if priceType != nil{
			aCoder.encode(priceType, forKey: ProductVariantDataKey.pricetype.rawValue)
		}
		if productDesc != nil{
			aCoder.encode(productDesc, forKey: ProductVariantDataKey.productdesc.rawValue)
		}
		if sku != nil{
			aCoder.encode(sku, forKey: ProductVariantDataKey.sku.rawValue)
		}
		if supplierBranchId != nil{
			aCoder.encode(supplierBranchId, forKey: ProductVariantDataKey.supplierbranchid.rawValue)
		}
		if supplierId != nil{
			aCoder.encode(supplierId, forKey: ProductVariantDataKey.supplierid.rawValue)
		}
		if supplierImage != nil{
			aCoder.encode(supplierImage, forKey: ProductVariantDataKey.supplierimage.rawValue)
		}
		if supplierName != nil{
			aCoder.encode(supplierName, forKey: ProductVariantDataKey.suppliername.rawValue)
		}
		if urgentType != nil{
			aCoder.encode(urgentType, forKey: ProductVariantDataKey.urgenttype.rawValue)
		}
		if urgentValue != nil{
			aCoder.encode(urgentValue, forKey: ProductVariantDataKey.urgentvalue.rawValue)
		}
		if variants != nil{
			aCoder.encode(variants, forKey: ProductVariantDataKey.variants.rawValue)
		}
        if ratingModel != nil{
            aCoder.encode(ratingModel, forKey: ProductVariantDataKey.rating.rawValue)
        }
        

	}

}
