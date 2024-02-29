//
//  SortedBy.swift
//  Sneni
//
//  Created by MAc_mini on 04/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
enum TableViewSectionTypes: String {
    
    case none = ""
    
    case sortedBy = "Sort"
    case priceRange = "Price Range"
    case discount = "Discount"
    case availability = "Availability"
    case category = "Category"
    
    case size = "Size"
    case color = "Color"
    case style = "Style"
    
    case lowToHigh = "Price: Low to High"
    case higtToLow = "Price: High to Low"
    case popularity = "Popularity"
    
    case yes = "Yes"
    case no = "No"

    case others = "Others"
    case brands = "Brands"

    
}

class SectionData {
   
    var type : TableViewSectionTypes = .sortedBy
    var title : String?
    var cells: [Any]?
    var id:Int = 0
    var rowHeight = 0
    var headerHeight = 0
    
    init(type : TableViewSectionTypes, title: String? = nil, _cells: [Any],id: Int, rowHeight:Int,headerHeight:Int ) {
        
        self.type = type
        self.title = title ?? type.rawValue
        self.cells = _cells
        self.id = id
        self.rowHeight = rowHeight
        self.headerHeight = headerHeight
        
    }
    
    init(title : String, _cells: [Any],id: Int, rowHeight:Int,headerHeight:Int ) {
        
        self.type = TableViewSectionTypes(rawValue: title.capitalized) ?? .none
        
        self.title = title
        self.cells = _cells
        self.id = id
        self.rowHeight = rowHeight
        self.headerHeight = headerHeight
        
    }
    
    
    class func setSectionData(type: TableViewSectionTypes = .none, variant: Variant? = nil) -> [SectionData] {
        
        switch type {
        case .sortedBy:
            return [SectionData(type: TableViewSectionTypes.sortedBy, _cells: [
                Sorted.init(subName: "", type: TableViewSectionTypes.lowToHigh, id: 1),
                Sorted.init(subName: "", type: TableViewSectionTypes.higtToLow, id: 0),
                Sorted.init(subName: "", type: TableViewSectionTypes.popularity, id: 0)
                ], id: -1, rowHeight: 40, headerHeight:50)]
        
        case .priceRange:
            return [SectionData(type:TableViewSectionTypes.priceRange , _cells: [
                Sorted.init(subName: "", type: TableViewSectionTypes.priceRange , id: 0)
                ], id: -1, rowHeight: 70, headerHeight: 50)]
            
        case .discount:
            return [SectionData(type: TableViewSectionTypes.discount, _cells: [
                Sorted.init(subName: "Show products on discount", type: TableViewSectionTypes.yes ,id: 0),
                Sorted.init(subName: "Don’t show products on discount", type: TableViewSectionTypes.no ,id: 0),
                ], id: -1, rowHeight:60, headerHeight: 50)]
            
        case .availability:
            return [SectionData(type: TableViewSectionTypes.availability, _cells: [
                Sorted.init(subName: "Show products that are available in stock", type: TableViewSectionTypes.yes ,id: 1),
                Sorted.init(subName: "Don’t show products that are not available in stock", type: TableViewSectionTypes.no ,id: 0),
                ], id: -1, rowHeight:60, headerHeight: 50)]
            
        case .category:
            return [SectionData(type: TableViewSectionTypes.category, _cells: [
//                Sorted.init(subName: "", type: TableViewSectionTypes.category ,id: 0),
                ], id: -1, rowHeight:60, headerHeight: 1)]
            
        case .others:
            
            var data: [SectionData] = []
            if !((variant?.brands ?? []).isEmpty) {
                data = [SectionData(type: TableViewSectionTypes.brands, _cells: [variant?.brands ?? []], id: 0, rowHeight:64, headerHeight: 50)]
            }
            variant?.variantData?.forEach({ (obj) in
                data.append(SectionData(type: TableViewSectionTypes.others, title: obj.variantName,  _cells: [obj.variantValues], id: 0, rowHeight:64, headerHeight: 50))
            })
            return data
            
        //case .brands:
            //return [SectionData(type: TableViewSectionTypes.brands, _cells: [variant?.brands ?? []], id: 0, rowHeight:64, headerHeight: 50)]
            
        default:
            if let obj = variant?.variantData.first(where: { $0.variantName == type.rawValue }), !obj.variantValues.isEmpty {
                return [SectionData(type: type, _cells: [obj.variantValues], id: 0, rowHeight:64, headerHeight: 50)]
            }
//            let sectionData = [
//                SectionData(type: TableViewSectionTypes.sortedBy, _cells: [
//                    Sorted.init(subName: "", type: TableViewSectionTypes.lowToHigh, id: 1),
//                    Sorted.init(subName: "", type: TableViewSectionTypes.higtToLow, id: 0),
//                    Sorted.init(subName: "", type: TableViewSectionTypes.popularity, id: 0)
//                    ], id: -1, rowHeight: 40, headerHeight:50),
//                SectionData(type:TableViewSectionTypes.priceRange , _cells: [
//                    Sorted.init(subName: "", type: TableViewSectionTypes.priceRange , id: 0)
//                    ], id: -1, rowHeight: 70, headerHeight: 0),
//                SectionData(type: TableViewSectionTypes.category, _cells: [
//                    Sorted.init(subName: "", type: TableViewSectionTypes.discount ,id: 0),
//                    Sorted.init(subName: "", type: TableViewSectionTypes.availability, id: 1),
//                    Sorted.init(subName: "", type: TableViewSectionTypes.category, id: 0)
//                    ], id: -1, rowHeight:60, headerHeight: 0)
//            ]
            return []
        }
    }
    
    class func getItems(backendObj: Any?,sectionDataArr:[SectionData]) -> [SectionData] {
        
        let variant = backendObj as? Variant
        var backenArray = [SectionData]()
        
        variant?.variantData?.forEach({
            (obj) in
            
            if sectionDataArr.first(where: { $0.id != obj.id }) == nil {
                
                let rowH = obj.variantValues.count == 0 ? 0 : 64
                let hHeight = obj.variantValues.count == 0 ? 0 : 50
                let sectionData = SectionData(title: obj.variantName, _cells: [obj.variantValues], id: obj.id, rowHeight: rowH, headerHeight: hHeight)
                backenArray.append(sectionData)
                
            }
        })
        
        if /variant?.brands.count > 0 {
            
            let sectionData = SectionData(title: "Brands", _cells: [variant?.brands ?? []], id: 0, rowHeight: 64, headerHeight: 50)
            backenArray.append(sectionData)
        }
        
    return sectionDataArr + backenArray
    }
}




