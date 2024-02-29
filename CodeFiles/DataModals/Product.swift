//
//  Product.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper
import EZSwiftExtensions

enum ProductKeys : String {
    
    // Inner Packet
    case detailed_sub_category_id = "detailed_sub_category_id"
    case id = "id"
    case product_id = "product_id"
    case bar_code = "bar_code"
    case sku = "sku"
    case detailed_name = "detailed_name"
    case name = "name"
    case isQuantity = "is_quantity"
    case isFavourite = "is_favourite"
    case product_desc = "product_desc"
    case image_path = "image_path"
    case price = "price"
    case pPrice = "p_price"
    case delivery_charges = "delivery_charges"
    case is_package = "is_package"
    case commission = "commission"
    case commission_type = "commission_type"
    case display_price = "display_price"
    case handling = "handling"
    case handling_supplier = "handling_supplier"
    case can_urgent = "can_urgent"
    case urgent_price = "urgent_price"
    case urgent_type = "urgent_type"
    case urgent_value = "urgent_value"
    
    case product_type = "product_type"
    case handling_admin = "handling_admin"
    case measuring_unit = "measuring_unit"
    case supplier_branch_id = "supplier_branch_id"
    case product = "product"
    case DetailSubName = "DetailSubName"
    case quantity = "quantity"
    //Laundry
    case charges_below_min_order = "charges_below_min_order"
    case min_order = "min_order"
    case category_id = "category_id"
    case sub_category_id = "sub_category_id"
    
    case fixed_price = "fixed_price"
    case isVariant = "is_variant"
    case hourly_price = "hourly_price"
    case price_type = "price_type"
    case min_hour = "min_hour"
    case max_hour = "max_hour"
    case price_per_hour = "price_per_hour"
    case discount_price = "discount_price"
    case supplier_name = "supplier_name"
    case product_image = "product_image"
    case supplier_id = "supplier_id"
    case variants = "variants"
    case rating = "rating"
    case avg_rating = "avg_rating"
    case total_reviews = "total_reviews"
    case brandname = "brand_name"
    case agentlist = "agent_list"
    case isAgent = "is_agent"
    case duration
    case isAddonAdded
    case addOnId
    case radius_price
    case deliveryMaxTime = "delivery_max_time"
    case questions
    case supplier
}

class ProductF : Cart, RMMapping, NSCoding {
    
    var detailedSubCatId : String?
    var barCode : String?
    
    var detailedName : String?
    var desc : String?
    var images : [String]?
    var isPackage : String?
    var commission : String?
    var commissionType : String?
    var handling : String?
    
    var supplierid : String?
//    var supplierName : String?
    var brandname : String?
    
    //Rating&Review
    var ratingModel : [RatingModel]!
    var totalReview : Int!
    var variants : [ProductVariantModel]?
    
   
    //Laundry
    var subCategoryId : String?
    var chargesBelowMinimumOrder : String?
    var minOrder : String?
    
    //Offers
    var offerPrice : String?
    var isOffer : Bool? = false
    var actualPrice: Double?
    
    //Nitin Check
    var logo: String?
    var supplier_image: String?
    var is_product_adds_on: Int?
    var adds_on: [CartDataModal]?
    var addOnValue : [AddonValueModal]?
    var selectedIndexModal: [IndexPath]?
    var product_id : String?
    var isAddon : Bool? = false
    var arrayAddOnValue : [[AddonValueModal]]?
    var self_pickup: Int?
    var supplierAddrerss : String?
    
    //Rental
    var interval_flag : Int?
    var interval_value: Int?
    var image_path : String?
    var supplier_address : String?
    var hourly_price : [HourlyPriceModal]?   //priceType == fixed (get price from price key), priceType == hourly (calculate price from hourly_price key)
    var required_day : Int?
    var required_hour : Int?
    var type: Int? //Doctor
    var cart_image_upload: String?
    var order_instructions: String?
    var is_quantity: Int?
    var recipe_pdf : String?
    var order_price_id: Int?
    var return_data : [ReturnStatus]?
    var isRated: Int = 0
    var detailed_sub_category_id: Int?
    // is_quantity == 1 > add/remove, 0 > + -

    override init (attributes : SwiftyJSONParameter) {
        
        super.init(attributes: attributes)
        var arrayReturnData : [ReturnStatus] = []
        for element in attributes?["return_data"]?.arrayValue ?? [] {
            let obj = ReturnStatus(attributes: element.dictionaryValue)
            arrayReturnData.append(obj)
        }
        self.return_data = arrayReturnData

        self.order_price_id = attributes?["order_price_id"]?.intValue
        self.recipe_pdf = attributes?["recipe_pdf"]?.stringValue
        self.purchased_quantity = attributes?["purchased_quantity"]?.intValue
        self.totalQuantity = attributes?["quantity"]?.intValue
        
        self.latitude = attributes?["latitude"]?.doubleValue
        self.longitude = attributes?["longitude"]?.doubleValue
        self.deliveryMaxTime = attributes?["delivery_max_time"]?.intValue
        self.handlingAdmin = attributes?["handling_admin"]?.stringValue
        self.deliveryCharges = "\(/attributes?["delivery_charges"]?.intValue)"

        self.self_pickup = attributes?["self_pickup"]?.intValue

        self.interval_flag = attributes?["interval_flag"]?.intValue
        self.interval_value = attributes?["interval_value"]?.intValue
        self.image_path = attributes?["image_path"]?.stringValue
        self.name = attributes?["name"]?.stringValue
        self.supplier_address = attributes?["supplier_address"]?.stringValue
        self.required_day = attributes?["required_day"]?.intValue
        self.required_hour = attributes?["required_hour"]?.intValue

        //Nitin Check
        self.logo = attributes?["logo"]?.stringValue
        self.supplier_image = attributes?["supplier_image"]?.stringValue
        self.is_product_adds_on = attributes?["is_product_adds_on"]?.intValue
        self.isAddon = attributes?["isAddon"]?.boolValue
        self.product_id = attributes?["product_id"]?.stringValue
        self.addOnId = attributes?["addOnId"]?.stringValue
        self.isRated = attributes?["is_rated"]?.intValue ?? 0
        self.distanceValue = attributes?["distance_value"]?.doubleValue ?? 0
        self.detailed_sub_category_id = attributes?["detailed_sub_category_id"]?.intValue
        
        let hourlyPriceJSON = attributes?["hourly_price"]?.arrayValue
        
        if hourlyPriceJSON?.count != 0 {
            hourly_price = [HourlyPriceModal]()
            for dict in hourlyPriceJSON ?? []{
                let value = HourlyPriceModal(attributes: dict.dictionaryValue)
                hourly_price?.append(value)
            }
        }
        
        let selectedIndex = attributes?["selectedIndexModal"]?.arrayObject
      
        if let index = selectedIndex as? [IndexPath] {
            if index.count != 0 {
                selectedIndexModal = [IndexPath]()
                for dict in index {
                    self.selectedIndexModal?.append(dict)
                }
            }
        }
        
        let addonArray = attributes?["adds_on"]?.arrayValue
        
        if addonArray?.count != 0 {
            adds_on = [CartDataModal]()
            for dict in addonArray ?? []{
                let value = CartDataModal(attributes: dict.dictionaryValue)
                adds_on?.append(value)
            }
        }
        
        if addonArray?.count != 0 {
            productDetailAddson = [ProductDetailAddonModal]()
            for dict in addonArray ?? []{
                let value = ProductDetailAddonModal(attributes: dict.dictionaryValue)
                productDetailAddson?.append(value)
            }
        }
        
        let addonValueArray = attributes?["adds_on_value"]?.arrayValue
        
        if addonValueArray?.count != 0 {
            addOnValue = [AddonValueModal]()
            for dict in addonValueArray ?? []{
                for (key,_) in dict {
                    
                    if key == "type_name" || key == "type_id" || key == "price" || key == "name" || key == "id" {
                        
                        let value = AddonValueModal(attributes: dict.dictionaryValue)
                        addOnValue?.append(value)
                        
                    }
                }
            }
        }
        
        let arr = attributes?["array_adds_on_value"]?.arrayObject
//        if arr?.count != 0 {
//            arrayAddOnValue = [AddonArrayDataModel]()
//            for dict in arr ?? []{
//                let value = AddonArrayDataModel(key: nil, data: dict as? [AddonValueModal])
//                arrayAddOnValue?.append(value)
//            }
//        }
      //  let arr = attributes?["array_adds_on_value"]?.arrayObject
       
        if arr?.count != 0 {
            arrayAddonValue = [[AddonValueModal]]()
            var tempArr = [AddonValueModal]()
            if let arrayModal = arr as? [[AddonValueModal]] {
                for addonArr in arrayModal {
                    for dict in addonArr {
                        tempArr.append(dict)
                    }
                }
            }
            if tempArr.count>0 {
                self.arrayAddonValue?.append(tempArr)
            }
        }
        
        self.detailedSubCatId = attributes?[ProductKeys.detailed_sub_category_id.rawValue]?.stringValue
        self.barCode = attributes?[ProductKeys.bar_code.rawValue]?.stringValue
        self.sku = attributes?[ProductKeys.sku.rawValue]?.stringValue
        self.detailedName = attributes?[ProductKeys.detailed_name.rawValue]?.stringValue
        self.desc = attributes?[ProductKeys.product_desc.rawValue]?.stringValue
        self.isPackage = attributes?[ProductKeys.is_package.rawValue]?.stringValue
        self.commission = attributes?[ProductKeys.commission.rawValue]?.stringValue
        self.commissionType = attributes?[ProductKeys.commission_type.rawValue]?.stringValue
        self.offerPrice = attributes?[ProductKeys.display_price.rawValue]?.stringValue
        self.handling = attributes?[ProductKeys.handling.rawValue]?.stringValue
        self.measuringUnit = attributes?[ProductKeys.measuring_unit.rawValue]?.stringValue
        self.chargesBelowMinimumOrder = attributes?[ProductKeys.charges_below_min_order.rawValue]?.stringValue
        self.minOrder = attributes?[ProductKeys.min_order.rawValue]?.stringValue
        self.categoryId = attributes?[ProductKeys.category_id.rawValue]?.stringValue
        self.subCategoryId = attributes?[ProductKeys.sub_category_id.rawValue]?.stringValue
        self.productType = attributes?[ProductKeys.product_type.rawValue]?.stringValue
        self.totalReview = attributes?[ProductKeys.total_reviews.rawValue]?.int
        self.brandname = attributes?[ProductKeys.brandname.rawValue]?.string
        
        self.agentList = attributes?[ProductKeys.agentlist.rawValue]?.int?.toString
        self.isAgent = attributes?[ProductKeys.isAgent.rawValue]?.int?.toString

        let variantsArray = attributes?[ProductKeys.variants.rawValue]?.arrayValue
        
        if variantsArray?.count != 0 {
             variants = [ProductVariantModel]()
            for dict in variantsArray ?? []{
                let value = ProductVariantModel(fromDictionary: dict.dictionaryObject ?? [:])
                variants?.append(value)
            }
        }
        
        ratingModel = [RatingModel]()
        let ratingArray = attributes?[ProductKeys.rating.rawValue]?.arrayValue
        
        for dict in ratingArray ?? []{
            let rating = RatingModel(fromDictionary: dict.dictionaryObject ?? [:])
            ratingModel?.append(rating)
        }
        
        self.supplierid = attributes?[ProductKeys.supplier_id.rawValue]?.stringValue
        
        isOffer = false
        if priceType == .Hourly {
            if hourlyPrice.count > 0 {
                let obj = hourlyPrice[getIndex(quantity: 1)]
                if obj.isOffer {
                    isOffer = true
                    actualPrice = obj.pricePerHourOffer
                }
            }
        }
        else {
            //(self.offerPrice?.toDouble() ?? 0.0) > (self.displayPrice?.toDouble() ?? 0.0)
             
            if Double(/offerPrice) != Double(/price) {
                isOffer = true
            }
            actualPrice = Double(/offerPrice)
        }

//        if hourlyPrice.count <= 0 { print("Hourly price nahi hai"); return fixedPrice }
//                   guard let price = hourlyPrice[getIndex(quantity: quantity)].pricePerHour else { return nil }
        
        
        if let quantity = attributes?[ProductKeys.quantity.rawValue]?.stringValue {
            self.quantity = quantity
        }else {
            updateValuesFromDB()
        }
        
        if let productImages = attributes?[ProductKeys.image_path.rawValue]?.arrayValue, productImages.count > 0 {
            var tempImages : [String] = []
            for image in productImages {
                tempImages.append(/image.stringValue)
            }
            self.images = tempImages
        } else {
            self.images = [/attributes?[ProductKeys.image_path.rawValue]?.stringValue]
        }
        
        var variants: [ProductVariantValue] = []
        for element in attributes?[OrderRelatedKeys.prod_variants.rawValue]?.arrayValue ?? [] {
            let variant =  ProductVariantValue(fromDictionary: element.dictionaryObject ?? [:])
            variants.append(variant)
        }
        if variants.count > 0 {
            self.selectedVariants = variants
        }
        is_question = attributes?["is_question"]?.int ?? 0
        type = attributes?["type"]?.int
        is_quantity = attributes?["is_quantity"]?.int ?? 0
        cart_image_upload = attributes?["cart_image_upload"]?.stringValue
        order_instructions = attributes?["order_instructions"]?.stringValue
    }
    
    override init(){
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
     //  print(supplierid)
        
        //Nitin
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(latitude, forKey: "latitude")

        aCoder.encode(self_pickup, forKey: "self_pickup")

        aCoder.encode(interval_flag, forKey: "interval_flag")
        aCoder.encode(interval_value, forKey: "interval_value")
        
        aCoder.encode(logo, forKey: "logo")
        aCoder.encode(supplier_image, forKey: "supplier_image")
        aCoder.encode(is_product_adds_on, forKey: "is_product_adds_on")
        aCoder.encode(adds_on, forKey: "adds_on")
        aCoder.encode(addOnValue, forKey: "addOnValue")
        aCoder.encode(selectedIndexModal, forKey: "selectedIndexModal")
        aCoder.encode(isAddon, forKey: "isAddon")
        //aCoder.encode(arrayAddonValue, forKey: "array_adds_on_value")
        aCoder.encode(addOnId, forKey: "addOnId")


        aCoder.encode(supplierid, forKey: "supplier_id")
        aCoder.encode(detailedSubCatId, forKey: "detailedSubCatId")
        aCoder.encode(barCode, forKey: "barCode")
        aCoder.encode(detailedName, forKey: "detailedName")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(images, forKey: "images")
        
        aCoder.encode(isPackage, forKey: "isPackage")
        aCoder.encode(commission, forKey: "commission")
        aCoder.encode(commissionType, forKey: "commissionType")
        aCoder.encode(handling, forKey: "handling")
        
        aCoder.encode(subCategoryId, forKey: "subCategoryId")
        aCoder.encode(chargesBelowMinimumOrder, forKey: "chargesBelowMinimumOrder")
        
        aCoder.encode(minOrder, forKey: "minOrder")
        aCoder.encode(offerPrice, forKey: "offerPrice")
        aCoder.encode(supplierName, forKey: "supplierName")
        aCoder.encode(isOffer, forKey: "isOffer")
        aCoder.encode(variants, forKey: ProductKeys.variants.rawValue)
        aCoder.encode(ratingModel, forKey: ProductKeys.rating.rawValue)
        aCoder.encode(totalReview, forKey: ProductKeys.total_reviews.rawValue)
        aCoder.encode(brandname, forKey: ProductKeys.brandname.rawValue)
        aCoder.encode(distanceValue, forKey: "distanceValue")
        aCoder.encode(detailed_sub_category_id, forKey: "detailed_sub_category_id")
        
  
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init()
        //Nitin
        
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double

        self_pickup = aDecoder.decodeObject(forKey: "self_pickup") as? Int

        interval_value = aDecoder.decodeObject(forKey: "interval_value") as? Int
        interval_flag = aDecoder.decodeObject(forKey: "interval_flag") as? Int

        addOnId = aDecoder.decodeObject(forKey: "addOnId") as? String

        logo = aDecoder.decodeObject(forKey: "logo") as? String
        supplier_image = aDecoder.decodeObject(forKey: "supplier_image") as? String
        is_product_adds_on = aDecoder.decodeObject(forKey: "is_product_adds_on") as? Int
        adds_on = aDecoder.decodeObject(forKey: "adds_on") as? [CartDataModal]
        addOnValue = aDecoder.decodeObject(forKey: "addOnValue") as? [AddonValueModal]
        selectedIndexModal = aDecoder.decodeObject(forKey: "selectedIndexModal") as? [IndexPath]
        isAddon = aDecoder.decodeObject(forKey: "isAddon") as? Bool
       // arrayAddonValue = aDecoder.decodeObject(forKey: "array_adds_on_value") as? [AddonArrayDataModel]

        detailedSubCatId = aDecoder.decodeObject(forKey: "detailedSubCatId") as? String
        barCode = aDecoder.decodeObject(forKey: "barCode") as? String
        detailedName = aDecoder.decodeObject(forKey: "detailedName") as? String
        desc = aDecoder.decodeObject(forKey: "desc") as? String
        supplierid = aDecoder.decodeObject(forKey: "supplier_id") as? String
        
        images = aDecoder.decodeObject(forKey: "images") as? [String]
        
        isPackage = aDecoder.decodeObject(forKey: "isPackage") as? String
        commission = aDecoder.decodeObject(forKey: "commission") as? String
        commissionType = aDecoder.decodeObject(forKey: "commissionType") as? String
        handling = aDecoder.decodeObject(forKey: "handling") as? String
        subCategoryId = aDecoder.decodeObject(forKey: "subCategoryId") as? String
        
        chargesBelowMinimumOrder = aDecoder.decodeObject(forKey: "chargesBelowMinimumOrder") as? String
        minOrder = aDecoder.decodeObject(forKey: "minOrder") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offerPrice") as? String
        supplierName = aDecoder.decodeObject(forKey: "supplierName") as? String
        isOffer = aDecoder.decodeObject(forKey: "isOffer") as? Bool
        variants = aDecoder.decodeObject(forKey :ProductKeys.variants.rawValue) as? [ProductVariantModel]
        ratingModel = aDecoder.decodeObject(forKey :ProductKeys.rating.rawValue) as? [RatingModel]
        totalReview = aDecoder.decodeObject(forKey :ProductKeys.total_reviews.rawValue) as? Int
        brandname = aDecoder.decodeObject(forKey: ProductKeys.brandname.rawValue) as? String
        distanceValue = aDecoder.decodeObject(forKey: "distanceValue") as? Double ?? 0
        detailed_sub_category_id = aDecoder.decodeObject(forKey: "detailed_sub_category_id") as? Int
    }
    
    init(cart : Cart?) {
        super.init()
        
        radius_price = cart?.radius_price
        latitude = cart?.latitude
        longitude = cart?.longitude
        
        totalQuantity = cart?.totalQuantity
        purchased_quantity = cart?.purchased_quantity
        selfPickup = cart?.selfPickup
        id = cart?.id
        name = cart?.name
        image = cart?.image
        quantity = cart?.quantity
        handlingSupplier = cart?.handlingSupplier
        handlingAdmin = cart?.handlingAdmin
        price = cart?.price
        pPrice = cart?.pPrice
        hourlyPrice = cart?.hourlyPrice ?? []
        
        deliveryCharges = cart?.deliveryCharges
        supplierBranchId = cart?.supplierBranchId
        displayPrice = cart?.displayPrice
        sku = cart?.sku
        measuringUnit = cart?.measuringUnit
        isQuantity = cart?.isQuantity
        canUrgent = cart?.canUrgent
        priceType = cart?.priceType ?? .None
        strHourlyPrice = cart?.strHourlyPrice
        fixedPrice = cart?.fixedPrice
        urgentType = cart?.urgentType
        urgentValue = cart?.urgentValue
        category = cart?.category
        categoryId = cart?.categoryId
        supplierId = cart?.supplierId
        supplierName = cart?.supplierName
        agentList =  cart?.agentList
        isAgent =  cart?.isAgent
        duration =  cart?.duration

        priceType =  cart?.priceType ?? .Fixed
        isProduct =  cart?.isProduct ?? .product
        addOnValue = cart?.addOns
        product_id = cart?.id
        isAddonAdded = cart?.isAddonAdded
        arrayAddonValue = cart?.arrayAddonValue
        addOnId = cart?.addOnId
        typeId = cart?.typeId
        perAddonQuantity = cart?.perAddonQuantity
        savedAddons = cart?.savedAddons ?? []
        averageRating = cart?.averageRating ?? 0
        supplierAddressCart = cart?.supplierAddressCart
        productDetailAddson = cart?.productDetailAddson
        deliveryMaxTime = cart?.deliveryMaxTime
        selectedVariants = cart?.selectedVariants
        questionsSelected = cart?.questionsSelected
        distanceValue = cart?.distanceValue ?? 0
        updateHourly()

    }

    func updateValuesFromDB(){
        DBManager.sharedManager.getCart {
            [weak self] (array) in
            guard let self = self else { return }
            
            for product in array {
                let isSameSuplier = self.isSameSupplierId(currentSupplierId: self.supplierBranchId)
                
                guard let currentProduct = product as? Cart else { return }
                
                if currentProduct.id == self.id  && isSameSuplier
                {
                    self.quantity = currentProduct.quantity
                    self.dateModified = currentProduct.dateModified
                }
            }
        }
    }
    
    func isSameSupplierId(currentSupplierId : String?) -> Bool {
        guard let suppId = GDataSingleton.sharedInstance.currentSupplierId else {
            return true
        }
        if currentSupplierId == nil {
            return true
        }
        return suppId == currentSupplierId ? true : false
    }
    
    func openDetail() {
        
        let productDetailVc = ProductVariantVC.getVC(.main)
        productDetailVc.is_question = is_question
        productDetailVc.passedData.productId = id
        productDetailVc.suplierBranchId = supplierBranchId
        ez.topMostVC?.pushVC(productDetailVc)
        
    }
}

class CartDataModal: NSObject,NSCoding {
    
    var is_multiple: String?
    var name : String?
    var value : [AddonValueModal]?
    var addon_limit :String?
    
    init(is_multiple:String?,name: String?,value: [AddonValueModal]?, addon_limit:String?) {
        self.is_multiple = is_multiple
        self.name = name
        self.value = value
        self.addon_limit = addon_limit
    }
    
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        self.name = rawData["name"]?.stringValue
        self.is_multiple = rawData["is_multiple"]?.stringValue
        self.addon_limit = rawData["addon_limit"]?.stringValue

        let json = JSON(rawData)
        let products = json["value"].arrayValue
        
        var arrayValue : [AddonValueModal] = []
        for element in products{
            let value = AddonValueModal(attributes: element.dictionaryValue)
            arrayValue.append(value)
        }
        self.value = arrayValue

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "strTitle")
        aCoder.encode(value, forKey: "value")
        aCoder.encode(is_multiple, forKey: "is_multiple")
        aCoder.encode(addon_limit, forKey: "addon_limit")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        value = aDecoder.decodeObject(forKey: "value") as? [AddonValueModal]
        is_multiple = aDecoder.decodeObject(forKey: "is_multiple") as? String
        addon_limit = aDecoder.decodeObject(forKey: "addon_limit") as? String

    }
    
}

class AddonValueModal: NSObject,NSCoding  {
    
    var is_default : String?
    var max_adds_on : String?
    var min_adds_on : String?
    var price : String?
    var id : String?
    var is_multiple : String?
    var name : String?
    var type_name : String?
    var type_id : String?
    var add_on_id_ios : String?
    var selectedQuantity = "1"
    var adds_on_type_quantity : String?
    init(price: String?,id: String?,name:String?,type_name:String?,type_id:String?,add_on_id_ios: String?){
        
        self.price = price
        self.id = id
        self.name = name
        self.type_name = type_name
        self.type_id = type_id
        self.add_on_id_ios = add_on_id_ios
    }
    
    init(attributes : SwiftyJSONParameter){
        
        self.is_default = attributes?["is_default"]?.stringValue
        self.max_adds_on = attributes?["addon_limit"]?.stringValue//attributes?["max_adds_on"]?.stringValue
        self.min_adds_on = "0"//attributes?["min_adds_on"]?.stringValue
        self.price = attributes?["price"]?.stringValue
        self.id = attributes?["id"]?.stringValue
        self.is_multiple = attributes?["is_multiple"]?.stringValue
        self.name = attributes?["name"]?.stringValue
        self.type_name = attributes?["type_name"]?.stringValue
        self.type_id = attributes?["type_id"]?.stringValue
        self.adds_on_type_quantity = attributes?["adds_on_type_quantity"]?.stringValue

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(add_on_id_ios, forKey: "add_on_id_ios")
        aCoder.encode(is_default, forKey: "is_default")
        aCoder.encode(max_adds_on, forKey: "max_adds_on")
        aCoder.encode(min_adds_on, forKey: "min_adds_on")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(is_multiple, forKey: "is_multiple")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type_name, forKey: "type_name")
        aCoder.encode(type_id, forKey: "type_id")
        aCoder.encode(adds_on_type_quantity, forKey: "adds_on_type_quantity")

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        add_on_id_ios = aDecoder.decodeObject(forKey: "add_on_id_ios") as? String
        is_default = aDecoder.decodeObject(forKey: "is_default") as? String
        max_adds_on = aDecoder.decodeObject(forKey: "max_adds_on") as? String
        min_adds_on = aDecoder.decodeObject(forKey: "min_adds_on") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        is_multiple = aDecoder.decodeObject(forKey: "is_multiple") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        type_name = aDecoder.decodeObject(forKey: "type_name") as? String
        type_id = aDecoder.decodeObject(forKey: "type_id") as? String
        adds_on_type_quantity = aDecoder.decodeObject(forKey: "adds_on_type_quantity") as? String

    }
    
}

class ProductDetailAddonModal: NSObject,NSCoding  {
    
    var id : String?
    var adds_on_name : String?
    var cart_id : String?
    var quantity : Int?
    var adds_on_type_jd : String?
    var serial_number : Int?
    var adds_on_id : String?
    var adds_on_type_name : String?
    var price : String?
    var add_on_id_ios : String?
    var adds_on_type_quantity : String?
    
    init(attributes : SwiftyJSONParameter){
        
        self.id = attributes?["id"]?.stringValue
        self.adds_on_name = attributes?["adds_on_name"]?.stringValue
        self.cart_id = attributes?["cart_id"]?.stringValue
        self.quantity = attributes?["quantity"]?.intValue
        self.adds_on_type_jd = attributes?["adds_on_type_jd"]?.stringValue
        self.serial_number = attributes?["serial_number"]?.intValue
        self.adds_on_id = attributes?["adds_on_id"]?.stringValue
        self.adds_on_type_name = attributes?["adds_on_type_name"]?.stringValue
        self.price = attributes?["price"]?.stringValue
        self.add_on_id_ios = attributes?["add_on_id_ios"]?.stringValue
        self.adds_on_type_quantity = attributes?["adds_on_type_quantity"]?.stringValue

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(add_on_id_ios, forKey: "add_on_id_ios")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(adds_on_name, forKey: "adds_on_name")
        aCoder.encode(cart_id, forKey: "cart_id")
        aCoder.encode(quantity, forKey: "quantity")
        aCoder.encode(adds_on_type_jd, forKey: "adds_on_type_jd")
        aCoder.encode(serial_number, forKey: "serial_number")
        aCoder.encode(adds_on_id, forKey: "adds_on_id")
        aCoder.encode(adds_on_type_name, forKey: "adds_on_type_name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(adds_on_type_quantity, forKey: "adds_on_type_quantity")

    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        adds_on_name = aDecoder.decodeObject(forKey: "adds_on_name") as? String
        cart_id = aDecoder.decodeObject(forKey: "cart_id") as? String
        quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
        adds_on_type_jd = aDecoder.decodeObject(forKey: "adds_on_type_jd") as? String
        serial_number = aDecoder.decodeObject(forKey: "serial_number") as? Int
        adds_on_id = aDecoder.decodeObject(forKey: "adds_on_id") as? String
        adds_on_type_name = aDecoder.decodeObject(forKey: "adds_on_type_name") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        add_on_id_ios = aDecoder.decodeObject(forKey: "add_on_id_ios") as? String
        adds_on_type_quantity = aDecoder.decodeObject(forKey: "adds_on_type_quantity") as? String

    }
    
}

class HourlyPriceModal : NSObject {
    
    var min_hour : String?
    var max_hour : String?
    var price_per_hour : Int?
    var discount_price: Int?

    init(attributes : SwiftyJSONParameter){
        
        self.min_hour = attributes?["min_hour"]?.stringValue
        self.max_hour = attributes?["max_hour"]?.stringValue
        self.price_per_hour = attributes?["price_per_hour"]?.intValue
        self.discount_price = attributes?["discount_price"]?.intValue
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(min_hour, forKey: "min_hour")
        aCoder.encode(max_hour, forKey: "max_hour")
        aCoder.encode(price_per_hour, forKey: "price_per_hour")
        aCoder.encode(discount_price, forKey: "discount_price")

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        min_hour = aDecoder.decodeObject(forKey: "min_hour") as? String
        max_hour = aDecoder.decodeObject(forKey: "max_hour") as? String
        price_per_hour = aDecoder.decodeObject(forKey: "price_per_hour") as? Int
        discount_price = aDecoder.decodeObject(forKey: "discount_price") as? Int
    }
    
}

class AddonValueIndexModal: NSObject  {
    
    var row : Int?
    var section : Int?

    init(row: Int?,section: Int?){

        self.row = row
        self.section = section
        
    }
    
}

class ProductDetailData : NSObject {
    
    var name : String?
    var quantity : String?
    var measuringUnit : String?
    var price : String?
    var image : String?
    var productDetailAddson : [ProductDetailAddonModal]?
    var variants: [ProductVariantValue]?
    var recipe_pdf : String?
    var product_id: String?
    var order_price_id: Int?
    var return_data: [ReturnStatus]?
    
    init(name: String?,quantity: String?,measuringUnit: String?,price: String?,image: String?,productDetailAddson: [ProductDetailAddonModal]?, variants: [ProductVariantValue]?, recipe_pdf:String?, product_id: String?, order_price_id: Int?, return_data: [ReturnStatus]?){
        
        self.name = name
        self.quantity = quantity
        self.measuringUnit = measuringUnit
        self.price = price
        self.image = image
        self.productDetailAddson = productDetailAddson
        self.variants = variants
        self.recipe_pdf = recipe_pdf
        self.product_id = product_id
        self.order_price_id = order_price_id
        self.return_data = return_data
    }
    
    override init() {
        super.init()
    }
}

class AddonArrayDataModel : NSObject {
    
    var addonKey : String?
    var data : [AddonValueModal]?
    
    init(key: String?,data: [AddonValueModal]?){
        
        self.addonKey = key
        self.data = data
        
    }
    
    override init() {
        super.init()
    }
}


class DetailedSubCategories : NSObject,NSCoding {
    
    var strTitle : String?
    var arrProducts : [ProductF]?
    
    init(strTitle : String?,products : [ProductF]?) {
        self.strTitle = strTitle
        self.arrProducts = products
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(strTitle, forKey: "strTitle")
        aCoder.encode(arrProducts, forKey: "arrProducts")
    }
    
    required init(coder aDecoder: NSCoder) {
        strTitle = aDecoder.decodeObject(forKey: "strTitle") as? String
        arrProducts = aDecoder.decodeObject(forKey: "arrProducts") as? [ProductF]
    }
    
}

class ProductListing : NSObject, NSCoding {
    
    var arrDetailedSubCategories : [DetailedSubCategories]?
    
    override init() {
        super.init()
    }
    
    init(attributes : SwiftyJSONParameter){
        
        var arrayDSCs : [DetailedSubCategories] = []
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let detailedSubCategories = json[APIConstants.DataKey][ProductKeys.product.rawValue].arrayValue
        for dsc in detailedSubCategories{
            
            let dict = dsc[ProductKeys.product.rawValue]
            let products = dict.arrayValue
            var arrayProducts : [ProductF] = []
            for element in products{
                let supplier = ProductF(attributes: element.dictionaryValue)
                arrayProducts.append(supplier)
            }
            arrayDSCs.append(DetailedSubCategories(strTitle: dsc[ProductKeys.DetailSubName.rawValue].stringValue, products: arrayProducts))
        }
        
        arrayDSCs.sort(by: {
            /$0.strTitle < /$1.strTitle
        })
        self.arrDetailedSubCategories = arrayDSCs
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrDetailedSubCategories, forKey: "arrDetailedSubCategories")
    }
    
    required init(coder aDecoder: NSCoder) {
        arrDetailedSubCategories = aDecoder.decodeObject(forKey: "arrDetailedSubCategories") as? [DetailedSubCategories]
    }
    
}


class BarCodeProductListing : NSObject,NSCoding {
    
    var arrProduct : [ProductF]?
    
    init(attributes : SwiftyJSONParameter , key : String){
        super.init()
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let productListing = json[key].arrayValue
        
        var arrayProducts : [ProductF] = []
        for element in productListing{
            let supplier = ProductF(attributes: element.dictionaryValue)
            arrayProducts.append(supplier)
        }
        self.arrProduct = arrayProducts
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrProduct, forKey: "arrProduct")
    }
    
    required init(coder aDecoder: NSCoder) {
        arrProduct = aDecoder.decodeObject(forKey: "arrProduct") as? [ProductF]
    }
    
}

class PackageProductListing : NSObject,NSCoding {
    var arrProduct : [PackageProduct]?
    
    init(attributes : SwiftyJSONParameter , key : String) {
        super.init()
        guard let json = attributes,let jsonArr = json[key]?.arrayValue else { return }
        var tempArr : [PackageProduct] = []
        for product in jsonArr {
            
            //TODO: Add Supplier Branch Id for packages
            let packageProduct = PackageProduct(attributes: product.dictionaryValue)
            tempArr.append(packageProduct)
        }
        
        arrProduct = tempArr
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrProduct, forKey: "arrProduct")
    }
    
    required init(coder aDecoder: NSCoder) {
        arrProduct = aDecoder.decodeObject(forKey: "arrProduct") as? [PackageProduct]
    }
    
}

enum LaundryProductKeys : String{
    case supplier_name = "supplier_name"
    case supplier_address = "supplier_address"
}

class LaundryProductListing : NSObject,NSCoding {
    
    var arrDetailedSubCategories : [DetailedSubCategories]?
    var totalAmount : String?
    var supplierName : String?
    var supplierAddress : String?
    
    override init() {
        super.init()
    }
    
    init(attributes : SwiftyJSONParameter){
        
        supplierName = attributes?[APIConstants.DataKey]?[LaundryProductKeys.supplier_name.rawValue].stringValue
        supplierAddress = attributes?[APIConstants.DataKey]?[LaundryProductKeys.supplier_address.rawValue].stringValue
        var arrayDSCs : [DetailedSubCategories] = []
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let detailedSubCategories = json[APIConstants.DataKey]["list"].arrayValue
        for dsc in detailedSubCategories{
            
            let dict = dsc[ProductKeys.product.rawValue]
            let products = dict.arrayValue
            var arrayProducts : [ProductF] = []
            for element in products{
                let supplier = ProductF(attributes: element.dictionaryValue)
                arrayProducts.append(supplier)
            }
            arrayDSCs.append(DetailedSubCategories(strTitle: dsc[ProductKeys.name.rawValue].stringValue, products: arrayProducts))
        }
        self.arrDetailedSubCategories = arrayDSCs
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrDetailedSubCategories, forKey: "arrDetailedSubCategories")
        aCoder.encode(totalAmount, forKey: "totalAmount")
        aCoder.encode(supplierName, forKey: "supplierName")
        aCoder.encode(supplierAddress, forKey: "supplierAddress")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        arrDetailedSubCategories = aDecoder.decodeObject(forKey: "arrDetailedSubCategories") as? [DetailedSubCategories]
        totalAmount = aDecoder.decodeObject(forKey: "totalAmount") as? String
        supplierName = aDecoder.decodeObject(forKey: "supplierName") as? String
        supplierAddress = aDecoder.decodeObject(forKey: "arrsupplierAddressProduct") as? String
        
    }
    
}

class OfferListing : NSCoding {
    
    var arrOffers : [ProductF]?
    
    init(attributes : SwiftyJSONParameter){
        let tempArr = attributes?["list"]?.arrayValue ?? []
        arrOffers = []
        for product in tempArr {
            arrOffers?.append(ProductF(attributes: product.dictionaryValue))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrOffers, forKey: "arrOffers")
    }
    
    required init(coder aDecoder: NSCoder) {
        arrOffers = aDecoder.decodeObject(forKey: "arrOffers") as? [ProductF]
    }
    
}

class CompareProductListing :NSCoding {
    
    var arrProducts : [ProductF]?
    
    init(attributes : SwiftyJSONParameter){
        let tempArr = attributes?["details"]?["products"].arrayValue ?? []
        arrProducts = []
        for product in tempArr {
            arrProducts?.append(ProductF(attributes: product.dictionaryValue))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(arrProducts, forKey: "arrProducts")
    }
    
    required init(coder aDecoder: NSCoder) {
        arrProducts = aDecoder.decodeObject(forKey: "arrProducts") as? [ProductF]
    }
    
}



//class SupplierListing: NSCoding {
//
//
//    var suppliers : [Supplier]?
//    var sponsor : Supplier?
//
//    init(attributes : SwiftyJSONParameter , key : String){
//        guard let rawData = attributes else { return }
//        let json = JSON(rawData)
//
//        let dict = json[APIConstants.DataKey]
//
//        let suppliers = dict[key].arrayValue
//        var arraySuppliers : [Supplier] = []
//        for element in suppliers{
//            let supplier = Supplier(attributes: element.dictionaryValue)
//            arraySuppliers.append(supplier)
//        }
//        self.suppliers = arraySuppliers
//    }
//
//
//    func encode(with aCoder: NSCoder) {
//
//        aCoder.encode(suppliers, forKey: "suppliers")
//        aCoder.encode(sponsor, forKey: "sponsor")
//
//    }
//
//    required init(coder aDecoder: NSCoder) {
//
//        suppliers = aDecoder.decodeObject(forKey: "suppliers") as? [Supplier]
//        sponsor = aDecoder.decodeObject(forKey: "sponsor") as? Supplier
//
//    }
//
//}



//changes by rohit
class filteredProducts: NSCoding {
    
    var products : [ProductF]?
    
    init(attributes : SwiftyJSONParameter , key : String){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[key]
        
        let products = dict["product"].arrayValue
        var arrayProduct : [ProductF] = []
        for element in products{
            let supplier = ProductF(attributes: element.dictionaryValue)
            arrayProduct.append(supplier)
        }
        self.products = arrayProduct
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(products, forKey: "product")
    }
    
    required init(coder aDecoder: NSCoder) {
        products = aDecoder.decodeObject(forKey: "product") as? [ProductF]
    }
    
}

class FavProducts: NSCoding {

    var products : [ProductF]?
    
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let products = json[APIConstants.DataKey].arrayValue
        
        var arrayProduct : [ProductF] = []
        for element in products{
            let supplier = ProductF(attributes: element.dictionaryValue)
            arrayProduct.append(supplier)
        }
        self.products = arrayProduct
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(products, forKey: "data")
    }
    
    required init(coder aDecoder: NSCoder) {
        products = aDecoder.decodeObject(forKey: "data") as? [ProductF]
    }
    
}



class CheckProductList: NSCoding {
    
    var result : [ProductF]?
    var not_available_ids : [Any]?
    var tips = [Int]()
    var region_delivery_charge: Double?
    var payment_gateways: [String]?
    
    //var paymentGateways:
    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let data = json["data"].dictionaryValue
      if let products = data["result"]?.arrayValue{
        //        guard let products = data["result"]?.arrayValue else {return}
                
        var arrayProduct : [ProductF] = []
        for element in products{
            let supplier = ProductF(attributes: element.dictionaryValue)
            arrayProduct.append(supplier)
        }
        self.result = arrayProduct
        }
        self.region_delivery_charge = data["region_delivery_charge"]?.doubleValue
        self.payment_gateways = data["payment_gateways"]?.arrayObject as? [String]
        
        guard let tipsValue = data["tips"]?.arrayObject else {
            return
        }
        for val in tipsValue {
            if let valObj = val as? Int {
                self.tips.append(valObj)
            }
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(result, forKey: "result")
        aCoder.encode(tips, forKey: "tips")
    }
    
    required init(coder aDecoder: NSCoder) {
        result = aDecoder.decodeObject(forKey: "result") as? [ProductF]
        tips = (aDecoder.decodeObject(forKey: "tips") as? [Int]) ?? []

    }
    
}


class ReturnStatus : NSObject {
    var reasons : String?
    var status : String?
    
    init(attributes : SwiftyJSONParameter) {
        
        
//        RETURN REQUESTED 0
//        AGENT ON THE WAY 1
//        PRODUCT PICKED 2
//        RETURNED 3
        let status = attributes?["status"]?.intValue
        switch status {
        case 0:
            self.status = "Return Requested".localized()
        case 1:
            self.status = "Agent on the way".localized()
        case 2:
            self.status = "Product Picked up".localized()
        case 3:
            self.status = "Returned".localized()
        default:
            self.status = ""
        }
        self.reasons = attributes?["reasons"]?.stringValue
    }
}

