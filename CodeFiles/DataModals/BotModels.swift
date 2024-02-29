//
//  BotModels.swift
//  Sneni
//
//  Created by Sandeep Kumar on 15/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON

class BotError: NSObject {
    
    var code: Int?
    var errorType: String?
    var errorDetails: String?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(code, forKey: "code")
        aCoder.encode(errorType, forKey: "errorType")
        aCoder.encode(errorDetails, forKey: "errorDetails")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        code = aDecoder.decodeObject(forKey: "code") as? Int
        errorType = aDecoder.decodeObject(forKey: "errorType") as? String
        errorDetails = aDecoder.decodeObject(forKey: "errorDetails") as? String
    }
    
    init(attributes : SwiftyJSONParameter) {
        super.init()
        
        guard let json = attributes else { return }
        
        code = json["code"]?.int
        errorType = json["status"]?.stringValue
        errorDetails = json["message"]?.stringValue
        
    }
}

enum BotResultType: Int {
    case message = 0
    case products
}

class BotResult: NSObject {
    
    var message: String?
    var items: [ProductF]?
    var type: BotResultType = .message
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(type, forKey: "type")
        aCoder.encode(message, forKey: "message")
        aCoder.encode(items, forKey: "items")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        message = aDecoder.decodeObject(forKey: "message") as? String
        items = aDecoder.decodeObject(forKey: "items") as? [ProductF]
        type = aDecoder.decodeObject(forKey: "items") as? BotResultType ?? .message
    }
    
    init(attributes : SwiftyJSONParameter) {
        super.init()
        
        guard let json = attributes else { return }
        message = json["fulfillmentText"]?.stringValue

        let product = json["webhookPayload"]?.dictionary?["richResponse"]?.dictionary?["items"]?.arrayValue
        var tempProd : [ProductF] = []
        for prod in (product ?? []) {
            let itemList = ProductF(attributes: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        items = tempProd
        type = product == nil ? .message : .products
    }
}

class BotResponce: NSObject {
    
    var error: BotError?
    var result: BotResult?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(error, forKey: "error")
        aCoder.encode(result, forKey: "result")
        
    }
    
    required init?(coder aDecoder: NSCoder) {

        error = aDecoder.decodeObject(forKey: "status") as? BotError
        result = aDecoder.decodeObject(forKey: "result") as? BotResult
    }
    
    init(attributes : SwiftyJSONParameter) {
        super.init()
        
        guard let json = attributes else { return }
        
        error = BotError(attributes: json["error"]?.dictionaryValue)
        result = BotResult(attributes: json["queryResult"]?.dictionaryValue)
        
    }
}
