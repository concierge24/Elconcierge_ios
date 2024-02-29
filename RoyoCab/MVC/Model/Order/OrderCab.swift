//
//  Order.swift
//  Buraq24
//
//  Created by MANINDER on 18/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import ObjectMapper


enum OrderTurn : String {
    case MyTurn = "1"
    case OtherCustomerTurn = "0"
    
}


class RatingCab : Mappable {
    
    
    var comment  : String?
    var ratingGiven : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        comment <- map["comments"]
        ratingGiven <- map["ratings"]
    }
}

class OrderDates : Mappable{
    
    
    var startedDate : Date?
    var completedDate : Date?
    

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        var strAccepted : String?
        strAccepted <- map["accepted_at"]
        
        var strCompleted : String?
        strCompleted <- map["updated_at"]
        guard let utcAccDateStr = strAccepted else{return}
        startedDate = utcAccDateStr.getLocalDate()
        guard let utcCompletedDateStr = strCompleted else{return}
        completedDate = utcCompletedDateStr.getLocalDate()
    }
}

class OrderCab: Mappable {
    
    var orderId : Int?
    var customerOrganisationId : Int?
    var refundStatus : String?
    var initialCharge : String?
    var continuousOrderId : Int?
    
    
    var bottleCharge : String?
    var bottleReturned : String?
    var userType : UserType = .Customer
    var bottleReturnedValue : Int?
    // var paymentStatus : PaymentStatus = .Pending
    
    var serviceId: Int?
    var serviceBrandId : Int?
    var categoryBrandProductId : Int?
    
    var userCardId : Int?
    var bookingType : BookingType = .Present
    var paymentType : PaymentType = .Cash
    var orderStatus : OrderStatus = .Searching
    
    var pickUpLongitude : Double?
    var pickUpLatitude : Double?
    var pickUpAddress : String?
    
    var dropOffAddress  : String?
    var dropOffLatitude : Double?
    var dropOffLongitude : Double?
    
    
    var orderToken : String?
    var orderTimings : String?
    var orderLocalDate : Date?
    var orderDate : Date?
    var cancelReason : String?
    
    var finalCharge : String?
    var productQuantity :  Int?
    var orderProductDetail : OrderProductDetail?
    var driverAssigned : Driver?
    var payment : Payment?
    var rating : RatingCab?
   
    
    var orderDates : OrderDates?
    
    var myTurn : OrderTurn = .MyTurn
    var isDirectSearching = false
    
    var organisationCouponUserId :Int?
    var booking_type : String?
    
    var isContinueFromBreakdown: Bool?
    var shareWith : [ContactNumberModal]?
    var updated_at: String?
    var accepted_at: String?
    
    var orderTurn : OrderTurn  = .MyTurn
    var statusCode: Int? // to check pending balance for last ride
    
    var cancellation_charges: Float?
    var payment_id: Int?
    var ride_stops: [Stops]?
    var check_lists:[CheckLists]?
    var check_list_total: Int?
    var otp:String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        otp <- map["otp"]
        orderId <- map["order_id"]
        customerOrganisationId <- map["customer_organisation_id"]
        refundStatus <- map["refund_status"]
        initialCharge <- map["initial_charge"]
        continuousOrderId <- map["continuous_order_id"]
        serviceId <- map["category_id"]
        bottleCharge <- map["bottle_charge"]
        bottleReturned <- map["bottle_returned"]
        bottleReturnedValue <- map["bottle_returned_value"]
        productQuantity <- map["product_quantity"]
        cancelReason <- map["cancel_reason"]
        orderTimings <- map["order_timings"]
        shareWith <- map["shareWith"]
        updated_at <- map["updated_at"]
        accepted_at <- map["accepted_at"]
        statusCode <- map["statusCode"]
        cancellation_charges <- map["cancellation_charges"]
        payment_id <- map["payment_id"]
        ride_stops <- map["ride_stops"]
       
        
        guard let utcDateStr = orderTimings else{return}
        
        orderLocalDate = utcDateStr.getLocalDate()
        
        finalCharge <- map["final_charge"]
        orderToken <- map["order_token"]
        userCardId <- map["user_card_id"]
        
        organisationCouponUserId <- map["organisation_coupon_user_id"]

        
        pickUpLongitude <- map["pickup_longitude"]
        pickUpLatitude <- map["pickup_latitude"]
        pickUpAddress <- map["pickup_address"]
        dropOffAddress  <- map["dropoff_address"]
        dropOffLatitude <- map["dropoff_latitude"]
        dropOffLongitude <- map["dropoff_longitude"]
        orderProductDetail <- map["brand"]
        driverAssigned <- map["driver"]
        payment <- map["payment"]
        rating <- map["ratingByUser"]
        booking_type <- map["booking_type"]
        check_lists <- map["check_lists"]
        
        var orderstatus : String?
        orderstatus <- map["order_status"]
        
        guard let status = orderstatus else{return}
        orderStatus = OrderStatus(rawValue: /status)!
        
        var orderTurn : String?
        orderTurn  <- map["my_turn"]
        
        guard let turn = orderTurn else{return}
        myTurn = OrderTurn(rawValue: /turn)!
        
        orderDates  <- map["cRequest"]
        
        
        var strFuture : String?
        strFuture <- map["future"]
         guard let future = strFuture else{return}
        bookingType = BookingType(rawValue: /future)!

    }
    
}

class CheckLists: NSObject, Mappable {
    
    var after_item_price: String?
    var before_item_price: String?
    var check_list_id: Int?
    var created_at: String?
    var item_name: String?
    var order_id: String?
    var updated_at: String?
    var user_detail_id: String?
    var tax: Int?
    var price: String?
    
    required convenience init?(map: Map) {
           self.init()
       }
    
    func mapping(map: Map) {
        after_item_price <- map["after_item_price"]
        before_item_price <- map["before_item_price"]
        check_list_id <- map["check_list_id"]
        created_at <- map["created_at"]
        item_name <- map["item_name"]
        order_id <- map["order_id"]
        updated_at <- map["updated_at"]
        user_detail_id <- map["user_detail_id"]
        tax <- map["tax"]
        price <- map["price"]
    }
    
}


class CheckListModel {
      var after_item_price: String?
      var before_item_price: String?
      var check_list_id: Int?
      var created_at: String?
      var item_name: String?
      var order_id: String?
      var updated_at: String?
      var user_detail_id: String?
      var tax: Int?
      var price: String?
    
    
    init(afteritemprice: String?, beforeitemprice: String?, checklistid: Int?, createdat: String?, itemname: String?, orderid: String?, updatedat: String?, userdetailid: String?, tax: Int?, price: String?) {
        self.after_item_price = afteritemprice
        self.before_item_price = beforeitemprice
        self.check_list_id = checklistid
        self.created_at = createdat
        self.item_name = itemname
        self.order_id = orderid
        self.updated_at = updatedat
        self.user_detail_id = userdetailid
        self.tax = tax
        self.price = price
    }
}


class Stops: NSObject, Mappable {
    
    var latitude: Double?
    var longitude: Double?
    var priority: Int?
    var address: String?
    var added_with_ride: String?
    
    required init?(map: Map) {}
       
    func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        priority <- map["priority"]
        address <- map["address"]
        added_with_ride <- map["added_with_ride"]
    }
    
    
    init(latitude: Double?, longitude: Double?, priority: Int?, address: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.priority = priority
        self.address = address
    }
}

class ShareWith : NSObject, Mappable{

    var name : String?
    var phoneCode : String?
    var phoneNumber : String?


    class func newInstance(map: Map) -> Mappable?{
        return ShareWith()
    }
    private override init(){}
    required init?(map: Map){}

    func mapping(map: Map)
    {
        name <- map["name"]
        phoneCode <- map["phone_code"]
        phoneNumber <- map["phone_number"]
        
    }
}


class OrderProductDetail : Mappable {
    
    var productName : String?
    var productDescription : String?
    var pricePerWeight : Float?
    var productCategoryId : Int?
    var pricePerDistance : Float?
    var productBrandId : Int?
    var productPricePerQuantity : Float?
    var productActualPrice : Float?
    var productAlphaPrice : Float?
    var productId : Int?
    var productBrandName : String?
    var category_name :String?
    var price_per_hr: Float?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productName <- map["name"]
        productDescription <- map["description"]
        pricePerWeight <- map["price_per_weight"]
        productCategoryId <- map["category_id"]
        pricePerDistance <- map["price_per_distance"]
        productBrandId <- map["category_brand_id"]
        productPricePerQuantity <- map["price_per_quantity"]
        productActualPrice <- map["actual_value"]
        productAlphaPrice <- map["alpha_price"]
        productId <- map["category_brand_product_id"]
        productBrandName <- map["brand_name"]
        category_name <- map["category_name"]
        price_per_hr <- map["price_per_hr"]
    }
}

