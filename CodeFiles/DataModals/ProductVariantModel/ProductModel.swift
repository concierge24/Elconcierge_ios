//
//  ProductModel.swift
//  Sneni
//
//  Created by Mac_Mini17 on 13/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper



class ProductModel {
  
    var variantName : String?
   
    var variantValuesArr : [ProductVariantValue]?
    
    init (attributes : Dictionary<String, JSON>?){
      
        
        self.variantName = attributes?[BookingFlowKeys.is_scheduled.rawValue]?.string
         variantValuesArr = [ProductVariantValue]()
        let variantValues = attributes?[BookingFlowKeys.schedule_time.rawValue]?.arrayValue
        
        for dict in variantValues ?? []{
            
            let value = ProductVariantValue(fromDictionary: dict.dictionaryValue)
            variantValuesArr?.append(value)
            
        }
     
        
    }
    
    
    
    
    
}
