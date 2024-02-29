//
//  SKAppType.swift
//  Sneni
//
//  Created by Sandeep Kumar on 18/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

enum SKAppType: Int {
    
    //Nitin
//    case test = -1
//    case eCom
//    case food
//    case gym // Marketplace
//    case beauty
//    case home
//    case constrution
//    case party
//    case jnj
    
    
    case food = 1
    case eCom
    case grocery
    case books
    case carRental
    case productRental
    case spaceRental
    case home
    case laundry
    case beauty
    
    //Nitin

//    var imgName: String {
//        switch self {
//        case .eCom:
//            return "ECom"
//        case .food:
//            return "Food"
//        case .gym:
//            return "Gym"
//        case .beauty:
//            return "Beauty"
//        case .home:
//            return "Home"
//        case .constrution:
//            return "Constrution"
//        case .party:
//            return "Party"
//        case .jnj:
//            return "Food"
//        default:
//            return "ECom"
//        }
//    }
    
    var imgName: String {
        switch self {
        case .food:
            return "Food"
        case .grocery:
            return "Grocery"
        case .beauty:
            return "Beauty"
        case .books:
            return "Books"
        case .carRental:
            return "Car Rental"
        case .productRental:
            return "Product Rental"
        case .spaceRental:
            return "Space Rental"
        case .home:
            return "Home Service"
        case .laundry:
            return "Laundry"
        default:
            return "ECom"
        }
    }
}

extension SKAppType {
    
    //Nitin
//    var api: String {
//        switch self {
//        case .gym:
//            //Nitin
//            return "https://api.royoapps.com/"
//            //"http://192.168.102.52:9020/"
//            //return "http://192.168.102.61:9020/"
//          //  return "https://marketplace-api.royoapps.com/"
//        case .test:
//            return "http://demo.netsolutionindia.com:8081/"
//        case .food:
//            return "https://api.royoapps.com/"
//        case .beauty:
//            return "http://demo.netsolutionindia.com:8092/"
//        case .home:
//            return "https://home-service-api.royoapps.com/"
//        case .constrution:
//            return "http://demo.netsolutionindia.com:8071/"
//        case .party:
//            return "http://demo.netsolutionindia.com:8072/"
//        case .jnj:
//            //Nitin
//            return "https://cafejj-api.royoapps.com/"
//            //return "http://demo.netsolutionindia.com:8074/"
////            return "http://demo.netsolutionindia.com:8072/"
//        default://eCom
//            return "https://ecommerce-api.royoapps.com/"//"http://45.232.252.46:8082/"
//        }
//    }
//

//    var api: String {
//        switch self {
//        case .carRental:
//            //Nitin
//            return "https://api.royoapps.com/"
//        case .books:
//            return "http://demo.netsolutionindia.com:8081/"
//        case .grocery:
//            return "http://demo.netsolutionindia.com:8081/"
//        case .food:
//            return "https://api-saas.royoapps.com/" //Nitin
//            //return "https://api.royoapps.com/"
//        case .beauty:
//            return "http://demo.netsolutionindia.com:8092/"
//        case .home:
//            return "https://api.royoapps.com/"
////            return "https://home-service-api.royoapps.com/"
//        case .spaceRental:
//            return "http://demo.netsolutionindia.com:8071/"
//        case .laundry:
//            return "http://demo.netsolutionindia.com:8072/"
//        case .productRental:
//            //Nitin
//            return "https://cafejj-api.royoapps.com/"
//        default://eCom
////            return "https://api-saas.royoapps.com/"
//            return "https://api.royoapps.com/"
//            //return "https://ecommerce-api.royoapps.com/"//"http://45.232.252.46:8082/"
//        }
//    }
    

    var apiBot: String {
        //        return "https://api.dialogflow.com/v1/"
        //        return "https://api.dialogflow.com/v1/"
        return "https://dialogflow.googleapis.com/v2/projects/newagent-orotpo/agent/sessions/1234:detectIntent/"
    }
    
    var apiBotKey: String {
        //        return "33e1a79a1470485fa2bebdd6393d2c3c"
        return AppSettings.shared.botChatToken
    }
    //Nitin

//    var key: String {
//        switch self {
//        case .gym:
//            return "56e71eaf7936466683b0ca6fc0d426ff"
//            //"55c55b26868b539a6444fce7ab5c91b366ed76e6729ef5926db69aeabc73e00f"
//            //"b6405ad1d46ff3c6022810838a5742d1"
//            //return "56c11872fdffa7631dc2afa67ee99f2b"
//           // return "47bd894b6dfb9955bc41d1060b718ccc"
//        case .test:
//            return "d1accb9eb36bf77ebd7f26612b2f3347"
//        case .food:
//            return "de19d1d45ff3bf2538f0db21c094a8e3"//"c89f8e74077d0f6aefec6773eedc6ff7"
//            //"4f406adc42c92e8eb4b6c55f8003d95d"
//        //"82108bd37bbe80553296332bce0ff97a89092a9f0d7b2f5d2054ac1b042ac283"
//        case .beauty:
//            return "a0e767bdeb37fd7a02b9cbc6d6b142c6"
//        //"a8542616a66c4a788356afa097026fb7"
//        case .home:
//            return "9c985440051f9c1faf67628d93579f23"//"1e1cd9533f7aca9182859ded8fa107b8a55d5e06da246b1cceb0ed834f473ddc"
//        //"9c985440051f9c1faf67628d93579f23"
//        case .constrution:
//            return "647d19ee2c6740b5bdf09446dc7d9a65"
//        case .party:
//            return "59ee57a788f8e0b79ec2c261f4d6741e"
//        case .jnj:
//            return "e3686d127671ecb06fca2754fd161ceb"
////            return "59ee57a788f8e0b79ec2c261f4d6741e"
//
//        default://eCom
//            return "75708c7b78b8a06b0909dab5e5c51909"
//            //"561ac5351c78188705c57e59d9880884"
//        }
//    }
    
//    var key: String {
//        switch self {
//        case .grocery:
//            return "56e71eaf7936466683b0ca6fc0d426ff"
//        case .laundry:
//            return "d1accb9eb36bf77ebd7f26612b2f3347"
//        case .books:
//            return "d1accb9eb36bf77ebd7f26612b2f3347"
//        case .food:
//            return "4f406adc42c92e8eb4b6c55f8003d95d"
//        case .beauty:
//            return "a0e767bdeb37fd7a02b9cbc6d6b142c6"
//        case .home:
//            return "9c985440051f9c1faf67628d93579f23"
//        case .carRental:
//            return "647d19ee2c6740b5bdf09446dc7d9a65"
//        case .productRental:
//            return "59ee57a788f8e0b79ec2c261f4d6741e"
//        case .spaceRental:
//            return "e3686d127671ecb06fca2754fd161ceb"
//        default://eCom
//            return "75708c7b78b8a06b0909dab5e5c51909"
//        }
//    }
}

extension SKAppType {
    
    static var type: SKAppType {
        //return APIConstants.mode
        guard let obj = SKAppType(rawValue: AppSettings.shared.appType ?? 1) else { return .food }
        return obj
        
    }
    
    var isFood: Bool {
        return self == .food //|| self == .jnj//(self == .food || self == .beauty || self == .home)
    }
    
    var isHome: Bool {
        return self == .home //|| self == .jnj//(self == .food || self == .beauty || self == .home)
    }
    
    var isJNJ: Bool {
        return self == .beauty
    }
    
    //MARK:- ======== Variables ========

    //Nitin
//    var color: UIColor {
//        switch self {
//        case .eCom:
//            return UIColor.appBlue
//        case .food:
//            return UIColor.appRed
//        case .gym:
//            return UIColor.appOringe
//        case .beauty:
//            return UIColor.appBeauty
//        case .home:
//            return UIColor.appHome
//        case .constrution:
//            return UIColor.appConstrution
//        case .party:
//            return UIColor.appParty
//        case .jnj:
//            return UIColor.appCBCafe
//        default:
//            return UIColor.appRed
//        }
//    }

    var color: UIColor {
        switch self {
        case .eCom:
            return UIColor.appBlue
        case .food:
            return UIColor.appRed
        case .grocery:
            return UIColor.appOringe
        case .beauty:
            return UIColor.appBeauty
        case .home:
            return UIColor.appHome
        case .books:
            return UIColor.appConstrution
        case .carRental:
            return UIColor.appParty
        case .productRental:
            return UIColor.appCBCafe
        case .spaceRental:
            return UIColor.appCBCafe
        default:
            return UIColor.appRed
        }
    }
    
    var headerColor: UIColor {
        if let headerColor = AppSettings.shared.appThemeData?.header_color, let header = UIColor(hexString: headerColor) {
            return header
        }
        return UIColor.white
    }
    
    var elementColor: UIColor {
       // return UIColor(hex: "#3C4464")
           if let headerColor = AppSettings.shared.appThemeData?.element_color, let header = UIColor(hexString: headerColor) {
               return header
           }
           return UIColor.white
       }
    var headerTextColor: UIColor {
        if let headerColor = AppSettings.shared.appThemeData?.header_text_color, let header = UIColor(hexString: headerColor) {
            return header
        }
        return UIColor.darkGray
    }
    
    var grayTextColor: UIColor {
        return elementColor.withAlphaComponent(0.6) // UIColor.darkGray //UIColor(hexString: "#888B9B") ??
    }
    
    var elementAlphaColor: UIColor {
        return elementColor.withAlphaComponent(0.06)
    }

    var alphaColor : UIColor {
        switch self {
        case .eCom:
            return UIColor.appBlue.withAlphaComponent(0.3)
        case .food:
            return UIColor.alphaFood.withAlphaComponent(0.3)
        case .grocery:
            return UIColor.appOringe
        case .beauty:
            return UIColor.appBeauty
        case .home:
            return UIColor.appHome.withAlphaComponent(0.3)
        case .books:
            return UIColor.appConstrution
        case .carRental:
            return UIColor.appParty
        case .productRental:
            return UIColor.appCBCafe
        case .spaceRental:
            return UIColor.appCBCafe
        default:
            return UIColor.appRed
        }
    }
    //    GDataSingleton.sharedInstance.isFoodApp ? L10n.RecommendedRestaurants.string : L10n.RecommendedSupplier.string
    //Nitin
//    var strRecommendedRestaurants: String {
//        switch self {
//        case .eCom:
//            return L11n.RecommendedSupplier.string
//        case .food:
//            return L11n.RecommendedRestaurants.string
//        case .gym:
//            return L11n.RecommendedExpert.string
//        case .beauty:
//            return L11n.RecommendedBeautyExpert.string
//        case .home:
//            return L11n.RecommendedExpert.string
//        default:
//            return L11n.RecommendedRestaurants.string
//
//        }
//    }
    
    var strRecommendedRestaurants: String {
        switch self {
        case .eCom:
            return L11n.RecommendedSupplier.string
        case .food:
            return L11n.RecommendedRestaurants.string
        case .beauty:
            return L11n.RecommendedBeautyExpert.string
        case .home:
            return L11n.RecommendedExpert.string
        default:
            return L11n.RecommendedRestaurants.string

        }
    }

    //Nitin
    var agent: String {
        return "Agent"
    }
    
    var agents: String {
        switch self {
        case .home:
            return "Service Providers"
        default:
            return "Agents"
            
        }
    }
    
    var order: String {
           switch self {
           case .home:
               return "Booking"
           default:
               return "Order"

            }
       }
       
       var orders: String {
           switch self {
           case .home:
               return "Bookings"
           default:
               return "Orders"
               
           }
       }
    
    var product: String {
        switch self {
        case .food:
            return "Food Item"
        case .home:
            return "Service"
        default:
            return "Product"
        }
    }
    
    var products: String {
        switch self {
        case .food:
            return "Food Items"
        case .home:
            return "Services"
        default:
            return "Products"
        }
    }
    
    var supplier: String {
        switch self {
        case .food:
            return "Restaurant"
        case .home:
            return "Service Provider"
        default:
            return "Supplier"
        }
    }
    
    var suppliers: String {
        switch self {
        case .food:
            return "Restaurants"
        case .home:
            return "Service Providers"
        default:
            return "Suppliers"
        }
    }
    
    //Nitin
    var shipped: String {
        switch self {
        case .food://, .jnj:
            return "INPROCESS"
//        case .gym:
//            return "SHIPPED"
//        case .home:
//            return "INPROCESS"
        default:
            return "SHIPPED"

        }
    }


//    var shipped: String {
//        switch self {
//        case .food:
//            return "INPROCESS"
//        case .homeService:
//            return "INPROCESS"
//        default:
//            return "SHIPPED"
//
//        }
//    }

    //Nitin
//    var lookingFor: String {
//        switch self {
//        case .food, .jnj:
//            return "Looking for food delivery?"
//        case .gym:
//            return "Looking for Fitness Experts?"
//        case .beauty:
//            return "Looking for Beauty Experts?"
//        case .home:
//            return "Looking for Home Services?"
//        default:
//            return "Looking for Supplier?"
//        }
//    }
    
    var lookingFor: String {
        switch self {
        case .food:
            return "Looking for food delivery?"
        case .beauty:
            return "Looking for Beauty Experts?"
        case .home:
            return "Looking for Home Services?"
        default:
            return "Looking for Supplier?"
        }
    }
    
    //Nitin
//    func orderFrom(supplierName: String) -> String {
//        switch self {
//        case .eCom:
//            return "Order food online from \(supplierName) to enjoy food at your home."
//        case .food//, .jnj:
//            return "Order food online from \(supplierName) to enjoy food at your home."
////        case .gym:
////            return "Order food online from \(supplierName) to enjoy food at your home."
//        case .beauty:
//            return "Order food online from \(supplierName) to enjoy food at your home."
//        case .homeS:
//            return "Order food online from \(supplierName) to enjoy food at your home."
//        default:
//            return "Order food online from \(supplierName) to enjoy food at your home."
//        }
//    }
    
    
    func orderFrom(supplierName: String) -> String {
        switch self {
        case .eCom:
            return "Order food online from \(supplierName) to enjoy food at your home."
        case .food:
            return "Order food online from \(supplierName) to enjoy food at your home."
        case .beauty:
            return "Order food online from \(supplierName) to enjoy food at your home."
        case .home:
            return "Order food online from \(supplierName) to enjoy food at your home."
        default:
            return "Order food online from \(supplierName) to enjoy food at your home."
        }
    }

}
