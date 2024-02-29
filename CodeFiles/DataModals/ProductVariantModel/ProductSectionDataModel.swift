//
//  ProductSectionDataModel.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
class ProductSectionData{
    
    var title: String?
    var id:Int = 0
    var numOfRow:Int = 0
    var rowHeight = 0
    var headerHeight = 0
    var type: SectionTypes = .ratingReview
    
    init(title: String?,id: Int, rowHeight:Int,headerHeight:Int,numOfRow:Int, type: SectionTypes ) {
        
        self.title = title
        self.numOfRow = numOfRow
        self.rowHeight = rowHeight
        self.headerHeight = headerHeight
        self.type = type
    }
    
    
    class func getItems(backendObj: Any?) -> [ProductSectionData] {
        
        let backendObj = backendObj as? ProductF
        
        var backenArray = [ProductSectionData]()

        backendObj?.variants?.forEach({
            (obj) in
            if !obj.variantValues.isEmpty {
                let productData = ProductSectionData(title: obj.variantName, id: 0, rowHeight: Int(92), headerHeight: 0, numOfRow: 1, type: .color)
                backenArray.append(productData)

            }
//            let rowH = obj.variantValues.count == 0 ? 0 : 108
        })
        
        let productData = ProductSectionData(title: "Delivery Location", id: 0, rowHeight: Int(UITableView.automaticDimension), headerHeight: 0, numOfRow: 1, type: .deliveryLocation)
        backenArray.append(productData)
        
        if (backendObj?.desc) != nil {
            
            let productData = ProductSectionData(title: "Product Description", id: 0, rowHeight: Int(UITableView.automaticDimension), headerHeight: 0, numOfRow: 1, type: .productDescription)
            backenArray.append(productData)
        }
        
        //Ratings header
        let ratingHeader = ProductSectionData(title: "Rating & Reviews", id: 0, rowHeight: Int(UITableView.automaticDimension), headerHeight: 0, numOfRow: 1, type: .ratingHeader)
        backenArray.append(ratingHeader)
        
        //List of ratings
        let productRatingData = ProductSectionData(title: "Ratings", id: 0, rowHeight: Int(UITableView.automaticDimension), headerHeight: 0, numOfRow: backendObj?.ratingModel.count ?? 0, type: .ratingReview)
        backenArray.append(productRatingData)

        return  backenArray
    }
    
//    
    
}
