//
//  Laundry.swift
//  Clikat
//
//  Created by cbl73 on 5/7/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum  LaundryRelatedKeys : String {
    case sub_category_id = "sub_category_id"
    case sub_category_image = "sub_category_image"
    case sub_category_icon = "sub_category_icon"
    case sub_category_name = "sub_category_name"
    case sub_category_description = "sub_category_description"
    case product = "product"
    case details = "details"
}

class Laundry {
    
    var subCategoryId : String?
    var subCategoryImage : String?
    var subCategoryIcon : String?
    var subCategoryName : String?
    var subCategoryDesc : String?
    
    var products : [ProductF]?
    
    
    init (attributes : SwiftyJSONParameter){
        self.subCategoryId = attributes?[LaundryRelatedKeys.sub_category_id.rawValue]?.stringValue
        self.subCategoryImage = attributes?[LaundryRelatedKeys.sub_category_image.rawValue]?.stringValue
        self.subCategoryIcon = attributes?[LaundryRelatedKeys.sub_category_icon.rawValue]?.stringValue
        self.subCategoryName = attributes?[LaundryRelatedKeys.sub_category_name.rawValue]?.stringValue
        self.subCategoryDesc = attributes?[LaundryRelatedKeys.sub_category_description.rawValue]?.stringValue

        var tempArr : [ProductF] = []
        for product in attributes?[LaundryRelatedKeys.product.rawValue]?.arrayValue ?? [] {
            
            //TODO: Add Supplier Branch Id for packages
            let product = ProductF(attributes: product.dictionaryValue)
            tempArr.append(product)
        }
        self.products = tempArr
    
    }
}


class LaundryServices {
    
    var services : [Laundry]?

        init(attributes : SwiftyJSONParameter){
            guard let rawData = attributes else { return }
            let json = JSON(rawData)
            
            let dict = json[LaundryRelatedKeys.details.rawValue]
            let servs = dict.arrayValue
            var arrayServs : [Laundry] = []
            
            for element in servs{
                let service = Laundry(attributes: element.dictionaryValue)
                arrayServs.append(service)
            }
            self.services = arrayServs
        }
        
    
}


