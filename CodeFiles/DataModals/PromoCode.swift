//
//  PromoCode.swift
//  Sneni
//
//  Created by Mac_Mini17 on 29/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper

enum PromoCodeKeys : String {
    case id
    case discountAmount
    case discountType
    case supplierIds
    case discountPrice
    case categoryIds
    case code
    case minOrder
}

class PromoCode : NSObject , RMMapping, NSCoding {
    
    var discountAmount: String?
    var id: String?
    var code: String?
    var discountType: Int?
    var supplierIds: [Int]?
    var discountPrice: Double?
    var categoryIds: [Int]?
    var minOrder : Double?
    
    var totalAmountOnDiscount: Double?
    var totalDiscount: Double?

    
    init (attributes : SwiftyJSONParameter){
        self.minOrder = attributes?[PromoCodeKeys.minOrder.rawValue]?.doubleValue

        self.id = attributes?[PromoCodeKeys.id.rawValue]?.stringValue
        self.discountAmount = attributes?[PromoCodeKeys.discountAmount.rawValue]?.stringValue
        self.discountType = attributes?[PromoCodeKeys.discountType.rawValue]?.int
        self.supplierIds = attributes?[PromoCodeKeys.supplierIds.rawValue]?.arrayObject as? [Int]
        self.discountPrice = attributes?[PromoCodeKeys.discountPrice.rawValue]?.double
        self.categoryIds = attributes?[PromoCodeKeys.categoryIds.rawValue]?.arrayObject as? [Int]
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: PromoCodeKeys.id.rawValue)
        aCoder.encode(code, forKey: PromoCodeKeys.code.rawValue)
        aCoder.encode(minOrder, forKey: PromoCodeKeys.minOrder.rawValue)

        aCoder.encode(discountAmount, forKey: PromoCodeKeys.discountAmount.rawValue)
        aCoder.encode(discountType, forKey: PromoCodeKeys.discountType.rawValue)
        aCoder.encode(supplierIds, forKey: PromoCodeKeys.supplierIds.rawValue)
        aCoder.encode(discountPrice, forKey: PromoCodeKeys.discountPrice.rawValue)
        aCoder.encode(categoryIds, forKey: PromoCodeKeys.categoryIds.rawValue)

    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        minOrder = aDecoder.decodeObject(forKey: PromoCodeKeys.minOrder.rawValue) as? Double
        
        code = aDecoder.decodeObject(forKey: PromoCodeKeys.code.rawValue) as? String
        discountAmount = aDecoder.decodeObject(forKey: PromoCodeKeys.discountAmount.rawValue) as? String
        discountType = aDecoder.decodeObject(forKey: PromoCodeKeys.discountType.rawValue) as? Int
        supplierIds = aDecoder.decodeObject(forKey: PromoCodeKeys.supplierIds.rawValue) as? [Int]
        discountPrice = aDecoder.decodeObject(forKey: PromoCodeKeys.discountPrice.rawValue) as? Double
        categoryIds = aDecoder.decodeObject(forKey: PromoCodeKeys.categoryIds.rawValue) as? [Int]

    }
}
