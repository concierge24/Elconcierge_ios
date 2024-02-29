//
//  TravelPackages.swift
//  Trava
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class TravelPackages : NSObject, Mappable{
    
    var descriptionField : String?
    var name : String?
    var packageId : Int?
    var package : Package?
    var terms : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return TravelPackages()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        descriptionField <- map["description"]
        name <- map["name"]
        packageId <- map["package_id"]
        package <- map["package"]
        terms <- map["terms"]
        
    }
}

class Package : NSObject, Mappable{
    
    var blocked : String?
    var createdAt : String?
    var distanceKms : Float?
    var image : String?
    var packageId : Int?
    var packagePricings : [PackagePricing]?
    var packageType : String?
    var sortOrder : Int?
    var updatedAt : String?
    var validity : Int?
    var pricingData : PricingData?
    
    
    class func newInstance(map: Map) -> Mappable? {
        return Package()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        blocked <- map["blocked"]
        createdAt <- map["created_at"]
        distanceKms <- map["distance_kms"]
        image <- map["image"]
        packageId <- map["package_id"]
        packagePricings <- map["package_pricings"]
        packageType <- map["package_type"]
        sortOrder <- map["sort_order"]
        updatedAt <- map["updated_at"]
        validity <- map["validity"]
        pricingData <- map["pricingData"]
        
    }
}

class PackagePricing : NSObject, NSCoding, Mappable{
    
    var categoryBrandId : Int?
    var categoryBrandProduct : CategoryBrandProduct?
    var categoryBrandProductId : Int?
    var categoryId : Int?
    var distancePriceFixed : Int?
    var packageId : Int?
    var packagePricingId : Int?
    var pricePerKm : Int?
    var pricePerMin : Int?
    var timeFixedPrice : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return PackagePricing()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        categoryBrandId <- map["category_brand_id"]
        categoryBrandProduct <- map["category_brand_product"]
        categoryBrandProductId <- map["category_brand_product_id"]
        categoryId <- map["category_id"]
        distancePriceFixed <- map["distance_price_fixed"]
        packageId <- map["package_id"]
        packagePricingId <- map["package_pricing_id"]
        pricePerKm <- map["price_per_km"]
        pricePerMin <- map["price_per_min"]
        timeFixedPrice <- map["time_fixed_price"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryBrandId = aDecoder.decodeObject(forKey: "category_brand_id") as? Int
        categoryBrandProduct = aDecoder.decodeObject(forKey: "category_brand_product") as? CategoryBrandProduct
        categoryBrandProductId = aDecoder.decodeObject(forKey: "category_brand_product_id") as? Int
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? Int
        distancePriceFixed = aDecoder.decodeObject(forKey: "distance_price_fixed") as? Int
        packageId = aDecoder.decodeObject(forKey: "package_id") as? Int
        packagePricingId = aDecoder.decodeObject(forKey: "package_pricing_id") as? Int
        pricePerKm = aDecoder.decodeObject(forKey: "price_per_km") as? Int
        pricePerMin = aDecoder.decodeObject(forKey: "price_per_min") as? Int
        timeFixedPrice = aDecoder.decodeObject(forKey: "time_fixed_price") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryBrandId != nil{
            aCoder.encodeConditionalObject(categoryBrandId, forKey: "category_brand_id")
        }
        if categoryBrandProduct != nil{
            aCoder.encode(categoryBrandProduct, forKey: "category_brand_product")
        }
        if categoryBrandProductId != nil{
            aCoder.encodeConditionalObject(categoryBrandProductId, forKey: "category_brand_product_id")
        }
        if categoryId != nil{
            aCoder.encodeConditionalObject(categoryId, forKey: "category_id")
        }
        if distancePriceFixed != nil{
            aCoder.encodeConditionalObject(distancePriceFixed, forKey: "distance_price_fixed")
        }
        if packageId != nil{
            aCoder.encodeConditionalObject(packageId, forKey: "package_id")
        }
        if packagePricingId != nil{
            aCoder.encodeConditionalObject(packagePricingId, forKey: "package_pricing_id")
        }
        if pricePerKm != nil{
            aCoder.encodeConditionalObject(pricePerKm, forKey: "price_per_km")
        }
        if pricePerMin != nil{
            aCoder.encodeConditionalObject(pricePerMin, forKey: "price_per_min")
        }
        if timeFixedPrice != nil{
            aCoder.encodeConditionalObject(timeFixedPrice, forKey: "time_fixed_price")
        }
        
    }
    
}


class PricingData : NSObject, Mappable {
    
    var categories : [CategoryCab]?
    var categoryBrands : [Brand]?
    var distancePriceFixed : Int?
    var pricePerKm : Int?
    var pricePerMin : Int?
    var timeFixedPrice : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return PricingData()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        categories <- map["categories"]
        categoryBrands <- map["category_brands"]
        distancePriceFixed <- map["distance_price_fixed"]
        pricePerKm <- map["price_per_km"]
        pricePerMin <- map["price_per_min"]
        timeFixedPrice <- map["time_fixed_price"]
        
    }
    
    
    
}


class CategoryBrandProduct : NSObject, Mappable{
    
    var categoryBrandProductId : Int?
    var image : String?
    var maxQuantity : Int?
    var minQuantity : Int?
    var seatingCapacity : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CategoryBrandProduct()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        categoryBrandProductId <- map["category_brand_product_id"]
        image <- map["image"]
        maxQuantity <- map["max_quantity"]
        minQuantity <- map["min_quantity"]
        seatingCapacity <- map["seating_capacity"]
        
    }
    
}

 /*class CategoryBrand : NSObject, Mappable{
    
    var blocked : String?
    var buraqPercentage : Int?
    var categoryBrandId : Int?
    var categoryBrandType : String?
    var categoryId : Int?
    var createdAt : String?
    var sortOrder : Int?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CategoryBrand()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        blocked <- map["blocked"]
        buraqPercentage <- map["buraq_percentage"]
        categoryBrandId <- map["category_brand_id"]
        categoryBrandType <- map["category_brand_type"]
        categoryId <- map["category_id"]
        createdAt <- map["created_at"]
        sortOrder <- map["sort_order"]
        updatedAt <- map["updated_at"]
        
    }
} */

class CategoryCab : NSObject, Mappable{
    
    var blocked : String?
    var buraqPercentage : Int?
    var categoryId : Int?
    var categoryType : String?
    var createdAt : String?
    var defaultBrands : String?
    var image : String?
    var maximumDistance : String?
    var maximumRides : Int?
    var sortOrder : Int?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return CategoryCab()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        blocked <- map["blocked"]
        buraqPercentage <- map["buraq_percentage"]
        categoryId <- map["category_id"]
        categoryType <- map["category_type"]
        createdAt <- map["created_at"]
        defaultBrands <- map["default_brands"]
        image <- map["image"]
        maximumDistance <- map["maximum_distance"]
        maximumRides <- map["maximum_rides"]
        sortOrder <- map["sort_order"]
        updatedAt <- map["updated_at"]
        
    }
}



