//
//  APIConstants.swift
//  Buraq24
//
//  Created by MANINDER on 16/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import Foundation

internal struct APIBasePath {
    

   // static let basePath =
    static let categoryImageBasePath = "https://cdn-royorides.imgix.net/BuraqExpress/public/images/"

    static let basePath = "https://apitest.royorides.io/v1" //"https://apidev.royorides.io" //"https://apidev.royorides.io" //"https://ridesapi.marketplace24.ch/" //"https://apidev.royorides.io" //"https://apitest.royorides.io"//// "https://apitest.royorides.io" //"https://apidev-royodelivery.royoapps.com" //"https://apiroyo-delivery.royoapps.com"  // //"https://trava-backend.netsolutionindia.com"  //"http://demo.netsolutionindia.com:9009" //  Live
    
    static let baseImagePath =  "https://apitest.royorides.io/v1/images/"//"https://apidev.royorides.io/images/" //"https://ridesapi.marketplace24.ch/images/" //"https://apidev.royorides.io/images/" // "https://apidev-royodelivery.royoapps.com/images/"  // "https://trava-backend.netsolutionindia.com/images/" "https://apiroyo-delivery.royoapps.com/images/"  // // //
    static let TermsConditions = "http://demo.netsolutionindia.com:9006/pages/Customer/"
    static let PrivacyPolicy = "http://demo.netsolutionindia.com:9006/PPolicy"
    static let TermsConditionsGoMove = "https://gomove.co/en/legal/terms/"
    static let PrivacyPolicyGoMove = "https://gomove.co/en/legal/privacy/"
    static let AboutUs = "https://gomove.co/en/about-us"
    
    static let AppStoreURL = "https://itunes.apple.com/app/id1467144828"
    //static let googleApiKey = "AIzaSyBiBi-y-jreGQjQfu1M1Fnr8WYZxIZIrxw"//"AIzaSyBJ--xhuftJS-r48lPXdvYN7nrvJnOpsk0"
    static let googleApiKey = "AIzaSyDFfLXKDcENGjXYyM_ekHDHeEncJR0rqRw"//"AIzaSyAGCCNk1wfi0ZH3R_JzYgGCX5CgRbYNnWY" // "AIzaSyBJuh2WQjOR5aaxTmauWhWPI7B0z4Njtmc" //"AIzaSyDNjbIaiPB41uhvhD0mb9Xdi2tA7n0AFlo" // Trava
    static let GoogleClientID = "16623817647-8hq7l7c8e424d27elcbeq9a8fv2e1jnc.apps.googleusercontent.com"
 //   86edd688f591b7ef8b90529839e6cf71 wassel
    
     static let secretDBKey =  "79a636635798f6d94039d71b7f69f511"// Kapil "45f9cf2153d4b36e45fae24859f7d33d" //"ec2f1d6330674db22eb826606109f0d9"//"45f9cf2153d4b36e45fae24859f7d33d"//"45f9cf2153d4b36e45fae24859f7d33d"//"9b450e4156d3b15781b6ea4a500c9cef"  // "99c4c1fcf5a48a1f48d7e6e4ea66ab72" // thena
  //   static let secretDBKey = "15159452ed37ca739abee6bbdb8ffa2f38e7bb4b6aea427c389c349adf887fcf" // bag n deliver //"418a5720aad9639370e84e56e38921a9" //"c8181080fcadf2ab9230a1ebb921933048136663d8f5a9f694481bacd3363e08" // mp24live
    //"e408d6dd43ebb7cc31f7ddc12a48d20343c7cbed5d550d5f95823a33535b6bdf"//"37e669eb126e013d534955c7d65ae9cf" // movify // //"418a5720aad9639370e84e56e38921a9" // biplife //"d396f33a61a03615339989e299cab0f33d28af0410e3922bca3ee029339a893b"//"c8181080fcadf2ab9230a1ebb921933048136663d8f5a9f694481bacd3363e08" //MarketPlace24//
    // //"46ef7ac0b555723837597609d5a46852"//"c8181080fcadf2ab9230a1ebb921933048136663d8f5a9f694481bacd3363e08" // marketplacenewkey
     //"86edd688f591b7ef8b90529839e6cf71" //"37e669eb126e013d534955c7d65ae9cf" // movify
     //"46ef7ac0b555723837597609d5a46852" //brownstown
     //"photophotophoto" // bag delivery
     //"46ef7ac0b555723837597609d5a46852" //"e408d6dd43ebb7cc31f7ddc12a48d20343c7cbed5d550d5f95823a33535b6bdf"
     
     //
     
     //"5be35d327420a5794a692222d2786e99"//"5c63ec20415244ff4a6ff53645663ad8" //"418a5720aad9639370e84e56e38921a9" //"418a5720aad9639370e84e56e38921a9" //"9ee7e0852c66256e2869195d93913d96" //"418a5720aad9639370e84e56e38921a9"  //"9ee7e0852c66256e2869195d93913d96"
    //  static let secretDBKey = "3e0e1eb99360db2f348f4aa874bb0955" //Yocab
    // 15159452ed37ca739abee6bbdb8ffa2f38e7bb4b6aea427c389c349adf887fcf // bag n delivery
     //86edd688f591b7ef8b90529839e6cf71 //wessel
        

}

internal struct APITypes {
    
    //Corona effected area
    static let getCoronaArea = "coronaArea"
    
    static let appSetting = "appSettings"
    
    //Login Signup
    
    static let sendOtp = "sendOtp"
    static let verifyOTP = "verifyOTP"
    static let addName = "addName"
    static let logOut = "logout"
    static let updateData = "updateData"
    static let eContacts = "eContacts"
    static let contactUs = "contactus"
    static let editProfile = "profileUpdate"
    static let changeNotification = "settingUpdate"
    static let checkuserExists = "checkuserExists"
    static let socailLogin = "socailLogin"
    static let emailLogin = "emailLogin"
    static let privateCooperationListing = "privateCooperationListing"
    static let privateCooperationRegForum = "privateCooperationRegForum"
    static let addEmergencyContact = "addEmergencyContacts"
    static let removeEmergencyContact = "removeEmergencyContacts"
    static let userEmergencyContact = "emergencyContactListing"
    
    //Service APIs
    static let homeAPI = "homeApi"
    static let terminologyAPI = "terminology"
    static let requestAPI = "Request"
    static let cancelRequestAPI = "Cancel"
    static let ongoingRequestAPI = "Ongoing"
    static let rate = "Rate"
    static let packageListing = "packageListing"
    static let scanQrCode = "scanQrCode"
    static let coupons = "coupons"
    static let checkCoupons = "checkCoupons"
    static let halfWayStop = "halfWayStop"
    static let breakdownRequest = "breakdownRequest"
    static let shareRide = "shareRide"
    static let cancelShareRide = "cancelShareRide"
    static let cancelHalfWayStop = "cancelHalfWayStop"
    static let cancelVehicleBreakDown = "cancelVehicleBreakDown"
    static let getCreditPoints = "getCreditPoints"
    static let panic = "panic"
    static let addStops = "addStops"
    static let addAddress = "addAddress"
    static let editAddress = "editAddress"
    static let bannerAndServices = "bannerAndServices"
    static let addCard = "addCard"
    static let getCard = "getCardList"
    static let removeCard = "removeCard"
    static let payPendingAmount = "payPendingAmount"
    static let notification = "notificationListing"
    
    //Buy EToken
    static let eTokens = "ETokens"
    static let paginate = "ETokens/Paginate"
    static let buyEToken = "eToken/buy"
    static let eTokenDetails = "payment/details"
    static let bookingHistory = "order/history"
    static let orderDetails = "order/details"
    static let companyList = "companies/list"
    static let etokensList = "etokens/list"
    static let etokenPurchasedList = "purchases/list"
    static let etokenPurchase = "etoken/purchase"
    static let etokenConfirmReject   = "confirm/order"
    static let editCheckList = "editCheckList"
    static let removeCheckListItem = "removeCheckListItem"
    static let walletLogs = "walletLogs"
    static let walletTransfer = "walletTransfer"
    static let addTip = "Tip"
    static let getWalletBalance = "getWalletBalance"
    
    static let chatList   = "chatlogs"
    static let getConversationList   = "getChat"
    static let uploadImge = "mediafileUpload"
    static let addWalletAmount = "addMoneyInWallet"
    static let addUserCard = "addUserCard"
    static let razorPayReturnUrl = "razorPayReturnUrl"
    
}

internal struct Routes{
    static let user = "/user/"
    static let commonRoutes = "/common/"
    static let service = "/service/"
    
    struct SubRoute {
        static let service = "service/"
        static let other = "other/"
        static let water = "water/"
        static let order = "order/"
    }
}

enum APIConstantsCab:String {
    case success = "success"
    case message = "msg"
    case accessToken = "accessToken"
    case statusCode = "statusCode"
}

enum SocialLoginType : String {
    
    case facebook = "Facebook"
    case google = "Google"
}

enum Keys : String {
    
    case access_token = "access_token"
    case receiver_id = "receiver_id"
    case language_id = "language_id"
    case phone_code = "phone_code"
    case phone_number = "phone_number"
    case timezone = "timezone"
    case latitude = "latitude"
    case longitude = "longitude"
    case socket_id = "socket_id"
    case fcm_id = "fcm_id"
    case device_type = "device_type"
    case otp = "otp"
    case name = "name"
    case distance = "distance"
    case category_id = "category_id"
    case payment_type = "payment_type"
    case category_brand_id = "category_brand_id"
    case category_brand_product_id = "category_brand_product_id"
    case product_quantity = "product_quantity"
    case pickup_address = "pickup_address"
    case pickup_latitude = "pickup_latitude"
    case pickup_longitude = "pickup_longitude"
    
    case dropoff_address = "dropoff_address"
    case dropoff_latitude = "dropoff_latitude"
    case dropoff_longitude = "dropoff_longitude"
    
    case order_timings = "order_timings"
    case future = "future"
    case orderId = "order_id"
    case cancelReason = "cancel_reason"
    case ratings = "ratings"
    case comments = "comments"
    case take = "take"
    case organisation_coupon_id = "organisation_coupon_id"
    case organisation_coupon_user_id = "organisation_coupon_user_id"
    case coupon_user_id = "coupon_user_id"
    case skip = "skip"
    case type = "type"
    case message = "message"
    case profile_pic = "profile_pic"
    case notifications = "notifications"
    case order_images = "order_images"
    case product_weight = "product_weight"
    case details = "details"
    case material_details = "material_details"
    case order_distance = "order_distance"
    case status = "status"
    
    // water modules
    
    case organisation_id = "organisation_id"
    case buraq_percentage = "buraq_percentage"
    case bottle_returned_value = "bottle_returned_value"
    case bottle_charge = "bottle_charge"
    case quantity = "quantity"
    case price  = "price"
    case eToken_quantity = "eToken_quantity"
    
    case address = "address"
    case  address_latitude = "address_latitude"
    case  address_longitude  = "address_longitude"
    
    case pickupPersonName = "pickup_person_name"
    case pickupPersonPhone = "pickup_person_phone"
    case invoiceNumber = "invoice_number"
    case deliveryPersonName = "delivery_person_name"
    
    case brandName = "brand_name"
    case firstName = "firstName"
    case lastName = "lastName"
    case gender = "gender"
    case finalCharge = "final_charge"
    case email
    case iso
    case package_id
    case distance_price_fixed
    case price_per_min
    case time_fixed_price
    case price_per_km
    case booking_type
    case friend_name
    case friend_phone_number
    case friend_phone_code
    case user_id
    case driver_id
    case coupon_id
    case coupon_code
    case code
    case half_way_stop_reason
    case reason
    case shareWith
    case cancellation_charges
    case stops
    case user_address_id
    case category
    case address_name
    case user_card_id
    case amount
    case credit_point_used
    case description
    case elevator_pickup
    case elevator_dropoff
    case pickup_level
    case dropoff_level
    case fragile
    case signup_as
    case social_key
    case login_as
    case password
    case items
    case cooperation_type
    case cooperation_id
    case identification_number
    case document
    case user_type_id
    case check_lists
    case check_list_ids
    case token_id
    case gateway_unique_id
    case card_number
    case exp_year
    case exp_month
    case cvc
    case limit
    case tip = "tip"
    case card_holder_name
    case card_brand
    case referral_code
    case emergencyContacts
    case emergency_contact_id
    case nationalId
    case start_dt = "start_dt"
    case end_dt = "end_dt"
    case order_time
     case payment_id
    case numberOfRiders = "numberOfRiders"
    case nonce
    
}

enum ValidateCab : String {
    
    case none
    case success = "1"
    case successCode = "200"
    case failure = "0"
    case invalidAccessToken = "401"
    case fbLogin = "3"
    case validation = "400"
    case apiError = "500"
    case lastRideCharges = "301"
    
    func map(response message : String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure :
            return message
        case .invalidAccessToken :
            return message
        default:
            return nil
        }
    }
}

enum ResponseCab {
    case success(AnyObject?)
    case failure(String?)
}

//typealias OptionalDictionary = [String : Any]?

let reasonString = "CANCELLING_WHILE_REQUESTING"

struct Parameters {
    
    //User Login SignUp Routes
    static let sendOtp : [Keys] = [.language_id , .phone_code , .phone_number , .timezone , .latitude , .longitude , .socket_id , .fcm_id, .device_type, .iso, .social_key, .signup_as, .email, .password ]
    static let socailLogin : [Keys] = [.language_id , .timezone , .latitude , .longitude , .socket_id , .fcm_id, .device_type, .social_key, .login_as]
    static let emailLogin : [Keys] = [.language_id , .timezone , .latitude , .longitude , .socket_id , .fcm_id, .device_type, .login_as, .email, .password ]
    static let privateCooperationRegForum: [Keys] = [.language_id , .timezone , .latitude , .longitude , .socket_id , .fcm_id, .device_type, .cooperation_id, .identification_number, .email, .phone_code, .iso, .phone_number, .password, .user_type_id]
    
    static let checkuserExists: [Keys] = [.social_key, .login_as]
    static let privateCooperationListing : [Keys] = [.items, .cooperation_type]
    static let addEmergrncyContact : [Keys] = [.emergencyContacts]
    static let removeEmergencyContact: [Keys] = [.emergency_contact_id]
    
    static let verifyOTP : [Keys] = [.otp ]
    static let addName : [Keys] = [.name,.firstName,.lastName,.gender,.address, .email, .referral_code, .nationalId]
    static let logout : [Keys] = []
    static let homeApi : [Keys] = [ .category_id  , .latitude , .longitude ,.distance ]
    static let braintreeCheckout : [Keys] = [ .amount  , .nonce, .orderId ]
    static let terminologyAPI : [Keys] = [.category_id]
    static let requestAPi : [Keys] = [
        .category_id,
        .category_brand_id,
        .category_brand_product_id,
        .product_quantity,
        .dropoff_address,
        .dropoff_latitude,
        .dropoff_longitude,
        .pickup_address,
        .pickup_latitude,
        .pickup_longitude,
        .order_timings,
        .future,
        .payment_type,
        .distance,
        .organisation_coupon_user_id,
        .material_details,
        .product_weight,
        .details,
        .order_distance,
        .pickupPersonName,
        .pickupPersonPhone,
        .invoiceNumber,
        .deliveryPersonName,
        .brandName,
        .finalCharge,
        .package_id,
        .distance_price_fixed,
        .price_per_min,
        .time_fixed_price,
        .price_per_km,
        .booking_type,
        .friend_name,
        .friend_phone_number,
        .friend_phone_code,
        .driver_id,
        .coupon_code,
        .cancellation_charges,
        .stops,
        .address_name,
        .user_card_id,
        .credit_point_used,
        .description,
        .elevator_pickup,
        .elevator_dropoff,
        .pickup_level,
        .dropoff_level,
        .fragile,
        .check_lists,
        .gender,
        .order_time,
        .numberOfRiders
    ]
    
    static let addStops: [Keys] = [.orderId, .stops, .dropoff_address, .dropoff_latitude, .dropoff_longitude]
    static let cancelRequestApi : [Keys] = [ .orderId , .cancelReason]
    static let ongoingApi : [Keys] = []
    static let rateDriver : [Keys] = [.orderId , .ratings , .comments]
    static let eTokens : [Keys] = [.category_id , .latitude , .longitude ,.distance ,.take , .order_timings]
    static let eTokenDetails : [Keys] = [.category_id , .latitude , .longitude ,.distance ,.take , .order_timings]
    static let buyETokens : [Keys] = [.organisation_coupon_id ]
    static let updateData : [Keys] = [.timezone , .latitude , .longitude , .fcm_id]
    static let history : [Keys] = [.skip , .take , .type, .start_dt, .end_dt]
    static let contactUs : [Keys] = [.message]
    static let editProfile : [Keys] = [.name, .email, .phone_code, .phone_number, .iso]
    static let orderDetail : [Keys] = [.orderId]
    static let changeNotification : [Keys] = [.notifications]
    static let getCompanyListWater :[Keys] = [.type, .latitude, .longitude, .category_brand_id, .category_brand_product_id,.take,.skip]
    static let getCompanyTokenList :[Keys] = [.organisation_id,.category_brand_id, .skip, .take]
    static let getTokenPurchaseList:[Keys] = [.skip, .take]
    
    static let purchaseEToken :[Keys] = [.organisation_coupon_id,.buraq_percentage, .bottle_returned_value, .bottle_charge, .quantity, .payment_type, .price, .eToken_quantity,.address, .address_latitude, .address_longitude]
    
    static let EtokenOrderAcceptReject :[Keys] = [.orderId, .status]
    static let scanQrCode: [Keys] = [.user_id]
    static let checkCoupons: [Keys] = [.code]
    static let halfWayStop: [Keys] = [.orderId, .latitude, .longitude, .order_distance, .half_way_stop_reason, .payment_type]
    static let breakdownRequest: [Keys] = [.orderId, .latitude, .longitude, .order_distance, .reason]
    static let shareRide: [Keys] = [.shareWith, .orderId]
    static let cancelShareRide: [Keys] = [.orderId]
    static let cancelHalfWayStop: [Keys] = [.orderId]
    static let cancelVehicleBreakDown: [Keys] = [.orderId]
    static let addAddress: [Keys] = [.address, .address_latitude, .address_longitude, .category, .address_name]
    static let editAddress: [Keys] = [.address, .address_latitude, .address_longitude, .user_address_id, .category, .address_name]
    static let removeCard: [Keys] = [.user_card_id]
    static let removeCardWithPaymentId: [Keys] = [.user_card_id,.gateway_unique_id]
    static let payPendingAmount: [Keys] = [.user_card_id, .amount]
    static let eContacts:[Keys] = [.phone_code]
    static let editCheckList:[Keys] = [.check_lists]
    static let removeCheckListItem:[Keys] = [.check_list_ids]
    static let addStripCard:[Keys] = [.token_id,.gateway_unique_id]
    static let addEpaycoCard:[Keys] = [.card_number,.exp_year,.exp_month,.cvc,.gateway_unique_id]
    static let walletLogs:[Keys] = [.skip, .limit]
    static let walletTransfer:[Keys] = [.amount, .phone_code, .phone_number]
    static let addTip : [Keys] = [.tip , .orderId, .gateway_unique_id]
    static let getWalletBalance: [Keys] = []
    static let addCard: [Keys] = [.card_holder_name, .card_number, .exp_year, .cvc, .gateway_unique_id, .card_brand, .exp_month]
    static let addWalletAmount: [Keys] = [.amount,.user_card_id, .gateway_unique_id]
    static let getchatList :[Keys] = [.language_id,.limit,.skip]
    static let pssChatList :[Keys] = [.language_id,.receiver_id,.limit,.skip]
    static let razorPayReturnUrl:[Keys] = [.orderId, .payment_id]
}

struct Headers {
    
    //User Login SignUp Routes
    static let headerBasic : [Keys] = [.language_id]
    static let headerUserInfo : [Keys] = [.language_id , .access_token  ]
    
}

