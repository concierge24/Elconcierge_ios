//
//  OrderSummary.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

//prefix operator /
//
//prefix func /(value: Int?) -> Int {
//    return value ?? 0
//}
//prefix func /(value : String?) -> String {
//    return value ?? ""
//}
//prefix func /(value : Bool?) -> Bool {
//    return value ?? false
//}
//prefix func /(value : Double?) -> Double {
//    return value ?? 0.0
//}
//prefix func /(value : Array<AnyObject>) -> Array<AnyObject> {
//    return value
//}

enum CartFlowType {
    case Normal
    case LoyaltyPoints
    case Laundry
}

class OrderSummary: NSObject {
    
    var isBuyOnly: Bool = false
    var useReferral = false
    var promoCode: PromoCode?
    var pickupAddress : Address?
    var pickupDate : Date?
    var deliveryAddress : Address?
    var deliveryDate : Date?
    var currentDate : Date?
    var items : [Cart]?
    var netTotal : String?
    var netTotalActualValue : String?
    var deliveryCharges : String?
    var handlingFee : String?
    var netPayableAmount : String?
    var discount : Double?
    var displayNetTotal : String? {
        didSet {
            print("fdfsd")
        }
    }
    var paymentMode = PaymentMode(paymentType: .DoesntMatter)
    var handlingCharges : String?
    var handlingSupplier: String?
    var minOrderAmount : String?
    var minDelCharges : Double?
    var regionDeliveryCharge: Double?
    var totalAmount : Double?
    var pickupBuffer : String?
    var isPackage : String?
    var dDeliveryCharges : Double?
    var dTotalPrice : Double?
    var selectedDeliverySpeed : DeliverySpeedType = .Standard
    var deliveryMaxTime : Int?

    var duration : Double?
    var questions: [Question]?
    var deliveryAdditionalCharges : Double?{
        didSet{
//            let delivery = deliveryAdditionalCharges?.toString
//            deliveryCharges = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string,delivery])
//            let total = /totalAmount  + /deliveryAdditionalCharges
//            netPayableAmount = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string ,total.toString])
        }
    }
    
    var cartId : String?
    var agentId : String?
    var isAgent : Bool = false
    var addOnCharge: Double = 0
    var appType: SKAppType {
        if let t = GDataSingleton.sharedInstance.cartAppType, let model = SKAppType(rawValue: t) {
            return model
        }
        return SKAppType.type
    }
    var referralApplied = false
    
    override init() {
        super.init()
        
//        DBManager().getCart { (array) in
//            weak var weakSelf = self
//            weakSelf?.initalizeOrderSummary(array)
//        }
    }
    
    init(items : [Cart]?){
        super.init()
        
        initalizeOrderSummary(cart: items)
    }
    
    init(items: [Cart]?, promo: PromoCode?,netTotal : String? = "", deliveryBasePrice: Double? = nil, regionDeliveryCharge: Double? = nil, referralApplied: Bool? = false){
        super.init()
        promoCode = promo
        minDelCharges = deliveryBasePrice
        self.regionDeliveryCharge = regionDeliveryCharge
        self.referralApplied = /referralApplied
        guard let arrCart = items else { return }
        self.netPayableAmount = netTotal
        initalizeOrderSummary(cart: arrCart, forRental: true, rentalTotal: netTotal ?? "")
        self.deliveryMaxTime = items?.map({/$0.deliveryMaxTime}).max()
    }
    
    init(items : [Cart]?,netTotal : String?) {
        self.items = items
        self.netTotal = netTotal
        self.netPayableAmount = netTotal
        self.displayNetTotal = netTotal
        self.deliveryCharges = "0.0" + L10n.Points.string
        self.deliveryMaxTime = items?.map({/$0.deliveryMaxTime}).max()
    }
    
    func initalizeOrderSummary(cart : [AnyObject]?,forRental:Bool = false,rentalTotal : String? = ""){
        guard let arrCart = cart as? [Cart] else { return }
        self.deliveryMaxTime = arrCart.map({/$0.deliveryMaxTime}).max()
//        let totalPrice = arrCart.reduce(0.0, {
//            (initial, cart) -> Double in
//            let price = cart.getPrice(quantity: cart.quantity?.toDouble())?.toDouble() ?? 0.0
//            let quantity = cart.quantity?.toDouble() ?? 0.0
//            return initial + (price * (quantity < 0.0 ? 1 : quantity))
//        })
//        dTotalPrice = totalPrice
//
        let totalDuration = arrCart.reduce(0.0, {
            (initial, cart) -> Double in
            return initial + cart.totalDuration
        })
        duration = totalDuration
        questions = arrCart.first?.questionsSelected

//        
//        let deliCharges = arrCart.reduce(0.0, { (initial, cart) -> Double in
//            let delivery = cart.deliveryCharges?.toDouble() ?? 0.0
//            return delivery > initial ? delivery : initial
//        })
//        
//        if let _ = deliveryAdditionalCharges {
//            dDeliveryCharges = /deliveryAdditionalCharges
//        }else {
//           dDeliveryCharges = deliCharges
//        }
//        
//        isPackage = arrCart.first?.category == "12" ? "1" : "0"
//        
//        items = arrCart
//        
//        guard let maxSupplier = Double(Cart.getMaxSupplier(cart: arrCart) ?? "0"), let maxAdmin = Double(Cart.getMaxAdmin(cart: arrCart) ?? "0") else { return }
//        
//        let handling = maxSupplier + maxAdmin
//        let total = totalPrice + /dDeliveryCharges + handling
//        totalAmount = total
//        handlingCharges = handling.addCurrencyLocale
//        displayNetTotal =  total.addCurrencyLocale
//        netTotal =  totalPrice.addCurrencyLocale
//        deliveryCharges =  (/dDeliveryCharges).addCurrencyLocale
//        netPayableAmount = total.addCurrencyLocale
       
        //Nitin
//        if forRental {
//            self.netPayableAmount = Double(/rentalTotal)?.addCurrencyLocale
//        }
        
        //Add ons in home service
              if appType == .home {
                  //I home service only 1 product allowed to be added
                  let product = arrCart.first
                  if let questions = product?.questionsSelected, !questions.isEmpty {
                      addOnCharge = questions.addOnPrice(productPrice: Double(/product?.getPrice(quantity: (Double((product?.quantity)!) ?? 1))))
                  }
              }
        
        CartBillCell.getNewTotalPrice(promo: self.promoCode, addOnCharges: addOnCharge, cart: arrCart, minDelCharges: minDelCharges, region_delivery_charge: regionDeliveryCharge) {
            [weak self] (totalPrice, deliveryCharges, discountOnTotal, handlingCharges, qty) in
            guard let self = self else { return }
            
            var discount = 0.0
            
            if let promoCode = self.promoCode {
                
                let isPercent = promoCode.discountType == 1
                let discountPrice = /promoCode.discountPrice
                
                if isPercent {
                    discount = discountOnTotal * discountPrice/100
                } else {
                    if discountPrice > discountOnTotal {
                        discount = discountOnTotal
                    } else {
                        discount = discountPrice
                    }
                }
            }
            
            if let _ = self.deliveryAdditionalCharges {
                self.dDeliveryCharges = /self.deliveryAdditionalCharges
            }else {
                self.dDeliveryCharges = deliveryCharges
            }
            
//            let maxSupplier = /Double(Cart.getMaxSupplier(cart: arrCart) ?? "0")
//            let maxAdmin = /Double(Cart.getMaxAdmin(cart: arrCart) ?? "0")
//            var handlingCharges = Double()
//            if GDataSingleton.sharedInstance.fromCart ?? false {
//                handlingCharges = maxAdmin
//            } else {
//                handlingCharges =  (maxAdmin/100)*totalPrice.rounded(toPlaces: 2)
//            }
           // let handlingCharges = maxSupplier + maxAdmin
            if self.appType == .home {
                let maxSupplier = /Double(Cart.getMaxSupplier(cart: arrCart) ?? "0")
                self.handlingSupplier = String(maxSupplier)
            }
            let referralAmount = Double(GDataSingleton.sharedInstance.referalAmount ?? 0.0)
            
            let tipAmount = GDataSingleton.sharedInstance.tipAmount.toDouble
            
            let subTotal = totalPrice
            let valueServiceCharge = DeliveryType.shared == .pickup ? 0.0 : Double(/GDataSingleton.sharedInstance.userServiceCharge)
            let userServiceCharge = subTotal * /valueServiceCharge / 100
                  
            let netTotal = ((totalPrice + handlingCharges + /self.dDeliveryCharges + self.addOnCharge + tipAmount + userServiceCharge) - discount - referralAmount)

//            let netTotal = ((totalPrice + handlingCharges + deliveryCharges + valueLabelTip + addOnCharge) - discount - referralAmountApplied)
            //let netTotal = ((subTotal + /self.dDeliveryCharges + handlingCharges) - discount)
            
            self.handlingCharges = String(handlingCharges)
            self.deliveryCharges =  self.dDeliveryCharges?.addCurrencyLocale
            
            self.netPayableAmount = netTotal.addCurrencyLocale
            self.totalAmount = netTotal
            self.netTotal =  netTotal.addCurrencyLocale
            self.displayNetTotal =  subTotal.addCurrencyLocale
            self.discount = discount
            
            //Nitin
//            if forRental {
//                self.netPayableAmount = Double(/rentalTotal)?.addCurrencyLocale
//            }
            
            
            //            self.labelSubTotal?.text = subTotal.addCurrencyLocale
            
            //            self.labelDiscont.text = discount.addCurrencyLocale
            //            self.labelNetTotal?.text = netTotal.addCurrencyLocale
        }
        
        
    }
}


class LoyaltyPointsSummary : OrderSummary{
    
    var totalPoints : String?
    var deliveryData : Delivery?
    var cartFlowType : CartFlowType = .LoyaltyPoints
}
