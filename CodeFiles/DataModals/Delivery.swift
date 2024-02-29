//
//  Delivery.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum DeliveryKeys : String {
    case postpone = "postpone"
    case min_order = "min_order"
    case min_order_delivery_charge = "min_order_delivery_charge"
    case free_delivery_amount = "free_delivery_amount"
    case standard = "standard"
    case urgent = "urgent"
    case urgent_type = "urgent_type"
    case urgent_price = "urgent_price"
    case urgent_delivery_time = "urgent_delivery_time"
    case payment_method = "payment_method"
    case address = "address"
    case is_urgent = "is_urgent"
    case delivery_max_time = "delivery_max_time"
    case is_postpone = "is_postpone"
    case notification_status = "notification_status"
    case userServiceCharge = "user_service_charge"
    case userID = "user_id"
    case base_delivery_charges
}

class Delivery: NSObject {
    
    var addresses : [Address]?
    var deliverySpeeds : [DeliverySpeed]?
    var minOrder : Double?
    var minOrderDeliveryCharge : String?
    var freeDeliveryAmount : String?
    var urgentType : String?
    var urgentPrice : String?
    var urgentDeliveryTime : String?
    var paymentMethod : PaymentMethod = .DoesntMatter
    var deliveryCharges : String?
    var totalPrice : String?
    var handlingAdmin : String?
    var handlingSupplier : String?
    var minOrderDeliveryCrossed : String?
    var isUrgent : String?
    
    var deliveryMaxTime : String?
    var isPostPone : String?
    
    var pickupAddress : Address?
    var pickupDate : Date?
    
    var netAmount : String?
    var userServiceCharge : String?
    var needPickup = false
    var userID: Int?
    var notificationStatus : String?
    var base_delivery_charges: Double?
    
    init(attributes : SwiftyJSONParameter) {
        
        super.init()
        guard let json = attributes else { return }
        var tempArr : [Address] = []
        for address in json[DeliveryKeys.address.rawValue]?.arrayValue ?? [] {
            let tempAddr = Address(attributes: address.dictionaryValue)
            tempArr.append(tempAddr)
        }
        addresses = tempArr
        notificationStatus = json[DeliveryKeys.notification_status.rawValue]?.stringValue
        userServiceCharge = json[DeliveryKeys.userServiceCharge.rawValue]?.stringValue
        userID = json[DeliveryKeys.userID.rawValue]?.int
        minOrder = json[DeliveryKeys.min_order.rawValue]?.doubleValue
        base_delivery_charges = json[DeliveryKeys.base_delivery_charges.rawValue]?.doubleValue
        minOrderDeliveryCharge = json[DeliveryKeys.min_order_delivery_charge.rawValue]?.stringValue
        freeDeliveryAmount = json[DeliveryKeys.free_delivery_amount.rawValue]?.stringValue
        urgentType = json[DeliveryKeys.urgent_type.rawValue]?.stringValue
        isUrgent = json[DeliveryKeys.is_urgent.rawValue]?.stringValue
        urgentDeliveryTime = json[DeliveryKeys.urgent_delivery_time.rawValue]?.stringValue
        paymentMethod = PaymentMethod(rawValue: json[DeliveryKeys.payment_method.rawValue]?.stringValue ?? "") ?? .DoesntMatter
        if let time = json[DeliveryKeys.delivery_max_time.rawValue]?.stringValue {
            deliveryMaxTime = time
        }
        isPostPone = json[DeliveryKeys.is_postpone.rawValue]?.stringValue
        deliverySpeeds = []
        if let standard = json[DeliveryKeys.standard.rawValue]?.stringValue {
            deliverySpeeds?.append(DeliverySpeed(selected: true, name: standard))
        }
        if let urgent = json[DeliveryKeys.urgent.rawValue]?.stringValue {
            deliverySpeeds?.append(DeliverySpeed(selected: false, name: urgent))
        }
//        if let postpone = json[DeliveryKeys.postpone.rawValue]?.stringValue, isPostPone == "1" {
//            deliverySpeeds?.append(DeliverySpeed(selected: false, name: postpone))
//        }
        
        
    }
    
    override init() {
        super.init()
    }
    
    
    static func validateTextFieldsInView(arrStrings : [String],view : UIView) -> Bool{
        var showAlert = false
        for (index,element) in arrStrings.enumerated() {
            
            if element != "Address Line Second" {
                guard let tf = view.viewWithTag(index + 1) as? UITextField,let text = tf.text else { continue }
                showAlert = text.trimmed() == "" ?  true : false
                if showAlert { break }
            }
        }
        return showAlert
    }
    
    
    func updateDeliveryFromDB(){
        DBManager().getCart {[weak self] (array) in
            
            self?.initalizeDelivery(cart: array)
        }
    }
    
    func initalizeDelivery(cart : [AnyObject]?){
        guard let arrCart = cart as? [Cart] else { return }
   
        handlingAdmin = arrCart.map({
            return /$0.handlingAdmin?.toDouble()
        }).max()?.toString
        handlingSupplier = arrCart.map({
            return /$0.handlingSupplier?.toDouble()
        }).max()?.toString
        
        totalPrice = arrCart.reduce(0.0, { (initial, cart) -> Double in
            let price = cart.getPrice(quantity: cart.quantity?.toDouble())?.toDouble() ?? 0.0
            let quantity = cart.quantity?.toDouble() ?? 0.0
            return initial + (price * (quantity < 0.0 ? 1 : quantity))
        }).toString
    
        self.deliveryCharges = arrCart.reduce(0.0, { (initial, cart) -> Double in
            let delivery = cart.deliveryCharges?.toDouble() ?? 0.0
            return delivery > initial ? delivery : initial
        }).toString
        var canUrgent = arrCart.reduce(arrCart.first?.canUrgent == "1" ? true : false, {
            
            ($1.canUrgent != nil && $1.canUrgent == "1") ? ($0 && true) : ($0 && false)
        })
        
        if arrCart.count == 1 {
            canUrgent = arrCart.first?.canUrgent == "1" ? true : false
        }
        if (deliverySpeeds?.count ?? 0) > 1 && !canUrgent && deliverySpeeds?[1].type == .Urgent {
            deliverySpeeds?.remove(at: 1)
        }
        if let minOrderPrice = minOrderDeliveryCharge?.toDouble(),let totalCharges = totalPrice?.toDouble() {
        
            minOrderDeliveryCrossed = totalCharges > minOrderPrice ? "1" : "0"
        }else {
            minOrderDeliveryCrossed = "1"
        }
        
        for product in arrCart {
            if product.category == "2" || product.category == "10" {
               needPickup = true
            }
        }
        if needPickup {
            pickupAddress = GDataSingleton.sharedInstance.pickupAddress
            pickupDate = GDataSingleton.sharedInstance.pickupDate
        }
        self.urgentPrice = getMaxHandlingPercentage(cart: arrCart)?.toString
        let arrAmount = [totalPrice?.toDouble(),handlingAdmin?.toDouble(),handlingSupplier?.toDouble(),deliveryCharges?.toDouble()]
        netAmount = arrAmount.reduce(0.0,{ $0 + /$1 }).toString
    }
    
    static func getDeliveryDate(delivery : Delivery? ,selectedType : DeliverySpeedType) -> Date?{
        let date : Date? = (delivery?.needPickup ?? false) ? delivery?.pickupDate : Date()
        switch selectedType {
        case .Standard, .Postpone, .scheduled:
            let maxDays = delivery?.deliveryMaxTime?.toDouble() ?? 0
            return date?.addingTimeInterval(Double(60 * maxDays))
        case .Urgent:
            guard let urgentTime = delivery?.urgentDeliveryTime, let timeInterval = Int(urgentTime) else { return nil }
            
            
            var components = DateComponents()
            components.minute = timeInterval
            let calendar = NSCalendar.current
            let myNewDate = calendar.date(byAdding: components, to: date ?? Date())
            return myNewDate
//            date?.dateByAddingTimeInterval(timeInterval * 60)
        }
    }
    
    func getMaxHandlingPercentage(cart : [Cart]) -> Double? {
        var maxUrgentPer : [Double] = []
        var maxUrgentValue : [Double] = []
        guard let total = totalPrice?.toDouble() else { return 0.0 }
        for product in cart {
            if product.urgentType == "1" {
                guard let urgent = product.urgentValue?.toDouble() else { continue }
                maxUrgentPer.append((total * urgent/100))
            } else {
                guard let urgent = product.urgentValue?.toDouble(), urgent != 0 else { continue }
                maxUrgentValue.append(urgent)
            }
        }
        return [maxUrgentPer.max(), maxUrgentValue.max()].reduce(0.0, { ($0) + ($1 ?? 0) })
    }
}

class DeliverySpeed : NSObject {
    
    var selected : Bool = false
    var type : DeliverySpeedType = .Standard
    var name : String?
    
    init(attributes : SwiftyJSONParameter){
        super.init()
    }
    
    init(selected : Bool,name : String?) {
        super.init()
        self.selected = selected
        self.name = name
        guard let tempName = name else { return }
        if tempName.contains(Localize.currentLanguage() == Languages.Arabic ? "عادي" : "Standard") {
            type = .Standard
        }else if tempName.contains(Localize.currentLanguage() == Languages.Arabic ? "العاجلة" : "Urgent"){
            type = .Urgent
        }else if tempName.contains(Localize.currentLanguage() == Languages.Arabic ? "تأجيل" : "Postpone"){
            type = .Postpone
        }
    }
    override init() {
        super.init()
    }
}
