//
//  PriceRangeModel.swift
//  Sneni
//
//  Created by MAc_mini on 04/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

class PriceRangeModel : NSObject{
    
    var range:Int = 0
    var variantName : String?
    
    override init() {
        
        self.range = 1
        self.variantName = "Price Range"
    }
}
