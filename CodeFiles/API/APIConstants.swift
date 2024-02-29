//
//  APIConstants.swift
//  Clikat
//
//  Created by cbl73 on 4/22/16.
//  Copyright © 2016 Gagan. All rights reserved.

//





import Foundation
import Alamofire

struct APIConstants {
    
    static let modeKey = "AppConfigType"
    static let liveMode = true
    static let version2 = true

    static let defaultAgentCode =  "lconcierge_0676"//"bletani_0675" //"bellbee_0707"//"thena_0601"//"bagndelivery_0774" //"biplife_0744"//"marketplace24_0489"//"movify_0777"//"biplife_0744"
    // "deliverfy_0824"//"marketplace24_0489"//// deliveryfy
    
    //
    //"movify_0777"
    //
    // //"brownstowncorporation_0776"//"biplife_0744"//  //"wassel_0772" //"bagndelivery_0774"//"movify_0777"//"brownstowncorporation_0776" //"brownstowncorporation_0776" //"marketplace24ch_0766" //"biplife_0744" //"testessn_0426" //"tam11" //"biplife_0410" // "biplife_0744"  //"testrides3_0700" //"biplife_0744" //"testrides3_0700" //"royoessentials_0336" //"fooddemo_0215" // //"healthcare_0642" //"yammfood_0599" //"healthcare_0642" // // //"yammfood_0599" //"healthcare_0642" // "homerr_0625" // // //"yammfood_0599" //"healthcare_0642" //"yammfood_0599" //"healthcare_0642" //"yammfood_0599" //"healthcare_0642" //"homerr_0625" //"foodinflash_0217" //"yammfood_0599" //"homerr_0625" //"yammfood_0599" //"foodinflash_0217" //"yammfood_0599" //"cannadash_0180" //"yummie_0205"// //  //"homerr_0625" //cannadash_0180  // // //"royohomes_0237" //"lettta_0293" // //"homeservicesinglev_0250" //"zippklip_0123" // // // // // // // //"homeservicesinglev_0250" // //"yummie_0205" //"homerr_0625"//  // " // //"Grofferrs_0207"  // // // //"productosaltameza_0202"//"medexpertt_0210" ////"productosaltameza_0202"// //"productosaltameza_0202"  //"spicemaster_0134" //"yummy_0122"  //"yummie_0205"//"yummie_0205" //"ecommercen_0183"//"yummie_0205"// // //"yammfood_0599" //Food live mode
  //  static let defaultAgentCode = "ecommercensingledev_0548"// //Multi vendor
    //static let defaultAgentCode = "productosaltameza_0202"
  //  static let defaultAgentde = "ecommercensingledev_0548"//"ecommercen_0183" //Multi vendor
//    static let defaultAgentCode = "ecommercensingledev_0548"// "spicemaster_0134"// "ecommercensingledev_0548" //"spicemaster_0134""ecommercensingledev_0548" //"spicemaster_0134"   //ecommercen_0183 // "poneeex_0049"  //"adeee1234_0040" //"homedev_0530" //"ishaangrover_0148"

    
    static var BasePath: String {
        if APIConstants.liveMode {
            return  "https://api-saas.royoapps.com/" //"https://ordersapi.marketplace24.ch/"
        }
        else {
//            return "https://gagan-api.royodev.tk/"
            //return "https://ishan-api.royodev.tk/"
//            return "https://monu-api.royodev.tk/"
            return "https://api.royoapps.com/"

        }
        //        return mode.api
    }
    
    //    static var secretdbkey: String {
    //        return mode.key
    //    }
    
    
    //AgentBaseUrl
    static let agentBasePath:String = liveMode ? "https://onboarding-liveagent.royoapps.com/" : "https://onboarding-agent.royoapps.com/" //"https://gagan-agent.royodev.tk/"//
    static let agentTokenBasePath = liveMode ? "https://onboarding-livebkend.royoapps.com/" :  "https://codebrew.royoapps.com/"
    static let referalData = "referalData"
    static let DataKey = "data"
    static let listKey = "list"
    static let Status = "status"
    static let statusCode = "statusCode"
    
    static let message = "message"
    static let id = "id"
    
//    /v2/history_order
//    /v2/upcoming_order
//    /v2/user_order_details
//    /v2/genrate_order
}

enum APIValidation : String {
    
    /**
     status : 4 -- success
     status : 1 -- parameter missing error
     status : 2 -- error of invalid access token
     status : 8 -- something went wrong error
     status : 5 -- user is not active
     */
    
    case None
    case Success = "200"
    case ParameterMissing = "400"
    case InvalidAccessToken = "401"
    case ApiError = "500"
    case Validation = "8"
    case Delivery = "501"
    case Terms = "4"
    
    var message : String?{
        
        switch self {
        case .ParameterMissing:
            return ""
        case .InvalidAccessToken :
            return ""
        case .ApiError :
            return ""
        case .Validation:
            return "Email Id or Password not correct."
        default:
            return nil
        }
    }
}

enum APIResponse {
    
    case Success(Any?)
    case Failure(APIValidation)
}

typealias OptionalDictionary = [String : Any]?

enum API {
    
    ///Chat Bot Responce
    case getBotResponce(query: String)
    case GetSettings(OptionalDictionary)
    case Home(latitude: Double?,longitude:Double?, catId: String?)
    case offers(latitude: Double?,longitude:Double?)
    case SupplierListing(OptionalDictionary)
    case SupplierInfo(OptionalDictionary)
    case MarkSupplierFav(OptionalDictionary)
    case UnFavoriteSupplier(OptionalDictionary)
    case SubCategoryListing(supplierId : String? , categoryId : String?)
    case ProductListing(OptionalDictionary)
    case ProductDetail(OptionalDictionary)
    case MultiSearch(OptionalDictionary)
    case RegisterSingleStep(OptionalDictionary)
    case Register(OptionalDictionary)
    case Login(OptionalDictionary)
    case SendOTP(OptionalDictionary)
    case CheckOTP(OptionalDictionary)
    case RegisterLastStep(OptionalDictionary)
    case LocationList(OptionalDictionary,type : SelectedLocation)
    case ResendOTP(OptionalDictionary)
    case Addresses(OptionalDictionary)
    case AddNewAddress(OptionalDictionary)
    case EditAddress(OptionalDictionary)
    case AddToCart(OptionalDictionary)
    case UpdateCartInfo(OptionalDictionary)
    case PackageSupplierListing(OptionalDictionary)
    case PackageProductListing(OptionalDictionary)
    case LoyalityPointScreen(OptionalDictionary)
    case MyFavorites(OptionalDictionary)
    case OrderHistory(OptionalDictionary)
    case OrderUpcoming(OptionalDictionary)
    case OrderTrackingList(OptionalDictionary)
    case SupplierRating(OptionalDictionary)
    case BarCodeSearch(OptionalDictionary)
    case GenerateOrder(OptionalDictionary)
    case ScheduleOrder(OptionalDictionary)
    case RateOrderListing(OptionalDictionary)
    case RateMyOrder(OptionalDictionary)
    case PromotionProducts(OptionalDictionary)
    case DeleteAddress(OptionalDictionary)
    case OrderTrack(OptionalDictionary)
    
    //Notifications
    case AllNotifications(skip: Int)
    case ClearAllNotifications(OptionalDictionary)
    case NotificationSwitch(OptionalDictionary)
    //Laundry 
    case LaundryServices (OptionalDictionary)
    case LaundryProductListing(OptionalDictionary)
    case LaundrySupplierList(OptionalDictionary)
    
    case LoyaltyPointsOrder(OptionalDictionary)
    case CancelOrder(OptionalDictionary)
    case LoginFacebook(OptionalDictionary)
    
    case ChangeProfile(OptionalDictionary)
    case UploadReceipt(OptionalDictionary)
    case ChangePassword(OptionalDictionary)
    case ForgotPassword(OptionalDictionary)
    case ViewAllOffers(OptionalDictionary)
    case SupplierImage(OptionalDictionary)
    case OrderDetails(OptionalDictionary)
    case CompareProducts(OptionalDictionary)
    case CompareProductResult(OptionalDictionary)
    
    case ScheduleNewOrder(OptionalDictionary)
    case ScheduledOrders(OptionalDictionary)
    
    case NotificationLanguage(OptionalDictionary)
    case TotalPendingSchedule(OptionalDictionary)
    case OrderDetail(OptionalDictionary)
    case ClearOneNotification(OptionalDictionary)
    case ConfirmScheduleOrder(OptionalDictionary)
    case ProductVariantList(OptionalDictionary)
    case ProductFilteration(OptionalDictionary)
    case VariantProductDetail(OptionalDictionary)
    case GetArea(OptionalDictionary)
    case RateProduct(isOrder: Bool, value :String?,product_id:String?, order_id: String?, reviews:String?,title:String)
    case CheckPromo(OptionalDictionary)
    case GetAgentDBKeys
    case ServiceAgentlist(OptionalDictionary)
    case getAgentAvailabilties(id: String?, date: Date)
    case getSlotAvailabilties(date: Date)
    case getAgentAvailabilty(id: String)
    
    ///Product Fav
    case listAllFav
    case makeProductFav(id: String, isFav: Bool)
    
    case getRestorentList(latitude: Double?,longitude:Double?, search: String?)
    case getProductList(supplierId: String,latitude: Double?,longitude:Double?)
    case getPopularProducts(lat: Double, lng: Double)
    
    //Nitin
    case getSecretKey(uniqueId:String)
    case rentalFilternation(OptionalDictionary)
    case appleSignin(OptionalDictionary)
    case checkProductList(product_ids : [String])
    case getTermsAndConditions
    
    //referal
    case myReferals
    case getReferalAmount
    case getBraintreeToken
    case getQuestions(categoryId: String)
    case updateFCMToken

    case addCard(OptionalDictionary)
    case deleteCard(OptionalDictionary)
    case getCards(customer_payment_id: String, gateway_unique_id :String)

    case uploadPrescription(OptionalDictionary)
    case makePayment(orderId: String, paymentType : PaymentMode)
    case payRemainingAmount(orderId: String, paymentType : PaymentMode)

    case returnProduct(OptionalDictionary)
    case requestList(skip: Int)
    case cancelRquest(requestId: Int, reason: String?)
    case verifySlot(agentId: String, duration: Int, datetime: Date)
    
    case geofenceTax(lat: String?, long: String?, branchId: String?)
    case getSadadPaymentUrl(name: String, email: String, amount: String)
    case getMyFatoorahPaymentUrl(currency: String, amount: String)

    case searchTag(text: String, skip: Int)
    case searchSupplierTags(productName: [String])
    case getPaystackAccessCode(email: String, netAmount: Double)
    case RateSupplier(orderId: String, supplierId: String, rating: String, title: String?, comment: String?)
}

protocol Router { 
    var route : String { get }
    var parameters : OptionalDictionary { get }
}

extension API : Router {
    
    var route : String  {
        
           let latitude = LocationSingleton.sharedInstance.searchedAddress?.lat ?? (LocationSingleton.sharedInstance.selectedLatitude ?? 30.733351)
           let longitude = LocationSingleton.sharedInstance.searchedAddress?.long ?? (LocationSingleton.sharedInstance.selectedLongitude ?? 76.779037)
        
        let languageId = GDataSingleton.sharedInstance.languageId
        
        //        let latitude = 34.05223420
        //        let longitude = -99.99999999
        
        switch self {
            
        case .getBotResponce:
            return ""//"query?v=20150910"
            
        case .getRestorentList(let lati,let longi, let search):
            var deliveryType = 0
            if let type = UserDefaults.standard.value(forKey: SingletonKeys.deliveryType.rawValue) as? Int {
                deliveryType = type
            }
            var latitud = Double()
            var longitud = Double()
            if let lat = lati,let long = longi {
                latitud = lat
                longitud = long
            } else {
                latitud = latitude
                longitud = longitude
            }
            let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
            if catId != nil {
                return "home/supplier_list?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&self_pickup=\(deliveryType)&categoryId=\(catId!)"
            }
            return "home/supplier_list?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&self_pickup=\(deliveryType)"
            
        case .searchSupplierTags(_):
            return "product/supplier_list"
            
        case .getProductList(let supplierId,let lati,let longi):
            // let areaId = /LocationSingleton.sharedInstance.location?.areaEN?.id
            let languageId = GDataSingleton.sharedInstance.languageId
            var latitud = Double()
            var longitud = Double()
            if let lat = lati,let long = longi {
                latitud = lat
                longitud = long
            } else {
                latitud = latitude
                longitud = longitude
            }
            return "supplier/product_list?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&supplier_id=\(supplierId)"
            
        case .GetSettings(_) : return "getSettings"
        case .getPopularProducts(let lat, let lng):
            let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
            if catId != nil {
                return "popular/product?languageId=\(languageId)&latitude=\(lat)&longitude=\(lng)&offset=0&limit=10&categoryId=\(catId!)"
            }
            return "popular/product?languageId=\(languageId)&latitude=\(lat)&longitude=\(lng)&offset=0&limit=10"
        case .Home(let lati, let longi, let catId):
            let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
            //            let countryId = /LocationSingleton.sharedInstance.location?.countryEN?.id
            // let areaId = /LocationSingleton.sharedInstance.location?.areaEN?.id
            //Nitin
            //            ["countryId" : countryId , "accessToken" : accessToken , "areaId" : areaId ]
            //return "get_all_category_new?languageId=\(languageId)&areaId=\(areaId)&latitude=\(latitude)&longitude=\(longitude)&accessToken=\(accessToken)"
            var latitud = Double()
            var longitud = Double()
            if let lat = lati,let long = longi {
                latitud = lat
                longitud = long
            } else {
                latitud = latitude
                longitud = longitude
            }
            if catId != nil {
                return "get_all_category_new?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&accessToken=\(accessToken)&categoryId=\(catId!)"
            }
            return "get_all_category_new?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&accessToken=\(accessToken)"
            
        case .offers(let lati, let longi):
            let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
            
            var latitud = Double()
            var longitud = Double()
            if let lat = lati,let long = longi {
                latitud = lat
                longitud = long
            } else {
                latitud = latitude
                longitud = longitude
            }
            let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
            if catId != nil {
                return "get_all_offer_list?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&accessToken=\(accessToken)&categoryId=\(catId!)"
                
            }
            return "get_all_offer_list?languageId=\(languageId)&latitude=\(latitud)&longitude=\(longitud)&accessToken=\(accessToken)"
            
        case .Register(_) : return "customer_register_step_first"
        case .RegisterSingleStep(_) : return "v1/user/registration"
        case .Login(_) : return "login"
        case .SendOTP(_) : return "customer_register_step_second"
        case .CheckOTP(_) : return "check_otp"
        case .SupplierListing(_) : return "get_supplier_list"
        case .SupplierInfo(_) : return "supplier_details"
        case .MarkSupplierFav(_) : return "add_to_favourite"
        case .UnFavoriteSupplier(_): return "un_favourite"
        case .SubCategoryListing(let supplierId , let categoryId):// return "subcategory_listing_v1"
            
            //            let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
            
            //            var api = "home/subcategory_listing_v1?language_id=\(languageId)&area_id=\(areaId)&category_id=\(/categoryId)"
            //Nitin
            
            var api = "home/subcategory_listing_v1?languageId=\(languageId)&latitude=\(latitude)&longitude=\(longitude)&category_id=\(/categoryId)"
            if !(/supplierId).isEmpty {
                api = api + "&supplier_id=\(/supplierId)"
            }
            return api
            
            
            //            ["supplierId" : supplierId ?? "" , "categoryId" : categoryId ?? "" , "languageId" : languageId]
            
        case .ProductListing(_) : return "get_products"
        case .ProductDetail(_) :  if SKAppType.type == .carRental {return "v1/get_product_details"} else {return "get_product_details"}
        case .MultiSearch(_): return "multi_search"
        case .LocationList(_, type:let type):
            switch type {
            case .Country:
                return "get_all_country1"
            case .City:
                return "get_all_city1"
            case .Zone:
                return "get_all_zone1"
            case .Area:
                return "get_all_area1"
            default:
                return ""
            }
        case .RegisterLastStep(_):
            return "customer_register_step_third"
        case .ResendOTP(_):
            return "resend_otp"
        case .Addresses(_):
            return "get_all_customer_address"
        case .AddNewAddress(_):
            return "add_new_address"
        case .EditAddress(_):
            return "edit_address"
        case .AddToCart(_):
            // return "add_to_cart"
            return "v1/add_to_cart"
        case .PackageSupplierListing(_):
            return "package_category"
        case .PackageProductListing(_):
            return "package_product"
        case .UpdateCartInfo(_):
            return "update_cart_info"
        case .LoyalityPointScreen(_):
            return "get_loyality_product"
        case .MyFavorites(_):
            return "get_my_favourite"
        case .OrderHistory(_):
            return APIConstants.version2 ? "v2/history_order" : "history_order"
        case .OrderUpcoming(_):
            return APIConstants.version2 ? "v2/upcoming_order" : "upcoming_order"
        case .OrderTrackingList(_):
            return "track_order_list"
        case .SupplierRating(_):
            return "supplier_rating"
        case .BarCodeSearch(_):
            return "bar_code"
        case .GenerateOrder(_):
            return APIConstants.version2 ? "v2/genrate_order" : "v1/genrate_order"
            //if SKAppType.type == .carRental {return "v1/genrate_order"} else {return "genrate_order"}
        //Nitin
        case .ScheduleOrder(_):
            return "schedule_order"
        case .RateOrderListing(_):
            return "rate_my_order_list"
        case .RateMyOrder(_):
            return "user_rate_order"
        case .PromotionProducts(_):
            return "get_promoation_product"
        case .DeleteAddress(_):
            return "delete_customer_address"
        case .OrderTrack(_):
            return "order_track"
        //Notifications
        case .AllNotifications(let skip):
            let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
            return "get_all_notification?skip=\(skip*10)&limit=10&accessToken=\(accessToken)"
        case .ClearAllNotifications(_):
            return "clear_all_notification"
        // Laundry
        case .LaundryServices(_):
            return "get_laundry_data"
        case .LoyaltyPointsOrder:
            return "loyality_order"
        case .NotificationSwitch(_):
            return "on_off_notification"
        case .CancelOrder(_):
            return "cancel_order"
        case .LoginFacebook(_):
            return "facebook_login"
        case .LaundryProductListing(_):
            return "get_laundry_product"
        case .ChangeProfile(_):
            return "change_profile"
        case .UploadReceipt(_):
            return "user/order/addReceipt"
        case .ChangePassword(_):
            return "change_password"
        case .ForgotPassword(_):
            return "forget_password"
        case .ViewAllOffers(_):
            return "view_all_offer"
        case .SupplierImage(_):
            return "supplier_image"
        case .OrderDetails(_):
            return "customer_order_description"
        case .CompareProducts(_):
            return "product_acco_to_area"
        case .CompareProductResult(_):
            return "compare_product"
        case .LaundrySupplierList(_):
            return "laundary_supplier_list"
        case .ScheduleNewOrder(_):
            return "schedule_order_new"
        case .ScheduledOrders(_):
            return "schedule_orders"
        case .NotificationLanguage(_):
            return "notification_language"
        case .TotalPendingSchedule(_):
            return "get_total_pending_schedule"
        case .OrderDetail(_):
            return APIConstants.version2 ? "v2/user_order_details" : "v1/user_order_details"
        case .ClearOneNotification(_):
            return "clear_notification"
        case .ConfirmScheduleOrder(_):return "confirm_order"
        case .ProductVariantList(_):return "common/variant_list"
        case .ProductFilteration(_):return "v1/product_filteration" //Nitin
        case .VariantProductDetail(_): return "get_product_details"
        case .GetArea(_): return "get_area"
        case .RateProduct(let isOrder, let value,let product_id, let order_id, let reviews,let title):
            return isOrder ? "user_rate_order" : "rate_product"
        case .RateSupplier(_):
            return "supplier_rating"
        case .CheckPromo(_): return "checkPromoV1"//"checkPromo"
        case .ServiceAgentlist(_): return "sevice/agent/list"
        case .GetAgentDBKeys: return "agent/get_agent_keys"
        //        case .getAgentAvailabilties(_): return "agent/slots"
        case .getAgentAvailabilty(let id):
            return "agent/availability?id=\(id)"
            
        case .getSlotAvailabilties(let date):
            return "agent/available/slots?date=\(date.toString(format: Formatters.date))&offset=\(Date().timeZone)"
            
        case .getAgentAvailabilties(let id, let date):
            if id == nil {
                 return "agent/slots?date=\(date.toString(format: Formatters.date))&offset=\(Date().timeZone)"
            }
            return "agent/slots?id=\(/id)&date=\(date.toString(format: Formatters.date))&offset=\(Date().timeZone)"
            
        case .listAllFav:
            let areaId = /LocationSingleton.sharedInstance.location?.areaEN?.id
            
            //return "favourite_product?language_id=\(languageId)&area_id=\(areaId)"
            return "favourite_product?language_id=\(languageId)&latitude=\(latitude)&longitude=\(longitude)"
            
        case .makeProductFav(_) : return "product_mark_fav_unfav"
            
        //Nitin
        case .getSecretKey(let uniqueId): return "v1/common/agent/boot?uniqueId=\(uniqueId)"
        case .rentalFilternation(_): return "v1/product_filteration"
        case .appleSignin(_):return "user/apple_login"
        case .checkProductList(_) : return "check_product_list"
        case .getTermsAndConditions: return "list_termsConditions"
        case .myReferals: return "user/myReferral"
        case .getReferalAmount : return "user/referralAmount"
        case .getBraintreeToken: return "braintree/client-token"
        case .getQuestions(let categoryId): return "getQuestionsByCategoryId?categoryId=\(categoryId)&languageId=\(languageId)"
        case .updateFCMToken: return "user/fcmToken/update"
        case .deleteCard(_):
            return "customer/delete_card"
        case .getCards(let customerPaymentId, let gateway_unique_id):
            return "customer/get_cards?customer_payment_id=\(customerPaymentId)&gateway_unique_id=\(gateway_unique_id)"
        case .addCard(_):
            return "customer/add_card"
        case .uploadPrescription(_):
            return "user/order/request"
        case .makePayment(_):
            return "user/order/make_payment"
            case .payRemainingAmount(_):
                return "user/order/remaining_payment"
        case .returnProduct(_): return "/user/order/return_request"
        case .requestList(let skip): return "user/order/requestList?offset=\(skip*10)&limit=10"
        case .cancelRquest(_):
            return "user/order/request_reject"
        case .verifySlot(let agentId, let duration, let datetime):
            let timezoneOffset = TimeZone.current.offsetInHours()
            return "agent/checkAgentSlotsAvailability?offset=\(timezoneOffset)&id=\(agentId)&duration=\(duration)&datetime=\(datetime.toString(format: Formatters.dateTime))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        case .geofenceTax(let lat, let long, let branchId):
            return "common/geofencing_tax?lat=\(/lat)&long=\(/long)&branchId=\(/branchId)"
        case .getSadadPaymentUrl(let name, let email, let amount):
            return "user/Sadded/getPaymentUrl?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&email=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&amount=\(amount)"
        case .getMyFatoorahPaymentUrl:
            return "get_myfatoorah_payment_url"

        case .searchTag(let text, let skip):
            return "search/tags?limit=\(10)&offset=\(skip*10)&latitude=\(latitude)&longitude=\(longitude)&languageId=\(languageId)&tags=\(text)"
        case .getPaystackAccessCode(let email, let netAmount):
            return "paystack/access_code?email=\(email)&net_amount=\(netAmount)"


        }
        
        
    }
    
    var parameters: OptionalDictionary {
        
        let latitude = LocationSingleton.sharedInstance.searchedAddress?.lat ?? (LocationSingleton.sharedInstance.selectedLatitude ?? 0.0)
        let longitude = LocationSingleton.sharedInstance.searchedAddress?.long ?? (LocationSingleton.sharedInstance.selectedLongitude ?? 0.0)
        
        switch self {
        case .myReferals , .getReferalAmount , .getBraintreeToken : return [:]
        case .getBotResponce(let query):
            return [
                "queryInput": [
                    "text": [
                        "text": query,
                        "languageCode": "en"
                    ]
                ],
                "queryParams": [
                    "timeZone": "Asia/Colombo"
                ]
            ]
            
        case .GetSettings(let params) :
            return params
        case .Home, .offers, .getRestorentList, .getProductList :
            return [:]
            
        case .Register(let params):
            return params
        case .RegisterSingleStep(let params):
            return params
        case .Login(let params):
            return params
        case .SendOTP(let params):
            return params
        case .CheckOTP(let params):
            return params
        case .SupplierListing(let params):
            return params
        case .SupplierInfo(let params):
            return params
        case .MarkSupplierFav(let params):
            return params
        case .UnFavoriteSupplier(let params):
            return params
        case .SubCategoryListing(_):
            return nil
        case .ProductListing(let params) :
            return params
        case .ProductDetail(let params):
            return params
        case .MultiSearch(let params):
            return params
        case .LocationList(let params, type: _):
            return params
        case .RegisterLastStep(let params):
            return params
        case .ResendOTP(let params):
            return params
        case .Addresses(let params):
            return params
        case .AddNewAddress(let params):
            return params
        case .EditAddress(let params):
            return params
        case .AddToCart(let params):
            return params
        case .PackageSupplierListing(let params):
            return params
        case .PackageProductListing(let params):
            return params
        case .UpdateCartInfo(let params):
            return params
        case .LoyalityPointScreen(let params):
            return params
        case .MyFavorites(let params):
            return params
        case .OrderHistory(let params):
            return params
        case .OrderUpcoming(let params):
            return params
        case .OrderTrackingList(let params):
            return params
        case .SupplierRating(let params):
            return params
        case .BarCodeSearch(let params):
            return params
        case .GenerateOrder(let params):
            return params
        case .ScheduleOrder(let params):
            return params
        case .RateOrderListing(let params):
            return params
        case .RateMyOrder(let params):
            return params
        case .PromotionProducts(let params):
            return params
        case .DeleteAddress(let params):
            return params
        case .OrderTrack(let params):
            return params
        //Notifications
        case .AllNotifications(_):
            return [:]
        case .ClearAllNotifications(let params):
            return params
        // Laundry
        case .LaundryServices(let params):
            return params
        case .LaundryProductListing(let params):
            return params
        case .LoyaltyPointsOrder(let params):
            return params
        case .NotificationSwitch(let params):
            return params
        case .CancelOrder(let params):
            return params
        case .LoginFacebook(let params):
            return params
        case .ChangeProfile(let params):
            return params
        case .UploadReceipt(let params):
            return params
        case .ChangePassword(let params):
            return params
        case .ForgotPassword(let params):
            return params
        case .ViewAllOffers(let params):
            return params
        case .SupplierImage(let params):
            return params
        case .OrderDetails(let params):
            return params
        case .CompareProducts(let params):
            return params
        case .CompareProductResult(let params):
            return params
        case .LaundrySupplierList(let params):
            return params
        case .ScheduleNewOrder(let params):
            return params
        case .ScheduledOrders(let params):
            return params
        case .NotificationLanguage(let params):
            return params
        case .TotalPendingSchedule(let params):
            return params
        case .OrderDetail(let params):
            return params
        case .ClearOneNotification(let params):
            return params
        case .ConfirmScheduleOrder(let params):
            return params
        case .ProductVariantList(let params):
            return params
        case .ProductFilteration(let params):
            return params
        case .VariantProductDetail(let params):return params
        case .GetArea(let params):return params
        case .RateProduct(let isOrder, let value,let product_id, let order_id, let reviews,let title):
            if isOrder {
                let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
                //            let countryId = /LocationSingleton.sharedInstance.location?.countryEN?.id
                //                let areaId = /LocationSingleton.sharedInstance.location?.areaEN?.id
                let languageId = GDataSingleton.sharedInstance.languageId
                
                //                hashMap.put("languageId", "" + StaticFunction.getLanguage(mContext));
                //                hashMap.put("orderId", "" + list.get(adapterPosition).getOrder_id());
                //                hashMap.put("accessToken", signUp.data.access_token);
                //                hashMap.put("rating", "" + rating);
                //                hashMap.put("comment",""+trim);
                
                return ["accessToken" : accessToken, "languageId": languageId, "rating" : value ?? "" , "orderId" : product_id ?? "","comment" : reviews ?? "", "title": title ?? ""]
            }
            return ["value" : value ?? "" , "product_id" : product_id ?? "", "order_id": order_id ?? "", "reviews" : reviews ?? "", "title": title ?? ""]
        case .CheckPromo(let params): return params
            
        case .ServiceAgentlist(let params): return params
        case .GetAgentDBKeys:
            return [:]
        case .getAgentAvailabilties(_), .getAgentAvailabilty, .getSlotAvailabilties:
            return [:]
        case .listAllFav :
            return [:]
        case .makeProductFav(let id, let isFav) :
            return ["product_id": id, "status": isFav.toInt]
        case .getSecretKey(_):
            return [:]
        case .rentalFilternation(let params):
            return params
        case .appleSignin(let params):
            return params
        case .checkProductList(let product_ids):
            return ["product_ids": product_ids, "latitude" : latitude ,"longitude":longitude]
        case .searchSupplierTags(let productName):
            let languageId = GDataSingleton.sharedInstance.languageId
            return ["productName": productName, "latitude" : latitude ,"longitude":longitude, "languageId": languageId]
        case .getPopularProducts(_), .getTermsAndConditions, .getQuestions(_) ,.getCards(_):
            return [:]
        case .updateFCMToken:
            return ["fcmToken": /GDataSingleton.sharedInstance.fcmToken]
        
        case .addCard(let params):
            return params
        case .deleteCard(let params):
            return params

        case .uploadPrescription(let params):
            return params
        case .makePayment(let orderId, let paymentType):
            let languageId = GDataSingleton.sharedInstance.languageId
            var dict: [String: Any] = ["languageId": languageId, "currency": Constants.currencyName, "order_id": orderId]
            if paymentType.paymentType == .Card {
                dict["payment_token"] = paymentType.token ?? ""
                dict["gateway_unique_id"] = paymentType.gatewayUniqueId
                dict["card_id"] = paymentType.card_id ?? ""
                dict["payment_type"] = 1
                if !(paymentType.card_id ?? "").isEmpty {
                    dict["customer_payment_id"] = GDataSingleton.sharedInstance.customerPaymentId
                }
            }
            else {
                dict["payment_type"] = 0
            }
            return dict
        case .payRemainingAmount(let orderId, let paymentType):
            let languageId = GDataSingleton.sharedInstance.languageId
            var dict: [String: Any] = ["languageId": languageId, "currency": Constants.currencyName, "order_id": orderId]
            dict["payment_token"] = paymentType.token ?? ""
            dict["gateway_unique_id"] = paymentType.gatewayUniqueId
            dict["card_id"] = paymentType.card_id ?? ""
            if !(paymentType.card_id ?? "").isEmpty {
                dict["customer_payment_id"] = GDataSingleton.sharedInstance.customerPaymentId
            }
            return dict
            
        case .returnProduct(let params):
            return params
        case .requestList(_):
            return [:]
        case .cancelRquest(let requestId, let reason):
            return ["id": requestId, "reason": /reason]
        case .verifySlot(_), .searchTag(_):
            return [:]
        case .getPaystackAccessCode(_):
            return [:]

        case .geofenceTax(_), .getSadadPaymentUrl(_):
            return [:]
        case .getMyFatoorahPaymentUrl(let currency, let amount):
            return ["currency":/currency, "amount": /amount]


        case .RateSupplier(let orderId, let supplierId, let rating, let title, let comment):
            let accessToken = /GDataSingleton.sharedInstance.loggedInUser?.token
            return ["orderId": orderId, "accessToken": accessToken,"comment": /comment, "supplierId": supplierId, "rating": rating]

        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .getAgentAvailabilties,
             .getSlotAvailabilties,
             .getAgentAvailabilty,
             .Home,
             .offers,
             .SubCategoryListing,
             .listAllFav,
             .getRestorentList,
             //.GetSettings, // Nitin
        .getProductList,
        .getSecretKey,
        .getPopularProducts,
        .getTermsAndConditions,
        .myReferals , .getReferalAmount , .getBraintreeToken, .getQuestions(_), .getCards(_), .requestList(_), .AllNotifications(_), .verifySlot(_), .geofenceTax(_), .getSadadPaymentUrl(_), .searchTag(_), .getPaystackAccessCode(_):

            return .get
        case .updateFCMToken, .cancelRquest(_):
            return .put
        default:
            return .post
        }
    }
}

enum FormatAPIParameters  {
    
    case GetSetting
    case Home
    case Register(email : String?,password : String?)
    case RegisterSingleStep(email: String?, password: String?, first_name: String?, last_name: String?, referralCode: String?, countryCode: String?, mobileNumber: String?)
    case SupplierListing(categoryId: String?,subCategoryId : String?)
    case SupplierInfo(supplierId : String? ,branchId : String? , accessToken : String?,categoryId : String?)
    case MarkSupplierFavorite (supplierId : String?)
    case UnFavoriteSupplier(supplierId : String?)
    case SubCategoryListing(supplierId : String? , categoryId : String?)
    case DetailedSubCatProducts(supplierBranchId : String? , subCategoryId : String?)
    case ProductDetail(productId : String?,supplierBranchId : String?,offer : String?)
    case MultiSearch(supplierBranchId : String? , categoryId : String? , searchList : String?)
    case Country
    case LocationList(type : SelectedLocation, id : String?)
    //Register & Login
    case SendOTP(accessToken : String?,mobileNumber : String?,countryCode : String?, referalCode: String?)
    case CheckOTP(accessToken : String?,OTP : String?)
    case RegisterLastStep(accessToken : String?,name : String?, email: String?)
    case Login(email : String?,phoneNumber : String? ,countryCode: String?,password : String?)
    case ResendOTP(token : String?)
    
    //Address
    case Addresses(supplierBranchId : String?,areaId : String?)
    case AddNewAddress(address : Address?)
    case EditAddress(address : Address?,addressId : String?)
    case AddToCart(cart : [Cart],supplierBranchId : String?,promotionType : String?,remarks : String?)
    case UpdateCartInfo(cartId : String?,deliveryAddressId : String?,deliveryType : String?,delivery : Delivery?,deliveryDate : Date?,netAmount : String?,remarks : String?, addOn: Double?)
    case PackageSupplierListing
    case PackageProductListing(supplierBranchId : String? , categoryId : String?)
    case LoyalityPointScreen
    case MyFavorites
    case OrderHistory(skip: Int)
    case OrderUpcoming(skip: Int)
    case RateOrderListing
    case OrderTrackingList
    case SupplierRating(supplierId : String?,rating : String?,comment : String?)
    case BarCodeSearch(barCode : String? , supplierBranchId : String?)
    case GenerateOrder(useReferral: Bool, promoCode: PromoCode?, cartId : String?,isPackage : String?,paymentType : PaymentMode,agentIds:[Int]?, deliveryDate: Date?, duration: Double,from_address:String?,to_address:String?,booking_from_date:String?,booking_to_date:String?,from_latitude: Double?,to_latitude:Double?,from_longitude:Double?,to_longitude:Double?,tip_agent:Int?, arrPres:[String]?, instructions: String?, bookingDate: Date?, questions: [Question]?, customer_payment_id: String?, user_service_charge: Double?, donateToSomeone: Bool)
    case ScheduleOrder(orderId : String?,status : CalendarMode,deliveryTime : String?,selectedArr : String?)
    case RateMyOrder(orderId : String?,rating : String?,comment : String?)
    case PromotionProducts
    case DeleteAddress(addressId : String?)
    case OrderTrack(orderId : String?)
    
    //Notifications
    case AllNotifications(skip: Int)
    case ClearAllNotifications
    case NotificationSwitch(status : String?)
    case OrderDetails(orderId : String?)
    
    //Laundry
    case LaundryServices(categoryId : String?)
    case LaundryProductListing(categoryId : String?,supplierBranchId : String?)
    case CancelOrder(orderId : String?,isScheduled : String?)
    case LaundrySupplierList(categoryId : String?,pickupDate : Date?)
    
    case LoyaltyPointsOrder(supplierBranchId : String?,deliveryAddressId : String?,deliveryType : String?,deliveryDate : Date?,totalPoints : String?,urgentPrice : String?,remarks : String?,cart : [Cart])
    
    case FacebookLogin(fbProfile : Facebook)
    case ChangeProfile
    case UploadReceipt
    case ChangePassword(oldPassword : String?,newPassword : String?)
    case ForgotPassword(email : String?)
    
    case ViewAllOffers
    
    case SupplierImage(supplierBranchId : String?)
    case CompareProducts(productName : String?,startValue : String?)
    case CompareProductResult(sku : String?)
    
    case ScheduleNewOrder(orderId : [String]?,deliveryDate : [Date]?,pickUpBuffer : String?,deliveryTime : String?)
    
    case NotificationLanguage(languageId : String?)
    case TotalPendingSchedule
    case OrderDetail(orderId : [String]?)
    case ConfirmScheduleOrder(orderId : String?,paymentType : String?)
    case ClearOneNotification(notificationId : String?)
    case ProductVariantList(categoryId  : String?)
    case ProductFilteration(subCategoryId :[Int]?,low_to_high: String?, is_availability: String?, max_price_range: String?, min_price_range: String?, is_discount :String?, is_popularity:String, product_name: String?, variant_ids : [Any]?, supplier_ids:[String] ,brand_ids:[Int])
    case VariantProductDetail(productId : String?,supplierBranchId : String?,offer : String?)
    
    case GetArea(pincode : String?)
    
    case RateProduct(value :String?,product_id:String?,reviews:String?,title:String)
    
    case CheckPromo(supplierId :[Any]?,totalBill:String?,promoCode:String?,categoryId:[Any])
    
    case ServiceAgentlist(serviceIds :[Int], date: Date?, interval: Int)
    case GetAgentDBKeys
    case GetAgentToken(uniqueID :String?)
    case rentalFilteration(latitude: Double?,longitude: Double?,subCategoryId :[Int]?,low_to_high: String?, is_availability: String?, max_price_range: String?, min_price_range: String?, is_discount :String?, is_popularity:String, product_name: String?, variant_ids : [Any]?, supplier_ids:[String] ,brand_ids:[Int],booking_from_date:String?,booking_to_date:String?,need_agent:Int?,zone_offset:String?)
    case appleSignin(email : String?,first_name : String?,last_name:String?,apple_id :String?)
    case addCard(user_id:Int, card_type:String, card_number:String, exp_month:String, exp_year:String, card_token:String, gateway_unique_id:String, cvc:String, card_holder_name :String)
    case deleteCard(customer_paymentId: String, card_id: String, gateway_unique_id: String)
    case uploadPrescription(supplierBranchId: String, deliveryId: String)


    case returnProduct(order_price_id: Int, product_id: Int, reason: String)
    
    func formatParameters () -> [String : Any]? {
        
        let languageId = GDataSingleton.sharedInstance.languageId
        
        let accessToken = GDataSingleton.sharedInstance.loggedInUser?.token ?? ""
        let countryId = LocationSingleton.sharedInstance.location?.countryEN?.id ?? ""
        
        let areaId = LocationSingleton.sharedInstance.location?.areaEN?.id ?? "0"
        let deviceToken = GDataSingleton.sharedInstance.deviceToken ?? "asdf"
        
        let fcmToken = GDataSingleton.sharedInstance.fcmToken ?? "asdf"
        
        //Nitin
        
        let latitude = LocationSingleton.sharedInstance.searchedAddress?.lat ?? (LocationSingleton.sharedInstance.selectedLatitude ?? 0.0)
        let longitude = LocationSingleton.sharedInstance.searchedAddress?.long ?? (LocationSingleton.sharedInstance.selectedLongitude ?? 0.0)
        
        //        let latitude = 34.05223420
        //        let longitude = -99.99999999
        
        if case .Home = self {
            return [:]//["countryId" : countryId , "accessToken" : accessToken , "areaId" : areaId ]
        }
        
        if case .SupplierListing(let categoryId, let subCategoryId) = self {
            //            var params = ["areaId" : areaId , "categoryId" : categoryId ?? "" , "languageId" : languageId]
            //Nitin
            var params = ["latitude" : latitude ,"longitude":longitude, "categoryId" : categoryId ?? "" , "languageId" : languageId] as [String : Any]
            if subCategoryId != categoryId, subCategoryId != nil {
                params["subCat"] = subCategoryId
                return params
            } else {
                return params
            }
        }
        
        if case .SupplierInfo(let supplierId , let branchId ,let accessToken,let categoryId) = self {
            
            var params = [ "supplierId" : supplierId ?? "" , "branchId" : branchId ?? "" , "accessToken" : accessToken ?? "" , "languageId" : languageId,"latitude" : latitude,"longitude": longitude] as [String : Any]
            
            params["categoryId"] = categoryId ?? GDataSingleton.sharedInstance.currentCategoryId
            
            return params
        }
        
        
        if case .MarkSupplierFavorite(let supplierId) = self{
            return ["accessToken" : accessToken , "supplierId" : supplierId ?? ""]
        }
        
        if case .UnFavoriteSupplier(let supplierId) = self {
            return ["accessToken" : accessToken , "supplierId" : supplierId ?? ""]
        }
        
        if case .DetailedSubCatProducts(let supplierBranchId, let subCategoryId) = self {
            return ["supplierBranchId" : supplierBranchId ?? "" , "subCategoryId" : subCategoryId ?? "" , "languageId" : GDataSingleton.sharedInstance.languageId, "countryId" : countryId , "areaId" : areaId]
        }
        
        if case .ProductDetail(let productId,let supplierBranchId,let offer) = self {
            
            //return ["productId" : productId ?? "" , "languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","areaId" : areaId,"offer" : offer ?? ""]
            
            //Nitin
            return ["productId" : productId ?? "" , "languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","latitude" : latitude,"longitude":longitude,"offer" : offer ?? ""]
        }
        
        if case .SubCategoryListing(let supplierId , let categoryId) = self {
            return [:]//["supplierId" : supplierId ?? "" , "categoryId" : categoryId ?? "" , "languageId" : languageId]
        }
        
        if case .MultiSearch(let supplierBranchId , let categoryId , let searchList) = self {
            return ["supplierBranchId" : supplierBranchId ?? "" , "categoryId" : categoryId ?? "" , "languageId" : languageId , "searchList" : searchList ?? ""]
        }
        
        if case .Country = self {
            return ["languageId" : languageId]
        }
        
        if case .LoyalityPointScreen = self{
            return ["languageId" : languageId ,"accessToken" : accessToken , "areaId" : areaId ,"deviceType" : DeviceType.iOS]
        }
        
        if case .MyFavorites = self{
            return ["languageId" : languageId ,"accessToken" : accessToken , "latitude" : latitude, "longitude":longitude ]
        }
        
        if case .LocationList(let type ,let id) = self {
            
            var params: [String:String] = [:]
            
            switch type {
            case .City:
                params["countryId"] = id ?? ""
                
            case .Zone:
                params["cityId"] = id ?? ""
                
            case .Area:
                params["zoneId"] = id ?? ""
                if let token = GDataSingleton.sharedInstance.loggedInUser?.token {
                    params["accessToken"] = token
                }
            default:
                break
            }
            return params
        }
        
        if case .Register(let email, let password) = self {
            return ["email":email ?? "","password":password ?? "","deviceToken" : fcmToken,"deviceType" : DeviceType.iOS ,"areaId" : areaId,"latitude" : LocationManager.sharedInstance.currentLocation?.currentLat ?? "","longitude" : LocationManager.sharedInstance.currentLocation?.currentLng ?? "","languageId" : languageId]
        }
        
        if case .RegisterSingleStep(let email, let password, let first_name, let last_name, let referralCode, let countryCode, let mobileNumber) = self {
            var params = [String : Any]()

            params = ["email":email ?? "", "password":password ?? "", "first_name":first_name ?? "", "last_name":last_name ?? "", "countryCode":countryCode ?? "", "mobileNumber":mobileNumber ?? "", "deviceToken" : fcmToken, "deviceType" : DeviceType.iOS , "latitude" : LocationManager.sharedInstance.currentLocation?.currentLat ?? "0.0",  "longitude" : LocationManager.sharedInstance.currentLocation?.currentLng ?? "0.0",  "languageId" : languageId]
            
            if /referralCode != "" {
                params["referralCode"] = referralCode ?? ""
            }
            if areaId != "" {
                params["areaId"] = areaId
            }
            return params
        }
        
        if case .appleSignin(let email,let firstName, let lastName,let userId) = self {
            return ["email":email ?? "","first_name":firstName ?? "","deviceToken" : fcmToken,"last_name" : lastName ?? "" ,"apple_id" : userId ?? "","latitude" : latitude,"longitude" : longitude,"languageId" : languageId]
            
        }
        
        if case .SendOTP(let token, let mobileNumber,let countryCode,let referalCode) = self{
            if /referalCode == ""{
                return ["mobileNumber" : mobileNumber ?? "","accessToken" : token ?? "","countryCode" : countryCode ?? ""]
            }else{
                return ["mobileNumber" : mobileNumber ?? "","accessToken" : token ?? "","countryCode" : countryCode ?? "" , "referralCode": /referalCode]
            }
            
        }
        if case .CheckOTP(let token, let otp) = self {
            return ["accessToken" : token ?? "","otp" :otp ?? "","languageId" : languageId]
        }
        if case .RegisterLastStep(let token, let name, let email) = self {
            if let email = email {
                return ["accessToken" : token ?? "","name" : name ?? "", "email": email]
            }
            return ["accessToken" : token ?? "","name" : name ?? ""]
        }
        if case .Login(let email, let phoneNumber, let countryCode, let password) = self {
            if (/email).isEmpty {
                return ["countryCode": /countryCode, "phoneNumber":phoneNumber ?? "","password":password ?? "","deviceToken" : fcmToken ,"deviceType" : DeviceType.iOS ,"languageId" : languageId]
            }else {
                return ["email":email ?? "","password":password ?? "","deviceToken" : fcmToken ,"deviceType" : DeviceType.iOS ,"languageId" : languageId]
            }
        }
        if case .ResendOTP(let token) = self {
            return ["accessToken" : token ?? ""]
        }
        if case .Addresses(let supplierBranchId,let areaid) = self {
            var params = Dictionary<String,Any>()
            if let _ = supplierBranchId {
                params = ["supplierBranchId" : supplierBranchId ?? "", "accessToken" : accessToken,"languageId" : languageId]
            }else {
                params = ["accessToken" : accessToken,"languageId" : languageId]
            }
            
            //params["areaId"] = areaid ?? "0"
            
            //Nitin
            params["latitude"] = latitude
            params["longitude"] = longitude
            
            return params
        }
        
        if case .AddNewAddress(let address) = self {
            
            let pincode = UtilityFunctions.appendOptionalStrings(withArray: [address?.houseNo,address?.buildingName], separatorString: ",@#")
            let lineSecond = UtilityFunctions.appendOptionalStrings(withArray: [address?.city,address?.country], separatorString: ",@#")
            
            var params = [String : Any]()
            params["accessToken"] = accessToken
            //            if areaId != "" {
            //                params["areaId"] = areaId
            //            }
            //            if let land = address?.landMark{
            //                params["landmark"] = land
            //            }
            if let area = address?.area{
                params["addressLineFirst"] = area
            }
            //params["addressLineSecond"] = ""
            
            if let address = address?.address{
                params["customer_address"] = address
            }
            params["latitude"] = address?.latitude ?? ""
            params["longitude"] = address?.longitude ?? ""
            
            
            // let params = ["accessToken" : accessToken,"areaId" : areaId,"landmark" : /address?.landMark,"addressLineFirst" : /address?.area,"addressLineSecond" : /lineSecond ,"pincode" : pincode,"name" : /address?.name,"address_link" : /address?.placeLink,"customer_address" : /address?.address,"latitude" : latitude,"longitude" : longitude] as [String : Any]
            return params
        }
        
        if case .EditAddress(let address,let addressId) = self {
            let pincode = UtilityFunctions.appendOptionalStrings(withArray: [address?.houseNo,address?.buildingName], separatorString: ",@#")
            let lineSecond = UtilityFunctions.appendOptionalStrings(withArray: [address?.city,address?.country], separatorString: ",@#")
            
            var latitudes = Double()
            var lomgituds = Double()
            if let lat = address?.latitude, let lati = Double(lat) {
                latitudes = lati
            }
            if let long = address?.longitude, let longi = Double(long) {
                lomgituds = longi
            }
            
            // let params = ["accessToken" : accessToken,"areaId" : areaId,"landmark" : /address?.landMark,"addressLineFirst" : /address?.area,"addressLineSecond" : /lineSecond, "pincode" : pincode,"addressId" : /addressId,"name" : /address?.name,"address_link" : /address?.placeLink, "customer_address" : /address?.address]
            
            //Nitin
            let params = ["accessToken" : accessToken,"latitude" : latitudes,"longitude":lomgituds,"landmark" : /address?.landMark,"addressLineFirst" : /address?.area,"addressLineSecond" : /lineSecond, "pincode" : pincode,"addressId" : /addressId,"name" : /address?.name,"address_link" : /address?.placeLink, "customer_address" : /address?.address] as [String : Any]
            
            return params
        }
        
        if case .AddToCart(let cart,let supplierId,let promotionType,let remarks) = self {
            
            let bookingDate = GDataSingleton.sharedInstance.pickupDate
            var tempArr : [[String: String]] = []
            var addonArray : [[String:Any]] = []
            var variantsArray : [[String:Any]] = []

//            let maxAdm = Cart.getMaxAdmin(cart: cart)
            //            let maxAdm = Cart.getMaxAdmin(cart: cart)
            let maxSupplier = Cart.getMaxSupplier(cart: cart)
            //let tax = Cart.totalTax
            var addOnCharge: Double = 0

            var serialNo: Int = 0
            for product in cart {
                serialNo += 1
                
                if let arrayAddon = product.arrayAddonValue, arrayAddon.count > 0{
                    
                    if SKAppType.type.isFood {
                        for addons in arrayAddon {
                                                for addon in addons {
                                                    var productDict = [
                                                        "id" : addon.id ?? "",
                                                        "name" : addon.name ?? "",
                                                        "price" : addon.price ?? "",
                                                        "type_id" : addon.type_id ?? "",
                                                        "type_name" : addon.type_name ?? "",
                                                        "quantity": product.perAddonQuantity ?? 0,
                                                        "serial_number" : serialNo,
                                                        "add_on_id_ios": addon.add_on_id_ios ?? ""
                                                        ] as [String : Any]
                                                    
                                                    var isExist = false
                                                    var quantity = 1
                                                    for i in 0..<addonArray.count {
                                                        if addonArray[i]["type_id"] as? String == addon.type_id {
                                                            quantity += 1
                                                            addonArray[i]["adds_on_type_quantity"] = quantity.toString
                                                            isExist = true
                        //                                    quantity += 1 //  adon["adds_on_type_quantity"] as? Int ?? 1
                                                        }
                                                    }
                                                    if isExist {
                        //                                var value = quantity
                        //                                    value = value + 1
                                                        productDict["adds_on_type_quantity"] = quantity.toString // value.toString
                                                        }
                                                        else {
                                                            productDict["adds_on_type_quantity"] = "1"
                                                        
                                                    }
                                                    // print(productDict)r
                                                    addonArray.append(productDict)
                                                }
                                            }
                                            
                                            
                                            let sortedArray = (addonArray as NSArray).sortedArray(using: [NSSortDescriptor(key: "adds_on_type_quantity", ascending: false)]) as! [[String:Any]]
                        //                    print(sortedArray)
                                           
                                            var uniqueArray = [[String: Any]]()
                                            for item in sortedArray {
                                                let exists =  uniqueArray.contains{ element in
                                                    return element["type_id"] as? String == item["type_id"] as? String
                                                }
                                                if !exists {
                                                  uniqueArray.append(item)
                                                }
                                            }
                                            addonArray = uniqueArray
                    } else {
                                            for addons in arrayAddon {
                                                for addon in addons {
                                                    let productDict = [
                                                        "id" : addon.id ?? "",
                                                        "name" : addon.name ?? "",
                                                        "price" : addon.price ?? "",
                                                        "type_id" : addon.type_id ?? "",
                                                        "type_name" : addon.type_name ?? "",
                                                        "quantity": product.perAddonQuantity ?? 0,
                                                        "serial_number" : serialNo,
                                                        "add_on_id_ios": addon.add_on_id_ios ?? ""
                                                        ] as [String : Any]
                                                    // print(productDict)
                                                    addonArray.append(productDict)
                                                }
                                            }
                    }

                } else if let arrayAddons = product.productDetailAddson {
                    for addon in arrayAddons {
                        let productDict = [
                            "id" : addon.id ?? "",
                            "name" : addon.adds_on_name ?? "",
                            "price" : addon.price ?? "",
                            "type_id" : addon.adds_on_type_jd ?? "",
                            "type_name" : addon.adds_on_type_name ?? "",
                            "quantity": product.perAddonQuantity ?? 0,
                            "serial_number" : addon.serial_number ?? 0,
                            "add_on_id_ios" : addon.add_on_id_ios ?? ""
                            ] as [String : Any]
                        addonArray.append(productDict)
                    }
                }
                
                if let variants = product.selectedVariants {
                    for variant in variants {
                        let productDict: [String : Any] = [
                            "unid" : variant.unid ?? 0,
                            "product_name" : variant.productName ?? "",
                            "product_desc" : variant.productDesc ?? "",
                            "measuring_unit" : variant.measuringUnit ?? "",
                            "variant_value" : variant.variantValue ?? "",
                            "variant_id": variant.variantId ?? 0,
                            "variant_type" : variant.variantType ?? 0,
                            "variant_name" : variant.variantName ?? "",
                            "bar_code" : variant.barCode ?? "",
                            "product_id" : /product.id]
                          variantsArray.append(productDict)
                    }
                }
                
                //Do not calculate here (for food add ons case) - save dicounted price in db and get price from there
                
                let priceD: Double = /product.getPrice(quantity: Double(product.quantity!))?.toDouble()
                var itemPrice = (/product.quantity?.toDouble() * priceD)
                //For Home service
                if product.priceType == .Hourly {
                    itemPrice = priceD
                }
                let handlingAdmin = /Double(product.handlingAdmin ?? "0")
                var tax = (handlingAdmin/100)*itemPrice
                //Add ons in home service
                if SKAppType.type == .home {
                    //I home service only 1 product allowed to be added
                    let product = cart.first
                    if let questions = product?.questionsSelected, !questions.isEmpty {
                        addOnCharge = questions.addOnPrice(productPrice: Double(/product?.getPrice(quantity: /product?.quantity?.toDouble())))
                    }
                    tax = tax + (handlingAdmin/100)*addOnCharge
                }

                var productDict = [
                    "productId" : /product.id,
                    "category_id" : /product.categoryId,
                    "quantity" :  /product.quantity,
                    "handling_admin" : product.handlingAdmin ?? "0", //"\(tax)",//product.handlingAdmin == maxAdm ? /product.handlingAdmin : "0",
                    "handling_supplier" : product.handlingSupplier == maxSupplier ? /product.handlingSupplier : "0",
                    "price_type" : product.priceType.rawValue.toString,
                    "supplier_branch_id": /product.supplierBranchId,
                    "supplier_id": /product.supplierId
                ]
                if SKAppType.type == .home {
                    if product.priceType == .Hourly {
                        productDict["quantity"] = "1"
                    }
                    //price for selected no. of hrs of service
                    productDict["price"] = "\(/product.getPrice(quantity: (Double(product.quantity!) ?? 1)))"
                    productDict["agent_type"] = "1"
                }
                // print(productDict)
                tempArr.append(productDict)
                
            }
            
            
            tempArr = tempArr.removingDuplicates()
            print(tempArr)
            //Nitin
            var params = ["accessToken" : accessToken,"supplierBranchId" : /supplierId,"productList" : tempArr,"remarks" :  remarks ?? "0","deviceId" : "0","promotionType" : /promotionType,"latitude" : latitude,"longitude":longitude,"adds_on": addonArray,"variants": variantsArray] as [String : Any]
            if let questions = cart.first?.questionsSelected, !questions.isEmpty {
                var arr: [[String: Any]] = []
                for question in questions {
                    arr.append(question.toJSON())
                }
                params["questions"] = arr
                params["addOn"] = "\(addOnCharge)"
            }
            if SKAppType.type == .home, let date = bookingDate {
                let time = /UtilityFunctions.getDateFormatted(format: "HH:mm:ss", date: date)
                let myCalendar = Calendar(identifier: .gregorian)
                 let weekDay = myCalendar.component(.weekday, from: date)
                params["order_time"] = time
                params["order_day"] = weekDay == 1 ? 6 : (weekDay - 2)
            }
            print(params)
            return params
            
            //            do {
            //                let data = try JSONSerialization.data(withJSONObject: tempArr, options: .prettyPrinted)
            //                var jsonString = String(data: data,encoding: String.Encoding.utf8)
            //                jsonString = jsonString?.replacingOccurrences(of: "\n", with: "")
            //                jsonString = "\"" + (jsonString ?? "") + "\""
            //                let params = ["accessToken" : accessToken,"supplierBranchId" : /supplierId,"productList" : /jsonString,"remarks" :  remarks ?? "0","deviceId" : "1","promotionType" : /promotionType,"area_id" : areaId]
            //                return params
            //            }catch{}
        }
        
        if case .PackageSupplierListing = self {
            return ["areaId" :  areaId , "languageId" : languageId ]
        }
        if case .PackageProductListing(let supplierBranchId, let categoryId) = self {
            return ["supplierBranchId" : /supplierBranchId , "categoryId" : /categoryId , "languageId" : GDataSingleton.sharedInstance.languageId , "areaId" : areaId]
        }
        
        /*
         hanlding admin
         handling supplier
         delvery Charges
         min Order Delivery Crossed
         urgentPrice
         */
        
        if case .UpdateCartInfo(let cartId ,let deliveryAddressId ,let deliveryType,let delivery ,let deliveryDate ,let netAmount ,let remarks, let addOn ) = self {
            //delivery Type 0 -> Standard 1-> Urgent 2 -> Postpone
            var params: [String:Any] = [
                "accessToken": accessToken,
                "cartId" : /cartId,
                "deliveryId" : deliveryAddressId ?? "0",
                "deliveryType" : /deliveryType,
                "handlingAdmin" : /delivery?.handlingAdmin,
                "handlingSupplier" : (/delivery?.handlingSupplier) == "" ? "0" : (/delivery?.handlingSupplier),
                "deliveryCharges" : /delivery?.deliveryCharges,
                "currencyId" : "1",
                "minOrderDeliveryCrossed": /delivery?.minOrderDeliveryCrossed,
                "netAmount" : /netAmount,
                "remarks" : /remarks,
                "languageId" : languageId
            ]
            
            let deliveryDatestr = UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd", date: deliveryDate ?? Date().add(seconds: 15*60*60))
            let deliveryTime = UtilityFunctions.getTimeFormatted(format: "HH:mm:ss", date: deliveryDate ?? Date().add(seconds: 15*60*60))
            params["deliveryDate"] = deliveryDatestr
            params["deliveryTime"] = deliveryTime
            
            let cal = Calendar.current
            let comp = cal.component(.weekday,from: deliveryDate ?? Date().add(seconds: 15*60*60))
            if comp - 2 < 0 {
                params["day"] = "6"
            }else {
                params["day"] = (comp - 2).toString
            }
            if /delivery?.needPickup {
                params["pickupTime"] = UtilityFunctions.getTimeFormatted(format: "HH:mm:ss", date: delivery?.pickupDate ?? Date())
                params["pickupId"] = /delivery?.pickupAddress?.id
                params["pickupDate"] = UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd", date: delivery?.pickupDate ?? Date())
            }
            if deliveryType == "1" {
                params["urgentPrice"] = /delivery?.urgentPrice
            }
            if let price = addOn, price > 0 {
                params["addOn"] = "\(price)"
            }
            print(params)
            return params
        }
        
        if case .GenerateOrder(let useReferral, let promoCode, let cartId,let isPackage,let paymentType,let agentIds, let deliveryDate, let duration,let from_address,let to_address, let booking_from_date, let booking_to_date, let from_latitude,let to_latitude,let from_longitude,let to_longitude ,let tip_agent, let arrPres, let instructions, let bookingDate, let questions, let customer_payment_id, let user_service_charge, let donateToSomeone) = self {
            
            let timezoneOffset = TimeZone.current.offsetInHours()
            var date = deliveryDate ?? Date()
            if SKAppType.type == .home && bookingDate != nil {
                date = bookingDate!
            }
            let time = /UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd HH:mm:ss", date: date)
            
            var dict: [String: Any] = [
                "use_refferal": useReferral ? 1 : 0,
                "self_pickup" : "\(DeliveryType.shared.rawValue)",
                "promoCode" : /promoCode?.code,
                "promoId" : /promoCode?.id,
                "discountAmount" : /promoCode?.totalDiscount,
                "date_time" : time,
                "duration" : /duration,
                "accessToken" : accessToken,
                "languageId" : languageId,
                "cartId" : /cartId,
                "paymentType" : paymentType.paymentType.rawValue,
                "isPackage" : /isPackage,
                "offset":timezoneOffset,
                "agentIds": agentIds ?? [Int](),
                "from_address": from_address ?? "",
                "to_address" : to_address ?? "",
                "booking_from_date" : booking_from_date ?? "",
                "booking_to_date" : booking_to_date ?? "",
                "from_latitude" : from_latitude ?? 0.0,
                "to_latitude" : to_latitude ?? 0.0,
                "from_longitude" : from_longitude ?? 0.0,
                "to_longitude" : to_longitude ?? 0.0,
                "tip_agent" : tip_agent ?? 0,
                "customer_payment_id" : customer_payment_id ?? "",
                "user_service_charge" : user_service_charge ?? 0.0
            ]
            if paymentType.paymentType == .Card {
                dict["payment_token"] = paymentType.token
                dict["gateway_unique_id"] = paymentType.gatewayUniqueId
                dict["card_id"] = paymentType.card_id
            }
            if paymentType.paymentType == .AfterConfirmation {
                dict["payment_after_confirmation"] = "1"
            }
            if let arr = arrPres, !arr.isEmpty {
                var i = 1
                for imgUrl in arr {
                    dict["pres_image\(i)"] = imgUrl
                    i += 1
                }
            }
            if let txt = instructions {
                dict["pres_description"] = txt
            }
            if let date = bookingDate, let dateStr = UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd HH:mm:ss", date:date) {
                dict["booking_date_time"] = dateStr
            }
            if let data = questions, !data.isEmpty {
                var arr: [[String: Any]] = []
                for question in data {
                    arr.append(question.toJSON())
                }
                dict["questions"] = arr
            }
            if donateToSomeone {
                dict["donate_to_someone"] = "1"
            }
            if let type = GDataSingleton.sharedInstance.cartAppType {
                dict["type"] = type
            }
            return dict
        }
        
        if case .ScheduleOrder(let orderId ,let status,let deliveryTime ,let selectedArr ) = self {
            var params = ["accessToken" : accessToken,"orderId" : /orderId,"delivery_time" : /deliveryTime]
            
            params["status"] = status == .Weekly ? "1" : "2"
            if status == .Weekly {
                params["weekly_arr"] = "[" + (selectedArr ?? "") + "]"
            }else {
                params["monthly_arr"] = "[" + (selectedArr ?? "") + "]"
            }
            return params
        }
        if case .RateMyOrder(let orderId ,let rating, let comment) = self {
            return ["accessToken" : accessToken,"orderId" : /orderId, "rating" : /rating, "comment" : /comment,"languageId" : languageId]
        }
        
        if case .SupplierRating(let supplierId, let rating,let comment) = self{
            return ["accessToken" : accessToken,"supplierId" : /supplierId,"rating" : /rating, "comment" : comment ?? ""]
        }
        
        if case .BarCodeSearch(let barCode , let supplierBranchId) = self {
            var params = ["barCode" : /barCode , "languageId" : GDataSingleton.sharedInstance.languageId,"areaId" : /areaId]
            //            if let _ = supplierBranchId {
            //                params["supplierBranchId"] = supplierBranchId ?? ""
            //            }
            return params
        }
        if case .PromotionProducts = self {
            return ["languageId" : languageId , "areaId" : areaId]
        }
        //Notifications
        if case .AllNotifications = self{
            return ["accessToken" : accessToken]
        }
        
        if case .ClearAllNotifications = self{
            return ["accessToken" : accessToken]
        }
        
        //ORDER RELATED
        if case .OrderHistory(let skip) = self  {
            return ["accessToken" : accessToken,"languageId" : languageId, "limit": 5, "skip": skip*5]
        }
        
        if case .OrderUpcoming(let skip) = self {
            return ["accessToken" : accessToken,"languageId" : languageId, "limit": 5, "skip": skip*5]
        }
        
        if case .RateOrderListing = self {
                   return ["accessToken" : accessToken,"languageId" : languageId]
               }
        
        
        if case .OrderTrackingList = self {
            return ["accessToken" : accessToken,"languageId" : languageId]
        }
        
        if case .DeleteAddress(let addressId) = self {
            return ["accessToken" : accessToken,"addressId" : addressId ?? ""]
        }
        
        //Laundry
        if case .LaundryServices(let categoryId) = self {
            return ["categoryId" : categoryId ?? "" , "languageId" : languageId]
        }
        
        //Edited
        if case .OrderTrack(let orderId) = self {
            return ["accessToken" : accessToken,"languageId" : languageId,"orderId" : orderId ?? ""]
        }
        
        if case .CancelOrder(let orderId , let isScheduled) = self {
            return ["accessToken" : accessToken,"languageId" : languageId,"orderId" : orderId ?? "" , "isScheduled" : isScheduled ?? ""]
        }
        
        if case .LoyaltyPointsOrder(let supplierBranchId ,let deliveryAddressId,let deliveryType,let deliveryDate,let totalPoints  ,let urgentPrice ,let remarks ,let cart ) = self {
            
            var params = ["accessToken": accessToken,"languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","deliveryAddressId" : deliveryAddressId ?? "","deliveryType" : deliveryType ?? "","remarks" : remarks ?? "0","totalPoints" : totalPoints ?? "","deviceType" : DeviceType.iOS]
            
            let deliveryDatestr = UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd", date: deliveryDate ?? Date())
            
            params["deliveryDate"] = deliveryDatestr ?? ""
            if deliveryType == "1" {
                params["urgentPrice"] = urgentPrice ?? ""
                params["urgent"] = "1"
            }
            var productList = [String]()
            for product in cart {
                
                productList.append(product.id ?? "")
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: productList, options: .prettyPrinted)
                var jsonString = String(data: data,encoding: String.Encoding.utf8)
                jsonString = jsonString?.replacingOccurrences(of :"\n", with: "")
                params["productList"] = jsonString ?? ""
                return params
            }catch {}
        }
        
        if case .NotificationSwitch(let status) = self {
            return ["accessToken" : accessToken,"languageId" : languageId,"status" : status == "true" ? "1" : "0"]
        }
        
        if case .FacebookLogin(let profile) = self {
            //return ["facebookToken":profile.fbId ?? "","email":profile.email ?? "","deviceToken" : deviceToken,"deviceType" : DeviceType.iOS ,"areaId" : areaId,"image" : profile.imageUrl ?? "","name" : profile.firstName ?? ""]
            
            return ["facebookToken":profile.fbId ?? "","email":profile.email ?? "","deviceToken" : fcmToken,"deviceType" : DeviceType.iOS ,"latitude" : latitude,"longitude":longitude,"image" : profile.imageUrl ?? "","name" : profile.firstName ?? ""]
        }
        
        if case .LaundryProductListing(let categoryId, let supplierBranchId) = self{
            return ["categoryId" : categoryId ?? "","languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","areaId" : areaId]
        }
        
        if case .ChangeProfile = self {
            return ["accessToken" : accessToken]
        }
        
        if case .UploadReceipt = self {
            return ["accessToken" : accessToken]
        }
        
        if case .uploadPrescription(let supplierBranchId, let deliveryId) = self {
            return ["accessToken" : accessToken, "supplier_branch_id": supplierBranchId, "deliveryId": deliveryId, "service_type": SKAppType.type.rawValue]
        }
        
        if case .ChangePassword(let oldPassword,let newPassword) = self {
            return ["accessToken" : accessToken,"languageId" : languageId,"oldPassword" : oldPassword ?? "","newPassword" : newPassword ?? ""]
        }
        
        if case .ForgotPassword(let email) = self {
            return ["emailId" : email ?? ""]
        }
        
        if case .ViewAllOffers = self {
            // return ["languageId" : languageId,"areaId" : areaId]
            //Nitin
            if let catId = AppSettings.shared.selectedCategoryId{//GDataSingleton.sharedInstance.selectedCatId {
                return ["languageId" : languageId,"latitude" : latitude,"longitude":longitude, "categoryId": catId]
            }
            else {
                return ["languageId" : languageId,"latitude" : latitude,"longitude":longitude]
            }
            
        }
        
        if case .SupplierImage(let branchId) = self {
            return ["branchId" : branchId ?? ""]
        }
        
        if case .OrderDetails(let orderId) = self {
            return ["accessToken" : accessToken,"orderId" : orderId ?? ""]
            
            //Nitin
            //return ["accessToken" : accessToken,"latitude" : latitude,"longitude":longitude]
            
        }
        
        if case .CompareProducts(let productName,let startValue) = self {
            return ["languageId" : languageId,"areaId" : areaId,"productName" : productName.unwrap(),"startValue" : startValue.unwrap()]
        }
        
        if case .CompareProductResult(let sku) = self {
            // return ["languageId" : languageId,"areaId" : areaId,"skuCode" : sku.unwrap()]
            
            //Nitin
            return ["languageId" : languageId,"latitude" : latitude,"longitude":longitude,"skuCode" : sku.unwrap()]
            
        }
        
        if case .LaundrySupplierList(let categoryId,let date) = self {
            var dayNumber = (UtilityFunctions.getDateFormatted(format: "e",date : date ?? Date()))?.toInt()
            if dayNumber != 1 {
                dayNumber = (dayNumber ?? 2) - 2
            }else {
                dayNumber = 6
            }
            return ["categoryId" : categoryId ?? "", "date" : String(dayNumber ?? 0),"time" : UtilityFunctions.getTimeFormatted(format: "HH:mm:ss",date : date ?? Date()),"areaId" : areaId,"languageId" : languageId]
        }
        
        if case .ScheduleNewOrder(let orderId ,let dates,let pickupBuffer,let deliveryTime) = self {
            
            var tempArr : [[String:String]] = []
            for date in dates ?? [] {
                
                if let buffer = pickupBuffer?.toInt() {
                    
                    let calendar = Calendar.current
                    let newDate = calendar.date(byAdding: .minute, value: -buffer, to: date)
                    let dict = [
                        "deliveryDate" : newDate?.toString() ?? "",
                        "pickupDate" : date.toString(),
                        "pickupTime" : UtilityFunctions.getTimeFormatted(format: "HH:mm:ss",date : date)
                    ]
                    tempArr.append(dict)
                    
                }else {
                    
                    let dict = ["deliveryDate" : UtilityFunctions.getDateFormatted(format: "EEE MM dd HH:mm:ss ZZZ yyyy", date: date) ?? "","pickupDate" : "","pickupTime" : "","delivery_time" : /deliveryTime]
                    tempArr.append(dict)
                    
                }
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: tempArr, options: .prettyPrinted)
                var jsonString = String(data: data,encoding: String.Encoding.utf8)
                jsonString = jsonString?.replacingOccurrences(of: "\n", with: "")
                jsonString =  (jsonString ?? "")
                let params = ["orderId" : orderId ?? "","orderDates" : tempArr ,"type" : DeviceType.iOS,"accessToken" : accessToken] as [String : Any]
                return params
            }catch{ }
        }
        
        if case .NotificationLanguage(let language) = self {
            return ["accessToken" : accessToken, "languageId" : /language]
        }
        
        if case .TotalPendingSchedule = self {
            return ["accessToken" : accessToken]
        }
        if case .OrderDetail(let orderId) = self {
            return ["accessToken" : accessToken,"languageId" : languageId,"orderId" : orderId ?? ""]
        }
        
        if case .ClearOneNotification(let notificationId) = self {
            return ["accessToken" : accessToken,"notificationId" : notificationId ?? ""]
        }
        
        if case .ConfirmScheduleOrder(let orderId,let payment) = self {
            
            return ["accessToken" : accessToken,"languageId" : languageId,"orderId" : orderId ?? "","paymentType" : payment ?? ""]
        }
        
        if case .ProductVariantList(let categoryId) = self {
            return ["category_id": /categoryId]
        }
        
        
        if case .ProductFilteration(let subCategoryId, let low_to_high, let is_availability, let max_price_range, let min_price_range, let is_discount, let is_popularity, let product_name, let variant_ids ,let supplier_ids,let brand_ids) = self{
            
            // return ["languageId": languageId, "countryId": countryId,"areaId" : areaId,"subCategoryId": subCategoryId ?? [Any](),"low_to_high":low_to_high ?? "","is_availability":is_availability ?? "","max_price_range":max_price_range ?? "","min_price_range": min_price_range ?? "","is_discount": is_discount ?? "" ,"is_popularity": is_popularity, "product_name": product_name ?? "","variant_ids": variant_ids ?? [Any](),"supplier_ids": supplier_ids, "brand_ids":brand_ids]
            
            //Nitin
            return ["languageId": languageId,"latitude" : latitude,"longitude":longitude,"subCategoryId": subCategoryId ?? [Any](),"low_to_high":low_to_high ?? "","is_availability":is_availability ?? "","max_price_range":max_price_range ?? "","min_price_range": min_price_range ?? "","is_discount": is_discount ?? "" ,"is_popularity": is_popularity, "product_name": product_name ?? "","variant_ids": variant_ids ?? [Any](),"supplier_ids": supplier_ids, "brand_ids":brand_ids]
            
            //            return ["languageId": languageId, "countryId": countryId,"areaId" : areaId,"subCategoryId": subCategoryId ?? [Any](),"low_to_high":low_to_high ?? "","is_availability":is_availability ?? "","max_price_range":max_price_range ?? "","min_price_range": min_price_range ?? "","is_discount": is_discount ?? "" ,"is_popularity": is_popularity, "product_name": product_name ?? "" ,"variant_ids": variant_ids ?? [Any](),"supplier_ids": supplier_ids ?? [Any]()]
            
            
        }
        
        if case .VariantProductDetail(let productId,let supplierBranchId,let offer) = self {
            //            return ["productId" : productId ?? "" , "languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","areaId" : areaId,"offer" : offer ?? ""]
            //Nitin
            return ["productId" : productId ?? "" , "languageId" : languageId,"supplierBranchId" : supplierBranchId ?? "","latitude" : latitude,"longitude":longitude,"offer" : offer ?? ""]
        }
        
        if case .GetArea(let pincode) = self{
            return ["pincode" : pincode ?? "","languageId" : languageId]
        }
        
        if case .RateProduct(let value,let product_id,let reviews,let title) = self{
            
            return ["value" : value ?? "" , "product_id" : product_id ?? "","reviews" : reviews ?? "", "title": title ?? ""]
        }
        
        if case .CheckPromo(let supplierId, let totalBill, let promoCode, let categoryId) = self {
            return ["supplierId" : supplierId ?? "" , "totalBill" : totalBill ?? "","promoCode" : promoCode ?? "", "categoryId": categoryId ?? "","langId" : languageId , "accessToken" : accessToken]
        }
        
        if case .ServiceAgentlist(let serviceId, let date, let interval) = self{
            var dict = ["serviceIds":serviceId, "duration":interval] as [String : Any]
            if let dateStr = date?.toString(format: Formatters.dateTime) {
                dict["datetime"] = dateStr
            }
            return dict
        }
        
        if case .GetAgentDBKeys = self{
            return [:]
        }
        
        if case . GetAgentToken(let uniqueId) = self {
            return ["uniqueId":uniqueId as Any]
        }
        
        //Nitin
        if case .rentalFilteration(let lati, let longi,let subCategoryId, let low_to_high, let is_availability, let max_price_range, let min_price_range, let is_discount, let is_popularity, let product_name, let variant_ids ,let supplier_ids,let brand_ids,let booking_from_date,let booking_to_date,let need_driver,let zone_offset) = self {
            
            return ["languageId": languageId,"latitude" : lati ?? 0.0,"longitude":longi ?? 0.0,"subCategoryId": subCategoryId ?? [Any](),"low_to_high":low_to_high ?? "","is_availability":is_availability ?? "","max_price_range":max_price_range ?? "","min_price_range": min_price_range ?? "","is_discount": is_discount ?? "" ,"is_popularity": is_popularity, "product_name": product_name ?? "","variant_ids": variant_ids ?? [Any](),"supplier_ids": supplier_ids, "brand_ids":brand_ids,"booking_from_date": booking_from_date ?? "","booking_to_date": booking_to_date ?? "","need_agent":need_driver ?? 1,"zone_offset": zone_offset ?? ""]
        }
        
        if case .addCard(let user_id, let card_type, let card_number, let exp_month, let exp_year, let card_token, let gateway_unique_id, let cvc, let card_holder_name ) = self{
            return ["user_id" : user_id, "card_type":card_type, "card_number":card_number, "exp_month":exp_month, "exp_year":exp_year , "card_nonce":card_token, "gateway_unique_id":gateway_unique_id, "cvc":cvc, "card_holder_name": card_holder_name ]
        }
        
        if case .deleteCard(let customer_paymentId, let card_id, let gateway_unique_id) = self{
            return ["customer_payment_id":customer_paymentId, "card_id":card_id, "gateway_unique_id": gateway_unique_id]
        }
        
        if case .returnProduct(let order_price_id, let product_id, let reason) = self{
            return ["order_price_id":order_price_id, "product_id":product_id, "reason": reason]
        }
        
        if case .addCard(let user_id, let card_type, let card_number, let exp_month, let exp_year, let card_token, let gateway_unique_id, let cvc, let card_holder_name ) = self{
            return ["user_id" : user_id, "card_type":card_type, "card_number":card_number, "exp_month":exp_month, "exp_year":exp_year , "card_token":card_token, "gateway_unique_id":gateway_unique_id, "cvc":cvc, "card_holder_name": card_holder_name ]
        }
        
        if case .deleteCard(let customer_paymentId, let card_id, let gateway_unique_id) = self{
            return ["customer_payment_id":customer_paymentId, "card_id":card_id, "gateway_unique_id": gateway_unique_id]
        }
        
        return nil
    }
}
