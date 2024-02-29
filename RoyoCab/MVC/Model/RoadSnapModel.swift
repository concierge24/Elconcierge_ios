//
//  RoadSnapModel.swift
//  Buraq24
//
//  Created by MAC_MINI_6 on 08/12/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper


class RoadSnap: Mappable {
  
  var location : SnapLocation?
  var originalIndex : Int?
  var placeId : String?
    var bearing :Double?

  required init?(map: Map) {
    mapping(map: map)
  }
  
  func mapping(map: Map) {
    location <- map["location"]
    originalIndex <- map["originalIndex"]
    placeId <- map["placeId"]
  }
}

class SnapLocation: Mappable {
  var latitude: Double?
  var longitude: Double?
  
  required init?(map: Map) {
    mapping(map: map)
  }
  
  func mapping(map: Map) {
    latitude <- map["latitude"]
    longitude <- map["longitude"]
  }
}
