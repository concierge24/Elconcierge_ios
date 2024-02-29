//
//  LoyalityPoints.swift
//  Clikat
//
//  Created by Night Reaper on 25/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation


enum LoyalityPointsKeys : String {
    case image_path = "image_path"
    case product_id = "product_id"
    case product_desc = "product_desc"
    case measuring_unit = "measuring_unit"
    case name = "name"
    case supplier_id = "supplier_id"
    case loyalty_points = "loyalty_points"
    case supplier_branch_id = "supplier_branch_id"
    case product = "product"
    case supplier_name = "supplier_name"
    case orders = "orders"
}

class LoyalityPoints : ProductF {
    
    
    var product_desc : String?
    var measuring_unit : String?
    var supplier_id : String?
    var supplier_branch_id : String?
  
    
    
    override init(attributes : SwiftyJSONParameter){
        super.init(attributes: attributes)
        self.product_desc = attributes?[LoyalityPointsKeys.product_desc.rawValue]?.stringValue
        self.measuring_unit = attributes?[LoyalityPointsKeys.measuring_unit.rawValue]?.stringValue
        self.supplier_id = attributes?[LoyalityPointsKeys.supplier_id.rawValue]?.stringValue
        self.supplier_branch_id = attributes?[LoyalityPointsKeys.supplier_branch_id.rawValue]?.stringValue
        self.supplierName = attributes?[LoyalityPointsKeys.supplier_name.rawValue]?.stringValue
    }
    
    override init() {
        super.init()
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(product_desc, forKey: "product_desc")
         aCoder.encode(measuring_unit, forKey: "measuring_unit")
         aCoder.encode(supplier_id, forKey: "supplier_id")
         aCoder.encode(supplier_branch_id, forKey: "supplier_branch_id")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        product_desc = aDecoder.decodeObject(forKey: "product_desc") as? String
        measuring_unit = aDecoder.decodeObject(forKey: "measuring_unit") as? String
        supplier_id = aDecoder.decodeObject(forKey: "supplier_id") as? String
        supplier_branch_id = aDecoder.decodeObject(forKey: "supplier_branch_id") as? String
        
    }
    
    
}


class LoyalityPointsListing : NSObject, NSCoding {
    var arrProduct : [LoyalityPoints]?
    var totalPoints : String?
    var orders : [OrderDetails]?
    
    init(attributes : SwiftyJSONParameter) {
        super.init()
        self.totalPoints = attributes?[LoyalityPointsKeys.loyalty_points.rawValue]?.stringValue
        orders = []
        for order in attributes?[LoyalityPointsKeys.orders.rawValue]?.arrayValue ?? [] {
            orders?.append(OrderDetails(attributes: order.dictionaryValue))
        }
        
        guard let json = attributes,let jsonArr = json[LoyalityPointsKeys.product.rawValue]?.arrayValue else { return }
        var tempArr : [LoyalityPoints] = []
        for product in jsonArr {
            let lPproduct = LoyalityPoints(attributes: product.dictionaryValue)
            tempArr.append(lPproduct)
        }
        arrProduct = tempArr
    }
    
    override init() {
        super.init()
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrProduct, forKey: "arrProduct")
        aCoder.encode(totalPoints, forKey: "totalPoints")
        aCoder.encode(orders, forKey: "orders")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        arrProduct = aDecoder.decodeObject(forKey: "arrProduct") as? [LoyalityPoints]
        totalPoints = aDecoder.decodeObject(forKey: "totalPoints") as? String
        orders = aDecoder.decodeObject(forKey: "orders") as? [OrderDetails]
        
    }
}
