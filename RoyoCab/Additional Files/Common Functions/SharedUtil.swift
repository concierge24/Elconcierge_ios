//
//  SharedUtil.swift
//  InTheNight
//
//  Created by OSX on 15/02/18.
//  Copyright © 2018 InTheNight. All rights reserved.
//

import UIKit

class SharedUtil: NSObject {

  static func getAllCountries() -> [[String:String]] {
    let countryList:Array<Dictionary<String, String>> = (NSArray(contentsOfFile: Bundle.main.path(forResource : "CallingCodes", ofType: "plist")!) as? Array<Dictionary<String, Any>> as! Array<Dictionary<String, String>>)
    
    return countryList
  }
  
  static func currentCountryData() -> (code: String, name: String, imageName: String) {
    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
      
      let countryList:Array<Dictionary<String, Any>> = (NSArray(contentsOfFile: Bundle.main.path(forResource : "CallingCodes", ofType: "plist")!) as? Array<Dictionary<String, Any>>) ?? []
      let filterResult = countryList.filter({ (dict) -> Bool in
        let str = dict["code"] as! String
        return str == countryCode
      })
      
      if filterResult.isEmpty {
        return ("+91", "India", "in")
      } else {
        let dict = filterResult[0]
        return (dict["dial_code"] as! String, dict["name"] as! String, (dict["code"] as! String).lowercased())
      }
      
    } else {
      return ("+91", "India", "in")
    }
  }
  
  static func dateStrForPosted(dateStr: String?) -> String {
    guard let dateStr = dateStr else {
      return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: (dateStr))
    
    if date != nil {
      return timeElapsedFromDate(date: date!)
    }
    return ""
  }
  
  static func timeElapsedFromDate(date: Date) -> String {
    let currentDate = Date()
    let minutes = Int64(date.minutesInBetweenDate(currentDate))
    let hours = Int64(date.hoursInBetweenDate(currentDate))
    let days = Int64(date.daysInBetweenDate(currentDate))
    
    if days >= 1 {
      if days > 29 {
        let outputDateformatter = DateFormatter()
        outputDateformatter.dateFormat = "dd MMM yyyy, hh:mm a"
        return outputDateformatter.string(from: date)
      }
      return (days < 2) ? "\(days) Day ago" : "\(days) Days ago"
    } else if hours >= 1 {
      return (hours < 2) ? "\(hours) Hour ago" : "\(hours) Hours ago"
    } else if minutes >= 1 {
      return (minutes < 2) ? "\(minutes) Minute ago" : "\(minutes) Minutes ago"
    } else {
      return "Just now"
    }
  }
  
  static func beatAnimation() -> CAAnimationGroup {
    let pulse1 = CASpringAnimation(keyPath: "transform.scale")
    pulse1.duration = 0.6
    pulse1.fromValue = 1.0
    pulse1.toValue = 1.12
    pulse1.autoreverses = true
    pulse1.repeatCount = 1
    pulse1.initialVelocity = 0.5
    pulse1.damping = 0.8
    
    let animationGroup = CAAnimationGroup()
    animationGroup.duration = 2.7
    animationGroup.repeatCount = 1000
    animationGroup.animations = [pulse1]
    
    return animationGroup
  }
  
 static func animatesSandwichImages(imageViewCollection:[UIImageView]){
    
    //getting images from resource
    var path: [String]? =  Bundle.main.paths(forResourcesOfType: "png", inDirectory: "/AnimatedSandwich1")
    path?.append(contentsOf: Bundle.main.paths(forResourcesOfType: "png", inDirectory: "/AnimatedSandwich2"))
    path?.append(contentsOf: Bundle.main.paths(forResourcesOfType: "png", inDirectory: "/AnimatedSandwich3"))
    
    var pathIndex = 0 // no of all sandwich images flag
    var sandwichNo = 0 // sandwich type detect flag
    var imageViewIndex = 0 //uiimageView flag
    
    if #available(iOS 10.0, *) {
      
      _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { (timer) in
        
        //-----one iteration of all images when complete this block run--------
        if pathIndex == /(path?.count) - 1{
          
          for imageView in imageViewCollection {
            imageView.image = nil
          }
          
          imageViewIndex = 0
          sandwichNo = 0
          pathIndex = 0
        }
        
        //-----completion of on sandwich images iteration--------
        if ((sandwichNo == 0 || sandwichNo == 1) && imageViewIndex == 6) || (sandwichNo == 2 && imageViewIndex == 5){
          
          for imageView in imageViewCollection {
            imageView.image = nil
          }
          
          sandwichNo = sandwichNo == 0 ? 1 : sandwichNo == 1 ? 2 : 0
          imageViewIndex = 0
        }
        
        //setting image from resource path
        let imageFromPath = UIImage(contentsOfFile: (path?[pathIndex])!) ?? UIImage()
        imageViewCollection[imageViewIndex].image = imageFromPath
        
        pathIndex += 1
        imageViewIndex += 1
      })
    } else {
      // Fallback on earlier versions
    }
  }
  
}
