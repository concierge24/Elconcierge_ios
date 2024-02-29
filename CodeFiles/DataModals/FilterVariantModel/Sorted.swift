//
//  SortedBy.swift
//  Sneni
//
//  Created by MAc_mini on 04/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation


class Sorted {
    
    var type : TableViewSectionTypes = .none
    var variantName : String?
    var subName : String?
    var id : Int = 0
    
    init(subName: String?, type : TableViewSectionTypes, id: Int) {
        
        self.variantName = type.rawValue
        self.type = type
        self.id = id
        self.subName = subName
    }
    
    init(variantName : String?, id: Int) {
        
        self.variantName = variantName
        self.id = id
        
    }
}

//var variantName : String!
//var variantValues : [VariantValue]!
