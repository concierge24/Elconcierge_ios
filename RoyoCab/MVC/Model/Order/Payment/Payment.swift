//
//  Payment.swift
//  Buraq24
//
//  Created by MANINDER on 31/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper

class Payment: Mappable {
    
    
    var paymentType : PaymentType = .Cash
    var productWeight : String?
    var productPerQuantityCharge : String?
    var refundStatus : String?
    var initalCharge : String?
    var adminCharge : String?
    var bottleCharge : String?
    var refundId : String?
    var transactionId: String?
    var paymentId : Int?
    var productActualValue : String?
    var orderDistance : String?
    var productPerWeightCharge :String?
    var bottleReturnedValue : Int?
    var finalCharge : String?
    var bankCharge : String?
    var productPerDistanceCharge :String?
    var productStatus : String?
    var productQuantity : Int?
    var productAplhaCharge : String?
    var buraqPercentage : Float?
    var order_time: String?
    var waiting_time: String?
    var waiting_charges:String?
    var previous_charges:String?
    var price_per_km : String?
    var price_per_min : String?
    var extra_distance : String?
    var extra_time : String?
    var distance_price_fixed : String?
    var product_per_distance_charge : String?
    var product_per_hr_charge : String?
    var paymentBody: String?
    var tipCharge : String?
    var sur_charge: String?
    var tip: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        var strType : String?
        
        strType <- map["payment_type"]
        //guard let type = strType else {return}
        
        paymentType = PaymentType(rawValue: strType ?? "Cash") ?? .Cash
        paymentBody <- map["payment_body"]
        productWeight <- map["product_weight"]
        productPerQuantityCharge <- map["product_per_quantity_charge"]
        refundStatus <- map["refund_status"]
        initalCharge <- map["initial_charge"]
        adminCharge <- map["admin_charge"]
        bottleCharge <- map["bottle_charge"]
        refundId <- map["refund_id"]
        transactionId <- map["transaction_id"]
        paymentId <- map["payment_id"]
        productActualValue <- map["product_actual_value"]
        orderDistance <- map["order_distance"]
        productPerWeightCharge <- map["product_per_weight_charge"]
        bottleReturnedValue <- map["bottle_returned_value"]
        finalCharge <- map["final_charge"]
        bankCharge <- map["bank_charge"]
        productPerDistanceCharge <- map["product_per_distance_charge"]
        productStatus <- map["payment_status"]
        productQuantity <- map["product_quantity"]
        productAplhaCharge <- map["product_alpha_charge"]
        buraqPercentage <- map["buraq_percentage"]
        order_time <- map["order_time"]
        price_per_km <- map["price_per_km"]
        price_per_min <- map["price_per_min"]
        extra_distance <- map["extra_distance"]
        extra_time <- map["extra_time"]
        distance_price_fixed <- map["distance_price_fixed"]
        waiting_charges <- map["waiting_charges"]
        previous_charges <- map["previous_charges"]
        waiting_time <- map["waiting_time"]
        product_per_hr_charge <- map["product_per_hr_charge"]
        product_per_distance_charge <- map["product_per_distance_charge"]
        sur_charge <- map["sur_charge"]
    }
}
