//
//  GeofenceTax.swift
//  Sneni
//
//  Created by Ankit Chhabra on 22/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper
import EZSwiftExtensions


class GeofenceTaxData : NSCoding {

    let taxData : [TaxData]?
    
    init (attributes : SwiftyJSONParameter) {
          
          var arrayTaxData : [TaxData] = []
          for element in attributes?["taxData"]?.arrayValue ?? [] {
              let obj = TaxData(attributes: element.dictionaryValue)
              arrayTaxData.append(obj)
          }
          self.taxData = arrayTaxData
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(taxData, forKey: "taxData")
    }
    
    required init(coder aDecoder: NSCoder) {
        taxData = aDecoder.decodeObject(forKey: "taxData") as? [TaxData]

    }
}


class TaxData : NSObject {

    let delivery_charges : Double?
    let tax : Double?
    var payment_gateways: [String]?

    init (attributes : SwiftyJSONParameter) {
          
        self.delivery_charges = attributes?["delivery_charges"]?.doubleValue
        self.tax = attributes?["tax"]?.doubleValue
        self.payment_gateways = attributes?["payment_gateways"]?.arrayObject as? [String]

    }

}
