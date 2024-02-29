//
//  TerminologyModal.swift
//  Sneni
//
//  Created by cbl41 on 1/23/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

enum TerminologyKeys: String {
    case product
    case products
    case supplier
    case suppliers
    case order
    case orders
    case agent
    case agents
    case brand
    case brands
    case category
    case categories
    case catalogue
    case status
    case popularRestaurantes
    case noOrderFound
    case product_file_upload
    case customisable
    case unserviceable
    case paymentDetails
    case email
    case shareScreenshot
    case choosePaymentReceipt
    case wishlist
    case choosePayment
    case orderNow
    
    func englishText() -> String? {
        guard let model = AppSettings.shared.appThemeData?.terminology else { return nil}
        var txt: String?
        switch self {
        case .product:
            txt = model.english?.product
        case .products:
            txt = model.english?.products
        case .supplier:
            txt = model.english?.supplier
        case .suppliers:
            txt = model.english?.suppliers
        case .order:
            txt = model.english?.order
        case .orders:
            txt = model.english?.orders
        case .agent:
            txt = model.english?.agent
        case .agents:
            txt = model.english?.agents
        case .brand:
            txt = model.english?.brand
        case .brands:
            txt = model.english?.brands
        case .category:
            txt = model.english?.category
        case .categories:
            txt = model.english?.categories
        case .catalogue:
            txt = model.english?.catalogue
        case .popularRestaurantes:
            txt = model.english?.popularRestaurantes
        case .noOrderFound:
            txt = model.english?.noOrderFound
        case .product_file_upload:
            txt = model.english?.product_file_upload
        case .customisable:
            txt = model.english?.customisable
        case .unserviceable:
            txt = model.english?.unserviceable
        case .paymentDetails:
            txt = model.english?.paymentDetails
        case .email:
            txt = model.english?.email
        case .shareScreenshot:
            txt = model.english?.shareScreenshot
        case .choosePaymentReceipt:
            txt = model.english?.choosePaymentReceipt
        case .wishlist:
            txt = model.english?.wishlist
        case .choosePayment:
            txt = model.english?.choosePayment
        case .orderNow:
            txt = model.english?.orderNow
        default:
            txt = nil
        }
        if let value = txt, !value.isEmpty {
            return value
        }
        return nil
    }
    
    func otherText() -> String? {
        guard let model = AppSettings.shared.appThemeData?.terminology else { return nil}
        var txt: String?
        switch self {
        case .product:
            txt = model.other?.product
        case .products:
            txt = model.other?.products
        case .supplier:
            txt = model.other?.supplier
        case .suppliers:
            txt = model.other?.suppliers
        case .order:
            txt = model.other?.order
        case .orders:
            txt = model.other?.orders
        case .agent:
            txt = model.other?.agent
        case .agents:
            txt = model.other?.agents
        case .brand:
            txt = model.other?.brand
        case .brands:
            txt = model.other?.brands
        case .category:
            txt = model.other?.category
        case .categories:
            txt = model.other?.categories
        case .catalogue:
            txt = model.other?.catalogue
        case .popularRestaurantes:
            txt = model.other?.popularRestaurantes
        case .noOrderFound:
            txt = model.other?.noOrderFound
        case .product_file_upload:
            txt = model.other?.product_file_upload
        case .customisable:
            txt = model.other?.customisable
        case .unserviceable:
            txt = model.other?.unserviceable
        case .paymentDetails:
            txt = model.other?.paymentDetails
        case .email:
            txt = model.other?.email
        case .shareScreenshot:
            txt = model.other?.shareScreenshot
        case .choosePaymentReceipt:
            txt = model.other?.choosePaymentReceipt
        case .wishlist:
            txt = model.other?.wishlist
        case .choosePayment:
            txt = model.other?.choosePayment
        case .orderNow:
            txt = model.other?.orderNow

        default:
            txt = nil
        }
        if let value = txt, !value.isEmpty {
            return value
        }
        return nil
    }
    
    func localizedValue(prefix: String? = nil, appType: SKAppType? = SKAppType.type) -> Any? {
        let type = appType ?? SKAppType.type
        guard let model = AppSettings.shared.appThemeData?.terminology else { return defaultText(prefix: prefix, appType: type) }
        if self == TerminologyKeys.status {
            if type.isFood {
               return Localize.currentLanguage() == Languages.English ? model.english?.status ?? [] : model.other?.status ?? []
            } else if type.isHome {
               return Localize.currentLanguage() == Languages.English ? model.english?.status ?? [] : model.other?.status ?? []
            } else {
               return Localize.currentLanguage() == Languages.English ? model.english?.status ?? [] : model.other?.status ?? []
            }
        }
        
        if Localize.currentLanguage() == Languages.English {
            let value = englishText() ?? defaultText(prefix: prefix, appType: type)
            if prefix == nil || prefix == "" {
                return value
            }
            return "\(prefix!) \(value)"
        }
        else {
            let arabicValue = otherText() ?? defaultText(prefix: prefix, appType: type)
            if prefix == nil || prefix == "" {
                return arabicValue
            }
//            let value = englishText() ?? defaultEnglishText(prefix: prefix, appType: appType)
            /*
            if prefix == "Popular" {
                if value == "Brands" || value == "Suppliers" || value == "Service Providers" || value == "Products" || value == "Restaurants" {
                    //Return localization for complete text which is added in strings file
                    return "\(prefix!) \(value)".localized()
                }
            }
             */
            return "\(prefix!.localized()) \(arabicValue)"
        }
    }
    
    func defaultText(prefix: String? = nil, appType: SKAppType? = SKAppType.type) -> String {
        return defaultEnglishText(prefix: prefix, appType: appType).localized()
    }
    
    func defaultEnglishText(prefix: String? = nil, appType: SKAppType? = SKAppType.type) -> String {
        let type = appType ?? SKAppType.type
        switch self {
        case .product:
            return type.product
        case .products:
            return type.products
        case .supplier:
            return type.supplier
        case .suppliers:
            return type.suppliers
        case .order:
            return type.order
        case .orders:
            return type.orders
        case .agent:
            return type.agent
        case .agents:
            return type.agents
        case .brand:
            return "Brand"
        case .brands:
            return "Brands"
        case .category:
            return "Category"
        case .categories:
            return "Categories"
        case .catalogue:
            if type.isFood {
                return "Menu"
            } else if type.isHome {
                return "Services"
            } else {
                return "Catalogue"
            }
        case .unserviceable:
            return "Unserviceable"
        default:
            return self.englishText() ?? ""
        }
    }
}

class TerminologyModalClass: NSObject,Mappable,NSCoding {
    
    var other : TerminologyDataModal?
    var english : TerminologyDataModal?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map) {
        other <- map ["other"]
        english <- map["english"]
    }

    @objc required init(coder aDecoder: NSCoder){
        other = aDecoder.decodeObject(forKey: "other") as? TerminologyDataModal
        english = aDecoder.decodeObject(forKey: "english") as? TerminologyDataModal

    }
    
    @objc func encode(with aCoder: NSCoder){
        if other != nil{
            aCoder.encode(other, forKey: "other")
        }
        if english != nil{
            aCoder.encode(english, forKey: "english")
        }
        
    }

    func localizedStatus(status: OrderDeliveryStatus, deliveryType: DeliveryType, appType: SKAppType? = SKAppType.type) -> String {
        let type = appType ?? SKAppType.type
        let statusDict = Localize.currentLanguage() == Languages.English ? self.english?.status : self.other?.status
        if let str = statusDict?[status.rawValue] as? String, !str.isEmpty {
            return str
        }
//        {\"status\":{\"0\":\"a\",\"1\":\"b\",\"2\":\"c\",\"3\":\"d\",\"4\":\"e\",\"5\":\"f\",\"6\":\"g\",\"7\":\"h\",\"8\":\"i\",\"9\":\"j\",\"10\":\"k\",\"11\":\"l\"
        
        switch status {
        case .Pending:
            return type == .food ? L11n.placed.string : L11n.pending.string
            
        case .Confirmed: //1 - Approved / Confirmed / Confirmed
            return L11n.confirmed.string
            
        case .inTheKitchan: // 11 - Placed / OnTheWay / InTheKitchen
            return type == .food ? L11n.inTheKitchan.string : (type == .home ? L11n.onTheWay.string : L11n.packed.string)
            
        case .Reached: // 10 - Shipped / Reached / NA ** shown in pickup case **
            if type == .food {
                return "Ready to be Picked" //deliveryType == .pickup ? "Ready to be Picked" : L11n.onTheWay.string
            }
            return type == .home ? L11n.Reached.string : L11n.shipped.string
            
        case .Shipped: // 3 - OutForDelivery / Started / ReadyToBePicked ** shown in delivery case **
            if type == .food {
                return deliveryType == .pickup ? "Ready to be Picked" : L11n.onTheWay.string
            }
            return type == .home ? L11n.Started.string : L11n.outForDelivery.string
            
        case .Delivered: // 5 - Delivered / Ended / Delivered
            if type == .food {
                return deliveryType == .pickup ? "Picked Up" : L11n.delivered.string
            }
            return type == .home ? L11n.Ended.string : L11n.delivered.string
            
        case .CustomerCancel:
            return L11n.canceled.string //L10n.CUSTOMERCANCELLED.string
        case .Rejected:
            return L11n.rejected.string //L10n.REJECTED.string
        case .FeedbackGiven:
            return L10n.FEEDBACKGIVEN.string
            
        case .Nearby:
            return L10n.NEARBY.string
            
        case .Tracked:
            return L10n.TRACKED.string
            
        case .Schedule:
            return L10n.SCHEDULED.string
        }

//         , "Ready to be Picked"//L11n.onTheWay.string
//        // , L11n.nearby.string //Nitin Food new changes
//         , "Picked Up"//L11n.delivered.string
        
        
//               case .inTheKitchan:
//                   return (SKAppType.type == .food || SKAppType.type.isJNJ) ? L11n.inTheKitchan.string : ((SKAppType.type == .home) ? L11n.start.string : L11n.inProgress.string
//               case .Shipped:
//                   return (SKAppType.type.isJNJ ? "Ready to be Picked" : (SKAppType.type == .eCom ? L10n.SHIPPED.string : L11n.onTheWay.string))
//
//               case .Reached:
//                   //Nitin
//                   return (SKAppType.type.isJNJ ? "Ready to be Picked" : ((SKAppType.type == .home) ? L11n.Reached.string : L11n.nearby.string))

        
    }
}

                            //   For Ecom, Home and Food Respectively
enum StatusTerminologies: String {
    case PENDING = "0"
    case CONFIRMED = "1" // 1 - Approved / Confirmed / Confirmed
    case REJECTED = "2"
    case STARTED = "3" // 3 - OutForDelivery / Started / ReadyToBePicked
    case NEARYOU = "4"
    case ENDED = "5" // 5 - Delivered / Ended / Delivered
    case RATINGGIVEN = "6"
    case TRACK = "7"
    case CUSTOMERCANCELLED = "8"
    case SCHEDULED = "9"
    case REACHED = "10" // 10 - Shipped / Reached / NA
    case ONTHEWAY = "11" // 11 - Placed / OnTheWay / InTheKitchen
}

class TerminologyDataModal : NSObject,Mappable,NSCoding {
    
    var product : String?
    var products : String?
    var supplier : String?
    var suppliers : String?
    var order : String?
    var orders : String?
    var agent : String?
    var agents : String?
    var brand : String?
    var brands : String?
    var category : String?
    var categories : String?
    var catalogue : String?
    var status : [String:Any]?
    var popularRestaurantes:String?
    var noOrderFound:String?
    var product_file_upload: String?
    var customisable:String?
    var unserviceable:String?
    var paymentDetails:String?
    var email:String?
    var shareScreenshot:String?
    var choosePaymentReceipt:String?
    var choosePayment: String? = "Choose Payment"
    var orderNow : String? = "Order Now"
    
    var wishlist: String?
    
    required init?(map: Map){}
    private override init(){}
       
    
    func mapping(map: Map) {
        product <- map ["product"]
        products <- map["products"]
        supplier <- map ["supplier"]
        suppliers <- map["suppliers"]
        order <- map ["order"]
        orders <- map["orders"]
        agent <- map ["agent"]
        agents <- map["agents"]
        brand <- map ["brand"]
        brands <- map["brands"]
        category <- map ["category"]
        categories <- map["categories"]
        catalogue <- map ["catalogue"]
        status <- map["status"]
        popularRestaurantes <- map["Popular Restaurantes"]
        noOrderFound <- map["No Orden found"]
        product_file_upload <- map["product_file_upload"]
        customisable <- map["Customisable"]
        unserviceable <- map ["Unserviceable"]
        paymentDetails <- map["Payment Details"]
        email <- map["Email"]
        shareScreenshot <- map["Share screenshot"]
        choosePaymentReceipt <- map["CHOOSE PAYMENT RECEIPT"]
        wishlist <- map["wishlist"]
        choosePayment <- map["choose_payment"]
        orderNow <- map["order_now"]
    }

    @objc required init(coder aDecoder: NSCoder){
        product = aDecoder.decodeObject(forKey: "product") as? String
        products = aDecoder.decodeObject(forKey: "products") as? String
        supplier = aDecoder.decodeObject(forKey: "supplier") as? String
        suppliers = aDecoder.decodeObject(forKey: "suppliers") as? String
        order = aDecoder.decodeObject(forKey: "order") as? String
        orders = aDecoder.decodeObject(forKey: "orders") as? String
        agent = aDecoder.decodeObject(forKey: "agent") as? String
        agents = aDecoder.decodeObject(forKey: "agents") as? String
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        brands = aDecoder.decodeObject(forKey: "brands") as? String
        category = aDecoder.decodeObject(forKey: "category") as? String
        categories = aDecoder.decodeObject(forKey: "categories") as? String
        catalogue = aDecoder.decodeObject(forKey: "catalogue") as? String
        status = aDecoder.decodeObject(forKey: "status") as? [String:Any]
        popularRestaurantes = aDecoder.decodeObject(forKey: "popularRestaurantes") as? String
        noOrderFound = aDecoder.decodeObject(forKey: "noOrderFound") as? String
        product_file_upload = aDecoder.decodeObject(forKey: "product_file_upload") as? String
        customisable = aDecoder.decodeObject(forKey: "customisable") as? String
        unserviceable = aDecoder.decodeObject(forKey: "unserviceable") as? String
        paymentDetails = aDecoder.decodeObject(forKey: "paymentDetails") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        shareScreenshot = aDecoder.decodeObject(forKey: "shareScreenshot") as? String
        choosePaymentReceipt = aDecoder.decodeObject(forKey: "choosePaymentReceipt") as? String
        wishlist = aDecoder.decodeObject(forKey: "wishlist") as? String
        choosePayment = aDecoder.decodeObject(forKey: "choosePayment") as? String
        orderNow = aDecoder.decodeObject(forKey: "orderNow") as? String
//Unserviceable//Payment Details//Email//Share screenshot//CHOOSE PAYMENT RECEIPT
    }
       
    @objc func encode(with aCoder: NSCoder){
        if product != nil{
            aCoder.encode(product, forKey: "product")
        }
        if products != nil{
            aCoder.encode(products, forKey: "products")
        }
        if supplier != nil{
            aCoder.encode(supplier, forKey: "supplier")
        }
        if suppliers != nil{
            aCoder.encode(suppliers, forKey: "suppliers")
        }
        if order != nil{
            aCoder.encode(order, forKey: "order")
        }
        if orders != nil{
            aCoder.encode(orders, forKey: "orders")
        }
        if agent != nil{
            aCoder.encode(agent, forKey: "agent")
        }
        if agents != nil{
            aCoder.encode(agents, forKey: "agents")
        }
        if brand != nil{
            aCoder.encode(brand, forKey: "brand")
        }
        if brands != nil{
            aCoder.encode(brands, forKey: "brands")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if categories != nil{
            aCoder.encode(categories, forKey: "categories")
        }
        if catalogue != nil{
            aCoder.encode(catalogue, forKey: "catalogue")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if popularRestaurantes != nil{
            aCoder.encode(popularRestaurantes, forKey: "popularRestaurantes")
        }
        if noOrderFound != nil{
            aCoder.encode(status, forKey: "noOrderFound")
        }
        if product_file_upload != nil{
            aCoder.encode(status, forKey: "product_file_upload")
        }
        if noOrderFound != nil{
            aCoder.encode(noOrderFound, forKey: "noOrderFound")
        }
        if customisable != nil{
            aCoder.encode(customisable, forKey: "customisable")
        }
        if unserviceable != nil{
            aCoder.encode(unserviceable, forKey: "unserviceable")
        }
        if paymentDetails != nil{
            aCoder.encode(paymentDetails, forKey: "paymentDetails")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if shareScreenshot != nil{
            aCoder.encode(shareScreenshot, forKey: "shareScreenshot")
        }
        if choosePaymentReceipt != nil{
            aCoder.encode(choosePaymentReceipt, forKey: "choosePaymentReceipt")
        }
        if wishlist != nil{
            aCoder.encode(wishlist, forKey: "wishlist")
        }
        if choosePayment != nil{
            aCoder.encode(choosePayment, forKey: "choosePayment")
        }
        if orderNow != nil{
            aCoder.encode(orderNow, forKey: "orderNow")
        }
        
    }
    
}
