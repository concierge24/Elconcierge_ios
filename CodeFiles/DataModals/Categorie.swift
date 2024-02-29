//
//  Categorie.swift
//  Clikat
//
//  Created by Night Reaper on 23/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum CategoryKeys : String {
    
    case category_id = "category_id"
    case category_name = "category_name"
    case order = "order"
    case category = "category"
    case category_flow = "category_flow"
    case supplier_placement_level

}

class Categorie : NSObject {
    
    var category_name : String?
    var category_id : String?
    var order : String?
    var category_flow : String?
    var supplier_placement_level : String?

    var image : String?
    var desc : String? //description
    var supplierId : String?
    var is_subcategory: Int?
    
    init(attributes : SwiftyJSONParameter){
        
        self.category_id = attributes?[CategoryKeys.category_id.rawValue]?.stringValue
        self.category_name = attributes?[CategoryKeys.category_name.rawValue]?.stringValue
        self.order = attributes?[CategoryKeys.order.rawValue]?.stringValue
        self.category_flow = attributes?[CategoryKeys.category_flow.rawValue]?.stringValue ?? ""
        self.supplier_placement_level = attributes?[CategoryKeys.supplier_placement_level.rawValue]?.stringValue
        self.image = attributes?[ServiceTypeKeys.image.rawValue]?.stringValue
        self.desc = attributes?[ServiceTypeKeys.description.rawValue]?.stringValue
        self.is_subcategory = attributes?["is_subcategory"]?.intValue
    }
    
    override init() {
        super.init()
        
    }
    
    
    var toServiceType: ServiceType {
        let objNew = ServiceType(attributes: nil)
        objNew.id = category_id
        objNew.category_flow = category_flow
        objNew.supplier_placement_level = supplier_placement_level
        objNew.name = category_name
        objNew.order = order
        objNew.image = image
        objNew.desc = desc
        objNew.supplierId = supplierId
        objNew.is_subcategory = is_subcategory
        return objNew
    }
    
}

class CategoriesListing {
    
    var arrayCategories : [Categorie]?
    
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[CategoryKeys.category.rawValue]
        let cats = dict.arrayValue
        var arrayCategories : [Categorie] = []
        
        for element in cats{
            let supplier = Categorie(attributes: element.dictionaryValue)
            arrayCategories.append(supplier)
        }
        self.arrayCategories = arrayCategories
    }
    
}


