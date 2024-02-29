//
//  ServiceType.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper
import ObjectMapper

public enum ServiceTypeKeys : String {
    case id = "id"
    case supplier_placement_level = "supplier_placement_level"
    case image = "image"
    case icon = "icon"
    case name = "name"
    case description = "description"
    case category_flow = "category_flow"
    case order = "order"
    case agentlist = "agent_list"
    case isProduct = "is_product"
    case parent_id
    case sub_category
    case is_assign
    case type
    case is_laundary = "is_laundary"
}


public enum SelectedServiceType {
    case cab
    case pickup
    case ambulance
    case other
}



open class ServiceType : NSObject, NSCoding{
    
    public var is_laundary : Int?
    public var id : String?
    public var supplier_placement_level : String?
    public var image : String?
    public var icon : String?
    public var name : String?
    public var desc : String?
    public var category_flow : String?
    public var order : String?
    public var agent_list : String?
    public var supplierId : String?
    public var parent_id : Int?
    public var sub_category: [SubSub_Category]?
    public var is_assign: Int?
    public var is_subcategory: Int?
    public var is_service_single_selection : Int?
    public var serviceType: SelectedServiceType?
    public var is_question: Int?
    
    public init(staticImage: UIImage, name: String, serviceType: SelectedServiceType,_ imgPath: String?) {
        self.staticImage = staticImage
        self.name = name
        self.serviceType = serviceType
        self.image = imgPath
    }
    
    public init(staticImage: UIImage, name: String, serviceType: SelectedServiceType,_ imgPath: String?, _ category_id: String) {
        self.staticImage = staticImage
        self.name = name
        self.serviceType = serviceType
        self.image = imgPath
        self.id = category_id
    }
    public var type: Int? //Doctor
    var terminology: TerminologyModalClass?
    public var terminologyStr: String?
    
    public var cart_image_upload: String?
    public var order_instructions: String?
    public var staticImage: UIImage?
    public var menu_type: String?
    public var is_dine: String?
    //    cart_image_upload: 0
    //    order_instructions: 0
    //    parent_id: 0
    //    payment_after_confirmation: 0
    //    tax: 10
    //    terminology: String
    //    type: 1
    
    // is_quantity == 1 > add/remove, 0 > + -
    
    public init (attributes : SwiftyJSONParameter){
        
        guard let data = attributes else {return}
        //Nitin
        self.parent_id = data[ServiceTypeKeys.parent_id.rawValue]?.intValue
        
        if let subcategory = data[ServiceTypeKeys.sub_category.rawValue]?.arrayValue {
            self.sub_category = []
            for json in subcategory {
                let obj = SubSub_Category(attributes: json.dictionary)
                self.sub_category?.append(obj)
            }
        }
        
        self.is_assign = data[ServiceTypeKeys.is_assign.rawValue]?.intValue
        self.is_service_single_selection = data["is_service_single_selection"]?.intValue
        self.id = data[ServiceTypeKeys.id.rawValue]?.stringValue
        self.supplier_placement_level = data[ServiceTypeKeys.supplier_placement_level.rawValue]?.stringValue
        self.is_laundary = data[ServiceTypeKeys.is_laundary.rawValue]?.intValue
        self.image = data[ServiceTypeKeys.image.rawValue]?.stringValue
        self.icon = data[ServiceTypeKeys.icon.rawValue]?.stringValue
        self.name = data[ServiceTypeKeys.name.rawValue]?.stringValue
        self.desc = data[ServiceTypeKeys.description.rawValue]?.stringValue
        self.category_flow = data[ServiceTypeKeys.category_flow.rawValue]?.stringValue
        self.order = data[ServiceTypeKeys.order.rawValue]?.stringValue
        self.agent_list = data[ServiceTypeKeys.agentlist.rawValue]?.stringValue
        self.type = data[ServiceTypeKeys.type.rawValue]?.intValue
        cart_image_upload = attributes?["cart_image_upload"]?.stringValue
        order_instructions = attributes?["order_instructions"]?.stringValue
        menu_type = attributes?["menu_type"]?.stringValue
        terminologyStr = data["terminology"]?.stringValue
        if let dict = terminologyStr?.convertToDictionary() {
            if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
                terminology = obj
            }
        }
        is_dine = data["is_dine"]?.stringValue
        is_question = data["is_question"]?.intValue ?? 0
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(is_laundary, forKey: "is_laundary")
        aCoder.encode(parent_id, forKey: "parent_id")
        aCoder.encode(sub_category, forKey: "sub_category")
        aCoder.encode(is_assign, forKey: "is_assign")
        aCoder.encode(is_service_single_selection, forKey: "is_service_single_selection")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(supplier_placement_level, forKey: "supplier_placement_level")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(desc, forKey: "desc")
        aCoder.encode(category_flow, forKey: "category_flow")
        aCoder.encode(order, forKey: "order")
        aCoder.encode(agent_list, forKey: ServiceTypeKeys.agentlist.rawValue)
        aCoder.encode(terminologyStr, forKey: "terminologyStr")
        aCoder.encode(is_dine, forKey: "is_dine")
        aCoder.encode(is_question, forKey: "is_question")
        aCoder.encode(cart_image_upload, forKey: "cart_image_upload")
        aCoder.encode(order_instructions, forKey: "order_instructions")
        aCoder.encode(type, forKey: "type")
    }
    
    public required init(coder aDecoder: NSCoder) {
        
        is_laundary = aDecoder.decodeObject(forKey: "is_laundary") as? Int
        parent_id = aDecoder.decodeObject(forKey: "parent_id") as? Int
        sub_category = aDecoder.decodeObject(forKey: "sub_category") as? [SubSub_Category]
        is_assign = aDecoder.decodeObject(forKey: "is_assign") as? Int
        is_service_single_selection = aDecoder.decodeObject(forKey: "is_service_single_selection") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? String
        supplier_placement_level = aDecoder.decodeObject(forKey: "supplier_placement_level") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        desc = aDecoder.decodeObject(forKey: "desc") as? String
        category_flow = aDecoder.decodeObject(forKey: "category_flow") as? String
        order = aDecoder.decodeObject(forKey: "order") as? String
        agent_list = aDecoder.decodeObject(forKey: ServiceTypeKeys.agentlist.rawValue) as? String
        terminologyStr = aDecoder.decodeObject(forKey: "terminologyStr") as? String
        if let dict = terminologyStr?.convertToDictionary() {
            if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
                terminology = obj
            }
        }
        cart_image_upload = aDecoder.decodeObject(forKey: "cart_image_upload") as? String
        order_instructions = aDecoder.decodeObject(forKey: "order_instructions") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        is_dine = aDecoder.decodeObject(forKey: "is_dine") as? String
        is_question = aDecoder.decodeObject(forKey: "is_question") as? Int
    }
    
    public init(subCategory : SubSub_Category){
        
        id = subCategory.id//"\(String(describing: subCategory.parent_id!))"
        
        name = subCategory.name
        
        image = subCategory.image
        
        icon = subCategory.icon
        
        is_assign = subCategory.is_assign//mattu -- neelam maam fix
        
        category_flow = "Category>Suppliers>SupplierInfo>SubCategory>Pl"
        
        parent_id = subCategory.parent_id
        
    }
}//Nitin


open class SubSub_Category : NSObject, NSCoding{
    
    public var parent_id : Int?
    public var is_assign : Int?
    public var image : String?
    public var icon : String?
    public var name : String?
    public var id : String?
    public var sub_category: [SubSub_Category]?
    
    public init (attributes : SwiftyJSONParameter){
        
        guard let data = attributes else {return}
        if let subcategory = data[ServiceTypeKeys.sub_category.rawValue]?.arrayValue {
            self.sub_category = []
            for json in subcategory {
                let obj = SubSub_Category(attributes: json.dictionary)
                self.sub_category?.append(obj)
            }
        }
        
        self.parent_id = data[ServiceTypeKeys.parent_id.rawValue]?.intValue
        self.is_assign = data[ServiceTypeKeys.is_assign.rawValue]?.intValue
        self.id = data[ServiceTypeKeys.id.rawValue]?.stringValue
        self.image = data[ServiceTypeKeys.image.rawValue]?.stringValue
        self.icon = data[ServiceTypeKeys.icon.rawValue]?.stringValue
        self.name = data[ServiceTypeKeys.name.rawValue]?.stringValue
        
    }
    
    override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(sub_category, forKey: "sub_category")
        aCoder.encode(parent_id, forKey: "parent_id")
        aCoder.encode(is_assign, forKey: "is_assign")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(name, forKey: "name")
        
    }
    
    required public init(coder aDecoder: NSCoder) {
        
        sub_category = aDecoder.decodeObject(forKey: "sub_category") as? [SubSub_Category]
        parent_id = aDecoder.decodeObject(forKey: "parent_id") as? Int
        is_assign = aDecoder.decodeObject(forKey: "is_assign") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        
    }
}
