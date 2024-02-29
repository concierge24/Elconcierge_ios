//
//  InstitutionsModel.swift
//  RoyoRide
//
//  Created by Ankush on 21/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class InstitutionsModel: Mappable {
  
    var type: String?
    var parent_key: String?
    var name: String?
    var cooperation_id: Int?
    
    
  required init?(map: Map) {
    mapping(map: map)
  }
  
  func mapping(map: Map) {
    type <- map["type"]
    parent_key <- map["parent_key"]
    name <- map["name"]
    cooperation_id <- map["cooperation_id"]
  }
}
