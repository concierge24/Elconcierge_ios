//
//  Question.swift
//  Sneni
//
//  Created by Daman on 02/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import ObjectMapper

enum QuestionValueKey:String {
   
   case questionId = "questionId"
   case categoryId = "categoryId"
   case question = "question"
   case questionTypeSelection = "questionTypeSelection"
   case optionsList = "optionsList"
   case questionOptionId = "questionOptionId"
   case optionLabel = "optionLabel"
   case valueChargeType = "valueChargeType"
   case flatValue = "flatValue"
    case percentageValue = "percentageValue"
}

class QuestionList: Mappable {

    var questionList: [Question]?

    required init?(map: Map){
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        questionList <- map["questionList"]
    }
}

extension Array where Element : Question {

    func addOnPrice(productPrice: Double?) -> Double {
        var addOnCharge: Double = 0
        for question in self {
            for option in question.optionsList ?? [] {
                if option.valueChargeType == 1 {
                    //flat value
                    addOnCharge += /option.flatValue
                }
                else if let totalPrice = productPrice {
                    //percentageValue
                    addOnCharge += (totalPrice * (Double(/option.percentageValue) / 100.0))
                }
            }
        }
        return addOnCharge
    }
}

class Question: NSObject, NSCoding, Mappable {

    var questionId: Int?
    var categoryId: Int?
    var question: String?
    var questionTypeSelection: Int?
    var optionsList: [QuestionOption]?
    var isMultiselect: Bool {
        return questionTypeSelection == 2
    }
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        questionId <- map["questionId"]
        categoryId <- map["categoryId"]
        question <- map["question"]
        questionTypeSelection <- map["questionTypeSelection"]
        optionsList <- map["optionsList"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        questionId = aDecoder.decodeObject(forKey: QuestionValueKey.questionId.rawValue) as? Int
        categoryId = aDecoder.decodeObject(forKey: QuestionValueKey.categoryId.rawValue) as? Int
        questionTypeSelection = aDecoder.decodeObject(forKey: QuestionValueKey.questionTypeSelection.rawValue) as? Int
        question = aDecoder.decodeObject(forKey: QuestionValueKey.question.rawValue) as? String
        optionsList = aDecoder.decodeObject(forKey: QuestionValueKey.optionsList.rawValue) as? [QuestionOption]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if questionId != nil{
            aCoder.encode(questionId, forKey: QuestionValueKey.questionId.rawValue)
        }
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: QuestionValueKey.categoryId.rawValue)
        }
        if questionTypeSelection != nil{
            aCoder.encode(questionTypeSelection, forKey:  QuestionValueKey.questionTypeSelection.rawValue)
        }
        if question != nil{
            aCoder.encode(question, forKey: QuestionValueKey.question.rawValue)
        }
        if optionsList != nil{
            aCoder.encode(optionsList, forKey: QuestionValueKey.optionsList.rawValue)
        }
    }
    
}

class QuestionOption: NSObject, NSCoding, Mappable {

    var questionId: Int?
    var categoryId: Int?
    var questionOptionId: Int?
    var optionLabel: String?
    var valueChargeType: Int?
    var flatValue: Double?
    var percentageValue: Int?
    var isSelected = false
    func displayValue(productPrice: Double? = nil) -> String {
        if valueChargeType == 1 {
            //flat value
            return flatValue?.addCurrencyLocale ?? ""
        }
        else {
            //percentageValue
            if let price = productPrice {
                return (price * (Double(/percentageValue) / 100.0)).addCurrencyLocale ?? ""
            }
            return "\(/percentageValue)\("% of service".localized())"
        }
    }
//    class func newInstance(map: Map) -> Mappable?{
//        return Bound()
//    }
//    required init?(map: Map){}
//    private override init(){}

    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map)
    {
        questionId <- map["questionId"]
        categoryId <- map["categoryId"]
        questionOptionId <- map["questionOptionId"]
        optionLabel <- map["optionLabel"]
        valueChargeType <- map["valueChargeType"]
        flatValue <- map["flatValue"]
        percentageValue <- map["percentageValue"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        questionId = aDecoder.decodeObject(forKey: QuestionValueKey.questionId.rawValue) as? Int
        categoryId = aDecoder.decodeObject(forKey: QuestionValueKey.categoryId.rawValue) as? Int
        questionOptionId = aDecoder.decodeObject(forKey: QuestionValueKey.questionOptionId.rawValue) as? Int
        optionLabel = aDecoder.decodeObject(forKey: QuestionValueKey.optionLabel.rawValue) as? String
        valueChargeType = aDecoder.decodeObject(forKey: QuestionValueKey.valueChargeType.rawValue) as? Int
        flatValue = aDecoder.decodeObject(forKey: QuestionValueKey.flatValue.rawValue) as? Double
        percentageValue = aDecoder.decodeObject(forKey: QuestionValueKey.percentageValue.rawValue) as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if questionId != nil{
            aCoder.encode(questionId, forKey: QuestionValueKey.questionId.rawValue)
        }
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: QuestionValueKey.categoryId.rawValue)
        }
        if questionOptionId != nil{
            aCoder.encode(questionOptionId, forKey:  QuestionValueKey.questionOptionId.rawValue)
        }
        if optionLabel != nil{
            aCoder.encode(optionLabel, forKey: QuestionValueKey.optionLabel.rawValue)
        }
        if valueChargeType != nil{
            aCoder.encode(valueChargeType, forKey: QuestionValueKey.valueChargeType.rawValue)
        }
        if flatValue != nil{
            aCoder.encode(flatValue, forKey: QuestionValueKey.flatValue.rawValue)
        }
        if percentageValue != nil{
            aCoder.encode(percentageValue, forKey: QuestionValueKey.percentageValue.rawValue)
        }
    }
}
