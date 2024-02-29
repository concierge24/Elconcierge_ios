//
//  CommonFunctions.swift
//  Idea
//
//  Created by Dhan Guru Nanak on 2/15/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import DropDown


typealias  dropDownSelectedIndex = (_ index: Int , _ strVal: String) -> ()


class Utility: NSObject {
  
  static let shared = Utility()
 var localTimeZoneName: String { return TimeZone.current.identifier }
  
    override init() {
    super.init()
  }
    
    static func sendAttString(_ fonts: [UIFont], colors: [UIColor], texts: [String], align : NSTextAlignment, lineSpacing : CGFloat) -> NSMutableAttributedString{
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.alignment = align
           paragraphStyle.lineSpacing = lineSpacing
           let attString : NSMutableAttributedString = NSMutableAttributedString(string: "")
           
           for (num,_) in fonts.enumerated(){
               let attributes = [NSAttributedString.Key.font: fonts[num], NSAttributedString.Key.foregroundColor: colors[num]]
               let myAttrString = NSAttributedString(string: texts[num], attributes: attributes)
               attString.append(myAttrString)
           }
           
           attString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attString.length))
           return attString
       }
    
    static func sendAttString(_ fonts: [UIFont], colors: [UIColor], texts: [String], align : NSTextAlignment) -> NSMutableAttributedString{
           return sendAttString(fonts, colors: colors, texts: texts, align: align, lineSpacing: 4)
       }
       
  
    static func dteGetConvert(string : String,fromFormat : String,_ toFormat : String) -> String{
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.dateFormat = fromFormat
           let cDate = formatter.date(from: string)
           
           if cDate == nil{
               return "01 May 1800"
           }
           formatter.dateFormat = toFormat
           
           let dt = formatter.date(from: formatter.string(from: cDate!))
           formatter.timeZone = TimeZone.current
           formatter.dateFormat = toFormat
           return formatter.string(from: cDate!)
       }
  
  func getAttributedTextWithFont(text:String,font:UIFont) -> NSMutableAttributedString{
    let myAttribute = [NSAttributedString.Key.font: font]
    let myString = NSMutableAttributedString(string: text, attributes: myAttribute )
    return myString
  }
  
  func resetUserDefaultKeys() {
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
      defaults.removeObject(forKey: key)
    }
  }
  
  func secondsToMinutesSeconds (seconds : Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
  }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
  
    
    func convertToReadableTimeDuration(seconds : Int) -> String? {
        
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: seconds)
        
        if h > 0 {
            return "\(h)h \(m)m"
        } else if m >= 0 {
            return m == 0 || m == 1 ? "1 min" : "\(m) mins"
        }
        return nil
    }
    
  func subtractSets(newSet:[String],oldSet:[String])->Set<String>{
    
    let newHydrantsIds:Set<String> = Set(newSet)
    let oldHydrantsIds:Set<String> = Set(oldSet)
    let removeMarkersID = newHydrantsIds.subtracting(oldHydrantsIds)
    
    return removeMarkersID
    
  }
  
  class func GetAttributedString(arrStrings : [String],arrColor : [UIColor], arrFont: [String] , arrSize: [CGFloat], arrNextLineCheck: [Bool]) -> NSMutableAttributedString {
    
    var attriString : NSMutableAttributedString?
    let combination = NSMutableAttributedString()
    
    for index in 0..<arrStrings.count {
      
        let yourAttributes = [NSAttributedString.Key.foregroundColor: arrColor[index], NSAttributedString.Key.font:UIFont.init(name: arrFont[index], size: arrSize[index])]
      
      if arrNextLineCheck[index] == true {
        
        attriString = NSMutableAttributedString(string:"\n\(arrStrings[index])" , attributes: yourAttributes)
        
      }else{
        
        attriString = NSMutableAttributedString(string:" \(arrStrings[index])"  , attributes: yourAttributes) }
      combination.append(attriString!)
    }
    
    return combination
  }
  
  func getDateFromFormat(date:String,time:String)->Date?{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = NSTimeZone.default
    dateFormatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
    let string = date + " at " + time                       // "March 24, 2017 at 7:00 AM"
    let finalDate = dateFormatter.date(from: string)
    return finalDate ?? Date()
    
  }
    
    
   func setStaticPolyLineOnMap(pickUpLat:Double,pickUpLng:Double,dropLat:Double,dropLng:Double) -> String {
    
    var pathColor = (UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? "0x1975fe")
    
    pathColor = pathColor.replacingOccurrences(of: "#", with: "0x")
    
    return /*"http://maps.googleapis.com/maps/api/staticmap?size=600x250&markers=icon:http://45.232.252.55:9007/images/pickupNew.png|\(pickUpLat),\(pickUpLng)&markers=icon:http://45.232.252.55:9007/images/drop.png|\(pickUpLat),\(pickUpLng)&path=color:0x549815|\(pickUpLat),\(pickUpLng)|\(pickUpLat),\(pickUpLng)&key=\(APIBasePath.googleApiKey)&language=\(LanguageFile.shared.getLanguage())&sensor=false"*/
        
       
  
    
    "http://maps.googleapis.com/maps/api/staticmap?size=600x250&markers=icon:http://45.232.252.55:9007/images/pickupNew.png|\(pickUpLat),\(pickUpLng)&markers=icon:http://45.232.252.55:9007/images/drop.png|\(dropLat),\(dropLng)&path=color:\(pathColor)|weight:5|fillcolor:\(pathColor)|\(pickUpLat),\(pickUpLng)|\(dropLat),\(dropLng)&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)&language=\(LanguageFile.shared.getLanguage())&sensor=false"
    
    
    
    
     }
    
    func currentTimeZone() -> String{
        return String (TimeZone.current.identifier)
    }
    
    
    func showDropDown(anchorView : UIView , dataSource : [String] , width : CGFloat , handler : @escaping dropDownSelectedIndex ) {
        
        let dropDown = DropDown()
        
        dropDown.anchorView = anchorView // UIView or UIBarButtonItem
        
        dropDown.dataSource = dataSource
        
        dropDown.selectionAction = { (index: Int, item: String) in
            handler(index, item)
        }
        dropDown.width = width
        dropDown.show()
    }
  
  
}



