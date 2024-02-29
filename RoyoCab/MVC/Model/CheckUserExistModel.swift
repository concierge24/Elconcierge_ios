//
//  CheckUserExistModel.swift
//  RoyoRide
//
//  Created by Ankush on 21/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class CheckUserExistModel: Mappable {
  
    var AppDetail: Appdet?
    
  required init?(map: Map) {
    mapping(map: map)
  }
  
  func mapping(map: Map) {
    AppDetail <- map["AppDetail"]
  }
}


class Appdet: Mappable {
      
  var userExists : Bool?

  required init?(map: Map) {
    mapping(map: map)
  }
  
  func mapping(map: Map) {
    userExists <- map["userExists"]
  }
}
