//
//  PickupDetails.swift
//  Clikat
//
//  Created by cblmacmini on 5/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class PickupDetails: NSObject {
    
    var arrAddress : [Address]?
    var date : Date?
    var time : String?
    
    init(arrAddress : [Address]?) {
        super.init()
        self.arrAddress = arrAddress
    }
    
    override init() {
        super.init()
    }
}
