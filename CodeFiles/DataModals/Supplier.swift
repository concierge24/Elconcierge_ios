//
//  Supplier.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON

public typealias SwiftyJSONParameter = Dictionary<String, JSON>?

enum CommissionPackage : String {
    
    case Silver = "0"
    case Bronze = "1"
    case Gold = "2"
    case None = "4"
    case DoesntMatter
    
    func indexValue() -> Int {
        
        switch self {
        case .Silver:
            return 0
        case .Bronze:
            return 1
        case .Gold:
            return 2
        case .None:
            return 4
        default:
            return 0
        }
    }
    
    static let allValues = [L10n.Gold.string, L10n.Silver.string , L10n.Bronze.string]
    
    func commissionStringValue() -> String{
        
        switch self {
        case .Gold:
            return L10n.Gold.string
        case .Silver:
            return L10n.Silver.string
        case .Bronze:
            return L10n.Bronze.string
        default:
            return ""
        }
    }
    
    func medal() -> Asset? {
        
        switch self {
            
        case .Gold :
            return Asset.Ic_badge_mini_gold
        case .Silver :
            return Asset.Ic_badge_mini_silver
        case .Bronze :
            return Asset.Ic_badge_mini_bronze
        case .None :
            return Asset.Ic_np
        default:
            return nil
        }
        
    }
    
    func bigMedal () -> Asset? {
        
        switch self {
            
        case .Gold :
            return Asset.Ic_badge_gold_big
        case .Silver :
            return Asset.Ic_badge_silver_big
        case .Bronze :
            return Asset.Ic_badge_bronze_big
        case .None :
            return Asset.Ic_np
        default:
            return nil
        }
        
    }
    
}

enum Status : String {
    
    case Online = "1"
    case Busy = "2"
    case Closed = "0"
    case DoesntMatter
    
    
    func indexValue () -> Int {
        
        switch self {
        case .Online:
            return 1
        case .Busy:
            return 2
        case .Closed:
            return 0
        default:
            return 2
        }
    }
    static let allValues = [L10n.Closed.string , L10n.Open.string , L10n.Busy.string ]
    
    func statusStringValue() -> String{
        
        if !AppSettings.shared.isFoodApp {
            switch  self {
            case .Online:
                return L10n.Open.string
            case .Busy:
                return L10n.Busy.string
            case .Closed:
                return L10n.Closed.string
            default:
                return L10n.Open.string
            }
            //            return ""
        }
        
        switch  self {
        case .Online:
            return "\(L10n.Open.string) \(L10n.Now.string) -"
        case .Busy:
            return "\(L10n.Busy.string) \(L10n.Now.string) -"
        case .Closed:
            return "\(L10n.Closed.string) \(L10n.Now.string) -"
        default:
            return "\(L10n.Open.string) \(L10n.Now.string) -"
        }
        
    }
    
    var color: UIColor {
        switch  self {
        case .Online:
            return UIColor.green
        case .Busy:
            return #colorLiteral(red: 0.8533234, green: 0.6520703435, blue: 0.1357885003, alpha: 1)
        case .Closed:
            return UIColor.red
        default:
            return UIColor.green
        }
    }
    
    func status () -> Asset {
        
        switch self {
        case .Online :
            return .Ic_status_online
        case .Busy :
            return .Ic_status_busy
        case .Closed :
            return .Ic_status_offline
        case .DoesntMatter :
            return .Ic_status_offline
        }
        
    }
    
}

enum CommisionType : String {
    
    case ByValue = "0"
    case ByPercentage = "1"
    case DoesntMatter
    
}

struct PaymentMode {
    
    var paymentType: PaymentMethod = .DoesntMatter
    var gatewayUniqueId: String?
    var token: String?
    var card_id:String?
    var displayName: String {
        if paymentType == .COD {
            return "Cash On Delivery"
        }
        else if paymentType == .Card {
            switch gatewayUniqueId {
            case "stripe":
                return "Credit Card"
            case "paypal":
                return "Paypal"
            case "venmo":
                return "Venmo"
            case "zelle":
                return "Zelle"
            case "squareup":
                return "Square"

            case "sadded":
                return "SADAD"
            case "myfatoorah":
                return "MyFatoorah"

            case "paystack":
                return "Paystack"
            default:
                return "\(/gatewayUniqueId)"
            }
        }
        else {
            return "None"
        }
    }
}

enum PaymentMethod : String {
    
    case AfterConfirmation = "3"
    case COD = "0"
    case Card = "1"
    case DoesntMatter = "2"
    
    
    
    func indexValue () -> Int {
        
        switch self {
        case .AfterConfirmation:
            return 3
        case .COD:
            return 0
        case .Card:
            return 1
        default:
            return 2
        }
    }
    
    static let allValues = [L10n.CashOnDelivery.string , L10n.Card.string , L10n.Both.string]
    
    func paymentMethodString() -> String{
        
        switch self {
        case .COD:
            return "Cash"//L10n.CashOnDelivery.string
        case .Card:
            return L10n.Card.string
        default:
            return L10n.Both.string
        }
        
    }
    
    
    func visibilityBasedOnDelivery (withImgCOD imgCOD : UIImageView? , imgCard : UIImageView?){
        
        
        switch self {
        case .DoesntMatter :
            imgCOD?.isHidden = false
            imgCard?.isHidden = false
            
        case .Card :
            imgCOD?.isHidden = true
            imgCard?.isHidden = false
            
        case .COD :
            imgCOD?.isHidden = false
            imgCard?.isHidden = true
        case .AfterConfirmation :
            imgCOD?.isHidden = false
            imgCard?.isHidden = true
            
        }
        
    }
    
}

// Ankit Timing array added
enum TimingKeys : String{
    
    case start_time = "start_time"
    case is_open = "is_open"
    case end_time = "end_time"
    case week_id = "week_id"
    
}

class Timing: NSObject,NSCoding {
    
    var startTime : String?
    var isOpen : Int?
    var endTime : String?
    var weekId : Int?
    
    init (attributes : SwiftyJSONParameter){
        self.startTime = attributes?[TimingKeys.start_time.rawValue]?.stringValue
        self.isOpen = attributes?[TimingKeys.is_open.rawValue]?.intValue
        self.endTime = attributes?[TimingKeys.end_time.rawValue]?.stringValue
        self.weekId = attributes?[TimingKeys.week_id.rawValue]?.intValue
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(startTime, forKey: "startTime")
        aCoder.encode(isOpen, forKey: "isOpen")
        aCoder.encode(endTime, forKey: "endTime")
        aCoder.encode(weekId, forKey: "weekId")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        startTime = aDecoder.decodeObject(forKey: "startTime") as? String
        isOpen = aDecoder.decodeObject(forKey: "isOpen") as? Int
        endTime = aDecoder.decodeObject(forKey: "endTime") as? String
        weekId = aDecoder.decodeObject(forKey: "weekId") as? Int
        
    }
}

enum SupplierKeys :String {
    
    case supplierList = "supplierList"
    
    case id = "id"
    case supplier_branch_id = "supplier_branch_id"
    case handling_fees = "handling_fees"
    case commission = "commission"
    case commission_type = "commission_type"
    case delivery_min_time = "delivery_min_time"
    case delivery_max_time = "delivery_max_time"
    case delivery_start_time = "delivery_start_time"
    case delivery_end_time = "delivery_end_time"
    case working_start_time = "working_start_time"
    case working_end_time = "working_end_time"
    case min_order = "min_order"
    case delivery_charges = "delivery_charges"
    case name = "name"
    case supplier_name = "supplier_name"
    case logo = "logo"
    case status = "status"
    case total_reviews = "total_reviews"
    case rating = "rating"
    case payment_method = "payment_method"
    case commission_package = "commission_package"
    case description = "description"
    case about = "about"
    case supplier_images = "supplier_image"
    case address = "address"
    case total_order = "total_order"
    case business_start_date = "business_start_date"
    case Favourite = "Favourite"
    case supplier_id = "supplier_id"
    case my_review = "my_review"
    case favorites = "favourites"
    case sponser = "sponser"
    case open_time = "open_time"
    case close_time = "close_time"
    case terms_and_conditions = "terms_and_conditions"
    case is_sponsor = "is_sponsor"
    case timing = "timing"
    case type
    case speciality = "speciality"
    case brand = "brand"
    case nationality = "nationality"
    case linkedin_link = "linkedin_link"
    case facebook_link = "facebook_link"
    case instagram_link = "instagram_link"
}


extension String {
    
    func percentEscapedString() -> String?{
        if self.contains("%20") {
            return self
        }
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
}

class Supplier : NSObject,NSCoding {
    
    var id : String?
    var supplierBranchId : String?
    
    var commission : String?
    var deliveryMinTime : String?
    var deliveryMaxTime : String?
    var deliveryStartTime : String?
    var deliveryEndTime : String?
    var workingStartTime : String?
    var workingEndTime : String?
    var minOrder : String?
    var deliveryCharges : String?
    var name : String?
    var logo : String?
    var totalReviews : String?
    var rating : String?
    var paymentMethod : PaymentMethod = .DoesntMatter
    var commissionPackage : CommissionPackage = .DoesntMatter
    var commissionType : CommisionType = .DoesntMatter
    var status : Status = .DoesntMatter
    
    var address : String?
    var openingTime : String?
    var minimumDeliveryTime : String?
    var ordersDoneSoFar : String?
    var businessSince : String?
    var reviews : [Review]?
    var myReview : Review?
    var Favourite : String?
    var categories : [Categorie]?
    var descriptionHTML : String?
    var about : String?
    var supplierImages : [String]?
    var closeTime : String?
    var termsAndConditions : String?
    
    var displayDeliveryTime : String?
    var isSponsor : String?
    
    var categoryId : String?
    var avg_rating: Int?
    var timing : [Timings]?
    
    var getCat: ServiceType? {
        return categories?.first?.toServiceType
    }
    var associatedQuestions: [Question]?
    var type: Int? //Doctor
    
    var facebook_link : String?
    var linkedin_link : String?
    var nationality : String?
    var brand : String?
    var speciality : String?
    var instagram_link: String?
    var user_request_flag: Int?
    
    
    init(attributes : SwiftyJSONParameter){
        
        
        super.init()
        self.supplierBranchId = attributes?[SupplierKeys.supplier_branch_id.rawValue]?.stringValue
        self.avg_rating = attributes?["avg_rating"]?.intValue
        
        self.commission = attributes?[SupplierKeys.commission.rawValue]?.stringValue //
        self.deliveryMinTime = attributes?[SupplierKeys.delivery_min_time.rawValue]?.stringValue //
        self.deliveryMaxTime = attributes?[SupplierKeys.delivery_max_time.rawValue]?.stringValue //
        self.deliveryStartTime = attributes?[SupplierKeys.delivery_start_time.rawValue]?.stringValue //
        self.deliveryEndTime = attributes?[SupplierKeys.delivery_end_time.rawValue]?.stringValue //
        self.workingStartTime = attributes?[SupplierKeys.working_start_time.rawValue]?.stringValue //
        self.workingEndTime = attributes?[SupplierKeys.working_end_time.rawValue]?.stringValue //
        self.minOrder = attributes?[SupplierKeys.min_order.rawValue]?.stringValue //
        self.deliveryCharges = attributes?[SupplierKeys.delivery_charges.rawValue]?.stringValue //
        self.logo = attributes?[SupplierKeys.logo.rawValue]?.stringValue
        self.totalReviews = attributes?[SupplierKeys.total_reviews.rawValue]?.stringValue
        self.rating = attributes?[SupplierKeys.rating.rawValue]?.stringValue
        self.address = attributes?[SupplierKeys.address.rawValue]?.stringValue
        self.Favourite = attributes?[SupplierKeys.Favourite.rawValue]?.stringValue
        self.isSponsor = attributes?[SupplierKeys.is_sponsor.rawValue]?.stringValue
        self.myReview = Review(attributes: attributes?[SupplierKeys.my_review.rawValue]?.dictionaryValue)
        self.commissionType = CommisionType(rawValue: attributes?[SupplierKeys.commission_type.rawValue]?.stringValue ?? "") ?? .DoesntMatter
        self.commissionPackage = CommissionPackage(rawValue: attributes?[SupplierKeys.commission_package.rawValue]?.stringValue ?? "") ?? .DoesntMatter
        self.status = Status(rawValue: attributes?[SupplierKeys.status.rawValue]?.stringValue ?? "") ?? .DoesntMatter
        self.paymentMethod = PaymentMethod(rawValue: attributes?[SupplierKeys.payment_method.rawValue]?.stringValue ?? "" ) ?? .DoesntMatter
        self.descriptionHTML = attributes?[SupplierKeys.description.rawValue]?.stringValue
        self.about = attributes?[SupplierKeys.about.rawValue]?.stringValue
        self.openingTime = attributes?[SupplierKeys.open_time.rawValue]?.stringValue
        self.closeTime = attributes?[SupplierKeys.close_time.rawValue]?.stringValue
        self.termsAndConditions = attributes?[SupplierKeys.terms_and_conditions.rawValue]?.stringValue
        self.descriptionHTML = UtilityFunctions.appendOptionalStrings(withArray: [self.descriptionHTML,self.termsAndConditions], separatorString: "\n")
        var images : [String] = []
        if let img = attributes?[SupplierKeys.supplier_images.rawValue]?.string {
            images.append(img)
        }
        for element in attributes?[SupplierKeys.supplier_images.rawValue]?.arrayValue ?? []{
            if element.stringValue.length == 0 { continue }
            images.append(element.stringValue ?? "")
        }
        self.supplierImages = images
        
        self.reviews = ReviewListing(attributes: attributes).reviewListing
        self.timing = TimingListing.init(attributes: attributes).arrayTimings
        
        self.ordersDoneSoFar = attributes?[SupplierKeys.total_order.rawValue]?.stringValue
        self.businessSince = attributes?[SupplierKeys.business_start_date.rawValue]?.stringValue
        businessSince = businessSince?.components(separatedBy: ",").last
        self.categories = CategoriesListing(attributes: attributes).arrayCategories
        self.timing = TimingListing(attributes: attributes).arrayTimings
        type = attributes?[SupplierKeys.type.rawValue]?.intValue
        
        self.displayDeliveryTime = self.getMinimumDeliveryTime(max: deliveryMaxTime, min: deliveryMinTime)
        if let suppName = attributes?[SupplierKeys.supplier_name.rawValue]?.stringValue {
            self.name = suppName
        }
        else{
            self.name = attributes?[SupplierKeys.name.rawValue]?.stringValue
        }
        user_request_flag = attributes?["user_request_flag"]?.intValue
        self.speciality = attributes?[SupplierKeys.speciality.rawValue]?.stringValue
        self.brand = attributes?[SupplierKeys.brand.rawValue]?.stringValue
        self.nationality = attributes?[SupplierKeys.nationality.rawValue]?.stringValue
        self.linkedin_link = attributes?[SupplierKeys.linkedin_link.rawValue]?.stringValue
        self.facebook_link = attributes?[SupplierKeys.facebook_link.rawValue]?.stringValue
        self.instagram_link = attributes?[SupplierKeys.instagram_link.rawValue]?.stringValue
        
        guard let supplierId = attributes?[SupplierKeys.supplier_id.rawValue]?.stringValue else{
            self.id = attributes?[SupplierKeys.id.rawValue]?.stringValue
            return
        }
        self.id = supplierId
        
        
    }
    
    override init() {
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(supplierBranchId, forKey: "supplierBranchId")
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(commission, forKey: "commission")
        
        aCoder.encode(deliveryMinTime, forKey: "deliveryMinTime")
        aCoder.encode(deliveryMaxTime, forKey: "deliveryMaxTime")
        aCoder.encode(deliveryStartTime, forKey: "deliveryStartTime")
        aCoder.encode(deliveryEndTime, forKey: "deliveryEndTime")
        aCoder.encode(workingStartTime, forKey: "workingStartTime")
        aCoder.encode(workingEndTime, forKey: "workingEndTime")
        aCoder.encode(minOrder, forKey: "minOrder")
        aCoder.encode(deliveryCharges, forKey: "deliveryCharges")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(logo, forKey: "logo")
        
        aCoder.encode(totalReviews, forKey: "totalReviews")
        aCoder.encode(rating, forKey: "rating")
        
        aCoder.encode(paymentMethod.rawValue, forKey: "paymentMethod")
        aCoder.encode(commissionPackage.rawValue, forKey: "commissionPackage")
        aCoder.encode(commissionType.rawValue, forKey: "commissionType")
        aCoder.encode(status.rawValue, forKey: "status")
        
        aCoder.encode(address, forKey: "address")
        aCoder.encode(openingTime, forKey: "openingTime")
        aCoder.encode(minimumDeliveryTime, forKey: "minimumDeliveryTime")
        aCoder.encode(ordersDoneSoFar, forKey: "ordersDoneSoFar")
        aCoder.encode(businessSince, forKey: "businessSince")
        aCoder.encode(reviews, forKey: "reviews")
        aCoder.encode(timing, forKey: "timing")
        
        aCoder.encode(myReview, forKey: "myReview")
        
        aCoder.encode(Favourite, forKey: "Favourite")
        aCoder.encode(categories, forKey: "categories")
        
        aCoder.encode(descriptionHTML, forKey: "descriptionHTML")
        aCoder.encode(about, forKey: "about")
        aCoder.encode(supplierImages, forKey: "supplierImages")
        aCoder.encode(closeTime, forKey: "closeTime")
        aCoder.encode(termsAndConditions, forKey: "termsAndConditions")
        aCoder.encode(displayDeliveryTime, forKey: "displayDeliveryTime")
        aCoder.encode(isSponsor, forKey: "isSponsor")
        aCoder.encode(categoryId, forKey: "categoryId")
        if let questions = associatedQuestions {
            aCoder.encode(questions, forKey: "associatedQuestions")
        }
        aCoder.encode(type, forKey: "type")
        
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        avg_rating = aDecoder.decodeObject(forKey: "avg_rating") as? Int
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        supplierBranchId = aDecoder.decodeObject(forKey: "supplierBranchId") as? String
        
        commission = aDecoder.decodeObject(forKey: "commission") as? String
        deliveryMinTime = aDecoder.decodeObject(forKey: "deliveryMinTime") as? String
        deliveryMaxTime = aDecoder.decodeObject(forKey: "deliveryMaxTime") as? String
        deliveryStartTime = aDecoder.decodeObject(forKey: "deliveryStartTime") as? String
        deliveryEndTime = aDecoder.decodeObject(forKey: "deliveryEndTime") as? String
        
        
        workingStartTime = aDecoder.decodeObject(forKey: "workingStartTime") as? String
        workingEndTime = aDecoder.decodeObject(forKey: "workingEndTime") as? String
        minOrder = aDecoder.decodeObject(forKey: "minOrder") as? String
        deliveryCharges = aDecoder.decodeObject(forKey: "deliveryCharges") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        logo = aDecoder.decodeObject(forKey: "logo") as? String
        
        totalReviews = aDecoder.decodeObject(forKey: "totalReviews") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        
        paymentMethod = PaymentMethod(rawValue: /(aDecoder.decodeObject(forKey: "paymentMethod") as? String))!
        commissionPackage = CommissionPackage(rawValue: /(aDecoder.decodeObject(forKey: "commissionPackage") as? String))!
        commissionType = CommisionType(rawValue: /(aDecoder.decodeObject(forKey: "commissionType") as? String))!
        status = Status(rawValue: /(aDecoder.decodeObject(forKey: "status") as? String))!
        
        address = aDecoder.decodeObject(forKey: "address") as? String
        openingTime = aDecoder.decodeObject(forKey: "openingTime") as? String
        
        minimumDeliveryTime = aDecoder.decodeObject(forKey: "minimumDeliveryTime") as? String
        ordersDoneSoFar = aDecoder.decodeObject(forKey: "ordersDoneSoFar") as? String
        businessSince = aDecoder.decodeObject(forKey: "businessSince") as? String
        reviews = aDecoder.decodeObject(forKey: "reviews") as? [Review]
        myReview = aDecoder.decodeObject(forKey: "myReview") as? Review
        
        timing = aDecoder.decodeObject(forKey: "timing") as? [Timings]
        Favourite = aDecoder.decodeObject(forKey: "Favourite") as? String
        categories = aDecoder.decodeObject(forKey: "categories") as? [Categorie]
        descriptionHTML = aDecoder.decodeObject(forKey: "descriptionHTML") as? String
        about = aDecoder.decodeObject(forKey: "about") as? String
        
        supplierImages = aDecoder.decodeObject(forKey: "supplierImages") as? [String]
        closeTime = aDecoder.decodeObject(forKey: "closeTime") as? String
        termsAndConditions = aDecoder.decodeObject(forKey: "termsAndConditions") as? String
        displayDeliveryTime = aDecoder.decodeObject(forKey: "displayDeliveryTime") as? String
        isSponsor = aDecoder.decodeObject(forKey: "isSponsor") as? String
        categoryId = aDecoder.decodeObject(forKey: "categoryId") as? String
        associatedQuestions = aDecoder.decodeObject(forKey: "associatedQuestions") as? [Question]
        type = aDecoder.decodeObject(forKey: "type") as? Int
    }
    
    func getMinimumDeliveryTime(max : String?,min : String?) -> String?{
        guard let minDelTime = min?.toInt(),let maxDelTime = max?.toInt() else { return nil }
        if minDelTime == maxDelTime {
            return convertMinutes(minutes: minDelTime)
        }else if minDelTime > maxDelTime {
            return UtilityFunctions.appendOptionalStrings(withArray: [convertMinutes(minutes: maxDelTime),convertMinutes(minutes: minDelTime)], separatorString: " - ")
        }else{
            return UtilityFunctions.appendOptionalStrings(withArray: [convertMinutes(minutes: minDelTime),convertMinutes(minutes: maxDelTime)], separatorString: " - ")
        }
    }
    
    func convertMinutes(minutes : Int) -> String?{
        
        let hours = minutes.toDouble / 60
        let days = hours / 24
        if hours > 23 {
            return UtilityFunctions.appendOptionalStrings(withArray: [ceil(days).toInt.toString , L10n.Days.string], separatorString: " ")
        }else if minutes > 59 {
            return UtilityFunctions.appendOptionalStrings(withArray: [ceil(hours).toInt.toString , L10n.Hours.string], separatorString: " ")
        }else {
            return UtilityFunctions.appendOptionalStrings(withArray: [minutes.toString ,L10n.Mins.string], separatorString: " ")
        }
    }
}



class SupplierListing: NSCoding {
    
    
    var suppliers : [Supplier]?
    var sponsor : Supplier?
    
    init(attributes : SwiftyJSONParameter , key : String){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[APIConstants.DataKey]
        
        let suppliers = dict[key].arrayValue
        var arraySuppliers : [Supplier] = []
        for element in suppliers{
            let supplier = Supplier(attributes: element.dictionaryValue)
            arraySuppliers.append(supplier)
        }
        self.suppliers = arraySuppliers
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(suppliers, forKey: "suppliers")
        aCoder.encode(sponsor, forKey: "sponsor")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        suppliers = aDecoder.decodeObject(forKey: "suppliers") as? [Supplier]
        sponsor = aDecoder.decodeObject(forKey: "sponsor") as? Supplier
        
    }
    
}

class Sponsor : NSCoding{
    
    var id : String?
    var logo : String?
    var name : String?
    
    init(attributes : SwiftyJSONParameter){
        self.id = attributes?[SupplierKeys.id.rawValue]?.stringValue
        self.logo = attributes?[SupplierKeys.logo.rawValue]?.stringValue
        self.name = attributes?[SupplierKeys.name.rawValue]?.stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(logo, forKey: "logo")
        aCoder.encode(name, forKey: "name")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        logo = aDecoder.decodeObject(forKey: "logo") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
    }
    
}

class Timings : NSObject, NSCoding{
    
    var start_time : String?
    var is_open : Int?
    var end_time : String?
    var week_id : Int?
    
    init(attributes : SwiftyJSONParameter){
        self.start_time = attributes?["start_time"]?.stringValue
        self.is_open = attributes?["is_open"]?.intValue
        self.end_time = attributes?["end_time"]?.stringValue
        self.week_id = attributes?["week_id"]?.intValue
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(start_time, forKey: "start_time")
        aCoder.encode(is_open, forKey: "is_open")
        aCoder.encode(end_time, forKey: "end_time")
        aCoder.encode(week_id, forKey: "week_id")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        start_time = aDecoder.decodeObject(forKey: "start_time") as? String
        is_open = aDecoder.decodeObject(forKey: "is_open") as? Int
        end_time = aDecoder.decodeObject(forKey: "end_time") as? String
        week_id = aDecoder.decodeObject(forKey: "week_id") as? Int
    }
    
}


class TimingListing {
    var arrayTimings : [Timings]?
    
    init(attributes : SwiftyJSONParameter){
        
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let products = json["timing"].arrayValue
        
        var arrayValue : [Timings] = []
        for element in products{
            let value = Timings(attributes: element.dictionaryValue)
            arrayValue.append(value)
        }
        self.arrayTimings = arrayValue
        
    }
    
}

