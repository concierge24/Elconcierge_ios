//
//  Banner.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper
import ObjectMapper

enum BannerKeys : String {
    case image = "image"
    case category_id = "category_id"
    case name = "name"
    case supplier_id = "supplier_id"
    case branch_id = "branch_id"
    case supplier_placement_level = "supplier_placement_level"
    case category_flow = "category_flow"
    case bannerType = "banner_type"
    case website_image = "website_image"
    case distance = "distance"
    case category_name = "category_name"
    case phone_image = "phone_image"
}

class Banner : NSObject, RMMapping {
    
    var image : String?
    var category_id : String?
    var name : String?
    var supplierId : String?
    var supplierBranchId : String?
    var categoryFlow : String?
    var supplierPlacementLevel : String?
    var banner_type : String?
    var staticImage : UIImage?
    var website_image : String?
    var distance: String?
    var category_name: String?
    var phone_image: String?
    var branch_id: Int?
    var is_subcategory: Int?
    var type: Int?
    
    var is_question: Int?
    var is_assign: Int?
    var payment_after_confirmation: Int?
    var terminology: TerminologyModalClass?
    var terminologyStr: String?
    var cart_image_upload: String?
    var order_instructions: String?
    
    
    init (attributes : Dictionary<String, JSON>?){
        self.category_id = attributes?[BannerKeys.category_id.rawValue]?.stringValue
        self.image = attributes?[BannerKeys.image.rawValue]?.stringValue
        self.image = self.image?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        self.name = attributes?[BannerKeys.name.rawValue]?.stringValue
        self.supplierId = attributes?[BannerKeys.supplier_id.rawValue]?.stringValue
        self.supplierBranchId = attributes?[BannerKeys.branch_id.rawValue]?.stringValue
        self.categoryFlow = attributes?[BannerKeys.category_flow.rawValue]?.stringValue
        self.supplierPlacementLevel = attributes?[BannerKeys.supplier_placement_level.rawValue]?.stringValue
        self.banner_type = attributes?[BannerKeys.bannerType.rawValue]?.stringValue
        
        self.website_image = attributes?[BannerKeys.website_image.rawValue]?.stringValue
        self.distance = attributes?[BannerKeys.distance.rawValue]?.stringValue
        self.category_name = attributes?[BannerKeys.category_name.rawValue]?.stringValue
        self.phone_image = attributes?[BannerKeys.phone_image.rawValue]?.stringValue
        self.branch_id = attributes?[BannerKeys.branch_id.rawValue]?.intValue
        self.is_subcategory = attributes?["is_subcategory"]?.intValue
        self.type = attributes?["type"]?.intValue
        
        cart_image_upload = attributes?["cart_image_upload"]?.stringValue
        order_instructions = attributes?["order_instructions"]?.stringValue
        payment_after_confirmation = attributes?["payment_after_confirmation"]?.intValue
        is_assign = attributes?["is_assign"]?.intValue
        is_question = attributes?["is_question"]?.intValue
        terminologyStr = attributes?["terminology"]?.stringValue
        if let dict = terminologyStr?.convertToDictionary() {
            if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
                terminology = obj
            }
        }
        
    }
 
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(image, forKey: "image")
        aCoder.encode(category_id, forKey: "category_id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(supplierId, forKey: "supplierId")
        aCoder.encode(supplierBranchId, forKey: "supplierBranchId")
        
        aCoder.encode(categoryFlow, forKey: "categoryFlow")
        aCoder.encode(supplierPlacementLevel, forKey: "supplierPlacementLevel")
        aCoder.encode(banner_type, forKey: "banner_type")

        aCoder.encode(website_image, forKey: "website_image")
        aCoder.encode(distance, forKey: "distance")
        aCoder.encode(category_name, forKey: "category_name")
        aCoder.encode(phone_image, forKey: "phone_image")
        aCoder.encode(branch_id, forKey: "branch_id")
        
    }

    required init(coder aDecoder: NSCoder) {
        
        image = aDecoder.decodeObject(forKey: "image") as? String
        category_id = aDecoder.decodeObject(forKey: "category_id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        supplierId = aDecoder.decodeObject(forKey: "supplierId") as? String
        supplierBranchId = aDecoder.decodeObject(forKey: "supplierBranchId") as? String
        
        categoryFlow = aDecoder.decodeObject(forKey: "categoryFlow") as? String
        supplierPlacementLevel = aDecoder.decodeObject(forKey: "supplierPlacementLevel") as? String
        banner_type = aDecoder.decodeObject(forKey: "banner_type") as? String
        
        website_image = aDecoder.decodeObject(forKey: "website_image") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        category_name = aDecoder.decodeObject(forKey: "category_name") as? String
        phone_image = aDecoder.decodeObject(forKey: "phone_image") as? String
        branch_id = aDecoder.decodeObject(forKey: "branch_id") as? Int

        

    }
    
}

