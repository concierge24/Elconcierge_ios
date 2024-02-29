//
//  RequestModel.swift
//  Sneni
//
//  Created by Daman on 01/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import ObjectMapper

class RequestList: Mappable {
    
    var data: [RequestModel]?
    var totalCount: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        data <- map["data"]
        totalCount <- map["totalCount"]
    }
}

class RequestModel: Mappable {
    
    var requestId: Int?
    var supplierName: String?
    var image: String?
    var supplier_branch_id: Int?
    var status: PrescriptionStatus = .pending
    var created_at: String?
    var createdAt: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        requestId <- map["id"]
        supplierName <- map["name"]
        image <- map["prescription_image"]
        status <- map["status"]
        created_at <- map["created_at"]
        createdAt = UtilityFunctions.getDateFormatted(format: OrderDateFormat.To.rawValue, date: created_at?.toDate(format: Formatters.ZZ))
    }
    
}
