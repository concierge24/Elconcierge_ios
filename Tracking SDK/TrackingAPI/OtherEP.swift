//
//  OtherEP.swift
//  Nequore
//
//  Created by MAC_MINI_6 on 17/07/18.
//  Copyright © 2018 Code-Brew Labs. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

enum OtherEP {
    case polyLineRoutes(sourceLat: String? , sourceLng: String? , destLat: String? , destLng: String?)
    case distanceBetween(sourceLat: Double , sourceLng: Double , destLat: Double , destLng: Double)
}

extension OtherEP: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType {
        return .bearer
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var multipartBody: [MultipartFormData]? {
        switch self {
            
        default:
            return nil
        }
    }
    
    var baseURL: URL {
        switch self {
        case .polyLineRoutes(_):
            return URL(string: "https://maps.googleapis.com/maps/api/directions/")!
        case .distanceBetween(_):
            return URL(string: "https://maps.googleapis.com/maps/api/")!
       
        }
    }
    
    var path: String {
        switch self {
        case .polyLineRoutes(_):
            return TrackingConstants.polyLine
        case .distanceBetween(let sourceLat, let sourceLng, let destLat, let destLng):
            return "distancematrix/json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .polyLineRoutes(_): return .get
        
        case .distanceBetween(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .polyLineRoutes(_):
            return JSONEncoding.default
            
        case .distanceBetween(_):
            return URLEncoding.queryString
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .polyLineRoutes(let sourceLat , let sourceLng , let destLat , let destLng):
            var dict = ["sensor" : "true" , "key" : GoogleApiKey]
            dict["origin"] = "\(/sourceLat),\(/sourceLng)"
            dict["destination"] = "\(/destLat),\(/destLng)"
            return dict
        case .distanceBetween(let sourceLat, let sourceLng, let destLat, let destLng):
            return ["units":"metric", "key" : GoogleApiKey, "origins": "\(sourceLat),\(sourceLng)", "destinations": "\(destLat),\(destLng)"]
        }
    }
    
    var task: Task {
        switch self {
        default:
            return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
}


extension TargetType {
    func parse(response : [String : Any]?) -> Any? {
        switch self {
        case is OtherEP:
            let target = self as! OtherEP
            switch target {
            case .polyLineRoutes(_):
                 return PolyRootClass(map: Map(mappingType: .fromJSON, JSON: response!))
                
            case .distanceBetween(_):
                if let data = response, let rows = data["rows"] as? [[String: Any]], let obj = rows.first {
                    if let elements = obj["elements"] as? [[String: Any]], let element = elements.first {
                        if let distanceObj = element["distance"] as? [String: Any], let value = distanceObj["value"] as? Float {
                            return value
                        }
                    }
                }
                return nil
            }
        default:
            return nil
        }
    }
}

