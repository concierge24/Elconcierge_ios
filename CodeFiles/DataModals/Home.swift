//
//  Home.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper

enum HomeKeys : String {
    case english = "english"
    case arabic = "arabic"
    case brands = "brands"
    case topBanner = "topBanner"
    case offerArabic = "offerArabic"
    case offerEnglish = "offerEnglish"
    case languageList = "languageList"
    case SupplierInEnglish = "SupplierInEnglish"
    case SupplierInArabic = "SupplierInArabic"
    case pendingOrder = "pendingOrder"
    case scheduleOrders = "scheduleOrders"
    case sub_category_data = "sub_category_data"
    case sub_cat_name = "sub_cat_name"
    case product = "product"
    case productValue = "value"
    case brand
    case offer
    case supplier_detail
    case orders
    case getOfferByCategory //Doctor
    case name //Doctor
}

class MenuProductSection: NSObject, RMMapping, NSCoding {
    
    var arrayProduct: [ProductList]?
    var supplier: Supplier?

    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrayProduct, forKey: APIConstants.DataKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        arrayProduct = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [ProductList]
    }
    
    override init(){
        super.init()
    }
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let dict = json[APIConstants.DataKey]
        let product = dict[HomeKeys.product.rawValue].arrayValue
        var tempProd : [ProductList] = []
        for prod in product {
            let itemList = ProductList(sender: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        self.arrayProduct = tempProd
        
        let supplierD = dict[HomeKeys.supplier_detail.rawValue].dictionaryValue
        supplier = Supplier(attributes: supplierD)
    }
}

class PopularProductsList: NSObject , RMMapping,NSCoding {
    
    var arrayProduct: [ProductF]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrayProduct, forKey: APIConstants.DataKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        arrayProduct = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [ProductF]
    }
    
    override init(){
        super.init()
    }
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let dict = json[APIConstants.DataKey]
        let product = dict[HomeKeys.product.rawValue].arrayValue
        var tempProd : [ProductF] = []
        for prod in product {
            let itemList = ProductF(attributes: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        self.arrayProduct = tempProd
    }
    
}

class DetailedSubCat: NSObject {
    var name: String?
    var id: Int?
    
    init(sender : SwiftyJSONParameter){
    guard let rawData = sender else { return }
        self.name = rawData["name"]?.stringValue
        self.id = rawData["detailed_sub_category_id"]?.intValue
    }
}

class ProductList: NSObject , RMMapping,NSCoding {
    
    var catName: String?
    var productValue: [ProductF]?
    var detailedSubCategory: [DetailedSubCat]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(catName, forKey: HomeKeys.sub_cat_name.rawValue)
        aCoder.encode(productValue, forKey: HomeKeys.productValue.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        catName = aDecoder.decodeObject(forKey: HomeKeys.sub_cat_name.rawValue) as? String
        productValue = aDecoder.decodeObject(forKey: HomeKeys.productValue.rawValue) as? [ProductF]
    }
    
    override init(){
        super.init()
    }
    
    init(sender : SwiftyJSONParameter){
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let product = json[HomeKeys.productValue.rawValue].arrayValue
        var tempProd : [ProductF] = []
        for prod in product {
            let itemList = ProductF(attributes: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        self.productValue = tempProd
        self.catName =  sender?[HomeKeys.sub_cat_name.rawValue]?.stringValue
        var subCats: [DetailedSubCat] = []
        if let subCatArr = sender?["detailed_category_name"]?.arrayValue {
            for subCat in subCatArr {
                 let cat = DetailedSubCat(sender: subCat.dictionaryValue)
                subCats.append(cat)
            }
        }
        if subCats.count > 0 {
            detailedSubCategory = subCats
            self.productValue = self.productValue?.sorted(by: { /$0.detailed_sub_category_id < /$1.detailed_sub_category_id })
        }
        //json[HomeKeys.sub_cat_name.rawValue].  //
    }
    
}

class TagList: NSObject , RMMapping,NSCoding {
    
    var products: [ProductF]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(products, forKey: ProductKeys.product.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        products = aDecoder.decodeObject(forKey: ProductKeys.product.rawValue) as? [ProductF]
    }
    
    override init(){
        super.init()
    }
    
    init(sender : SwiftyJSONParameter){
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let product = json[APIConstants.DataKey][ProductKeys.product.rawValue].arrayValue
        var tempProd : [ProductF] = []
        for prod in product {
            let itemList = ProductF(attributes: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        self.products = tempProd
    }
    
}

class TagSuppliers: NSObject, RMMapping, NSCoding {
    
    var arrayItems: [Supplier]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrayItems, forKey: ProductKeys.supplier.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        arrayItems = aDecoder.decodeObject(forKey: ProductKeys.supplier.rawValue) as? [Supplier]
    }
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let agentArray = json[APIConstants.DataKey][ProductKeys.supplier.rawValue].arrayValue
        
        self.arrayItems = []
        
        for element in agentArray {
            let orderDict = Supplier(attributes: element.dictionaryValue)
            self.arrayItems?.append(orderDict)
        }
    }
}

class OffersByCategory: NSObject , RMMapping,NSCoding {
    
    var name: String?
    var productValue: [ProductF]?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: HomeKeys.name.rawValue)
        aCoder.encode(productValue, forKey: HomeKeys.productValue.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: HomeKeys.name.rawValue) as? String
        productValue = aDecoder.decodeObject(forKey: HomeKeys.productValue.rawValue) as? [ProductF]
    }
    
    override init(){
        super.init()
    }
    
    init(sender : SwiftyJSONParameter){
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let product = json[HomeKeys.productValue.rawValue].arrayValue
        var tempProd : [ProductF] = []
        for prod in product {
            let itemList = ProductF(attributes: prod.dictionaryValue)
            tempProd.append(itemList)
        }
        self.productValue = tempProd
        self.name =  sender?[HomeKeys.name.rawValue]?.stringValue //json[HomeKeys.sub_cat_name.rawValue].  //
    }
    
}


class ReferalData: NSObject, RMMapping, NSCoding {
    
    var arrayItems: [User]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrayItems, forKey: APIConstants.DataKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        arrayItems = aDecoder.decodeObject(forKey: APIConstants.referalData) as? [User]
    }
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        
        let data =  json["data"].dictionaryValue
        
        let agentArray = data[APIConstants.referalData]?.array ?? []
        
        self.arrayItems = []
        
        for element in agentArray {
            let orderDict = User(attributes: element.dictionaryValue)
            self.arrayItems?.append(orderDict)
        }
    }
}


class HomeSuppliers: NSObject, RMMapping, NSCoding {
    
    var arrayItems: [Supplier]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(arrayItems, forKey: APIConstants.DataKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        arrayItems = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [Supplier]
    }
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let agentArray = json[APIConstants.DataKey].array ?? []
        
        self.arrayItems = []
        
        for element in agentArray {
            let orderDict = Supplier(attributes: element.dictionaryValue)
            self.arrayItems?.append(orderDict)
        }
    }
}

class Home : NSObject , RMMapping, NSCoding {
    
    var itemsBanners : [Banner]?
    var itemsOrders : [OrderDetails]?   
    lazy var staticBanners : [Banner] = {
        var b1 = Banner(attributes: [:])
        var b2 = Banner(attributes: [:])
        var b3 = Banner(attributes: [:])
        
        if let banner1 = AppSettings.shared.appThemeData?.pickup_url_one, !banner1.isEmpty {
            b1.phone_image = banner1
        }
        
        if let banner2 = AppSettings.shared.appThemeData?.pickup_url_two, !banner2.isEmpty {
            b2.phone_image = banner2
        }
        
        if let banner3 = AppSettings.shared.appThemeData?.pickup_url_three, !banner3.isEmpty {
            b3.phone_image = banner3
        }
        
        b1.staticImage = #imageLiteral(resourceName: "foodPickUpB1")
        b2.staticImage = #imageLiteral(resourceName: "foodPickUpB2")
        b3.staticImage = #imageLiteral(resourceName: "foodPickUpB3")
        return [
            b1,
            b2,
            b3,
        ]
    }()
    
    lazy var staticBannersForSingleCat : [Banner] = {
        
        var banners: [Banner] = []
        if let banner1 = AppSettings.shared.appThemeData?.banner_one, !banner1.isEmpty {
            let b1 = Banner(attributes: [:])
            b1.phone_image = banner1
            //b1.thumb = AppSettings.shared.appThemeData?.banner_one_thumb
            banners.append(b1)
        }
        if let banner1 = AppSettings.shared.appThemeData?.banner_two, !banner1.isEmpty {
            let b1 = Banner(attributes: [:])
            b1.phone_image = banner1
            banners.append(b1)
        }
        if let banner1 = AppSettings.shared.appThemeData?.banner_three, !banner1.isEmpty {
            let b1 = Banner(attributes: [:])
            b1.phone_image = banner1
            banners.append(b1)
        }
        if let banner1 = AppSettings.shared.appThemeData?.banner_four, !banner1.isEmpty {
            let b1 = Banner(attributes: [:])
            b1.phone_image = banner1
            banners.append(b1)
        }
//        if let value = AppSettings.shared.appThemeData?.banner_url, !value.isEmpty {
//            var b1 = Banner(attributes: [:])
//            let img = UIImageView()
//            b1.phone_image = value
//            return [b1]
//        }
      return banners
        
    }()
    
    var arrayBanners : [Banner]? {
        if SKAppType.type.isFood && DeliveryType.shared == .pickup {
            return staticBanners
        }
        if itemsBanners?.count ?? 0 > 0 {
            return itemsBanners
        }
        return staticBannersForSingleCat // [] kapil

    }
    var arrayServiceTypesEN : [ServiceType]?
    var arrayServiceTypesAR : [ServiceType]?
    var arrayOffersEN : [ProductF]?
    var arrayOffersAR : [ProductF]?
    
    //Nitin
    var arrOffersHomeAr: [ProductF]?
    var arrProductsList: [ProductList]?
    var arrayRecommendedEN : [Supplier]?
    var arrayRecommendedAR : [Supplier]?
    var arrayAllRecommended : [Supplier] = []
    var arrPopularProducts: [ProductF]? //Ecommerce

    var arrayLanguages : [ApplicationLanguage]?
    
    //Localize.currentLanguage() == Languages.Arabic
    var arrayBrands : [Brands]?
    var getOfferByCategory: [OffersByCategory]?

    init(sender : SwiftyJSONParameter) {
        
        guard let rawData = sender else { return }
        let json = JSON(rawData)
        
        let dict = json[APIConstants.DataKey]
        
        arrayLanguages = LanguageListing(attributes: dict.dictionaryValue).languages

        //Categories
        let arrCategoryEnglish = dict[HomeKeys.english.rawValue].arrayValue
        arrayServiceTypesEN = []
        for json in arrCategoryEnglish {
            let obj = ServiceType(attributes: json.dictionaryValue)
            arrayServiceTypesEN?.append(obj)
        }
        
        let arrCategoryArabic = dict[HomeKeys.arabic.rawValue].arrayValue
        arrayServiceTypesAR = []
        for json in arrCategoryArabic {
            let obj = ServiceType(attributes: json.dictionaryValue)
            arrayServiceTypesAR?.append(obj)
        }
        
        if /arrayServiceTypesAR?.isEmpty {
            arrayServiceTypesAR = arrayServiceTypesEN
        }
        
        //Brands
        let brands = dict[HomeKeys.brands.rawValue].arrayValue
        arrayBrands = []
        for json in brands {
            let banner = Brands(fromJson: json)
            arrayBrands?.append(banner)

        }
        
        if Localize.currentLanguage() == Languages.Arabic {
            itemsBanners = itemsBanners?.reversed()
        }
        
        //Banners
        let banners = dict[HomeKeys.topBanner.rawValue].arrayValue
        itemsBanners = []
        for (_ , element) in banners.enumerated(){
            let banner = Banner(attributes: element.dictionaryValue)
            if let name = banner.phone_image, !name.isEmpty {
                itemsBanners?.append(banner)
            }
            //Nitin
//            if banner.banner_type == "1" {
//            }
        }
        
        
        //Doctor Home
        let arrOffersByCat = dict[HomeKeys.getOfferByCategory.rawValue].arrayValue
        getOfferByCategory = []
        for json in arrOffersByCat {
            let obj = OffersByCategory(sender: json.dictionaryValue)
            getOfferByCategory?.append(obj)
        }
        
        if Localize.currentLanguage() == Languages.Arabic {
            itemsBanners = itemsBanners?.reversed()
        }
        
        //Offers
        let arrOffersEnglish = dict[HomeKeys.offerEnglish.rawValue].arrayValue
        arrayOffersEN = []
        for json in arrOffersEnglish {
            let obj = ProductF(attributes: json.dictionaryValue)
            arrayOffersEN?.append(obj)
        }
        
        let arrOffersArabic = dict[HomeKeys.offerArabic.rawValue].arrayValue
        arrayOffersAR = []
        for json in arrOffersArabic {
            let obj = ProductF(attributes: json.dictionaryValue)
            arrayOffersAR?.append(obj)
        }
        
        if /arrayOffersAR?.isEmpty {
            arrayOffersAR = arrayOffersEN
        }
        
        //Nitin
        let arrOffersHomeArabic = dict[HomeKeys.SupplierInArabic.rawValue].arrayValue
        arrOffersHomeAr = []
        for json in arrOffersHomeArabic {
            let obj = ProductF(attributes: json.dictionaryValue)
            arrOffersHomeAr?.append(obj)
        }
        
        if /arrOffersHomeAr?.isEmpty {
            arrOffersHomeAr = arrayOffersEN
        }
        
        //Recommended
        let arrRecEnglish = dict[HomeKeys.SupplierInEnglish.rawValue].arrayValue
        arrayRecommendedEN = []
        for json in arrRecEnglish {
            let obj = Supplier(attributes: json.dictionaryValue)
            arrayRecommendedEN?.append(obj)
        }
        
        let arrRecArabic = dict[HomeKeys.SupplierInArabic.rawValue].arrayValue
        arrayRecommendedAR = []
        for json in arrRecArabic {
            let obj = Supplier(attributes: json.dictionaryValue)
            arrayRecommendedAR?.append(obj)
        }
        
        if /arrayRecommendedEN?.isEmpty {
            arrayRecommendedEN = arrayRecommendedAR
        }
        
        if /arrayRecommendedAR?.isEmpty {
            arrayRecommendedAR = arrayRecommendedEN
        }
        
        //orders
        let orders = dict[HomeKeys.orders.rawValue].arrayValue
        itemsOrders = []
        for json in orders {
            let order = OrderDetails(attributes: json.dictionaryValue)
            itemsOrders?.append(order)
        }
    }
    
    override init(){
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(itemsBanners, forKey: "arrayBanners")
        aCoder.encode(arrProductsList, forKey: "arrProductsList")

        aCoder.encode(arrayServiceTypesEN, forKey: "arrayServiceTypesEN")
        aCoder.encode(arrayServiceTypesAR, forKey: "arrayServiceTypesAR")
        
        aCoder.encode(arrayOffersEN, forKey: "arrayOffersEN")
        aCoder.encode(arrayOffersAR, forKey: "arrayOffersAR")
        
        //Nitin
        aCoder.encode(arrOffersHomeAr, forKey: "arrayOffersAR")

        aCoder.encode(arrayRecommendedEN, forKey: "arrayRecommendedEN")
        aCoder.encode(arrayRecommendedAR, forKey: "arrayRecommendedAR")
        
        aCoder.encode(arrayLanguages, forKey: "arrayLanguages")
        
    }

    required init(coder aDecoder: NSCoder) {
        //Nitin
        arrProductsList = aDecoder.decodeObject(forKey: "arrProductsList") as? [ProductList]
        itemsBanners = aDecoder.decodeObject(forKey: "arrayBanners") as? [Banner]
        
        arrayServiceTypesEN = aDecoder.decodeObject(forKey: "arrayServiceTypesEN") as? [ServiceType]
        arrayServiceTypesAR = aDecoder.decodeObject(forKey: "arrayServiceTypesAR") as? [ServiceType]
        
        arrayOffersEN = aDecoder.decodeObject(forKey: "arrayOffersEN") as? [ProductF]
        arrayOffersAR = aDecoder.decodeObject(forKey: "arrayOffersAR") as? [ProductF]
        
        //Nitin
        arrOffersHomeAr = aDecoder.decodeObject(forKey: "arrayOffersAR") as? [ProductF]

        arrayRecommendedEN = aDecoder.decodeObject(forKey: "arrayRecommendedEN") as? [Supplier]
        arrayRecommendedAR = aDecoder.decodeObject(forKey: "arrayRecommendedAR") as? [Supplier]
        
        arrayLanguages = aDecoder.decodeObject(forKey: "arrayLanguages") as? [ApplicationLanguage]

    }
    
    
    func  getProducts() -> [ProductF] {
        
        return [
            ProductF() , ProductF(), ProductF()
        ]
    }
    
    
    func getServiceData () -> [ServiceType] {
        
        let list = [Any]()
        return list as! [ServiceType]
    }
}
