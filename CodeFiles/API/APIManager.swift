//
//  APIManager.swift
//  Clikat
//
//  Created by cbl73 on 4/22/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AFNetworking
import EZSwiftExtensions
import NVActivityIndicatorView
import ObjectMapper

typealias APICompletion = (APIResponse) -> ()

class APIManager {
    
    static let sharedInstance = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 40,height: 40), type: .ballPulseSync, color: UIColor.white, padding: 4)
    let overLayView = UIView(frame: UIScreen.main.bounds)
    
    func opertationWithRequest(refreshControl : UIRefreshControl? = nil, isLoader: Bool = false, withApi api : API , completion : @escaping APICompletion )  {
        
        if !Alamofire.NetworkReachabilityManager()!.isReachable {
            SKToast.makeToast(L10n.PleaseCheckYourInternetConnection.string)
            //refreshControl?.endRefreshing()
            return
        }
        
        if isLoader ? isLoader : isLoaderNeeded(api: api){
            showLoader()
        }
        
        httpClient.postRequest(refreshControl: refreshControl, withApi: api, success: {
            [weak self] (data) in
            guard let self = self else { return }
            
            if isLoader ? isLoader : self.isLoaderNeeded(api: api){
                self.hideLoader()
            }
            //             if self.isLoaderNeeded(api){
            
            //            }
            guard let response = data else {
                completion(APIResponse.Failure(.None))
                return
            }
            
            let json = JSON(response)
            
            print("<<<<<<=========== Result ===========")
            print(json)
            
            var statusKey = APIConstants.Status
            var statusCode = ""
            var message = /json.dictionaryValue[APIConstants.message]?.stringValue
            
            switch api {
                
                
                
                
            case .getBotResponce:
                statusKey = APIConstants.Status
                let result = BotResponce(attributes: json.dictionaryValue)
                statusCode = result.error?.code == nil ? "200" : "\(/result.error?.code)"
                message = /result.error?.errorDetails
                
            case .ServiceAgentlist, .getAgentAvailabilties, .getAgentAvailabilty, .getSlotAvailabilties, .verifySlot(_):
                statusKey =  APIConstants.statusCode
                statusCode = /(json.dictionaryValue[statusKey]?.stringValue)
                
            case .getSecretKey:
                statusKey = APIConstants.statusCode
                statusCode = /(json.dictionaryValue[statusKey]?.stringValue)
                
            default:
                statusKey = APIConstants.Status
                statusCode = /(json.dictionaryValue[statusKey]?.stringValue)
            }
            
            let responseType  = APIValidation(rawValue: statusCode) ?? .None
            
            if responseType == APIValidation.Success || responseType == APIValidation.Terms {
                
                var object : Any?
                switch api{
                case .getBraintreeToken:
                    let tokenData = json["data"].dictionaryValue
                    let clientToken = tokenData["client_token"]?.stringValue
                    object = clientToken
                    
                case .getReferalAmount:
                    let referData = json["data"].dictionaryValue
                    let referalAmount = referData["referalAmount"]?.floatValue
                    GDataSingleton.sharedInstance.referalAmount = referalAmount
                    object = referalAmount
                    
                case .myReferals:
                    let result = ReferalData(sender: json.dictionaryValue)
                    object = result.arrayItems
                    
                case .getBotResponce:
                    let result = BotResponce(attributes: json.dictionaryValue)
                    object = result.result
                    
                case .getRestorentList :
                    let home = HomeSuppliers(sender: json.dictionaryValue)
                    object = home.arrayItems
                    
                case .getProductList(_) :
                    let home = MenuProductSection(sender: json.dictionaryValue)
                    object = home
                    
                case .getPopularProducts:
                    let home = PopularProductsList(sender: json.dictionaryValue)
                    object = home
                    
                case .GetSettings(_) :
                    let getSettings = Mapper<ApiSucessData<AppSettings>>().map(JSONObject: response)?.object
                    //let getSettings = AppSettings(sender: json.dictionaryValue)
                    object = getSettings
                    GDataSingleton.sharedInstance.appSettingsData = getSettings
                case .getQuestions(_):
                    object = Mapper<ApiSucessData<QuestionList>>().map(JSONObject: response)?.object
                case .requestList(_):
                    object = Mapper<ApiSucessData<RequestList>>().map(JSONObject: response)?.object
                case .searchTag(_):
                    object = TagList(sender: json.dictionaryValue)
                case .searchSupplierTags(_):
                    object = TagSuppliers(sender: json.dictionaryValue)
                case .offers(_) :
                    let home = Home(sender: json.dictionaryValue)
                    object = home
                    GDataSingleton.sharedInstance.homeData?.arrayOffersAR = home.arrayOffersAR
                    GDataSingleton.sharedInstance.homeData?.arrayOffersEN = home.arrayOffersEN
                    
                    GDataSingleton.sharedInstance.homeData?.arrayRecommendedAR = home.arrayRecommendedAR
                    GDataSingleton.sharedInstance.homeData?.arrayRecommendedEN = home.arrayRecommendedEN
                    let newHome = GDataSingleton.sharedInstance.homeData
                    GDataSingleton.sharedInstance.homeData = newHome
                    
                case .Home(_) :
                    let home = Home(sender: json.dictionaryValue)
                    object = home
                    GDataSingleton.sharedInstance.homeData = home
                case .Register(_) :
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .RegisterSingleStep(_) :
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                
                case .Login(_) :
                    let user = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                    object = user
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                    
                case .SendOTP(_):
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                    
                case .CheckOTP(_):
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .SupplierListing(_):
                    object = SupplierListing(attributes: json.dictionaryValue,key: SupplierKeys.supplierList.rawValue)
                case .SupplierInfo(_):
                    object = Supplier(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .MarkSupplierFav(_):
                    print("Marked Successfully")
                case .SubCategoryListing(_):
                    object = SubCategoriesListing(attributes: json.dictionaryValue)
                case .ProductListing(_):
                    object = ProductListing(attributes: json.dictionaryValue)
                case .ProductDetail(_):
                    object = ProductF(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .MultiSearch(_):
                    object = SearchResult(attributes: json.dictionaryValue)
                case .LocationList(_, type: _):
                    object = Results1(sender: json.dictionaryValue)
                //  object = LocationResults(data: json[APIConstants.DataKey].dictionaryValue)
                case .ResendOTP(_):
                    break
                case .Addresses(_):
                    object = Delivery(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .EditAddress(_):
                    object = Address(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .PackageSupplierListing(_):
                    object = SupplierListing(attributes: json.dictionaryValue,key: APIConstants.listKey)
                case .PackageProductListing(_):
                    object = PackageProductListing(attributes: json[APIConstants.DataKey].dictionaryValue ,key:  APIConstants.listKey)
                case .AddToCart(_):
                    object = UtilityFunctions.appendOptionalStrings(withArray: [json[APIConstants.DataKey]["cartId"].stringValue,json[APIConstants.DataKey]["min_order"].stringValue], separatorString: "$")
                case .LoyalityPointScreen(_):
                    object = LoyalityPointsListing(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .MyFavorites(_):
                    object = SupplierListing(attributes: json.dictionaryValue,key: SupplierKeys.favorites.rawValue)
                case .OrderHistory(_):
                    object = OrderListing(attributes: json[APIConstants.DataKey].dictionaryValue, key: OrderRelatedKeys.orderHistory.rawValue)
                case .OrderUpcoming(_),.ScheduledOrders(_):
                    object = OrderListing(attributes: json[APIConstants.DataKey].dictionaryValue, key: OrderRelatedKeys.orderHistory.rawValue)
                case .OrderTrackingList(_),.RateOrderListing(_):
                    object = OrderListing(attributes: json[APIConstants.DataKey].dictionaryValue, key: OrderRelatedKeys.orderList.rawValue)
                case .AddNewAddress(_):
                    object = Address(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .GenerateOrder(_):
                    object = json[APIConstants.DataKey].arrayObject
                    
                case .BarCodeSearch(_):
                    object = BarCodeProductListing(attributes: json[APIConstants.DataKey].dictionaryValue, key: APIConstants.listKey)
                case .PromotionProducts(_):
                    object = PromotionListing(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .LaundryServices(_):
                    object = LaundryServices(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .AllNotifications(_):
                    object = NotificationListing(attributes : json[APIConstants.DataKey].dictionaryValue)
                case .OrderTrack(_):
                    object = json[APIConstants.DataKey]["msg"].stringValue
                case .LoginFacebook(_):
                    let user = User(attributes: json[APIConstants.DataKey].dictionaryValue,params: api.parameters)
                    object = user
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                case .LaundryProductListing(_):
                    object = LaundryProductListing(attributes: json.dictionaryValue)
                case .ViewAllOffers(_):
                    object = OfferListing(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .SupplierImage(_):
                    object = json[APIConstants.DataKey]["image"].stringValue + " " + json[APIConstants.DataKey][SupplierKeys.supplier_id.rawValue].stringValue
                case .OrderDetails(_):
                    object = OrderDetails(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .CompareProducts(_):
                    object = CompareProductListing(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .CompareProductResult(_):
                    object = CompareProductResult(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .LaundrySupplierList(_):
                    object = SupplierListing(attributes: json.dictionaryValue,key: SupplierKeys.supplierList.rawValue)
                case .ScheduleNewOrder(_):
                    object = json.stringValue
                case .OrderDetail(_):
                    //  let home = Home(sender: json.dictionaryValue)
                    let order =  OrderHistory(sender: json.dictionaryValue)
                    object = order
                //                    object = OrderDetails(attributes: json[APIConstants.DataKey]["orderHistory"].arrayValue.first?.dictionaryValue)
                case .TotalPendingSchedule(_):
                    object = UtilityFunctions.appendOptionalStrings(withArray:[json[APIConstants.DataKey]["pendingOrder"].stringValue,json[APIConstants.DataKey]["scheduleOrders"].stringValue],separatorString: "$$")
                case .ProductVariantList(_):
                    let variant = Variant(fromJson: json)
                    object = variant
                    break
                case .ProductFilteration(_):
                    object =  filteredProducts(attributes: json.dictionaryValue,key: APIConstants.DataKey)
                case .VariantProductDetail(_):
                    object = ProductVariant(fromDictionary:  json.dictionaryObject ?? ["" : (Any).self])
                case .GetArea(_):
                    let array = json[APIConstants.DataKey].arrayValue
                    object = GetArea(data: array.first?.dictionaryValue)
                case .CheckPromo(_):
                    object = PromoCode(attributes: json[APIConstants.DataKey].dictionaryValue)
                    
                case .GetAgentDBKeys:
                    let agentDBSecretKey = AgentDBSecretKey(sender: json.dictionaryValue)
                    object = agentDBSecretKey
                    GDataSingleton.sharedInstance.agentDBSecretKey = agentDBSecretKey
                    
                case .ServiceAgentlist(_):
                    object = AgentListing(sender: json.dictionaryValue)
                    
                case .getAgentAvailabilties, .getSlotAvailabilties:
                    object = AgentSlotListing(sender: json.dictionaryValue)
                case .getAgentAvailabilty:
                    object = AvailabilityModel(sender: json.dictionaryValue)
                    
                case .listAllFav:
                    object =  FavProducts(attributes: json.dictionaryValue).products
                    
                case .makeProductFav:
                    break
                    
                case .checkProductList:
                    object = CheckProductList(attributes: json.dictionaryValue)
                //Nitin
                case .getSecretKey:
                    let agentDBSecretKey  = AgentCode(attributes: json.dictionaryValue)
                    var agentSettingData: Any?
                    var agentData :Any?
                    var agentCurrencyData : Any?
                    
                    if let value = agentDBSecretKey.data?.data?.first {
                        agentData = value
                        AgentCodeClass.shared.loggedAgent = agentData as? AgentCodeData
                    }
                    if let currency = agentDBSecretKey.data?.currency?.first {
                        agentCurrencyData = currency
                        AgentCodeClass.shared.loggedCurrency = agentCurrencyData as? CurrencyData
                    }
                    if let featureData = agentDBSecretKey.data?.featureData {
                        AgentCodeClass.shared.agentFeatureData = featureData
                    }
                    if let settingInfo = agentDBSecretKey.data?.settingsData {
                        
                        agentSettingData = settingInfo
                        AgentCodeClass.shared.settingData = agentSettingData as? SettingsData
                    }
                    let dict = ["agentData":agentData, "currency": agentCurrencyData, "settingData": agentSettingData ]
                    object = dict
                    //Nitin
                    //case .rentalFilternation:
                //   break
                case .rentalFilternation:
                    object = RentalFilterData(attributes: json.dictionaryValue, key: APIConstants.DataKey)
                    
                case .appleSignin:
                    object = User(attributes:json[APIConstants.DataKey].dictionaryValue)
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                    
                case .getTermsAndConditions:
                    object = TermsResponse(sender: json.dictionaryValue)
                    
                case .addCard(_):
                    object = AddCard(attributes: json[APIConstants.DataKey].dictionaryValue)
                    
                case .getCards(_):
                    object = CardListing(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .geofenceTax(_):
                    object = GeofenceTaxData(attributes: json[APIConstants.DataKey].dictionaryValue)
                case .getSadadPaymentUrl(_):
                    object = SadadPaymentdata(attributes: json[APIConstants.DataKey].dictionaryValue)

                case .getMyFatoorahPaymentUrl(_):
                    object = MyFatoorahPaymentdata(attributes: json[APIConstants.DataKey].dictionaryValue)

                case .getPaystackAccessCode:
                    object = PayStackData(attributes:json[APIConstants.DataKey].dictionaryValue)
                case .RegisterLastStep(_):
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                    (object as? User)?.otpVerified = "1"
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                default:
                    object = json.stringValue
                }
                
                completion(APIResponse.Success(object))
                return
            }
            else if responseType == .InvalidAccessToken {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,let window = appDelegate.window else { return }
                GDataSingleton.sharedInstance.loggedInUser = nil
                UtilityFunctions.showAlert(title: nil, message: L10n.SessionExpiredLoginToContinue.string, success: {
                    appDelegate.switchViewControllers()
                    //let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
                    //window.rootViewController = navigationVc
                    
                    //                    let homeVC =  /GDataSingleton.sharedInstance.app_type == 5 ? StoryboardScene.Main.instantiateHomeViewController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
                    //                    window.rootViewController?.sideMenuController()?.setContentViewController(homeVC)
                    //                    window.rootViewController?.toggleSideMenuView()
                }, cancel: {
                    appDelegate.switchViewControllers()
                    //let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
                    //window.rootViewController = navigationVc
                    
                    //                    let homeVC =  /GDataSingleton.sharedInstance.app_type == 1 ? StoryboardScene.Main.instantiateHomeViewController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
                    //                    window.rootViewController?.sideMenuController()?.setContentViewController(homeVC)
                    //                    window.rootViewController?.toggleSideMenuView()
                    
                })
            }
            else if responseType == .ParameterMissing {
                if self.isAlertNeeded(api: api){
                    SKToast.makeToast(message)
                }
            }
            else if responseType == .ApiError {
                
                if self.isAlertNeeded(api: api) {
                    SKToast.makeToast(message)
                }
            }else if responseType == .Validation {
                if self.isAlertNeeded(api: api) {
                    SKToast.makeToast(message)
                }
            }
            else if responseType == .Delivery {
                UtilityFunctions.showSweetAlert(title: L10n.Warning.string, message: message, success: {}, cancel: {})
            }
            completion(APIResponse.Failure(responseType))
            
            }, failure: {
                [weak self] (message) in
                guard let self = self else { return }
                //                UtilityFunctions.stopLoader()
                if isLoader ? isLoader : self.isLoaderNeeded(api: api){
                    self.hideLoader()
                }
                //                if self.isAlertNeeded(api){
                //                    SKToast.makeToast(L10n.SomewhereSomehowSomethingWentWrong.string)
                //                }
                completion(APIResponse.Failure(.None))
        })
    }
    
    
    func opertationWithRequest ( withApi api : API,image : UIImage? , completion : @escaping APICompletion )  {
        
        if isLoaderNeeded(api: api){
            showLoader()
        }        
        
        httpClient.postRequest(withApi: api, image: image, success: { (data) in
            self.hideLoader()
            guard let response = data else {
                completion(APIResponse.Failure(.None))
                return
            }
            
            let json = JSON(response)
            let responseType  = APIValidation(rawValue: (json.dictionaryValue[APIConstants.Status]?.stringValue) ?? "") ?? .None
            if responseType == APIValidation.Success {
                var object : Any?
                
                switch api {
                case .RegisterLastStep(_):
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                    (object as? User)?.otpVerified = "1"
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                    
                case .CheckOTP(_):
                    object = User(attributes: json[APIConstants.DataKey].dictionaryValue)
                    GDataSingleton.sharedInstance.loggedInUser = object as? User
                    
                case .ChangeProfile(_):
                    object = json[APIConstants.DataKey]["image"].stringValue
                    
                case .UploadReceipt(_):
                    object = json[APIConstants.DataKey].string
                default:
                    break
                }
                completion(APIResponse.Success(object))
                return
            }
            completion(APIResponse.Failure(responseType))
        }) { (message) in
            
            
            self.hideLoader()
            
            completion(APIResponse.Failure(.None))
        }
    }
    
    
    func isAlertNeeded(api : API) -> Bool{
        switch api {
        case .SupplierImage(_):
            return false
        default :
            return true
        }
    }
    
    
    
    func isLoaderNeeded(api : API) -> Bool{
        switch api {
        //Login Flow
        case .Register(_), .Login(_), .SendOTP(_),.CheckOTP(_),.RegisterLastStep(_),.ChangeProfile(_),.LoginFacebook(_), .UploadReceipt(_), .RegisterSingleStep(_), .verifySlot(_), .uploadPrescription(_):
            return true
        //Cart Flow // .AddToCart(_), .GenerateOrder(_),.UpdateCartInfo(_),
        case .BarCodeSearch(_):
            return true
        //Package Flow
        case .PackageProductListing(_),.PackageSupplierListing(_),.LaundryProductListing(_),.LaundrySupplierList(_):
            return true
        // GenericFlow
        case .SupplierListing(_),.SupplierInfo(_),.SubCategoryListing(_),.ProductListing(_),.ProductDetail(_),.MultiSearch(_):
            return true
        //Location Related
        case .CompareProducts(_),.CompareProductResult(_),.ViewAllOffers(_),.ScheduleNewOrder(_),.RateOrderListing(_),.ClearAllNotifications(_),.AllNotifications(_):
            return true
        //Side Panel
        case .LoyalityPointScreen(_),.MyFavorites(_),.OrderHistory(_),.OrderUpcoming(_),.OrderTrackingList(_),.PromotionProducts(_),.ScheduledOrders(_),.LoyaltyPointsOrder(_),.OrderDetail(_):
            return true
        case .Home(_):
            return GDataSingleton.sharedInstance.homeData == nil ? false : false
        case .RateProduct(_):
            return true
        case .ProductVariantList(_),.ProductFilteration:
            return true
        case .GetAgentDBKeys, .ServiceAgentlist(_):
            return true
            
        //Nitin
        case .rentalFilternation(_) : return true
            
        case .AddNewAddress(_), .EditAddress(_) : return true
            // case .getProductList(_) : return false
            
        case .deleteCard(_) : return true

        default:
            return false
        }
    }
    
    func showLoader() {        UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.startAnimating(CGSize(width: 40,height: 40), message: L10n.Loading.string, type: .lineScalePulseOut, color: UIColor.white)
    }
    
    func hideLoader(){
        UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.stopAnimating()
    }
    
}
