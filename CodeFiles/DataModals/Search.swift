//
//  Search.swift
//  Clikat
//
//  Created by cblmacmini on 4/29/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON


enum SearchKeys : String {
    case name = "name"
    case result = "result"
}

class Search: NSObject {
    
    var title : String?
    var arrProducts : [ProductF]?
    
    init(title : String, arrProducts : [ProductF]) {
        self.title = title
        self.arrProducts = arrProducts
    }
    
    override init() {
        super.init()
    }
    
}

class SearchResult : NSObject {
    
    var arrSearchResults : [Search]?
    
    init(attributes : SwiftyJSONParameter) {
        
        var arrayResults : [Search] = []
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let results = json[APIConstants.DataKey][APIConstants.listKey].arrayValue
        for result in results{
            let dict = result[SearchKeys.result.rawValue]
            let products = dict.arrayValue
            var arrayProducts : [ProductF] = []
            for element in products{
                let product = ProductF(attributes: element.dictionaryValue)
                arrayProducts.append(product)
            }
            arrayResults.append(Search(title: result[SearchKeys.name.rawValue].stringValue, arrProducts: arrayProducts))
        }
        self.arrSearchResults = arrayResults
        
        
    }
    
    override init() {
        super.init()
    }
}
