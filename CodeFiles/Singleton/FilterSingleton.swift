//
//  FilterSingleton.swift
//  Sneni
//
//  Created by Mac_Mini17 on 05/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

struct FilterCategory {
    
    static var shared = FilterCategory()
    
//    var catIDString: String?
    static var supplierId: String?
    
    static var supplierIds: [String] {
        if (/supplierId).isEmpty {
            return []
        }
        return [/supplierId]
    }
    
    
    var txtSearch: String?

    var arrayCatIds = [String]()
    var arrayCatNames = [String]()

    var arraySubCatIds = [String]()
    var arraySubCatNames = [String]()
    
    var apiSubIds:[Int] {
        var arrSubCatIds: [Int] = arraySubCatIds.map({ /$0.toInt() })
        
//        if arrSubCatIds.isEmpty, let id = arrayCatIds.last?.toInt() {
//            arrSubCatIds = [id]
//        }
        return arrSubCatIds
    }
    
    var catPath: String {
        return (arrayCatNames + arraySubCatNames).joined(separator:" > ")
    }
    
    var variantIdArray = [Int]()
    var arrayBrandId = [Int]()
    var agentListFlow: String?
    
    var discount = 0
    var availablity = 1
    
    var maxPriceLimit = 10000
    var minPriceLimit = 0
    
    var maxPrice = 10000
    var minPrice = 0
    
    mutating func reset() {
        self = FilterCategory()
    }
    
    var lowToHigh: Bool = true
    var popularity: Bool = false

    func getValue(type: TableViewSectionTypes) -> Int {
        switch type {
        case .lowToHigh:
            return popularity ? 0 : (lowToHigh ? 1 : 0)
        case .higtToLow:
            return popularity ? 0 : (!lowToHigh ? 1 : 0)
        case .popularity:
            return popularity ? 1 : 0
        default:
            return 0
        }
    }
    
    func isSelected(catOrSubCat id: String?) -> Bool {
        
        if arrayCatIds.contains(/id) {
            return true
        } else if arraySubCatIds.contains(/id) {
            return true
        }
        return false
    }
}
