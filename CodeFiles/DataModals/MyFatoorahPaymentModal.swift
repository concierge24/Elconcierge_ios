//
//  MyFatoorahPaymentModal.swift
//  Sneni
//
//  Created by Ankit Chhabra on 25/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper


class MyFatoorahPaymentdata : NSObject , RMMapping, NSCoding {
    
    var InvoiceId: String?
    var PaymentURL: String?

    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.InvoiceId =  attributes?["InvoiceId"]?.stringValue
        self.PaymentURL = attributes?["PaymentURL"]?.stringValue

        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.InvoiceId , forKey: "InvoiceId")
        aCoder.encode(self.PaymentURL , forKey: "PaymentURL")

    }
    
    required init(coder aDecoder: NSCoder) {
        self.InvoiceId  = aDecoder.decodeObject(forKey: "InvoiceId") as? String
        self.PaymentURL  = aDecoder.decodeObject(forKey: "PaymentURL") as? String

    }
    
    
}

