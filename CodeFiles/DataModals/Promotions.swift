//
//  Promotions.swift
//  Clikat
//
//  Created by Night Reaper on 26/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 
 "min_order" : 123,
 "promotion_type" : 0,
 "promotion_price" : 12,
 "measuring_unit" : "",
 "delivery_charges" : 12,
 "promotion_description" : "test",
 
 */

enum PromotionKeys : String {
    
    case id = "id"
    case name = "product_name_1"
    case product_desc = "product_desc_1"
    case promotion_image = "promotion_image"
    case promotion_name = "promotion_name"
    case min_order = "min_order"
    case promotion_type = "promotion_type"
    case promotion_price = "promotion_price"
    case measuring_unit = "measuring_unit_2"
    case delivery_charges = "delivery_charges"
    case promotion_description = "promotion_description"
    case supplier_id = "supplier_id"
    case category_id = "category_id"
    case supplierBranchId = "supplierBranchId"
    case supplier_branch_id = "supplier_branch_id"
}



class Promotion{
    
    var id : String?
    var name : String?
    var productDesc : String?
    var minOrder : String?
    
    var promotionType : String?
    var promotionPrice : String?
    var promotionImage : String?
    var promotionName : String?
    var promotionDesc : String?
    
    var measuringUnit : String?
    var deliveryCharges : String?
    
    var supplierId : String?
    var supplierBranchId : String?
    var categoryId : String?
    
    var handlingSupplier : String?
    var handlingAdmin : String?
    
    
    init (attributes : Dictionary<String, JSON>?){
        self.id = attributes?[PromotionKeys.id.rawValue]?.stringValue
        self.name = attributes?[PromotionKeys.name.rawValue]?.stringValue
        self.productDesc = attributes?[PromotionKeys.product_desc.rawValue]?.stringValue
        self.promotionImage = attributes?[PromotionKeys.promotion_image.rawValue]?.stringValue
        self.promotionName = attributes?[PromotionKeys.promotion_name.rawValue]?.stringValue
        self.minOrder = attributes?[PromotionKeys.min_order.rawValue]?.stringValue
        self.promotionType = attributes?[PromotionKeys.promotion_type.rawValue]?.stringValue
        self.promotionPrice = attributes?[PromotionKeys.promotion_price.rawValue]?.stringValue
        self.measuringUnit = attributes?[PromotionKeys.measuring_unit.rawValue]?.stringValue
        self.deliveryCharges = attributes?[PromotionKeys.delivery_charges.rawValue]?.stringValue
        self.promotionDesc = attributes?[PromotionKeys.promotion_description.rawValue]?.stringValue
        self.supplierId = attributes?[PromotionKeys.supplier_id.rawValue]?.stringValue
        self.categoryId = attributes?[PromotionKeys.category_id.rawValue]?.stringValue
        self.supplierBranchId = attributes?[PromotionKeys.supplier_branch_id.rawValue]?.stringValue
        
        self.handlingSupplier = attributes?[ProductKeys.handling_supplier.rawValue]?.stringValue
        self.handlingAdmin = attributes?[ProductKeys.handling_admin.rawValue]?.stringValue
    }
    
}



class PromotionListing {
    
    var arrayPromotions : [Promotion]?
    
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[APIConstants.listKey]
        let unformattedPromotions = dict.arrayValue
        var promotions : [Promotion] = []
        
        for element in unformattedPromotions{
            let supplier = Promotion(attributes: element.dictionaryValue)
            promotions.append(supplier)
        }
        self.arrayPromotions = promotions
    }
    
}
