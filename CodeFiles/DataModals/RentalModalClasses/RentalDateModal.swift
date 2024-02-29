//
//  RentalDateModalClass.swift
//  Sneni
//
//  Created by Apple on 08/11/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

class RentalDateModalClass: NSObject {
    
    var month: String?
    var date : String?
    var parameterDate : String?
    
    init(month: String?,date:String?,parameterDate:String) {
        self.month = month
        self.date = date
        self.parameterDate = parameterDate
    }
    
    override init() {
        super.init()
    }
}
