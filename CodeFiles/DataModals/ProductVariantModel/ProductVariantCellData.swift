//
//  ProductVariantCellData.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

class ProductVariantCellData {
 
    var suppliername : String?
    var price : String?
    var name:String?
    var displayPrice:String?
    var id : Int = 0

    init(suppliername:String,price:String,name:String,displayPrice:String,id:Int) {
    
        self.suppliername = suppliername
        self.price = price
        self.name = name
        self.id = id
        self.displayPrice = displayPrice

}
    
}
