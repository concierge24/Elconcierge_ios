//
//  Cart.swift
//  Clikat
//
//  Created by cblmacmini on 5/11/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

typealias CartCompletionBlock = ([AnyObject]) -> ()

enum PriceType : Int {
    case Fixed = 0
    case Hourly
    case None

    func strPer(isProduct: ProductType, interVal: Double) -> String {
        var str = "" //"/ "//Nitin   //"/\(L10n.Per.string) "
        if SKAppType.type.isJNJ
        {
            str = ""
        }
        
        switch (isProduct, self) {
        case (.product, .Fixed), (.service, .Fixed) :
            str = str + L10n.EachOnly.string
            if SKAppType.type.isJNJ
            {
                str = ""
            }
            
        case (.product, .Hourly):
            str = str + L11n.hour.string
            
        case (.service, .Hourly):
            
            let hour = Int(interVal/60.0)
            let min = Int(interVal)%60
            if hour > 0 && min > 0 {
//                if hour == 1 {
//                    str = str + L11n.hour.string + " \(min) " + L10n.Mins.string
//                } else {
                    str = "\(str) / \(hour)hr \(min)min"//str + "\(hour) " + L10n.Hours.string + " \(min) " + L10n.Mins.string
//                }
            } else if hour > 0 && min == 0 {
//                if hour == 1 {
//                    str = str + L11n.hour.string
//                } else {
                    str = "\(str) / \(hour)hr" //str + "\(hour) " + L10n.Hours.string
//                }
            }  else if hour == 0 && min > 0 {
                str = "\(str) / \(min)min"//str + "\(min) " + L10n.Mins.string
            }
                    case (.service, .Fixed), (.service, .Hourly):
                        
                        let hour = Int(interVal/60.0)
                        let min = Int(interVal)%60
                        if hour > 0 && min > 0 {
            //                if hour == 1 {
            //                    str = str + L11n.hour.string + " \(min) " + L10n.Mins.string
            //                } else {
                                str = "\(str) / \(hour)hr \(min)min"//str + "\(hour) " + L10n.Hours.string + " \(min) " + L10n.Mins.string
            //                }
                        } else if hour > 0 && min == 0 {
            //                if hour == 1 {
            //                    str = str + L11n.hour.string
            //                } else {
                                str = "\(str) / \(hour)hr" //str + "\(hour) " + L10n.Hours.string
            //                }
                        }  else if hour == 0 && min > 0 {
                            str = "\(str) / \(min)min"//str + "\(min) " + L10n.Mins.string
                        }
            
        default: break
        }
        return str
    }
     func strStepperPer(isProduct: ProductType, interVal: Double) -> String {
            var str = "" //"/ "//Nitin   //"/\(L10n.Per.string) "
            if SKAppType.type.isJNJ
            {
                str = ""
            }
            
            switch (isProduct, self) {
            case (.product, .Fixed):
                str = str + L10n.EachOnly.string
                if SKAppType.type.isJNJ
                {
                    str = ""
                }
                
            case (.product, .Hourly):
                str = str + L11n.hour.string
                
            case (.service, .Fixed), (.service, .Hourly):
                
                let hour = Int(interVal/60.0)
                let min = Int(interVal)%60
                if hour > 0 && min > 0 {
    //                if hour == 1 {
    //                    str = str + L11n.hour.string + " \(min) " + L10n.Mins.string
    //                } else {
                        str = "\(str) / \(hour)hr \(min)min"//str + "\(hour) " + L10n.Hours.string + " \(min) " + L10n.Mins.string
    //                }
                } else if hour > 0 && min == 0 {
    //                if hour == 1 {
    //                    str = str + L11n.hour.string
    //                } else {
                        str = "\(str) / \(hour)hr" //str + "\(hour) " + L10n.Hours.string
    //                }
                }  else if hour == 0 && min > 0 {
                    str = "\(str) / \(min)min"//str + "\(min) " + L10n.Mins.string
                }
                
            default: break
            }
            return str
        }
}

enum ProductType : Int {
    case service = 0
    case product
}

class Cart: NSObject {
    
    //Nitin
    //Food, for pickup and delivery
    var typeId:String?
    var radius_price: Double?
    var totalQuantity: Int?
    var purchased_quantity: Int? //min max for fixed type
    var selfPickup: Int?
    var latitude: Double?
    var longitude: Double?
    
    var addOns :[AddonValueModal]?
    var isAddonAdded:Bool? = false
    var arrayAddonValue : [[AddonValueModal]]?
    var addOnId: String?
    
    var id: String?
    var dateModified: Date?
    var name: String?
    var productType: String?
    var handlingSupplier : String?
    var image : String?
    var deliveryCharges : String?
    var handlingAdmin : String?
    var supplierBranchId : String?
    var displayPrice : String?
    var measuringUnit : String?
    var sku : String?
    var canUrgent : String?
    var price: String?
    var pPrice: String?
    var loyalty_points : String?
    var supplierId : String?
    var priceType : PriceType = .None  //0 == fixed (get price from price key), 1 == hourly (calculate price from hourly_price key)
    var isProduct = ProductType.product
    var isVariant: Bool = false
    var fixedPrice : String?
    var hourlyPrice : [HourlyPrice] = []
    var duration: Int?
    var quantity: String?
    var payment_after_confirmation = false
    var distanceValue: Double = 0

//    var finalQuantity: Double {
//        if priceType == .Hourly {
//            return hourlyQuantity
//        }
//        else {
//            return quantity?.toDouble() ?? 0.0
//        }
//    }
//    var hourlyQuantity: Double {
//        let step = Int((/duration)/60)
//        return (/quantity?.toDouble())/Double(step)
//    }
//=======
//    var hourlyQuantity: Double {
//        let step = Int((/duration)/60)
//        return (/Double(/quantity))/Double(step)
//    }
//>>>>>>> 6f62af998e80b26657092ce7d5f6708b64310021
    
    var isFav: Int?
    var isFavourite: Bool {
        return isFav == 1
    }

    //Service duration for hourly service
    var totalDuration: Double {
        //for now total quantity is being stored in cart. So no need to calculate
        return (/quantity?.toDouble())*60
//        let interVal = typeDuration
//        let dur = (/quantity?.toDouble())*interVal
//        return dur
//=======
//
//        let interVal = typeDuration
//        let dur = (/Double(/quantity))*interVal
//        return dur
//>>>>>>> 6f62af998e80b26657092ce7d5f6708b64310021
    }
    
    var typeDuration: Double {
        return priceType == .Fixed ? (isProduct == .service ? AppSettings.shared.intervalServiceHourly : 60.0) : Double(/duration)
    }
    
    var strHourlyPrice : String?
    var hourlyPriceArr : [[String: Any]]?
    var urgentPrice : String?
    var urgentValue : String?
    var urgentType : String?
    
    var supplierName : String?
    
    var category : String?
    var categoryId : String?
    
    var agentList : String?
    var isAgent : String?
    var isQuantity : Int? = 1
    
    var maxQty: Double = 100.0
    var is_question: Int = 0
    var questionsSelected: [Question]?
    var prescription_required : String? = "1"
//
//    var maxQtyValue: Double {
//        if hourlyPrice.isEmpty {
//            updateHourly()
//        }
//        var pMax: Double = hourlyPrice.sorted(by: { /$0.maxHour < /$1.maxHour }).last?.maxHour ?? 100
//        if isProduct == .service {
//            pMax = (/pMax)/AppSettings.shared.intervalServiceHourly
//        } else {
//            pMax = (/pMax)/60
//        }
//        return Double(Int(pMax))
//    }
    var minQty: Double = 0
    var perAddonQuantity : Int?
    var savedAddons = [AddonsModalClass]()
    var averageRating: Int?
    var supplierAddressCart : String?
    var productDetailAddson : [ProductDetailAddonModal]?
    var deliveryMaxTime: Int?
    var selectedVariants: [ProductVariantValue]?
    // var supplierName : String?
    
    //MARK:- ======== Variables ========
    var isMax1: Bool {
        return isProduct == .product && agentList == "1" && isAgent == "1"
    }
    
    var totalMaxQuantity:Double {
        guard let qty = self.totalQuantity else {
            return 100
        }
        return Double(qty)
    }
    
    var purchasedQuantity :Double {  //Nitin
        guard let qty = self.purchased_quantity else {
            return 100
        }
        return Double(qty)
    }
    
    var valueMaxQtyLimit: Double {
 
//        let cartFlow = GDataSingleton.sharedInstance.cartFlow
//        if isMax1 {
//            return 1
//        } else if priceType == .Hourly {
//            return maxQtyValue
//        } else if cartFlow.isOneQty {
//            return 1
//        } else if SKAppType.type == .home && /isQuantity == 0 {
//            return 1
//        }

        return 100
    }
    
    func getPerPrice(block: ((Double) -> ())?) {
        
        DBManager.sharedManager.getProductToCart(productId: id) {
            [weak self]
            (products) in
            guard let self = self else { return }
            
            let currentProduct = products.first
            var quantity: Double = /Double(currentProduct?.quantity ?? "")
            if quantity < 1 {
                quantity = 1
            }
           
            let price: Double = /Double(self.getPrice(quantity: quantity) ?? "")
//            let array = self.hourlyPrice
//            
//            if self.priceType == PriceType.Hourly,
//                array.count > 0,
//                let value = array[self.getIndex(quantity: quantity)].pricePerHour
//            {
//                price = value
//            }
            block?(price)
        }
        
    }


    func getPriceLabel(block: ((String) -> ())?) {
        
        DBManager.sharedManager.getProductToCart(productId: id) {
//             [weak self]
            (products) in
//            guard let self = self else { return }
            
            let currentProduct = products.first
            var quantity: Double = /Double(currentProduct?.quantity ?? "")
            if quantity < 1 {
                quantity = 1
            }
           // let tempPrice = getDisplayPrice(quantity: 0)?.toFloat() ?? 0.0
            let price: Double = getDisplayPrice(quantity: quantity) ?? 0
            let interVal = typeDuration
            let value = UtilityFunctions.appendOptionalStrings(withArray: [price.addCurrencyLocale, self.priceType.strPer(isProduct: isProduct, interVal: interVal)])
            block?(value)
        }
    }
    
        func getCartPriceLabel(block: ((String) -> ())?) {
            
            DBManager.sharedManager.getProductToCart(productId: id) {
    //             [weak self]
                (products) in
    //            guard let self = self else { return }
                
                let currentProduct = products.first
                var quantity: Double = (/currentProduct?.quantity?.toDouble())
                if quantity < 1 {
                    quantity = 1
                }
               // let tempPrice = getDisplayPrice(quantity: 0)?.toFloat() ?? 0.0

                let price: Double = getDisplayPrice(quantity: quantity) ?? 0
                var interVal = totalDuration //typeDuration //show from cart quantity
                let value = UtilityFunctions.appendOptionalStrings(withArray: [price.addCurrencyLocale, self.priceType.strPer(isProduct: isProduct, interVal: interVal)])
                block?(value)
            }
        }
    
       
    init(attributes : SwiftyJSONParameter) {
        super.init()
        //nitin
        self.radius_price = attributes?["radius_price"]?.doubleValue
        self.prescription_required = attributes?["prescription_required"]?.stringValue
        self.totalQuantity = attributes?["quantity"]?.intValue
        self.purchased_quantity = attributes?["purchased_quantity"]?.intValue
        self.selfPickup = attributes?["selfPickup"]?.intValue
        self.isAddonAdded = attributes?[ProductKeys.isAddonAdded.rawValue]?.boolValue
        self.averageRating = attributes?[ProductKeys.avg_rating.rawValue]?.int
        
        let addonValueArray = attributes?["adds_on_value"]?.arrayValue

        if addonValueArray?.count != 0 {
            addOns = [AddonValueModal]()
            for dict in addonValueArray ?? []{
                for (key,_) in dict {
                    
                    if key == "type_name" || key == "type_id" || key == "price" || key == "name" || key == "id" {
                        
                        let value = AddonValueModal(attributes: dict.dictionaryValue)
                        addOns?.append(value)
                    }
                }
            }
        }
        
        let arr = attributes?["array_adds_on_value"]?.arrayObject
//        if arr?.count != 0 {
//            arrayAddonValue = [AddonArrayDataModel]()
//            for dict in arr ?? []{
//                let value = AddonArrayDataModel(key: nil, data: dict as? [AddonValueModal])
//                arrayAddonValue?.append(value)
//            }
//        }
//        let arr = attributes?["array_adds_on_value"]?.arrayObject
//        
//        if arr?.count != 0 {
//            arrayAddOnValue = [[AddonValueModal]]()
//            var tempArr = [AddonValueModal]()
//            if let arrayModal = arr as? [[AddonValueModal]] {
//                for addonArr in arrayModal {
//                    for dict in addonArr {
//                        tempArr.append(dict)
//                    }
//                }
//            }
//            self.arrayAddOnValue?.append(tempArr)
//        }
        self.addOnId = attributes?[ProductKeys.addOnId.rawValue]?.stringValue
        self.typeId = attributes?["typeId"]?.stringValue
        
        self.isQuantity = attributes?[ProductKeys.isQuantity.rawValue]?.int ?? 1
        self.name = attributes?[ProductKeys.name.rawValue]?.stringValue
        self.isFav = attributes?[ProductKeys.isFavourite.rawValue]?.int
        self.price = attributes?[ProductKeys.price.rawValue]?.stringValue
        self.pPrice = attributes?[ProductKeys.pPrice.rawValue]?.stringValue
        self.productType = attributes?[ProductKeys.product_type.rawValue]?.stringValue
        self.deliveryCharges = attributes?[ProductKeys.delivery_charges.rawValue]?.stringValue
        self.supplierBranchId = attributes?[ProductKeys.supplier_branch_id.rawValue]?.stringValue
        self.supplierId  = attributes?[ProductKeys.supplier_id.rawValue]?.stringValue
//        self.supName = attributes?[ProductKeys.supplier_name.rawValue]?.stringValue
        self.supplierName = attributes?[ProductKeys.supplier_name.rawValue]?.stringValue

        // print(attributes?[ProductKeys.id.rawValue]?.int)
        
        self.loyalty_points = attributes?[LoyalityPointsKeys.loyalty_points.rawValue]?.stringValue
        if let identifier = attributes?[ProductKeys.product_id.rawValue]?.stringValue {
            self.id = identifier
        } else {
            self.id = attributes?[ProductKeys.id.rawValue]?.stringValue
        }
        self.urgentValue = attributes?[ProductKeys.urgent_value.rawValue]?.stringValue
        self.handlingSupplier = attributes?[ProductKeys.handling_supplier.rawValue]?.stringValue
        self.handlingAdmin = attributes?[ProductKeys.handling_admin.rawValue]?.stringValue
        self.canUrgent = attributes?[ProductKeys.can_urgent.rawValue]?.stringValue
        self.urgentType = attributes?[ProductKeys.urgent_type.rawValue]?.stringValue
        self.urgentPrice = attributes?[ProductKeys.urgent_price.rawValue]?.stringValue
        self.priceType = PriceType(rawValue: attributes?[ProductKeys.price_type.rawValue]?.intValue ?? 0) ?? .None
        self.fixedPrice = attributes?[ProductKeys.fixed_price.rawValue]?.stringValue
        self.isVariant = attributes?[ProductKeys.isVariant.rawValue]?.int == 1

        self.agentList = attributes?[ServiceTypeKeys.agentlist.rawValue]?.stringValue
        self.duration = attributes?[ProductKeys.duration.rawValue]?.intValue
        self.isProduct = ProductType(rawValue: attributes?[ServiceTypeKeys.isProduct.rawValue]?.intValue ?? 1) ?? ProductType.product
        if urgentType == "1" {
        }
        self.distanceValue = attributes?["distance_value"]?.doubleValue ?? 0

        //to save string in core data
        self.strHourlyPrice = attributes?[ProductKeys.hourly_price.rawValue]?.rawString()
        self.hourlyPriceArr = attributes?[ProductKeys.hourly_price.rawValue]?.arrayObject as? [[String : Any]]//attributes?[ProductKeys.hourly_price.rawValue]?.rawString()
        let tempPrice = getDisplayPrice(quantity: 0) ?? 0.0
        self.displayPrice = String(tempPrice)
        
        hourlyPrice = []
        self.updateHourly()
        
        if let image = attributes?[ProductKeys.product_image.rawValue]?.stringValue {
            self.image = image
        }
        else if let productImages = attributes?[ProductKeys.image_path.rawValue]?.arrayValue, productImages.count > 0 {
            self.image = productImages.first?.stringValue
        }
        else {
            self.image = attributes?[ProductKeys.image_path.rawValue]?.stringValue
        }
        self.deliveryMaxTime = attributes?[ProductKeys.deliveryMaxTime.rawValue]?.int
        is_question = attributes?["is_question"]?.int ?? 0
        payment_after_confirmation = (attributes?["payment_after_confirmation"]?.int ?? 0) == 1
    }
    
    func updateHourly() {
        var varMax: Double = 100.0
//        var varMinValue: Double = 0.0
        
        if self.priceType == .Hourly {
            //from core data hourlyPrice array is already set, just set min max value
            if hourlyPrice.isEmpty {
                varMax = 1
                //            var arrayP: [[String:String]] = []
                
                //            var varMin: Double = 0
                var priceArr: [[String: Any]] = hourlyPriceArr as? [[String : Any]] ?? []
                
                if  priceArr.isEmpty,
                    let arry = price?.parseJSONString as? [[String:String]]
                {
                    priceArr = arry
                } else if priceArr.isEmpty,
                    let arry = pPrice?.parseJSONString as? [[String:String]]
                {
                    priceArr = arry
                }
                
                for price in  priceArr {
                    let tempPrice = HourlyPrice(dict: price)
                    let pMax = /tempPrice.maxHour
                    let pMin = /tempPrice.minHour
                    //                if isProduct == .product {
                    //                    pMax = (/pMax)/AppSettings.shared.intervalServiceHourly
                    //                    pMin = (/pMin)/AppSettings.shared.intervalServiceHourly
                    //                    //                        tempPrice.qtyUpdateBY(interVal: GDataSingleton.sharedInstance.intervalServiceHourly)
                    //                } else {
                    //                    pMax = (/pMax)/60
                    //                    pMin = (/pMin)/60
                    //                }
                    
                    if varMax < pMax {
                        varMax = pMax
                    }
                    //
                    //                if varMin == 0 || varMin > pMin {
                    //                    varMin = pMin
                    //                }
                    hourlyPrice.append(tempPrice)
            }
            
            }
            else {
                for price in  hourlyPrice {
                    let pMax = /price.maxHour
                    if varMax < pMax {
                        varMax = pMax
                    }
                }
            }
//            varMinValue = varMin
        }
        if SKAppType.type.isHome {
            if let d = duration, d > 0 {
                minQty = Double(d)/60.0//varMinValue
                let maxStep = Int(varMax/Double(d))
                maxQty = minQty * Double(maxStep)
                if maxQty * 60 >= varMax {
                    maxQty = maxQty - minQty
                }
            }
            else {
                print("duration ")
            }
        }
    
    }
//    func updateHourly() {
//        var varMax: Double = 100.0
//        var varMinValue: Double = 0.0
//
//        if self.priceType == .Hourly {
//            varMax = 1
//
//            var varMin: Double = 0
//
//            if  hourlyPrice.isEmpty,
//                let arry = price?.parseJSONString as? [[String:String]]
//            {
//                for price in arry {
//                    let tempPrice = HourlyPrice(dict: price)
//                    hourlyPrice.append(tempPrice)
//                }
//            }
//
//            for tempPrice in hourlyPrice {
//
//                var pMax = /tempPrice.maxHour
//                var pMin = /tempPrice.minHour
//                if isProduct == .service {
//                    pMax = (/pMax)/AppSettings.shared.intervalServiceHourly
//                    pMin = (/pMin)/AppSettings.shared.intervalServiceHourly
//                    //                        tempPrice.qtyUpdateBY(interVal: GDataSingleton.sharedInstance.intervalServiceHourly)
//                } else {
//                    pMax = (/pMax)/60
//                    pMin = (/pMin)/60
//                }
//
//                if varMax < pMax {
//                    varMax = pMax
//                }
//
//                if varMin == 0 || varMin > pMin {
//                    varMin = pMin
//                }
//
//            }
//            varMinValue = varMin
//        }
//
//        maxQty = varMax
//        minQty = varMinValue
//    }
    
    override init() {
        super.init()
    }
    
    class func initializePriceArray(rawStr : String?) -> [HourlyPrice]? {
        
        guard let jsonstr = rawStr?.parseJSONString else { return [] }
        let json = JSON(jsonstr)
        var arrPrice : [HourlyPrice] = []
        for price in json.arrayValue {
            let tempPrice = HourlyPrice(dict: price.dictionaryObject)
            arrPrice.append(tempPrice)
        }
        return arrPrice
    }
    
    func getDisplayPriceStr(quantity : Double?) -> String? {
        var addOnPriceTotal: Double = 0
//        arrayAddonValue?.forEach { (arr) in
//            arr.forEach { (model) in
//                if let addonPrice = model.price?.toDouble(){
//                   addOnPriceTotal += (addonPrice * /quantity)
//               }
//            }
//        }
        
        return getDisplayPrice(quantity: quantity)?.toString
    }
    
     func getDisplayPrice(quantity : Double?) -> Double? {
            var addOnPriceTotal: Double = 0
            switch priceType {
            case .Fixed:
                let price = (((Double(/fixedPrice) ?? 0) * (quantity ?? 1)) + addOnPriceTotal)
                return price
            case .Hourly:
                if hourlyPrice.count <= 0 { print("Hourly price nahi hai"); return fixedPrice?.toDouble() }
                guard let price = hourlyPrice[getIndex(quantity: quantity)].pricePerHour else { return nil }
                return price
            default:
                return nil
            }
        }
    
    func getPrice(quantity : Double?) -> String? {
        switch priceType {
        case .Fixed:
            return fixedPrice
        case .Hourly:
            if hourlyPrice.count <= 0 { print("Hourly price nahi hai"); return fixedPrice }
            guard let price = hourlyPrice[getIndex(quantity: quantity)].pricePerHour else { return nil }
            return price.toString
        default:
            return nil
        }
    }
    
    var stepValue: Double {
        return (priceType == PriceType.Hourly ? Double(/duration) : (isProduct == .service ? AppSettings.shared.intervalServiceHourly : 60.0))/60.0
    }
    
    func getPrice() -> Double? {
        switch priceType {
        case .Fixed:
            return Double(/fixedPrice)
        case .Hourly:
            if hourlyPrice.count <= 0 { print("Hourly price nahi hai"); return Double(/fixedPrice) }
            guard let price = hourlyPrice[getIndex(quantity: 1)].pricePerHour else { return nil }
            return price
        default:
            return nil
        }
    }
    
    func getIndex(quantity : Double?) -> Int {
        let array = hourlyPrice
        let qty = quantity ?? 0
        var priceIndex: Int = 0
        for (index,element) in (array).enumerated() {
            
//            var min = /element.minHour
//            var max = /element.maxHour
            var interVal = 60.0

            if isProduct == .product {
                interVal = AppSettings.shared.intervalServiceHourly
            }
//
//            min = (/min)/interVal
//            max = (/max)/interVal
//
//            if min...max ~= quantity ?? 0 {
//                priceIndex = index
//                break
//            }
            
            if (qty * interVal) >= /element.minHour && (qty * interVal) < /element.maxHour {
                priceIndex = index
                               break
            }
        }
        return priceIndex
    }
    
    class func getMaxSupplier(cart : [Cart]) -> String?{
        var maxSupplier : Int = 0
        for product in cart {
            guard let supplier = product.handlingSupplier?.toInt() else { return "0" }
            maxSupplier = maxSupplier > supplier ? maxSupplier : supplier
        }
        return maxSupplier.toString
        
    }
    
//    class func getMaxAdmin(cart : [Cart]) -> String?{
//        var maxAdmin : Double = 0
//        for product in cart {
//            guard let admin = product.handlingAdmin?.toDouble() else { return nil }
//            maxAdmin = maxAdmin > admin ? maxAdmin : admin
//        }
//        return maxAdmin.toString
//    }

    class var totalTax : String?{
        get{
            return UserDefaults.standard.object(forKey: "totalTax") as? String
        }
        set{
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: "totalTax")
            }else{
                UserDefaults.standard.removeObject(forKey: "totalTax")
            }
        }
    }
    static var subTotal: Double?
}

class PackageProduct : ProductF {
    
    override init(attributes : SwiftyJSONParameter) {
        super.init(attributes: attributes)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HourlyPrice {
    
    var minHour : Double?
    var maxHour : Double?
    var pricePerHour : Double?
    var pricePerHourOffer : Double?
    var isOffer = false
//    init(attributes : SwiftyJSONParameter){
//        if let double = attributes?[ProductKeys.min_hour.rawValue]?.doubleValue {
//            minHour = double
//        }
//        else {
//            minHour = attributes?[ProductKeys.min_hour.rawValue]?.string?.toDouble()
//        }
//        if let double = attributes?[ProductKeys.max_hour.rawValue]?.doubleValue {
//            maxHour = double
//        }
//        else {
//            maxHour = attributes?[ProductKeys.max_hour.rawValue]?.string?.toDouble()
//        }
//        if let double = attributes?[ProductKeys.price_per_hour.rawValue]?.doubleValue {
//            pricePerHour = double
//        }
//        else {
//            pricePerHour = attributes?[ProductKeys.price_per_hour.rawValue]?.string?.toDouble()
//        }
//    }
    
    init(dict : [String: Any]?){
        if let double = dict?[ProductKeys.min_hour.rawValue] as? Double {
            minHour = double
        }
        else {
            minHour = Double(dict?[ProductKeys.min_hour.rawValue] as? String ?? "")
        }
        if let double = dict?[ProductKeys.max_hour.rawValue] as? Double {
            maxHour = double
        }
        else {
            maxHour = Double(dict?[ProductKeys.max_hour.rawValue] as? String ?? "")
        }
        var discountPrice: Double?
        if let double = dict?[ProductKeys.discount_price.rawValue] as? Double {
            discountPrice = double
        }
        else {
            discountPrice = Double(dict?[ProductKeys.discount_price.rawValue] as? String ?? "")
        }
        var price: Double?
        if let double = dict?[ProductKeys.price_per_hour.rawValue] as? Double {
            price = double
        }
        else {
            price = Double(dict?[ProductKeys.price_per_hour.rawValue] as? String ?? "")
        }
        if /discountPrice > 0 && discountPrice != price {
            isOffer = true
            pricePerHour = discountPrice
            pricePerHourOffer = price
        }
        else {
            pricePerHour = price
        }
//        minHour = dict?[ProductKeys.min_hour.rawValue]?.toDouble()
//        maxHour = dict?[ProductKeys.max_hour.rawValue]?.toDouble()
//        pricePerHour = dict?[ProductKeys.price_per_hour.rawValue]?.toDouble()
    }
    
    func qtyUpdateBY(interVal: Double) {
        
        minHour = (/minHour)/interVal
        maxHour = (/maxHour)/interVal
        
    }
}
