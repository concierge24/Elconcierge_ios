//
//  Review.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON


enum ReviewKeys : String{
    
    case firstname = "firstname"
    case user_image = "user_image"
    case comment = "comment"
    case rating = "rating"
    case review_list = "review_list"
    
}

class Review: NSObject,NSCoding {

    var userImage : String?
    var userName : String?
    var comment : String?
    var rating : Int?
    
    init (attributes : SwiftyJSONParameter){
        self.userName = attributes?[ReviewKeys.firstname.rawValue]?.stringValue
        self.userImage = attributes?[ReviewKeys.user_image.rawValue]?.stringValue
        self.comment = attributes?[ReviewKeys.comment.rawValue]?.stringValue
        self.rating = attributes?[ReviewKeys.rating.rawValue]?.intValue
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userImage, forKey: "userImage")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(comment, forKey: "comment")
        aCoder.encode(rating, forKey: "rating")
       
    }
    
    required init(coder aDecoder: NSCoder) {
        userImage = aDecoder.decodeObject(forKey: "userImage") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        comment = aDecoder.decodeObject(forKey: "comment") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
        
    }
    
    
}

class ReviewListing: NSObject,NSCoding {
    
    var reviewListing : [Review]?
    
    init(attributes : SwiftyJSONParameter) {
        
        var arrayResults : [Review] = []
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let results = json[ReviewKeys.review_list.rawValue].arrayValue
        for result in results{
                let product = Review(attributes: result.dictionaryValue)
                arrayResults.append(product)
        }
        self.reviewListing = arrayResults        
        
    }
    
    override init() {
        super.init()
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(reviewListing, forKey: "reviewListing")
    }
    
    required init(coder aDecoder: NSCoder) {
        reviewListing = aDecoder.decodeObject(forKey: "reviewListing") as? [Review]
        
    }
    
}

