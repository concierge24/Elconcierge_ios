//
//  OrderDetails.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions
import ObjectMapper

enum OrderDateFormat : String {
    case From = "yyyy-MM-dd HH:mm:ss"
    case To = "MMM dd EEE hh:mm a"
    case ToLine = "MMM dd EEE\n hh:mm a"
}

 //   For Ecom, Home and Food Respectively
//    1 - Approved / Confirmed / Confirmed          //.Confirmed
//    11 - Placed / OnTheWay / InTheKitchen         //.inTheKitchan
//    10 - Shipped / Reached / NA                   //.Reached
//    3 - OutForDelivery / Started / ReadyToBePicked //.Shipped
//    5 - Delivered / Ended / Delivered             //.Delivered

enum OrderDeliveryStatus : String {
    
    case Pending = "0" // == placed
    case Confirmed = "1" // == approved
    case Rejected = "2" // Red - History
    case inTheKitchan = "11" //InProcess || in Kitchan
    case Shipped = "3" // Yellow //Ship || on the way
    
    case Reached = "10" // == ready to be picked
//    case Start = "13" //For home Only
    case Delivered = "5" // Green - History
    
    case CustomerCancel = "8" // Red - History
    case Tracked = "7" // Yellow - Track
    case Schedule = "9" // - Upcoming
    case FeedbackGiven = "6"
    
    case Nearby = "4" // Yellow

    // for pickup
    // 0, 1, 11, 3,10,5
    func color() -> UIColor {
        switch self {
        case .Delivered :
            return Colors.GreenColor.color()
        
        case .CustomerCancel:
            return Colors.RedColor.color()
            
        case .Rejected :
            return Colors.RedColor.color()
            
        case .Tracked , .Shipped , .Nearby, .Reached, .inTheKitchan :
            return Colors.YellowColor.color()
        
        default:
            return LabelThemeColor.shared.lblThemeColor
        }
    }
    
    func stringValue (deliveryType: DeliveryType, appType: SKAppType?) -> String {
        return AppSettings.shared.appThemeData?.terminology?.localizedStatus(status: self, deliveryType: deliveryType, appType: appType ?? SKAppType.type) ?? ""
    }
    
    var canTrack: Bool {
        if SKAppType.type == .food {
            return isDelivered || [OrderDeliveryStatus.CustomerCancel, .Rejected, .Confirmed, .Pending, .inTheKitchan].contains(self)
        }
        //Track button hidden for these conditions
        return isDelivered || [OrderDeliveryStatus.CustomerCancel, .Rejected, .Confirmed, .Pending].contains(self)
    }
    
    var isDelivered: Bool {
        return [OrderDeliveryStatus.Delivered, .FeedbackGiven].contains(self)
    }
    
    var isCancelled: Bool {
          return [OrderDeliveryStatus.Rejected, .CustomerCancel].contains(self)
    }
    
     var isDone0st: Bool {
            if self == .Rejected || self == .CustomerCancel {
    //            || self == .Pending{
                return false
            }
            return true
        }
    
    var isDone1st: Bool {
        if SKAppType.type == .eCom || SKAppType.type == .home {
            return isDone0st && self != .Pending
        }
        if self == .Rejected || self == .CustomerCancel {
//            || self == .Pending{
            return false
        }
        return true
    }
    
    var isDone2st: Bool {
        if SKAppType.type == .eCom || SKAppType.type == .home {
            //In the kitchen i.e Packed
             return isDone1st && self != .Confirmed
        }
        if !isDone1st || self == .Pending {
            return false
        } else if isDone1st && (self == .Confirmed && self != .inTheKitchan) {
            return true
        }
        return true
    }
    
//    var isDone3st: Bool {
//        if isDone2st && ((SKAppType.type == .home || SKAppType.type == .gym) ? self != .Shipped : self != .inTheKitchan) {
//            return true
//        }
//        return false
//    }
    
    var isDone3st: Bool {
        if SKAppType.type == .eCom || SKAppType.type == .home {
           //Shipped
            return isDone2st && self != .inTheKitchan
        }
        if isDone2st && self == .Confirmed {
            return false
        } else if isDone2st && (self == .inTheKitchan && self != .Shipped){
            return true
        } else if isDone2st && self != .Nearby {
            return true
        }

     //   return true
        return false
    }
    
    //Nitin
//    var isDone3st: Bool {
//        if !isDone2st && ((SKAppType.type == .home) ? self != .Shipped : self != .inTheKitchan) {
//            return false
//        } else if isDone2st && ((SKAppType.type == .home) ? self != .Shipped : self != .inTheKitchan) {
//            return false
//        }
//        return true
//    }
    
    //3 (Shipped) - on the way
    //10 (Reached) - ready to be picked
    func isDone4st(_ deliveryType: DeliveryType) -> Bool {
        if SKAppType.type == .eCom || SKAppType.type == .home {
           //Out for delivery
            return isDone3st && self != .Reached
        }
        if isDone3st && self == .inTheKitchan {
            return false
        }
        else if isDone3st {
            if deliveryType == .pickup {
                return true
            }
            else {
                return self != .Reached
            }
        }
        
        
//        else if isDone3st && ((self == .Shipped && self != .Nearby) || (self == .Shipped && self != .Reached)) {
//            return true
//        } else if isDone3st && self != .Shipped {
//            return true
//        }
        return false
    }
    
    //Nitin
//    var isDone4st: Bool {
//        if isDone3st && ((SKAppType.type == .home) ? self != .Reached : self == .Shipped) {
//            return true
//        }
//        return false
//    }
    

    //Nitin
//    var isDone5st: Bool {
//        if isDone4st && ((SKAppType.type == .home) ? self != .inTheKitchan : self == .Reached) {
//            return true
//        }
//        return false
//    }
    
//    var isDone5st: Bool {
//        if SKAppType.type == .eCom {
//          //Delivered
//           return isDone4st && self != .Shipped
//        }
//        if isDone4st && (self == .Delivered) {
//            return true
//        }
//        return false
//    }
    
    func isDone5st(_ deliveryType: DeliveryType) -> Bool {
        if SKAppType.type == .eCom || SKAppType.type == .home {
          //Delivered
           return isDone4st(deliveryType) && self != .Shipped
        }
        if isDone4st(deliveryType) && (self == .Delivered || self == .FeedbackGiven) {
            return true
        }
        return false
    }
    
    var pendingTitle: String {
        if self == .Rejected {
            return L11n.rejected.string
        } else if self == .CustomerCancel {
            return L11n.canceled.string
        } else if self != .Pending {
            return L11n.approved.string
        }
        return L11n.placed.string
    }
    
    func getPendingDate(order: OrderDetails) -> String {
//        labelDatePlaced?.text = orderDetails?.createdOnLine ?? "\n"
//        labelDateShipped?.text = orderDetails?.shippedOnLine ?? "\n"
//        labelDateNearYou?.text = orderDetails?.nearOnLine ?? "\n"
//
//        switch cellType{
//
//        case .OrderHistory:
//            labelDateDelivered?.text =  orderDetails?.deliveredOnLine ?? "\n"
//        case .OrderTracking:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .OrderUpcoming:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .OrderScheduled:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .RateOrder:
//            labelDateDelivered?.text =  orderDetails?.deliveredOnLine ?? "\n"
//        default: break
        
        if self == .Rejected {
            return "\n"//L11n.rejected.string
        } else if self == .CustomerCancel { //Cancel Date
            return "\n"//L11n.canceled.string
        } else if self != .Pending { //Approved Date
            return order.createdOnLine ?? "\n"
        }
        return order.createdOnLine ?? "\n"
    }
    
    
}

enum OrderRelatedKeys : String {
    
    case net_amount = "net_amount"
    case order_id = "order_id"
    case service_date = "service_date"
    case progress_on = "progress_on"
    case delivered_on = "delivered_on"
    case confirmed_on = "confirmed_on" //Nitin
    case status = "status"
    case near_on = "near_on"
    case self_pickup
    case shipped_on = "shipped_on"
    case payment_type = "payment_type"
    case payment_source = "payment_source"
    case created_on = "created_on"
    case product_count = "product_count"
    case user_delivery_address = "user_delivery_address"
    case delivery_address = "delivery_address"
    case product = "product"
    case schedule_order = "schedule_order"
    case orderHistory = "orderHistory"
    case orderList = "orderList"
    case supplierBranchId = "supplier_branch_id"
    case supplier_id
    case logo
    case supplierName = "supplier_name"
    case total_points = "total_points"
    case area_id = "area_id"
    
    case agent = "agent"
    case delivery_charges
    case promoCode
    case discountAmount
    case order_price
    case handling_admin
    case supplier_address
    case prod_variants
    case referral_amount
    case tip_agent = "tip_agent"
    case shippingData
    case user_service_charge
    case donate_to_someone
}

class OrderDetails: NSObject {

    var netAmount : String?
    var orderId : String?
    var serviceDate : String?
    var deliveredOn : String?
    var confirmed_on : String? //Nitin
    var status : OrderDeliveryStatus = .Pending
    var nearOn : String?
    var shippedOn : String?
    var paymentType :PaymentMethod = .COD
    var paymentSource: String?
    var createdOn : String?
    var productCount : String?
    var userDeliveryAddress : String?
    var scheduleOrder : String?
    var deliveryAddress : Address?
    var product : [ProductF]?
    var supplierBranchId : String?
    var supplierName : String?

    //New
    var nearOnLine : String?
    var shippedOnLine : String?
    var inProgressDate : String?
    var serviceDateObj : Date?
    var serviceDateLine : String?
    var deliveredOnLine : String?
    var createdOnLine : String?
    var confirmed_onLine : String? //Nitin
    var areaId : String?
    var totalPoints : String?
    
    var orderStatus : Int?
    var deliveryStatus : DeliveryType?

    //Agent
    var agentArray:[CblUser]?
    
    // Nitin
    var user_service_charge : String?
    var delivery_charges : String?
    var promoCode :String?
    var discountAmount:String?
    var order_price : String?
    var handling_admin : String?
    var supplier_address : String?
    var referral_amount: Double?
    var tipAgent :String?
    var pres_description: String?
    var arrPrescription: [String]?
    var duration: Int?
    var questions: [Question]?
    var addOn: Double?
    var type: Int?
    var appType: SKAppType {
        if type ==  nil {
            //Doctor - if from cart
            type = GDataSingleton.sharedInstance.cartAppType
        }
        //if from order details
        if let t = type, let model = SKAppType(rawValue: t) {
            return model
        }
        return SKAppType.type
    }
    var created_by: Int?
    var payment_after_confirmation: Int?
    var payment_status: Int?
    var remaining_amount: Double?
    var refund_amount: Double?

    
    var latitude : Double?
    var longitude : Double?

    var donate_to_someone: String?
    var supplier_id: String?
    var logo: String?
    var is_supplier_rated: Int?
    var terminology : TerminologyModalClass? = AppSettings.shared.appThemeData?.terminology

    //Shipping
    var shippingData: [ShippingDetails]?
    var subTotal: Double?
    var shouldPayAfterConfirmation: Bool {
        if ((created_by ?? 0) > 0 || payment_after_confirmation == 1)  && status == .Confirmed && payment_status == 0 && paymentType != .COD {
            return true
        }
        return false
    }
    var shouldPayRemainingAmount: Bool {
        if (remaining_amount ?? 0) > 0 && !(payment_after_confirmation == 1 && status == .Pending) {
            return true
        }
        return false
    }
//    var estimateDeliveredOn: Date?
    /*
     [10:01 AM] prince: schedule_order
     [10:02 AM] prince: 0: no schedule order , 1: schedule order
     */
    init(attributes : SwiftyJSONParameter) {
     
        self.supplier_address = attributes?[OrderRelatedKeys.supplier_address.rawValue]?.stringValue
        self.handling_admin = attributes?[OrderRelatedKeys.handling_admin.rawValue]?.stringValue
        self.order_price = attributes?[OrderRelatedKeys.order_price.rawValue]?.stringValue
        self.promoCode = attributes?[OrderRelatedKeys.promoCode.rawValue]?.stringValue
        self.discountAmount = attributes?[OrderRelatedKeys.discountAmount.rawValue]?.stringValue
        self.referral_amount = attributes?[OrderRelatedKeys.referral_amount.rawValue]?.doubleValue
        self.delivery_charges = attributes?[OrderRelatedKeys.delivery_charges.rawValue]?.stringValue
        self.user_service_charge = attributes?[OrderRelatedKeys.user_service_charge.rawValue]?.stringValue
        self.netAmount = attributes?[OrderRelatedKeys.net_amount.rawValue]?.stringValue
        self.deliveryStatus = DeliveryType(rawValue: attributes?[OrderRelatedKeys.self_pickup.rawValue]?.int ?? 0) ?? .delivery

        self.supplierName = attributes?[OrderRelatedKeys.supplierName.rawValue]?.stringValue
        self.tipAgent = attributes?[OrderRelatedKeys.tip_agent.rawValue]?.stringValue

        self.orderId = attributes?[OrderRelatedKeys.order_id.rawValue]?.stringValue
        self.status = OrderDeliveryStatus(rawValue: attributes?[OrderRelatedKeys.status.rawValue]?.stringValue ?? "") ?? .Pending
        self.orderStatus = attributes?[OrderRelatedKeys.status.rawValue]?.int
        
        self.paymentType = PaymentMethod(rawValue: attributes?[OrderRelatedKeys.payment_type.rawValue]?.stringValue ?? "") ?? .COD
        self.paymentSource = attributes?[OrderRelatedKeys.payment_source.rawValue]?.stringValue
        self.productCount = attributes?[OrderRelatedKeys.product_count.rawValue]?.stringValue
        self.userDeliveryAddress = attributes?[OrderRelatedKeys.user_delivery_address.rawValue]?.stringValue
        
        self.scheduleOrder = attributes?[OrderRelatedKeys.schedule_order.rawValue]?.stringValue
        self.supplierBranchId = attributes?[OrderRelatedKeys.supplierBranchId.rawValue]?.stringValue
        
        self.totalPoints = attributes?[OrderRelatedKeys.total_points.rawValue]?.stringValue
        self.areaId = attributes?[OrderRelatedKeys.area_id.rawValue]?.stringValue
        self.duration = attributes?["duration"]?.intValue
        self.addOn = attributes?["addOn"]?.doubleValue
        self.type = attributes?["type"]?.intValue

        self.created_by = attributes?["created_by"]?.intValue
        self.payment_after_confirmation = attributes?["payment_after_confirmation"]?.intValue
        self.payment_status = attributes?["payment_status"]?.intValue
        self.subTotal = attributes?["total_order_price"]?.doubleValue
        self.remaining_amount = attributes?["remaining_amount"]?.doubleValue
        self.refund_amount = attributes?["refund_amount"]?.doubleValue
        self.is_supplier_rated = attributes?["is_supplier_rated"]?.intValue
        self.donate_to_someone = attributes?[OrderRelatedKeys.donate_to_someone.rawValue]?.stringValue
        self.supplier_id = attributes?[OrderRelatedKeys.supplier_id.rawValue]?.stringValue
        self.logo = attributes?[OrderRelatedKeys.logo.rawValue]?.stringValue
        var arrayProducts : [ProductF] = []
        for element in attributes?[OrderRelatedKeys.product.rawValue]?.arrayValue ?? [] {
            let product = ProductF(attributes: element.dictionaryValue)
            arrayProducts.append(product)
        }
        
        var agentArray : [CblUser] = []
        for element in attributes?[OrderRelatedKeys.agent.rawValue]?.arrayValue ?? [] {
           
            let cblUser =  CblUser(attributes: element.dictionary)
             agentArray.append(cblUser)
        }
        
        self.agentArray = agentArray
        
        self.product = arrayProducts
        self.deliveryAddress = Address(attributes: attributes?[OrderRelatedKeys.delivery_address.rawValue]?.dictionaryValue)
        
        arrPrescription = []
        if let img1 = attributes?["pres_image1"]?.stringValue, !img1.isEmpty {
            arrPrescription?.append(img1)
        }
        if let img2 = attributes?["pres_image2"]?.stringValue, !img2.isEmpty{
            arrPrescription?.append(img2)
        }
        if let img2 = attributes?["pres_image3"]?.stringValue, !img2.isEmpty {
            arrPrescription?.append(img2)
        }
        if let img2 = attributes?["pres_image4"]?.stringValue, !img2.isEmpty {
            arrPrescription?.append(img2)
        }
        if let img2 = attributes?["pres_image5"]?.stringValue, !img2.isEmpty {
            arrPrescription?.append(img2)
        }
        pres_description = attributes?["pres_description"]?.stringValue
        if let questionsStr = attributes?["questions"]?.stringValue, let json = JSON(parseJSON: questionsStr).arrayObject {
            questions = []
            for question in json {
                if let object = Mapper<Question>().map(JSONObject: question) {
                    questions?.append(object)
                }
            }
        }
        if let terminologyStr = attributes?["terminology"]?.stringValue {
            if let dict = terminologyStr.convertToDictionary(){
                if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
                    terminology = obj
                }
            }
        }

        //Dates
        self.nearOn = attributes?[OrderRelatedKeys.near_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
        self.shippedOn = attributes?[OrderRelatedKeys.shipped_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
        self.createdOn = attributes?[OrderRelatedKeys.created_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
        self.deliveredOn = attributes?[OrderRelatedKeys.delivered_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
        self.serviceDate = attributes?[OrderRelatedKeys.service_date.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
        self.confirmed_on = attributes?[OrderRelatedKeys.confirmed_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.To)
//        self.estimateDeliveredOn = attributes?[OrderRelatedKeys.service_date.rawValue]?.stringValue.convertToDate(from: .From,to:.To)

        self.nearOnLine = attributes?[OrderRelatedKeys.near_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.shippedOnLine = attributes?[OrderRelatedKeys.shipped_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.createdOnLine = attributes?[OrderRelatedKeys.created_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.deliveredOnLine = attributes?[OrderRelatedKeys.delivered_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.serviceDateObj = attributes?[OrderRelatedKeys.service_date.rawValue]?.stringValue.convertToDate(from: .From)
        self.serviceDateLine = attributes?[OrderRelatedKeys.service_date.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.inProgressDate = attributes?[OrderRelatedKeys.progress_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        self.confirmed_onLine = attributes?[OrderRelatedKeys.confirmed_on.rawValue]?.stringValue.convertDateStringFormat(from: .From,to:.ToLine)
        
        
        var arrayShipping : [ShippingDetails] = []
        for element in attributes?[OrderRelatedKeys.shippingData.rawValue]?.arrayValue ?? [] {
            let obj = ShippingDetails(attributes: element.dictionaryValue)
            arrayShipping.append(obj)
        }
        self.shippingData = arrayShipping
        
        self.latitude = attributes?["latitude"]?.doubleValue
        self.longitude = attributes?["longitude"]?.doubleValue
    }
    
    init(orderSummary : OrderSummary?,orderId : String?,scheduleOrder : String?) {
        guard let summary = orderSummary else { return }
        self.orderId = orderId
        self.status = .Pending
        self.paymentType = summary.paymentMode.paymentType
        self.createdOn = UtilityFunctions.getDateFormatted(format: OrderDateFormat.To.rawValue, date: Date())
        self.deliveryAddress = orderSummary?.deliveryAddress
        self.product = []
        for product in orderSummary?.items ?? [] {
            self.product?.append(ProductF(cart:product))
        }
        self.netAmount = orderSummary?.totalAmount?.toString
        self.supplierBranchId = product?.first?.supplierBranchId
        self.scheduleOrder = scheduleOrder
        self.userDeliveryAddress = self.deliveryAddress?.addressString
        self.productCount = self.product?.count.toString
        
        self.deliveredOn = UtilityFunctions.getDateFormatted(format: OrderDateFormat.To.rawValue, date: orderSummary?.deliveryDate ?? Date())
        self.serviceDate = self.deliveredOn
    }
    
    init(orderId : String?) {
        self.orderId = orderId
    }
    
    override init() {
        super.init()
    }
}

class OrderListing {   
    
    var orders : [OrderDetails]?
    var count: Int = 0
    
    init(attributes : SwiftyJSONParameter , key : String){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[key]
        let tempOrders = dict.arrayValue
        var arrayOrders : [OrderDetails] = []
        
        for element in tempOrders {
            let order = OrderDetails(attributes: element.dictionaryValue)
            arrayOrders.append(order)
        }
        self.orders = arrayOrders
        self.count = json["count"].intValue
    }
    
}

extension String {
    
    func convertDateStringFormat(from : OrderDateFormat, to : OrderDateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = from.rawValue
        var str = self.components(separatedBy : "+").first ?? ""
        str = str.replacingOccurrences(of: "T", with: " ")
        guard let date = dateFormatter.date(from: str) else { return nil }
        
        print(date)
        return UtilityFunctions.getDateFormatted(format: to.rawValue,date: date)
    }
    
    func convertToDate(from : OrderDateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = from.rawValue
        var str = self.components(separatedBy : "+").first ?? ""
        str = str.replacingOccurrences(of: "T", with: " ")
        guard let date = dateFormatter.date(from: str) else { return nil }
        
        print(date)
        return date
    }
}


class ShippingDetails : NSObject {
    var orderStatus : String?
    var orderNumber : String?
    var orderId : String?
    
    init(attributes : SwiftyJSONParameter) {
        
        
        //Status -  awaiting_shipment, cancelled, shipped, onhold
        let status = attributes?["orderStatus"]?.stringValue
        switch status {
        case "awaiting_shipment":
            self.orderStatus = "Awaiting Shipment".localized()
        case "cancelled":
            self.orderStatus = "Cancelled".localized()
        case "shipped":
            self.orderStatus = "Shipped".localized()
        case "onhold":
            self.orderStatus = "On hold".localized()
        default:
            self.orderStatus = ""
        }
        self.orderNumber = attributes?["orderNumber"]?.stringValue
        self.orderId = attributes?["orderId"]?.stringValue
    }
}

