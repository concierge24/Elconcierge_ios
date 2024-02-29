

import Foundation
import SwiftyJSON
import ObjectMapper

enum ResponseKeys : String {
    case user = "profile"
    case countries = "countries"
    case data = "data"
    case count = "count"
    case stats = "stats"
    case messages = "messages"
    case cardId = "card_id"
    case flag = "flag"
    case msg = "msg"
    case cuisines = "cuisines"
    case userPost = "userPost"
    case billingAddress = "billingAddress"
    case serviceId = "serviceId"
    case serviceMakId = "serviceMakId"
    case usersAddress = "usersAddress"
    case multipleAddress = "multipleAddress"
}

extension LoginEndpoint {
    
    func handle(parameters : JSON) -> Any? {
        
        switch self {
        case .sendOtp(_), .privateCooperationRegForum(_):
            let obj = Mapper<ApiSucessDataCab<SendOtp>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .verifyOTP(_), .socailLogin(_), .emailLogin(_) :
            let obj = Mapper<ApiSucessDataCab<LoginDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .addName(_) :
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
        case .eContacts,.userEmergencyContact :
            let obj = Mapper<ApiSucessDataCab<EmergencyContact>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.array
        case .logOut , . contactUs(_) :
            return "Success"
        case .updateData(_):
            let obj = Mapper<ApiSucessDataCab<HomeCab>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
        case .editProfile(_):
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
        case .updateNotifications(_):
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .appSetting:
            let obj = Mapper<ApiSucessDataCab<AppSettingModel>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .checkuserExists:
            let obj = Mapper<ApiSucessDataCab<CheckUserExistModel>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .privateCooperationListing:
            let obj = Mapper<ApiSucessDataCab<InstitutionsModel>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.array
            
        case .addEmergencyContact(_):
            
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
                       return obj
        case .removeEmergencyContact(_):
            
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
                       return obj
        }
    }
}
    
    

extension BookServiceEndPoint {
    
    func handle(parameters : JSON) -> Any? {
        let dictObj = parameters.dictionaryObject
        switch self {
            
        case .getBraintreeToken:
            let obj = Mapper<BraintreeModel>().map(JSONObject: dictObj)
            return obj
            
        case .getCoronaAreas:
            let obj = Mapper<CoronaAreas>().map(JSONObject: dictObj)
            return obj
            
        case .homeApi(_):
            
            let obj = Mapper<ApiSucessDataCab<HomeCab>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .terminologyAPI(_):
            
            let obj = Mapper<ApiSucessDataCab<AppTerminologyModel>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .requestApi(_):
            
            let obj = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .cancelRequest(_), .addTip(_):
            
            return "Success"
            
        case .onGoingRequest:
            
            let obj = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .rateDriver(_) , .buyETokens(_), .cancelShareRide(_):
            return "Success"
            
        case .eTokens(_):
            
            let obj = Mapper<ApiSucessDataCab<EToken>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .getEtokenDetail(_) :
            
            let obj = Mapper<ApiSucessDataCab<EToken>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .history(_), .addStops(_) :
            
            let obj = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: dictObj)
            return obj?.array
            
        case .orderDetails(_) :
            
            let obj = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: dictObj)
            return obj?.object
            
            
        case .walletLogs(_):
            let obj = Mapper<ApiSucessDataCab<WalletModel>>().map(JSONObject: dictObj)
            return obj?.array
            
        case .getCompanyListWater(_):
            
            let obj = Mapper<ApiSucessDataCab<companies>>().map(JSONObject: dictObj)
            return  obj?.array
            
        case .getTokenList(_):
            
            let obj = Mapper<ApiSucessDataCab<CompanyTokenListing>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .getTokenPurchaseList(_):
            
            let obj = Mapper<ApiSucessDataCab<PurchasedTokens>>().map(JSONObject: dictObj)
            return obj?.array
            
        case .purchaseEToken(_):
            
            return dictObj
            
        case .EtokenOrderAcceptReject(_):
            
            return dictObj
            
        case .packageListing:
            let obj = Mapper<ApiSucessDataCab<TravelPackages>>().map(JSONObject: dictObj)
            return obj?.array
            
        case .scanQrCode(_):
            let obj = Mapper<ApiSucessDataCab<RoadPickupModal>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .coupons:
            let obj = Mapper<ApiSucessDataCab<PromoCouponsModal>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .checkCoupons(_):
            let obj = Mapper<ApiSucessDataCab<Coupon>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .halfWayStop(_), .breakdownRequest(_), .panic:
            return dictObj
            
        case .shareRide(_), .cancelHalfWayStop(_), .cancelVehicleBreakDown(_):
            let obj = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .getCreditPoints:
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .addAddress(_), .editAddress(_):
            let obj = Mapper<ApiSucessDataCab<AddressCab>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .bannerAndServices:
            let obj = Mapper<ApiSucessDataCab<BannerServicesModal>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .addCard:
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .addStripCard(_),.addEpaycoCard(_):
            let obj = Mapper<ApiSucessDataCab<UserDetail>>().map(JSONObject: parameters.dictionaryObject)
            return obj?.object
            
        case .getCard:
            let obj = Mapper<CardResponse>().map(JSONObject: parameters.dictionaryObject)
            return obj
            
        case .getStripeCard:
            let obj = Mapper<CardResponse>().map(JSONObject: parameters.dictionaryObject)
            return obj
            
        case .notification:
            let obj = Mapper<NotificationModel>().map(JSONObject: dictObj)
            return obj
            
            
        case .editCheckList:
            return "Success"
            
        case .getWalletBalance:
            let obj =  Mapper<ApiSucessDataCab<WalletDetails>>().map(JSONObject: dictObj)
            return obj?.object
        case .addWalletMoney:
            let obj =  Mapper<ApiSucessDataCab<AddWallet>>().map(JSONObject: dictObj)
            return obj?.object
            
        case .getChatList(_):
            let obj = Mapper<ApiSucessDataCab<UserList>>().map(JSONObject: dictObj)
            return obj?.array
        case .pssChatListing(_):
            let obj = Mapper<ApiSucessDataCab<Chat>>().map(JSONObject: dictObj)
            return obj?.array
            
        case .uploadImge:
            let obj = Mapper<ApiSucessDataCab<imgeUpload>>().map(JSONObject: dictObj)
            return obj?.object
            
            
        default:
            return dictObj
            
        }
    }
}

func saveJSON(json: JSON, key:String){
    let jsonString = json.rawString()!
    UserDefaults.standard.setValue(jsonString, forKey: key)
    UserDefaults.standard.synchronize()
}


public func loadJSON(key: String) -> JSON {
    let defaults = UserDefaults.standard
    return JSON.init(parseJSON: defaults.value(forKey: key) as? String ?? "")
    // JSON from string must be initialized using .parse()
}
