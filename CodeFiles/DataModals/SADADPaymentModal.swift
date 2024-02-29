//
//  SADADPaymentModal.swift
//  Sneni
//
//  Created by Ankit Chhabra on 22/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper


class SadadPaymentdata : NSObject , RMMapping, NSCoding {
    
    var transactionReference: String?
    var paymentUrl: String?
    var status: Int?
    var errorCode: Int?
    var errorMessage: String?
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.transactionReference =  attributes?["transaction-reference"]?.stringValue
        self.paymentUrl = attributes?["payment-url"]?.stringValue
        self.errorMessage =  attributes?["error-message"]?.stringValue
        self.status = attributes?["status"]?.intValue
        self.errorCode = attributes?["error-code"]?.intValue
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.transactionReference , forKey: "transactionReference")
        aCoder.encode(self.paymentUrl , forKey: "paymentUrl")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.transactionReference  = aDecoder.decodeObject(forKey: "transactionReference") as? String
        self.paymentUrl  = aDecoder.decodeObject(forKey: "paymentUrl") as? String
    }
    
    
}

