//
//  BookServiceEndPoint.swift
//  Buraq24
//
//  Created by MANINDER on 17/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import Alamofire



enum BookServiceEndPoint {
    
    
    case braintreeCheckout(amount:String,nonce:String,orderId:Int)
    case getBraintreeToken
    case homeApi(categoryID : Int? )
    case terminologyAPI(categoryID : Int? )
    case requestApi(objRequest: ServiceRequest, categoryId : Int?, categoryBrandId : Int?, categoryBrandProductId : Int? ,productQuantity : Int? , dropOffAddress : String? , dropOffLatitude : Double? , dropOffLongitude : Double?  , pickupAddress : String? , pickupLatitude : Double? , pickupLongitude : Double? , orderTimings : String? , future : String? , paymentType : String? , distance : Int? , organisationCouponUserId : Int? , materialType : String? , productWeight : Double? , productDetail : String? , orderDistance : Float?    , finalCharge: String?, package_id: Int?, distance_price_fixed: String?, price_per_min: String?, time_fixed_price: String?, price_per_km: String?, booking_type: String?, friend_name: String?, friend_phone_number: String?, friend_phone_code: String?, driver_id: Int?,coupon_code: String?, cancellation_charges: Float?, stops: String?, address_name: String?, user_card_id: Int?, credit_point_used: String?, description: String?, elevator_pickup: String?, elevator_dropoff: String?, pickup_level: String?, dropoff_level: String?, fragile: String?, check_lists: String?, gender: String?, order_time: Float?,numberOfRiders:String)
    
    case cancelRequest(orderId : Int? , cancelReason : String?)
    case onGoingRequest
    case rateDriver(orderId : Int? , rating : Int? , comment : String?)
    
    case eTokens(categoryId : Int?  , distance : Int? , take : Int? , orderTimings : String?)
    case getEtokenDetail(brandId : Int? , productId : Int?)
    case buyETokens(eTokenId : Int?)
    case history(skip : Int? , take : Int? ,type : Int?, startDate: String?, endDate: String?)
    case  orderDetails(orderID : Int? )
    case getCompanyListWater(type: String?, latitude:Double?, longitude:Double?, category_brand_id:Int?, category_brand_product_id: Int?, take:Int,skip:Int)
    case getTokenList (organisation_id:Int,category_brand_id:Int, skip:Int, take:Int)
    case getTokenPurchaseList (skip:Int,take:Int)
    case purchaseEToken(organisation_coupon_id:Int?, buraq_percentage:Int?, bottle_returned_value:Int?, bottle_charge:Int?, quantity:Int?, payment_type:String?, price:Int?, eToken_quantity:Int?, address:String?, address_latitude:Double?, address_longitude:Double?)
    case EtokenOrderAcceptReject(order_id:String?, status: String?)
    
    case packageListing
    case scanQrCode(user_id: String?)
    case coupons
    case checkCoupons(code: String?)
    case halfWayStop(orderId: Int?, latitude: Double?, longitude: Double?, order_distance: Double?,  half_way_stop_reason: String?, payment_type: String?)
    case breakdownRequest(orderId: Int?, latitude: Double?, longitude: Double?, order_distance: Double?,  reason: String?)
    case shareRide(shareWith: String?, orderId: Int?)
    case cancelShareRide(orderId: Int?)
    case cancelHalfWayStop(orderId: Int?)
    case cancelVehicleBreakDown(orderId: Int?)
    case getCreditPoints
    case panic
    case addStops(orderId: Int?, stops: String?, dropOffAddress : String? , dropOffLatitude : Double? , dropOffLongitude : Double?)
    case addAddress(address: String?, address_latitude: Double?, address_longitude: Double?, category: String?, address_name: String?)
    case editAddress(address: String?, address_latitude: Double?, address_longitude: Double?, user_address_id: Int?, category: String?, address_name: String?)
    case bannerAndServices
    case addStripCard(tokenId:String,gatewayId:String)
    case addEpaycoCard(card:String,year:String,month:String,cvv:String,gatewayId:String)
    case getCard
    case getStripeCard
    case removeCard(user_card_id: Int?,paymentId:String? = "")
    case payPendingAmount(user_card_id: Int?, amount: String?)
    case notification
    case editCheckList(checkList: String?)
    case removeCheckListItem(checkList: String?)
    case walletLogs(skip: String?, limit: String?)
    case walletTransfer(amount: String?, phone_code: String?, phone_number: String?)
    case addTip(tip : Int? , orderId : Int?, gateway_unique_id: String?)
    case getWalletBalance
    case addWalletMoney(amount:Int,cardId:Int,gatewayId:String)
    case addCard(card_holder_name: String?, card_number: String?, exp_year: String?, cvc: String?, gateway_unique_id: String?, card_brand: String?, exp_month: String?)
    case getChatList(_ language_id : String,_ limit : Int,_ skip : Int)
    case pssChatListing(_ language_id : String,_ receiver_id : String,_ limit : Int,_ skip : Int)
    case uploadImge
    case razorPayReturnUrl(order_id: String, payment_id: String)
     case getCoronaAreas
}

extension BookServiceEndPoint : RouterCab {
    
    func searchRequest(isImage: Bool, images: [UIImage?]?, isLoaderNeeded: Bool?, header: [String : String], completion: @escaping CompletionCab) -> DataRequest {
        let request = Alamofire.SessionManager.default.request("" , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            print(response)
        }
        return request
    }
    
    
    func request(isImage: Bool = false , images: [UIImage?]? = [] , isLoaderNeeded: Bool? = true , header: [String: String] , completion: @escaping CompletionCab ) {
        APIManagerCab.shared.request(with: self, images: images, isLoaderNeeded: isLoaderNeeded, completion: completion, header: header)
    }
    
    var route : String  {
        switch self {
        case .braintreeCheckout: return "brainTree/checkout"
        case .getBraintreeToken: return "braintree/user_token"
        case .getCoronaAreas: return APITypes.getCoronaArea
        case .homeApi(_): return APITypes.homeAPI
        case .terminologyAPI(_): return APITypes.terminologyAPI
        case .requestApi(_) : return APITypes.requestAPI
        case .cancelRequest(_) : return APITypes.cancelRequestAPI
        case .onGoingRequest : return APITypes.ongoingRequestAPI
        case .rateDriver(_) : return APITypes.rate
        case .eTokens(_) : return APITypes.eTokens
        case .getEtokenDetail(_) : return APITypes.eTokenDetails
        case .buyETokens(_) : return APITypes.buyEToken
        case .history(_) : return APITypes.bookingHistory
        case .orderDetails(_) : return APITypes.orderDetails
        case .getCompanyListWater(_) : return APITypes.companyList
        case .getTokenList(_) : return APITypes.etokensList
        case .getTokenPurchaseList(_) : return APITypes.etokenPurchasedList
        case .purchaseEToken(_) : return APITypes.etokenPurchase
        case .EtokenOrderAcceptReject(_): return APITypes.etokenConfirmReject
        case .packageListing: return APITypes.packageListing
        case .scanQrCode: return APITypes.scanQrCode
        case .coupons: return APITypes.coupons
        case .checkCoupons: return APITypes.checkCoupons
        case .halfWayStop(_): return APITypes.halfWayStop
        case .breakdownRequest(_): return APITypes.breakdownRequest
        case .shareRide(_): return APITypes.shareRide
        case .cancelShareRide(_): return APITypes.cancelShareRide
        case .cancelHalfWayStop(_): return APITypes.cancelHalfWayStop
        case .cancelVehicleBreakDown(_): return APITypes.cancelVehicleBreakDown
        case .getCreditPoints : return APITypes.getCreditPoints
        case .panic: return APITypes.panic
        case .addStops(_): return APITypes.addStops
        case .addAddress(_): return APITypes.addAddress
        case .editAddress(_): return APITypes.editAddress
        case .bannerAndServices: return APITypes.bannerAndServices
        case .addCard: return APITypes.addCard
        case .getCard,.getStripeCard: return APITypes.getCard
        case .addStripCard(_),.addEpaycoCard(_): return APITypes.addCard
        case .removeCard(_): return APITypes.removeCard
        case .payPendingAmount(_): return APITypes.payPendingAmount
        case .notification : return APITypes.notification
        case .editCheckList(_) : return APITypes.editCheckList
        case .removeCheckListItem(_) : return APITypes.removeCheckListItem
        case .walletLogs(_) : return APITypes.walletLogs
        case .walletTransfer(_): return APITypes.walletTransfer
        case .addTip : return APITypes.addTip
        case .getWalletBalance: return APITypes.getWalletBalance
        case .getChatList(_): return APITypes.chatList
        case .pssChatListing(_): return APITypes.getConversationList
        case .uploadImge: return APITypes.uploadImge
        case .addWalletMoney: return APITypes.addWalletAmount
        case .razorPayReturnUrl: return APITypes.razorPayReturnUrl
        }
    }
    
    var parameters: OptionalDictionary {
        return format()
    }
    
    func format() -> OptionalDictionary {
        
        switch self {
            
        case .braintreeCheckout(let amount,let nonce,let orderId):
            
            return Parameters.braintreeCheckout.map(values: [amount,nonce,orderId])
            
        case .homeApi(let categoryId):
            return Parameters.homeApi.map(values: [/categoryId , LocationsCab.lat.getLoc() , LocationsCab.longitude.getLoc(), 2000])
            
        case .terminologyAPI(let categoryId):
            return Parameters.terminologyAPI.map(values: [/categoryId])
            
            /**
             .description,
             .elevator_pickup,
             .elevator_dropoff,
             .pickup_level
             */
            
            
        case .requestApi(let objRequest, let categoryId ,  let categoryBrandId, let categoryBrandProductId, let productQuantity, let dropOffAddress , let dropOffLatitude , let dropOffLongitude,   let pickupAddress, let pickupLatitude,let pickupLongitude,let orderTimings, let future,let paymentType , let distance , let organisationCouponUserId  , let materialDetails , let productWeight , let productDetail , let orderDistance, let finalCharge, let package_id, let distance_price_fixed, let price_per_min, let time_fixed_price, let price_per_km, let booking_type, let friend_name, let friend_phone_number, let friend_phone_code, let driver_id, let coupon_code, let cancellation_charges, let stops, let address_name, let user_card_id, let credit_point_used, let description, let elevator_pickup, let elevator_dropoff, let pickup_level, let dropoff_level, let fragile, let check_lists, let gender, let order_time, let numberOfRiders):
            return Parameters.requestAPi.map(values: [
                categoryId,
                categoryBrandId,
                categoryBrandProductId,
                productQuantity,
                dropOffAddress,
                dropOffLatitude,
                dropOffLongitude,
                pickupAddress,
                pickupLatitude,
                pickupLongitude,
                orderTimings,
                future,
                paymentType,
                distance,
                organisationCouponUserId,
                materialDetails,
                productWeight,
                productDetail,
                orderDistance,
                objRequest.pickupPersonName,
                objRequest.pickupPersonPhone,
                objRequest.invoiceNumber,
                objRequest.deliveryPersonName,
                objRequest.selectedBrand?.brandName,
                finalCharge,
                package_id,
                distance_price_fixed,
                price_per_min,
                time_fixed_price,
                price_per_km,
                booking_type,
                friend_name,
                friend_phone_number,
                friend_phone_code,
                driver_id,
                coupon_code,
                cancellation_charges,
                stops,
                address_name,
                user_card_id,
                credit_point_used,
                description,
                elevator_pickup,
                elevator_dropoff,
                pickup_level,
                dropoff_level,
                fragile,
                check_lists,
                gender,
                order_time,
                numberOfRiders
                
            ])
        case .cancelRequest(let orderId , let cancelReason):
            return Parameters.cancelRequestApi.map(values: [/orderId , /cancelReason])
        case .rateDriver(let orderId , let rateValue , let comment):
            return Parameters.rateDriver.map(values: [/orderId , /rateValue , /comment])
        case .onGoingRequest:
            return Parameters.cancelRequestApi.map(values: [])
        case .eTokens(let categoryId , let distance , let take , let date):
            return Parameters.eTokens.map(values: [categoryId, LocationsCab.lat.getLoc()  , LocationsCab.longitude.getLoc() , distance , take , date])
            
        case .getEtokenDetail(let brandId , let productId ):
            return Parameters.eTokenDetails.map(values: [  brandId , productId])
            
        case .buyETokens(let tokenId) :
            return Parameters.buyETokens.map(values: [tokenId])
        case .history(let skip, let take ,let type, let startDate, let endDate):
            return Parameters.history.map(values: [skip , take ,/type, /startDate, /endDate])
        case .orderDetails(let orderId):
            return Parameters.orderDetail.map(values: [/orderId ])
            
        case .getCompanyListWater(let type, let latitude,  let longitude ,let  category_brand_id,let  category_brand_product_id , let take, let skip):
            return Parameters.getCompanyListWater.map(values: [/type, /latitude, /longitude, /category_brand_id, /category_brand_product_id, take, skip])
            
        case .getTokenList(let organisation_id,let category_brand_id ,let skip ,let take):
            return Parameters.getCompanyTokenList.map(values: [organisation_id, category_brand_id,/skip, /take])
            
        case .getTokenPurchaseList(let skip,let  take):
            return Parameters.getTokenPurchaseList.map(values: [/skip, /take])
            
            
        case .purchaseEToken(let organisation_coupon_id, let buraq_percentage,     let bottle_returned_value    , let bottle_charge    , let quantity, let  payment_type,let  price, let eToken_quantity, let address, let  address_latitude, let address_longitude ):
            return Parameters.purchaseEToken.map(values: [organisation_coupon_id,buraq_percentage,bottle_returned_value,bottle_charge, quantity,payment_type,price, eToken_quantity,address,address_latitude,/address_longitude])
            
        case  .EtokenOrderAcceptReject( let order_id, let status):
            
            return Parameters.EtokenOrderAcceptReject.map(values: [/order_id, /status])
            
        case .packageListing, .coupons, .getCreditPoints, .panic, .bannerAndServices,.getCard,.getStripeCard,.notification,.getCoronaAreas:
            return nil
            
        case .scanQrCode(let user_id):
            return Parameters.scanQrCode.map(values: [/user_id])
            
        case .checkCoupons(let code):
            return Parameters.checkCoupons.map(values: [/code])
            
        case .halfWayStop(let orderId, let latitude, let longitude, let order_distance, let half_way_stop_reason, let payment_type):
            return Parameters.halfWayStop.map(values: [/orderId, /latitude, /longitude, /order_distance, /half_way_stop_reason, /payment_type])
            
        case .breakdownRequest(let orderId, let latitude, let longitude, let order_distance, let reason):
            return Parameters.breakdownRequest.map(values: [/orderId, /latitude, /longitude, /order_distance, /reason])
            
        case .shareRide(let shareWith, let order_id):
            return Parameters.shareRide.map(values: [shareWith, order_id])
            
        case .cancelShareRide(let order_id):
            return Parameters.cancelShareRide.map(values: [order_id])
            
        case .cancelHalfWayStop(let orderId):
            return Parameters.cancelHalfWayStop.map(values: [orderId])
            
        case .cancelVehicleBreakDown(let orderId):
            return Parameters.cancelVehicleBreakDown.map(values: [orderId])
            
        case .addStops(let orderId ,let stops, let dropOffAddress, let dropOffLatitude, let dropOffLongitude):
            return Parameters.addStops.map(values: [orderId, stops, dropOffAddress, dropOffLatitude, dropOffLongitude])
            
        case .addAddress(let address, let address_latitude, let address_longitude, let category, let address_name):
            return Parameters.addAddress.map(values: [address, address_latitude, address_longitude, category, address_name])
            
        case .editAddress(let address, let address_latitude, let address_longitude, let user_address_id, let category, let address_name):
            return Parameters.editAddress.map(values: [address, address_latitude, address_longitude, user_address_id, category, address_name])
            
        case .removeCard(let user_card_id,let paymentId):
            if paymentId != ""{
                return Parameters.removeCardWithPaymentId.map(values: [user_card_id,paymentId])
            }
            return Parameters.removeCard.map(values: [user_card_id])
            
        case .payPendingAmount(let user_card_id, let amount):
            return Parameters.payPendingAmount.map(values: [user_card_id, amount])
            
        case .editCheckList(let checkList):
            return Parameters.editCheckList.map(values: [checkList])
            
        case .removeCheckListItem(let checkList):
            return Parameters.removeCheckListItem.map(values: [checkList])
            
        case .addEpaycoCard(let card,let year,let month,let cvv, let gatewayId):
            
            return Parameters.addEpaycoCard.map(values: [card,year,month,cvv,gatewayId])
            
        case .addStripCard(let tokenId,let gatewayId):
            return Parameters.addStripCard.map(values: [tokenId,gatewayId])
            
        case .walletLogs(let skip, let limit):
            return Parameters.walletLogs.map(values: [skip, limit])
            
        case .walletTransfer(let amount, let phone_code, let phone_number):
            return Parameters.walletTransfer.map(values: [amount, phone_code, phone_number])
            
        case .addTip(let tip, let orderId, let gateway_unique_id) :
            return Parameters.addTip.map(values : [tip, orderId, gateway_unique_id])
            
        case .getWalletBalance:
            return Parameters.getWalletBalance.map(values: [])
            
        case .addCard(let card_holder_name, let card_number, let exp_year, let cvc, let gateway_unique_id, let card_brand, let exp_month):
            return Parameters.addCard.map(values: [card_holder_name, card_number, exp_year, cvc, gateway_unique_id, card_brand, exp_month])
            
        case .addWalletMoney(let amount,let cardId,let gatewayId):
            return Parameters.addWalletAmount.map(values: [amount,cardId,gatewayId])
            
        case .getChatList(let language_id, let limit, let skip):
            return Parameters.getchatList.map(values: [language_id,limit,/skip])
            
        case .pssChatListing(let language_id, let receiver_id, let limit, let skip):
            return Parameters.pssChatList.map(values: [language_id,receiver_id,limit,/skip])
        case .uploadImge: return nil
            
        case .razorPayReturnUrl(let order_id, let payment_id):
            return Parameters.razorPayReturnUrl.map(values: [/order_id, /payment_id])
            
        case .getBraintreeToken:
            return nil
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
            
        case .terminologyAPI(_),.getCard,.getStripeCard,.getWalletBalance,.pssChatListing(_),.getCoronaAreas:
            return .get
            
        default:
            return .post
        }
    }
    
    var baseURL: String {
        switch self {
        case .homeApi(_) , .terminologyAPI(_), .requestApi(_)  , .cancelRequest(_) , .onGoingRequest ,.eTokens(_) , .buyETokens(_) , .rateDriver(_), .packageListing, .scanQrCode, .addStops(_), .addAddress(_), .editAddress(_), .bannerAndServices,.editCheckList, .removeCheckListItem(_), .addTip:
            return APIBasePath.basePath + Routes.user  + Routes.SubRoute.service
            
        case .getEtokenDetail(_) , .history(_) , .orderDetails(_), .coupons, .checkCoupons(_), .shareRide(_), .cancelShareRide(_),.getChatList(_),.pssChatListing(_),.uploadImge:
            return APIBasePath.basePath + Routes.user + Routes.SubRoute.other
            
        case .getCompanyListWater(_), .getTokenList(_), .purchaseEToken(_), .getTokenPurchaseList(_), .EtokenOrderAcceptReject(_):
            return APIBasePath.basePath + Routes.user + Routes.SubRoute.water
            
        case .halfWayStop(_), .breakdownRequest(_), .cancelHalfWayStop(_), .cancelVehicleBreakDown(_):
            return APIBasePath.basePath + Routes.service + Routes.SubRoute.order
            
        case .getCreditPoints, .panic , .notification:
            return APIBasePath.basePath + Routes.user
            
        case .walletLogs(_), .walletTransfer(_), .getWalletBalance,.addWalletMoney:
            return APIBasePath.basePath + "/" + Routes.SubRoute.service
            
        default:
            return APIBasePath.basePath + Routes.commonRoutes
        }
    }
    
}
