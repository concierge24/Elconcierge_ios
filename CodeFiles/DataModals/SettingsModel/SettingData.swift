//
//  SettingData.swift
//  Sneni
//
//  Created by MAc_mini on 11/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper

enum SettingDataFlowKeys : String {
    case app_type = "app_type"
}

//class SettingData : NSObject, RMMapping {
//    
//    var app_type : Int?
//    
//    
//    
//    init (attributes : Dictionary<String, JSON>?){
//        self.app_type = attributes?[ScreenFlowKeys.app_type.rawValue]?.intValue
//        
//    }
//    
//    override init() {
//        super.init()
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        
//        aCoder.encode(app_type, forKey: "app_type")
//        
//        
//        
//    }
//    
//    
//    
//    required init(coder aDecoder: NSCoder) {
//        
//        app_type = aDecoder.decodeObject(forKey: "app_type") as? Int
//        
//    }
//}
