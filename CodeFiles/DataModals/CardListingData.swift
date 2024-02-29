
//  Sneni
//
//  Created by Apple on 29/01/20.
//

import Foundation
import SwiftyJSON
import RMMapper

class CardListing: NSObject, RMMapping, NSCoding {
    
    var cardListing: [CardListingData]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(cardListing, forKey: "cardListing")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        cardListing = aDecoder.decodeObject(forKey: "cardListing") as? [CardListingData]
    }
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
//        self.cardListing =  attributes?["cardListing"]?.stringValue
         guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let products = json["data"].arrayValue
        
        var arrayValue : [CardListingData] = []
        for element in products{
            let value = CardListingData(attributes: element.dictionaryValue)
            arrayValue.append(value)
        }
        self.cardListing = arrayValue
    }
}

class CardListingData : NSObject , RMMapping, NSCoding {
    
    var expMonth: Int?
    var customer: String?
    var expYear: Int?
    var country: String?
    var name,brand, object, funding, last4: String?
    var id: String?
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.customer =  attributes?["customer"]?.stringValue
        self.country = attributes?["country"]?.stringValue
        if let brand = attributes?["brand"]?.stringValue {
            self.brand = brand
        }else {
            self.brand = attributes?["card_brand"]?.stringValue
        }
        self.id =  attributes?["id"]?.stringValue
        self.name = attributes?["name"]?.stringValue
        self.object = attributes?["object"]?.stringValue
        self.funding = attributes?["funding"]?.stringValue
        if let last4 = attributes?["last4"]?.stringValue {
            self.last4 =  last4
        }else {
            self.last4 =  attributes?["last_4"]?.stringValue
        }
        self.expMonth = attributes?["exp_month"]?.intValue
        self.expYear = attributes?["exp_year"]?.intValue
        
    }
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.customer, forKey:"customer")
        aCoder.encode(self.country , forKey: "country")
        aCoder.encode(self.brand , forKey: "brand")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.object , forKey: "name")
        aCoder.encode(self.object , forKey: "object")
        aCoder.encode(self.funding , forKey: "funding")
        aCoder.encode(self.last4, forKey: "last4")
        aCoder.encode(self.expMonth , forKey: "expMonth")
        aCoder.encode(self.expYear , forKey: "expYear")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.customer  = aDecoder.decodeObject(forKey: "customer") as? String
        self.country  = aDecoder.decodeObject(forKey: "country") as? String
        self.brand  = aDecoder.decodeObject(forKey: "brand") as? String
        self.id  = aDecoder.decodeObject(forKey: "id") as? String
        self.name  = aDecoder.decodeObject(forKey: "name") as? String
        self.object  = aDecoder.decodeObject(forKey: "object") as? String
        self.funding  = aDecoder.decodeObject(forKey: "funding") as? String
        self.last4  = aDecoder.decodeObject(forKey: "last4") as? String
        self.expMonth  = aDecoder.decodeObject(forKey: "expMonth") as? Int
        self.expYear  = aDecoder.decodeObject(forKey: "expYear") as? Int
    }
    
    
}


class AddCard: NSObject, RMMapping, NSCoding {
    
    var customer_payment_id: String?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(customer_payment_id, forKey: "customer_payment_id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        customer_payment_id = aDecoder.decodeObject(forKey: "customer_payment_id") as? String
    }
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        self.customer_payment_id =  attributes?["customer_payment_id"]?.stringValue
    }
}

class PayStackData : NSObject , RMMapping {
    
    var access_code: String?
    var authorization_url: String?
    var reference: String?
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        let data = attributes?[APIConstants.DataKey]?.dictionaryValue
        self.access_code =  data?["access_code"]?.stringValue
        self.authorization_url =  data?["authorization_url"]?.stringValue
        self.reference =  data?["reference"]?.stringValue
        
        
    }
}
