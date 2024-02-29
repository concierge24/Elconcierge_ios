//
//  Enums.swift
//  Buraq24
//
//  Created by MANINDER on 01/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import Foundation
import GoogleMaps
//MARK:- App Data based enums


enum LanguageCode : String {
    case English = "1"
    case Hindi = "2"
    case Urdu = "3"
    case Chinese = "4"
    case Arabic = "5"
    case Spanish = "8"
    case French = "6"
}

 /* enum Template : Int {
    case Default = 0
    case Mover = 3
} */

enum AppTemplate: Int {
    case Default = 0
    case DeliverSome = 1
    case GoMove = 2
    case Mover = 3
    case Moby = 4
    case Corsa = 5
    case Delivery20 = 6
}

enum LoginSignupType: String {
    
    case Normal = "Normal"
    case PhoneNo
    case Email
    case Facebook
    case Apple
    case Gmail
    case PrivateCooperative
}

enum PaymentScreenMode : Int {
    case BookRequest = 1
    case SideMenu = 2
}

struct AllOrdersOngoing{
    
    static var ordersOngoing = [String:TrackingModel]()
    static var order : TrackingModel?
}


struct ServiceTypeCab {
    var serviceName: String
    var serviceImageSelected: UIImage
    var serviceImageUnSelected: UIImage
    var objService: Service
}

struct ServiceRequest {
    
    var latitude : Double?
    var longitude: Double?
    var locationName : String?
    var locationNickName: String?
    
    var latitudeDest : Double?
    var longitudeDest : Double?
    var locationNameDest : String?
    
    
   /* var latitudeStop1 : Double?
    var longitudeStop1 : Double?
    var locationNameStop1 : String?
    
    var latitudeStop2 : Double?
    var longitudeStop2 : Double?
    var locationNameStop2 : String? */
    
    var serviceSelected : Service?
    var selectedBrand : Brand?
    var selectedProduct :  ProductCab?
    var quantity  = 0
    var distance : Float = 0
    var duration : Float = 0
    var productName : String?
    var orderDateTime : Date = Date()
    var paymentMode : PaymentType = .Cash
    var selectedCard: CardCab?
    var finalPrice : String?
    var requestType : BookingType = .Present
    var eToken : ETokenPurchased?
    
    var materialType : String?
    var weight : Double?
    var additionalInfo : String?
    var orderImages : [UIImage] = [UIImage]()
    
    var pickupPersonName : String?
    var pickupPersonPhone : String?
    var invoiceNumber : String?
    var deliveryPersonName : String?
    var elevator_pickup: String?
    var elevator_dropoff: String?
    var pickup_level: String?
    var dropoff_level: String?
    var fragile: String?
    var description: String?
    var check_lists: [[String: String]]?
    
   // var isBookingFromPackage: Bool?
    
    // Package
    var distance_price_fixed: String?
    var price_per_min: String?
    var time_fixed_price: String?
    var price_per_km: String?
    
    // Book for friend
    var booking_type: String?
    var friend_name: String?
    var friend_phone_number: String?
    var friend_phone_code: String?
    
    
    // RoadPickup
    var category_brand_id : Int?
    var category_id : Int?
    var category_brand_product_id: Int?
    var driver_id : Int?
    
    //Promo
    var coupon_id: Int?
    var coupon_code:String?
    var cancellation_charges: Float?
    
    lazy var stops = [Stops]()
    var credit_point_used: String?
    var levelPercentage: Int?
    var gender: String?
    var numberOfRiders: String?
    var isPool:Bool?

}

enum ScrollDirection {
    case Top
    case Right
    case Bottom
    case Left
    
    func contentOffsetWith(scrollView: UIScrollView) -> CGPoint {
        var contentOffset = CGPoint.zero
        switch self {
        case .Top:
            contentOffset = CGPoint(x: 0, y: -scrollView.contentInset.top)
        case .Right:
            contentOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
        case .Bottom:
            contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        case .Left:
            contentOffset = CGPoint(x: -scrollView.contentInset.left, y: 0)
        }
        return contentOffset
    }
}


enum MoveType  : Int {
    case Forward  = 1
    case Backward = 0
}

enum ServicePopUp  : Int {
    case Gas  = 1
    case WaterTanker = 2
}

enum ActionType : Int {
    case SelectLocation  = 0
    case Capacity  = 1
    case Quantity = 2
    case NextGasType = 3
    case Payment = 4
    case SubmitOrder = 5
    case CancelOrderOnSearch = 6
    case CancelTrackingOrder = 7
    case DoneInvoice = 8
    case SubmitRating = 9
    case BackFromFreightBrand = 10
    case BackFromFreightProduct = 11
    case CancelHalfwayStop = 12
    case CancelVehiclebreakdown = 13
    
    case SelectingFreightBrand
}

struct MovingVehicle {
    var driver : HomeDriver
    var driverMarker : GMSMarker
}


enum LocationEditing : Int {
    
    case PickUp = 0
    case DropOff = 1
    
}

enum ReasonPopuptype {
    
    case cancel
    case halfStop
}


enum MapMode  {
    case ZeroMode
    case NormalMode
    case SelectingLocationMode
    case OrderDetail
    case ScheduleMode
    case OrderPricingMode
   // case ConfirmPickup
    case UnderProcessingMode
    case RequestAcceptedMode
    case OnTrackMode
    case ServiceDoneMode
    case ServiceFeedBackMode
    case SelectingFreightBrand
    case SelectingFreightProduct
    
}

struct ScreenType {
    
    var mapMode : MapMode = .ZeroMode
    var entryType : MoveType = .Forward
}

enum SideMenuOptions:String {
    
  /*  case Bookings = "bookings"
    case ETokens = "E-Tokens"
    case Promotions = "promotions"
    case Payments = "payments"
    case Referral = "referral"
    case EmergencyContacts = "emergency_contacts"
    case Settings = "settings"
    case Contactus = "contact_us"
    case SignOut = "sign_out" */
    
    case BookTaxi = "SideMenu.Book_a_taxi"
    case PackageDelivery = "SideMenu.New_Services_Coming_soon"
   // case SchoolRides = "SideMenu.School_Rides"
    case Home = "SideMenu.Home"
    case MyBookings = "SideMenu.My_Bookings"
    case Payments = "SideMenu.Payment_Methods"
    case Packages = "SideMenu.Travel_Packages"
    case EmergencyContact = "SideMenu.Emergency_Contacts"
    case Notifications = "SideMenu.Notifications"
    case Settings = "SideMenu.Settings"
    case Help = "SideMenu.Help"
    case PaymentHistory = "SideMenu.Payment_History"
    case SavedCard = "SideMenu.Saved_Cards"
    case DeliveryHistory = "SideMenu.Delivery_History"
    case Promotions = "SideMenu.Promotions"
    case Contactus = "SideMenu.Contact_us"
    case SignOut = "SideMenu.Sign_out"
    case BookAService = "SideMenu.Book_service"
    case EditProfile = "SideMenu.Edit_Profile"
    case getDiscount = "SideMenu.Get_Discount"
    case deliverWithUs = "SideMenu.Deliver_with_us"
    case wallet = "SideMenu.Wallet"
    case referral = "SideMenu.Refer_Earn"



    func localString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

internal struct Languages {
    static let Arabic = "ar"
    static let English = "en"
    static let Urdu = "ur"
    static let Hindi = "hi"
    static let Chinese = "zh-Hans"
    static let Spanish = "es"
    static let French = "fr"
    static let Dutch = "nl"
    static let Japnesse = "ja"
    static let German = "de"
    static let Italian = "it"
    static let Albanian = "sq"
}

enum DefaultColor: String {
    case color = "#000000"
}

enum DefaultCountry : String {
    case ISO = "USA"
    case countryCode = "+1"
}

enum PaymentType : String {
    case Cash = "Cash"
    case Card = "Card"
    case EToken = "eToken"
    case Wallet = "Wallet"
}

enum PaymentGateway:String{
    
    case stripe = "stripe"
    case epayco = "epayco"
    case paystack = "paystack"
    case peach = "peach"
    case payku = "payku"
    case conekta = "conekta"
    case razorpay = "razorpay"
    case braintree = "braintree"
    
}

enum BookingType : String {
    case Present = "0"
    case Future = "1"
}

enum NumberType:String {
    case Old = "Old"
    case New = "New"
}

enum UserType : Int {
    case Customer = 1
    case Driver = 2
    case SupportProvider = 3
}

enum UserOnlineStatus : String {
    case Online = "1"
    case Offline = "0"
}

enum LocationsCab : Double {
    
    case lat
    case longitude
    
    func getLoc () -> Double {
        
        switch self {
        case .lat:
            return LocationManagerCab.shared.latitude
        case .longitude :
            return LocationManagerCab.shared.longitude
        }
    }
}

enum PaymentStatus : String {
    case Pending = "Pending"
    case Paid = "Paid"
}

enum OrderStatus: String {
    
    case Searching = "Searching"
    case Ongoing = "Ongoing"
    case Confirmed = "Confirmed"
    case reached = "Onreached"
    case CustomerCancel = "CustCancel"
    case ServiceComplete = "SerComplete"
    case SerHalfWayStop = "SerHalfWayStop"
    case ServiceTimeout = "SerTimeout"
    case ServiceReject = "SerReject"
    case DriverCancel = "DriverCancel"
    case Scheduled = "Scheduled"
    case DriverApprovalPending = "DPending"
    case DriverApproval = "DApproved"
    case DriverSchCancelled = "DSchCancelled"
    case DriverSchTimeOut = "DSchTimeout"
    case SystyemSchCancelled = "SysSchCancelled"
    case ServiceBreakdown = "SerBreakdown"
   
    case SerHalfWayStopRejected = "SerHalfWayStopRejected"
    
    // User Current Ride ongoing but schedule cancelled
    case  etokenSerCustCancel = "SerCustCancel"
    case etokenTimeOut = "CTimeout"
    case etokenCustomerPending = "SerCustPending"
    case etokenCustomerConfirm = "SerCustConfirm"
    case Pending = "Pending"
    
//    case reached = "Reached"

}

//MARK:- Socket Enums
enum SocketEvents : String {
    
    case OrderEvent = "OrderEvent"
    case CommonEvent = "CommonEvent"
    
}

enum BuraqMapType : String {
    
    case Satellite = "Satellite"
    case Hybrid = "Hybrid"
}

enum CommonEventType : String {
    
    case CustomerHomeMap = "CustHomeMap"
    case CustomerOrderTrack = "CCurrentOrders"
    case ParticularOrder = "CustSingleOrder"
}

enum EmitterParams : String {
    
    case EmitterType = "type"
    case AccessToken = "access_token"
    case Latitude = "latitude"
    case Longitude = "longitude"
    case Distance = "distance"
    case CategoryId = "category_id"
    case OrderToken = "order_token"
}

enum OrderEventType : String {
    
    case serReached = "OnReached"
    case ServiceAccepted = "SerAccept"
    case DriverRatedCustomer = "DriverRatedService"
    case ServiceRejectedByAllDriver = "SerReject"
    case ServiceCompletedByDriver = "SerComplete"
    case ServiceBreakdown = "SerBreakdown"
    case ServiceBreakDownAccepted = "SerBreakDownAccepted"
    case ServiceBreakDownRejected = "SerBreakDownRejected"
    case ServiceTimeOut = "SerTimeout"
    case ServiceCurrentOrder = "CurrentOrders"
    case ServiceOngoing = "Ongoing"
    case DriverCancelrequest = "DriverCancel"
    case SerHalfWayStopRejected = "SerHalfWayStopRejected"
    case SerLongDistance = "SerLongDistance"
    
    case EtokenConfirmed = "Confirmed"
    case EtokenStart = "eTokenSerStart"
    case EtokenSerCustPending = "SerCustPending"
    case EtokenCTimeout = "CTimeout"
    case CardAdded = "cardAdded"
    case SerCheckList = "SerCheckList"
    case Pending = "Pending"
    case DApproved = "DApproved"
}
