//
//  WalletModel.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 08/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation
import ObjectMapper

class WalletModel: Mappable {
    var wallet_log_id : Int?
    var status : String?
    var transaction_by: String?
    var user_wallet_id: Int?
    var created_at : String?
    var transaction_type : String?
    var amount : Int?
    var sender_user_detail_id: Int?
    var receiver_user_id: Int?
    var updated_balance : Int?
    
    required init?(map: Map) {
           
       }
       
       func mapping(map: Map) {
        wallet_log_id <- map["wallet_log_id"]
        status <- map["status"]
        transaction_by <- map["transaction_by"]
        user_wallet_id <- map["user_wallet_id"]
        created_at <- map["created_at"]
        transaction_type <- map["transaction_type"]
        amount <- map["amount"]
        sender_user_detail_id <- map["sender_user_detail_id"]
        receiver_user_id <- map["receiver_user_id"]
        updated_balance <- map["updated_balance"]
    }
}

class WalletDetails: Mappable {
    
    var amount: Int?
    var details: Details?
    var user_wallet_id: Int?
   
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        amount <- map["amount"]
        details <- map["details"]
        user_wallet_id <- map["user_wallet_id"]
       
        
    }
}

class Details: Mappable {
    var lowBalanceAlert: Int?
    var minBalance: String?
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
           lowBalanceAlert <- map["lowBalanceAlert"]
          minBalance <- map["minBalance"]
       }
}


class AddWallet:Mappable{
    
    var wallet_id: Int?
    var amount: Int?
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
           wallet_id <- map["wallet_id"]
          amount <- map["amount"]
       }
}
