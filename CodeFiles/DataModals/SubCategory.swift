//
//  SubCategory.swift
//  Clikat
//
//  Created by Night Reaper on 09/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON

enum SubCategoryKeys : String {
    
    case subCategoryId = "sub_category_id"
    case icon = "icon"
    case image = "image"
    case name = "name"
    case description = "description"
    case is_cub_category = "is_cub_category"
    case is_allChecked = "is_allChecked"
}

class SubCategory : NSObject,NSCoding {
    
    var subCategoryId: String?
    var icon: String?
    var image: String?
    var name: String?
    var subCategoryDesc: String?
    var is_cub_category: String?
    var is_allChecked: Bool?
    
    var isSelected: Bool = false
    var is_question: Int = 0
    
    init(attributes: SwiftyJSONParameter) {
        
        self.subCategoryId = attributes?[SubCategoryKeys.subCategoryId.rawValue]?.stringValue
        self.icon = attributes?[SubCategoryKeys.icon.rawValue]?.stringValue
        self.image = attributes?[SubCategoryKeys.image.rawValue]?.stringValue
        self.name = attributes?[SubCategoryKeys.name.rawValue]?.stringValue
        self.subCategoryDesc = attributes?[SubCategoryKeys.description.rawValue]?.stringValue
        self.is_cub_category = attributes?[SubCategoryKeys.is_cub_category.rawValue]?.stringValue
        self.is_question = attributes?["is_question"]?.intValue ?? 0
        is_allChecked = false
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(subCategoryId, forKey: "subCategoryId")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(subCategoryDesc, forKey: "subCategoryDesc")
        aCoder.encode(is_cub_category, forKey: "is_cub_category")
        aCoder.encode(is_allChecked, forKey: "is_allChecked")
        aCoder.encode(is_question, forKey: "is_question")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        subCategoryId = aDecoder.decodeObject(forKey: "subCategoryId") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        subCategoryDesc = aDecoder.decodeObject(forKey: "subCategoryDesc") as? String
        is_cub_category = aDecoder.decodeObject(forKey: "is_cub_category") as? String
        is_allChecked = aDecoder.decodeObject(forKey: "is_cub_category") as? Bool
        is_question = aDecoder.decodeObject(forKey: "is_question") as? Int ?? 0
    }
}

class SubCategoriesListing: NSCoding {
    
    var subCategories : [SubCategory]?
    var arrayBrands : [Brands]?
    var arrayOffers : [ProductF]?
    var arrayCategories : [Categorie]?

    init(attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        
        let dict = json[APIConstants.DataKey].dictionary
        
        //Brands
        let brands = dict?[HomeKeys.brand.rawValue]?.arrayValue ?? []
        arrayBrands = []
        for json in brands {
            let banner = Brands(fromJson: json)
            arrayBrands?.append(banner)
            
        }
        
        //Offers
        let arrOffersEnglish = dict?[HomeKeys.offer.rawValue]?.arrayValue ?? []
        arrayOffers = []
        for json in arrOffersEnglish {
            let obj = ProductF(attributes: json.dictionaryValue)
            arrayOffers?.append(obj)
        }
        
        //Sub Categories
        let subCategories = dict?[HomeKeys.sub_category_data.rawValue]?.arrayValue ?? []
        var arraySubcategories : [SubCategory] = []
        for json in subCategories {
            let supplier = SubCategory(attributes: json.dictionaryValue)
            arraySubcategories.append(supplier)
        }
        self.subCategories = arraySubcategories
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(subCategories, forKey: "subCategories")
    }
    
    required init(coder aDecoder: NSCoder) {
        subCategories = aDecoder.decodeObject(forKey: "subCategories") as? [SubCategory]
   
    }
}
