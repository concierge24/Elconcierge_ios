//
//  PayFort.swift
//  Clikat
//
//  Created by cblmacmini on 8/27/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum PayfortKeys : String {
    
    case access_code = "access_code"
    case sdk_token = "sdk_token"
    case signature = "signature"
    case merchant_identifier = "merchant_identifier"
}


class PayFort: NSObject {

    
    var accessCode : String?
    var sdkToken : String?
    var signature : String?
    var merchantIdentifier : String?
    
    
    init(attributes : SwiftyJSONParameter){
        accessCode = attributes?[PayfortKeys.access_code.rawValue]?.stringValue
        sdkToken = attributes?[PayfortKeys.sdk_token.rawValue]?.stringValue
        signature = attributes?[PayfortKeys.signature.rawValue]?.stringValue
        merchantIdentifier = attributes?[PayfortKeys.merchant_identifier.rawValue]?.stringValue
    }
}
