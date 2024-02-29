//
//  Extension.swift
//  Idea
//
//  Created by Dhan Guru Nanak on 2/16/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import NVActivityIndicatorView
import SafariServices
import SDWebImage
import CoreLocation
import MapKit
import GoogleMaps
import Kingfisher
import Alamofire
import libPhoneNumber_iOS

typealias didTapTermsOfService = ()->()
typealias didTapPrivacyPolicy = ()->()

extension UIView {
    
     public func setTextFields(){
            for view in self.subviews {
                
                if view is UITextField {
                    let txtField = view as? UITextField
                    txtField?.textAlignment = setTexts()
                }
                else if view is UITextView {
                    
                    let txtView = view as? UITextView
                    txtView?.textAlignment = setTexts()
                }
        }
    }
    
        func setTexts() -> NSTextAlignment{
            if Localize.currentLanguage()  == Languages.Arabic || Localize.currentLanguage()  == Languages.Urdu {
                return .right
            }else {return .left}
        }
        
        func setViewLeftAlign(mainView : [UIView]){
            
            for view in mainView{
                if view is UITextField {
                    let txtField = view as? UITextField
                    txtField?.textAlignment = .left
                }
                else if view is UITextView {
                    
                    let txtView = view as? UITextView
                    txtView?.textAlignment = .left
                }
            }
        }
    
    func createCustomGradient(colors : [CGColor] , startPoint : CGPoint , endPoint : CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = layer.bounds
        gradient.colors = colors
        gradient.locations = [0, 1]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
       // gradient.startPoint = CGPoint(x: 0, y: 0)
       // gradient.endPoint = CGPoint(x: 0.5, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
   /* func setBackgroundThemeGradientColor(isGradient: Bool = false) {
        
        if isGradient {
            let gradient = CAGradientLayer()
             gradient.frame = layer.bounds
             gradient.colors = [
                UIColor(red:25/255.0, green:117/255.0, blue:254/255.0, alpha:1).cgColor,
             UIColor(red:25/255.0, green:117/255.0, blue:254/255.0, alpha:1).cgColor
             ]
             gradient.locations = [0, 1]
             gradient.startPoint = CGPoint(x: 1.21, y: -0.23)
             gradient.endPoint = CGPoint(x: -0.25, y: 1.23)
             self.layer.insertSublayer(gradient, at: 0)
            
        } else {
            

            let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                   
            switch template {
            case .DeliverSome:
                 self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
                break
            default:
                self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
            }
            
            

        }
    } */
}

extension UICollectionView {
    
    func getMidVisibleIndexPath() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.indexPathForItem(at: visiblePoint) else { return nil }
        return indexPath
    }
}

extension UITextField{
    
    func setAlignmentCab() {
        
        if Localize.currentLanguage()  == Languages.Arabic || Localize.currentLanguage()  == Languages.Urdu {
            self.textAlignment = .right
            
        }else {
            self.textAlignment = .left
        }
    }
    
    
  @IBInspectable var placeHolderColor: UIColor? {
    get {
      return self.placeHolderColor
    }
    set {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
    }
  }
}



extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0,alignment:NSTextAlignment = .center) {
    
    guard let labelText = self.text else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = alignment
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineHeightMultiple = lineHeightMultiple
    
    let attributedString:NSMutableAttributedString
    if let labelattributedText = self.attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelattributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }
    // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    
    self.attributedText = attributedString
  }
  
  func setUpTermsAndContion(text:String) {
    //    self.attributedText = Utility.shared.getAttributedTextWithFont(text: text, font: R.font.sfProTextLight(size: 12)!)
    self.setLineSpacing(lineSpacing: 4, lineHeightMultiple: 0)
    
    let text = /self.text
    let underlineAttriString = NSMutableAttributedString(string: text)
    let range1 = (text as NSString).range(of: "terms of Service")
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
    
    let range2 = (text as NSString).range(of: "Privacy Policy")
    underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range2)
    self.attributedText = underlineAttriString
  }
  
}

extension UIViewController : NVActivityIndicatorViewable {
  
  func startAnimateLoader(){
    self.startAnimating(CGSize.init(width: 24, height: 24), message: nil, messageFont: nil, type: .ballPulse, color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
  }
  
  func openHyperLink(link:String?){
    let addUrl = link
//    if addUrl?.lowercased().hasPrefix("http://")==false{
//      addUrl = "http://" + /addUrl
//    }
//
    guard let url = URL(string: /addUrl) else {return}
    let safariVC = SFSafariViewController(url:url)
    safariVC.delegate = self as? SFSafariViewControllerDelegate
    ez.topMostVC?.presentVC(safariVC)
    
  }
  
    func openHyperLinkURL(link:URL){
        
//        let addUrl = link
//        //    if addUrl?.lowercased().hasPrefix("http://")==false{
//        //      addUrl = "http://" + /addUrl
//        //    }
//        //
//        guard let url = URL(string: /addUrl) else {
//            return //be safe
//        }
        let safariVC = SFSafariViewController(url:link)
        safariVC.delegate = self as? SFSafariViewControllerDelegate
        ez.topMostVC?.presentVC(safariVC)
        
    }
  
  
  func openVideoPlayer(url:String){
    
    if let url = URL(string: url){
      
      let player = AVPlayer(url: url)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      
      self.present(playerViewController, animated: true) {
        playerViewController.player!.play()
      }
    }
  }
  
  
  func showShare(shareLink : [Any]?){
    if let linkToShare = shareLink, !linkToShare.isEmpty{
      let objectsToShare = [link] as [Any]
      let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
      ez.topMostVC?.present(activityVC, animated: true, completion: nil)
      
    }
  }
  
}

extension NSObject {
  
  func openSettings(){
    
    let alertController = UIAlertController(title: "Alert", message: "You have forcefully denied location permission. Please open settings to allow them.", preferredStyle: .alert)
    alertController.view.tag = 101 // to prevent one above another

    alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
    alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        if #available(iOS 10.0, *) {
          UIApplication.shared.open(settingsUrl)
        } else {
          // Fallback on earlier versions
          UIApplication.shared.openURL(settingsUrl)
        }
      }
    }))
    
    if !((ez.topMostVC as? UIAlertController)?.view.tag == 101) {
        ez.topMostVC?.present(alertController, animated: true, completion: nil)
    }
    
  }
  
  func checkForLocationPermissoion()  {
    
    if CLLocationManager.locationServicesEnabled() {
      
      switch(CLLocationManager.authorizationStatus()) {
        
      case  .restricted, .denied:
        openSettings()
        
      case .authorizedAlways, .authorizedWhenInUse:
        if ((ez.topMostVC as? UIAlertController)?.view.tag == 101) {
            (ez.topMostVC as? UIAlertController)?.dismissVC(completion: nil)
        }
        break
      case .notDetermined:
        break
      }
    } else {
      print("Location services are not enabled")
        openSettings()
    }
  }
  
  func snapShotOfMap(lat:Double,long:Double,imageViewMap:UIImageView) {
    
    let mapSnapshotOptions = MKMapSnapshotter.Options()
    
    // Set the region of the map that is rendered.
    let location = CLLocationCoordinate2DMake(lat, long) // Apple HQ
    let region = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
    mapSnapshotOptions.region = region
    
    // Set the scale of the image. We'll just use the scale of the current device, which is 2x scale on Retina screens.
    mapSnapshotOptions.showsPointsOfInterest = false
    mapSnapshotOptions.mapType = .standard
    mapSnapshotOptions.scale = UIScreen.main.scale
    
    // Set the size of the image output.
    mapSnapshotOptions.size = CGSize(width: ez.screenWidth - 32, height: 114)
    
    let snapShotter = MKMapSnapshotter(options: mapSnapshotOptions)
    
    snapShotter.start { (snapShot, error) in
      let image = snapShot?.image
      imageViewMap.image = image
    }
    
  }
    
    
    func alertBoxOption(message:String,title:String , leftAction : String , rightAction : String , ok:@escaping ()->(), cancel: @escaping ()->() ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
       
        alert.addAction(UIAlertAction(title: leftAction , style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            cancel()
        }))
        
        alert.addAction(UIAlertAction(title: rightAction, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            ok()
        }))
        
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }
    
    
  
  
  func alertBox(message:String,title:String, ok:@escaping ()->()) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
      ok()
    }))
    alert.addAction(UIAlertAction(title:"Cancel", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction!) in
      alert.dismiss(animated: true, completion: nil)
    }))
    
    ez.topMostVC?.present(alert, animated: true, completion: nil)
  }
  
  func alertBoxOk(message:String,title:String, ok:@escaping ()->()){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok".localizedString, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
      ok()
    }))
    ez.topMostVC?.present(alert, animated: true, completion: nil)
  }
  
    
    
  func callToNumber(number : String?) {
    
    if let url = URL(string: "tel://\(number ?? "9875642354")"), UIApplication.shared.canOpenURL(url) {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.openURL(url)
      }
    } else {
        debugPrint("Can't call to number")
    }
    
  }
  
  
  func sendEmailToUser(emalAddress : String?){
    
    let email = emalAddress ?? "foo@foo.com"
    if let url = URL(string: "mailto:\(email)") ,UIApplication.shared.canOpenURL(url)  {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
   }
  
  func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String,completion:@escaping(String)->()) {
    var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
    let lat: Double = Double("\(pdblLatitude)")!
    //21.228124
    let lon: Double = Double("\(pdblLongitude)")!
    //72.833770
    let ceo: CLGeocoder = CLGeocoder()
    center.latitude = lat
    center.longitude = lon
    
    let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
    
    ceo.reverseGeocodeLocation(loc, completionHandler:
      {(placemarks, error) in
        if (error != nil)
        {
          print("reverse geodcode fail: \(error!.localizedDescription)")
        }
        let pm = (placemarks ?? []) as [CLPlacemark]
        
        if pm.count > 0 {
          let pm = placemarks![0]
        
          var addressString : String = ""
          if pm.subLocality != nil {
            addressString = addressString + pm.subLocality! + ", "
          }
          if pm.thoroughfare != nil {
            addressString = addressString + pm.thoroughfare! + ", "
          }
          if pm.locality != nil {
            addressString = addressString + pm.locality! + ", "
          }
          if pm.country != nil {
            addressString = addressString + pm.country! + ", "
          }
          if pm.postalCode != nil {

            addressString = addressString + pm.postalCode! + " "
          }
          
          completion(addressString)
        }
    })
    
  }
  
}

//extension UIScrollView {
//    
//  func scrollToBottom(animated: Bool) {
//    
//    if self.contentSize.height < self.bounds.size.height { return }
//    let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
//    self.setContentOffset(bottomOffset, animated: animated)
//    
//  }
//}


//MARK:- UIImage Extension

extension UIImage {
    
    func imageWithImage( scaledToSize newSize:CGSize) -> UIImage{
         UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func getDriverImage(type : Int) -> UIImage {
        switch type {
        case 1:
            return #imageLiteral(resourceName: "ic_mini_truck_m_gas")
        case 2:
            return #imageLiteral(resourceName: "ic_mini_truck_water_m")
        case 3:
            return #imageLiteral(resourceName: "ic_truck_water_tank_m")
        case 4:
            return #imageLiteral(resourceName: "ic_truck_m_freights")
        case 5:
            return #imageLiteral(resourceName: "ic_mini_truck_m_tow")
        case 6:
            return #imageLiteral(resourceName: "ic_heavy_machinery_m")
        case 7:
            return #imageLiteral(resourceName: "ic_mini_cab_m")
        case 10:
            return #imageLiteral(resourceName: "ambu_marker")
        default:
            return #imageLiteral(resourceName: "ic_mini_truck_m_gas")
        }
    }
    
    
  enum JPEGQuality: CGFloat {
    
    case lowest  = 0.1
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }
  
    var png: Data? { return self.pngData() }
  
  func reduceSize(_ quality: JPEGQuality) -> UIImage {
  
    switch quality {
    case .low, .lowest:
      return self.kf.image(withRoundRadius: 0.0, fit: CGSize(width: 100.0, height: 100.0))
      
    default :
      return self.kf.image(withRoundRadius: 0.0, fit: CGSize(width: 200.0, height: 200.0))
    }
  }
  
  func jpeg(_ quality: JPEGQuality) -> Data? {
    
    return self.jpegData(compressionQuality: quality.rawValue)
  }
    
    func setLocalizedImage() -> UIImage{
        
        if Localize.currentLanguage()  == Languages.Arabic  || Localize.currentLanguage()  == Languages.Urdu {
            return self.imageFlippedForRightToLeftLayoutDirection()
        }
        return self
    }
    
}

//MARK: - UIImageView extension
extension UIImageView {
    
    
    func setRating(rating : Int) {
        
        switch rating {
        case 1 :
            self.image = #imageLiteral(resourceName: "ic_1")
        case 2 :
            self.image = #imageLiteral(resourceName: "ic_2")
        case 3 :
            self.image = #imageLiteral(resourceName: "ic_3")
        case 4 :
            self.image = #imageLiteral(resourceName: "ic_4")
        case 5 :
            self.image = #imageLiteral(resourceName: "ic_5")
        default:
            break
        }
    }
    
    func setRatingSmall(rating : Int) {
        
        switch rating {
        case 1 :
            self.image = #imageLiteral(resourceName: "ic_1s")
        case 2 :
            self.image = #imageLiteral(resourceName: "ic_2s")
        case 3 :
            self.image = #imageLiteral(resourceName: "ic_3s")
        case 4 :
            self.image = #imageLiteral(resourceName: "ic_4s")
        case 5 :
            self.image = #imageLiteral(resourceName: "ic_5s")
        default:
            break
        }
        
        
    }
  
  func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
    let gradient = CAGradientLayer()
    gradient.frame = frame
    gradient.colors = colors.map{$0.cgColor}
    self.layer.addSublayer(gradient)
  }
  
  func loadImage(url: String,indicator:Bool = true) {
    self.contentMode = .scaleAspectFill
    if url != "" {
      if url.contains("/") {
        if let url = URL(string: url) {
          
          if indicator{
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
          //  sd_setShowActivityIndicatorView(true)
            
            //self.sd_setIndicatorStyle(.gray)
          }
          self.sd_setImage(with: url, completed: nil)
        }
      }
    }
  }
  
  
  func isNull() -> Bool{
    if self.image == nil{
      Toast.show(text: "Please select a picture", type: .error)
      return true
    }else{
      return false
    }
  }
}


extension Float {
    
    
    func getBuraqShare(percent : Float) -> Float {
          return self * percent / 100
     }
    

    
    var getZoomPercentage : Float {
        
        let range = maximumZoom - minimumZoom
        let startValue = self - minimumZoom
         return (startValue*100)/range
    }
}

//MARK: - String extension
extension String {
    
    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }
    var trailingSpacesTrimmed: String {
        var newString = self
        
        while newString.hasSuffix(" ") {
            newString = String(newString.dropLast())
        }
        
        return newString
    }
    
    
    
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        // Use NumberFormatter to check if we can turn the string into a number
        // and to get the locale specific decimal separator.
       
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
        
        // Check if we can create a valid number. (The formatter creates a NSNumber, but
        // every NSNumber is a valid double, so we're good!)
        if formatter.number(from: self) != nil {
            // Split our string at the decimal separator
            let split = self.components(separatedBy: decimalSeparator)
            
            // Depending on whether there was a decimalSeparator we may have one
            // or two parts now. If it is two then the second part is the one after
            // the separator, aka the digits we care about.
            // If there was no separator then the user hasn't entered a decimal
            // number yet and we treat the string as empty, succeeding the check
            let digits = split.count == 2 ? split.last ?? "" : ""
            
            // Finally check if we're <= the allowed digits
            return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
        }
        
        return false // couldn't turn string into a valid number
    }
    func getTwoDecimalFloat() -> String {
      return  String(format: "%.02f", self.floatValue)
        
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    var localizedString : String {
         return NSLocalizedString(self, comment:"")
    }
  
  func getTheSnippet(afterThis:String)-> String{
    if let range = self.range(of: afterThis) {
      let snippet = self.substring(from: range.upperBound).trimmingCharacters(in: .whitespacesAndNewlines)
      return snippet
    }else{
      return ""
    }
  }
  
  func directTextHeight(textFont : UIFont?) -> CGFloat {
    
    guard let font = textFont else { return 0.0 }
    let width = UIScreen.main.bounds.width - 100
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
    return boundingBox.height
  }
  
  //string to date
  func stringToDate(_ date:String , format:String)->Date  {
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format //Your date format
    let date1 = dateFormatter.date(from: String(date)) //according to date format your date string
    return date1 ?? Date()
    
  }
  
    
    func getLocalDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.date(from: self)
        
    }
    
    
  func isEmptyText(withErrorMessage:String?) -> Bool{
    
    if self.trimmed().isEmpty{
      Toast.show(text: withErrorMessage, type: .error)
      return true
    } else {
      return false
    }
  }
  
  func isNull() ->String? {
    if self.trimmed().isEmpty{
      return nil
    }
    return self
  }
  
  func validateUrl () -> Bool {
    let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
  }
  
  
  func widthOfString() -> CGFloat {
    
    let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 14)]
    let size = self.size(withAttributes: fontAttributes)
    return size.width
  }
  
  public func separate(withChar char : String) -> [String]{
    var word : String = ""
    var words : [String] = [String]()
    for chararacter in self {
      if String(chararacter) == char && word != "" {
        words.append(word)
        word = char
      }else {
        word += String(chararacter)
      }
    }
    words.append(word)
    return words
  }
    
    func openAppStore() {
        
          if let url = URL(string: self), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]) { (result) in
                }
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
   
    // Get iso code from contact
    func getISOAndCountryCode() -> (String?, String?) {
        
        do {
            let phoneUtil = NBPhoneNumberUtil.sharedInstance()
            let phoneNumber =  try phoneUtil?.parse(self, defaultRegion: "")
            
           // guard let countryCode = phoneUtil?.extractCountryCode(self, nationalNumber: nil) else {return("")}
            
             guard let isoCode = phoneUtil?.getRegionCode(for: phoneNumber),
                   let countryCode = phoneUtil?.extractCountryCode(self, nationalNumber: nil) else {return(("",""))}
            
            debugPrint("- isValidNumber", phoneUtil?.isValidNumber(phoneNumber) as Any)
            debugPrint("- isPossibleNumber", phoneUtil?.isPossibleNumber(phoneNumber) as Any)
            debugPrint("- getRegionCode", phoneUtil?.getRegionCode(for: phoneNumber) as Any)
            debugPrint("- extractPossibleNumber", phoneUtil?.extractPossibleNumber(self) as Any)
            debugPrint("- extractCountryCode", phoneUtil?.extractCountryCode(self, nationalNumber: nil) as Any)
            
            return( String(describing: isoCode), String(describing: countryCode))
        } catch {
            return("","")
        }
    }
    
    func flag() -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    func locale() -> String? {
        
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if self.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        
        return nil
    }
    
    mutating func insert(string:String, ind: Int) {
      self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }

}

extension UIPickerView {
  
  func addKeyboardToolBar() {
    let toolBar = UIToolbar()
    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done".localizedString, style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: Selector(("donePicker")))
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
  }
}

extension UIButton{
  
  func bounce(){
    self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   options: .allowUserInteraction,
                   animations: { [weak self] in
                    self?.transform = .identity
      },
                   completion: nil)
  }
  
  func transformContent(){
    self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
  }
  
  func setInsetsWithImage(){
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.size.width - 24, bottom: 0, right: 0)
    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.frame.size.width/2 + 16)
  }
  
  func addGradient(topColor:UIColor,bottomColor:UIColor,statPoint:CGPoint,endPoint:CGPoint){
    let gradient:CAGradientLayer = CAGradientLayer()
    let colorTop = topColor
    let colorBottom = bottomColor
    
    gradient.colors = [colorTop, colorBottom]
    gradient.startPoint = statPoint
    gradient.endPoint = endPoint
    gradient.frame = self.bounds
    gradient.cornerRadius = 5
    self.layer.insertSublayer(gradient, at: 0)
  }
}
extension UITextView{
    
    
    func setAlignmentCab() {
        
        if Localize.currentLanguage()  == Languages.Arabic || Localize.currentLanguage()  == Languages.Urdu {
            self.textAlignment = .right
            
        }else {
            self.textAlignment = .left
        }
    }
  
  func resolveHashTags() -> (NSAttributedString,[String]){
    var length : Int = 0
    let text:String = self.text
    let words:[String] = self.text.separate(withChar: " ")
    let hashtagWords = words.flatMap({$0.separate(withChar: "#")})
    let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)]
    let attrString = NSMutableAttributedString(string: text, attributes:attrs)
    var hashWord = [String]()
    var iterateIndex = 0
    for word in hashtagWords {
      if word.hasPrefix("#") {
        
        let matchRange:NSRange = NSMakeRange(length, word.count)
        let stringifiedWord:String = word
        hashWord.append(word)
        attrString.addAttribute(NSAttributedString.Key.link, value: "hash:\(stringifiedWord)", range: matchRange)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HASHTAG"), object: nil, userInfo: [iterateIndex:word])
        iterateIndex += 1
      }
      length += word.count
    }
    return (attrString,hashWord)
  }
  
}


@IBDesignable class HeaderViewWithShadow: UIView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.shadowOffset = CGSize(width: 0, height: 3)
    self.layer.shadowOpacity = 0
    self.layer.shadowRadius = 2
    self.layer.shadowColor = UIColor.lightGray.cgColor
  }
}


@IBDesignable class SmallerSwitch: UISwitch {
  override func layoutSubviews() {
    super.layoutSubviews()
    setup()
  }
  func setup() {
    transform = CGAffineTransform(scaleX: 0.774, y: 0.774)
    layer.cornerRadius = self.frame.height / 2.0
  }
}


@IBDesignable class TTNavigationBar: UINavigationBar {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.barTintColor = UIColor.white
    self.titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "Lato-Bold", size: 14)!]
  }
}


extension UITextView{
  
  func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
    
    guard let labelText = self.text else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineHeightMultiple = lineHeightMultiple
    
    let attributedString:NSMutableAttributedString
    if let labelattributedText = self.attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelattributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }
    // Line spacing attribute
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    
    self.attributedText = attributedString
  }
  
  
  
}

extension UIPageViewController {
  
  func goToCenterVC(viewController:UIViewController?){
    
    guard let seconVC = viewController else { return }
    setViewControllers([seconVC], direction: .forward, animated: false, completion: nil)
    
  }
}

extension UITapGestureRecognizer {
  
  func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
    // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
    let layoutManager = NSLayoutManager()
    let textContainer = NSTextContainer(size: CGSize.zero)
    let textStorage = NSTextStorage(attributedString: label.attributedText!)
    
    // Configure layoutManager and textStorage
    layoutManager.addTextContainer(textContainer)
    textStorage.addLayoutManager(layoutManager)
    
    // Configure textContainer
    textContainer.lineFragmentPadding = 0.0
    textContainer.lineBreakMode = label.lineBreakMode
    textContainer.maximumNumberOfLines = label.numberOfLines
    let labelSize = label.bounds.size
    textContainer.size = labelSize
    
    // Find the tapped character location and compare it to the specified range
    let locationOfTouchInLabel = self.location(in: label)
    let textBoundingBox = layoutManager.usedRect(for: textContainer)
    let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,y:
      (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,y:
      locationOfTouchInLabel.y - textContainerOffset.y);
    let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
    
    return NSLocationInRange(indexOfCharacter, targetRange)
  }
  
}

extension NSLayoutConstraint {
  func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
  }
}

extension UITableView{
  
  func registerNibTableCell(nibName:String){
    let nib = UINib(nibName: nibName, bundle: nil)
    self.register(nib, forCellReuseIdentifier: nibName)
  }
 
  
}

extension UICollectionView{
  
  func getVisibleIndexOnScroll()-> IndexPath?{
    
    var visibleRect = CGRect()
    visibleRect.origin = self.contentOffset
    visibleRect.size = self.bounds.size
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    let indexPath = self.indexPathForItem(at: visiblePoint)
    return indexPath
  }
  
  func registerNibCollectionCell(nibName:String,reuseIdentifier:String){
    let nib = UINib(nibName: nibName, bundle: nil)
    self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func deselectAllItems(animated: Bool = false) {
    for indexPath in self.indexPathsForSelectedItems ?? [] {
      self.deselectItem(at: indexPath, animated: animated)
    }
  }
  
}


extension NSMutableAttributedString {
  
  //    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
  //      let attrs: [NSAttributedStringKey: Any] = [(NSFontAttributeName as NSString) as NSAttributedStringKey: UIFont(name:R.font.sfuiDisplayBold.fontName, size: 13)!]
  //        let boldString = NSMutableAttributedString(string:text, attributes: attrs as [String : Any])
  //        append(boldString)
  //
  //        return self
  //    }
  //
  //    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
  //      let attrs: [NSAttributedStringKey: Any] = [(NSFontAttributeName as NSString) as NSAttributedStringKey: UIFont(name:R.font.sfuiDisplayRegular.fontName, size: 13)!]
  //        let boldString = NSMutableAttributedString(string:text, attributes: attrs as [String : Any])
  //        append(boldString)
  //
  //        return self
  //    }
}

extension URL
{
  
  static var documentsDirectory: URL {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
     return try! documentsDirectory.asURL()
  }
  
  static func urlInDocumentsDirectory(with filename: String) -> URL {
    return documentsDirectory.appendingPathComponent(filename)
  }
  
  
  func getMediaDuration() -> Float64{
    
    let asset : AVURLAsset = AVURLAsset.init(url: self) as AVURLAsset
    let duration : CMTime = asset.duration
    return CMTimeGetSeconds(duration)
    
  }
  
  func generateThumbnail() -> UIImage? {
    do {
      let asset = AVURLAsset(url: self)
      let imageGenerator = AVAssetImageGenerator(asset: asset)
      imageGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imageGenerator.copyCGImage(at: CMTime.zero, actualTime: nil)
      
      return UIImage(cgImage: cgImage)
    } catch {
      print(error.localizedDescription)
      
      return nil
    }
  }
}

extension Int {
    
    
    func formattedTimer() -> String {
        
        let mintues = self/60
        let seconds = self%60
        return String(format: "%02d : %02d", mintues ,seconds )
    }
    
}

extension NSObject{
  
//  func uploadMedia(mediaData: Data,fileName:String,mediaType:media,completion:@escaping(_ url:String)->())-> (Uploading){
//
//    let set = S3BucketHelper.shared.uploadRequest(data: mediaData,
//                                                  fileName: fileName,
//                                                  mediaType: .image,mimeType : mediaType == .video ? "mp4" : nil) { (Url) in
//                                                    guard let url = Url else { return }
//                                                    completion(url.absoluteString)
//                                                    print("--------------------\(url)")
//    }
//
//    return (Uploading(name: fileName, uploadRequest: set.0, transferManager: set.1, isAlreadyUploaded: false))
//
//  }
  
  func setExclusiveTouchToButtons(from view: UIView) {
    for subview: UIView in view.subviews {
      if subview.subviews.count > 0 {
        setExclusiveTouchToButtons(from: subview)
      }
      else if (subview is UIButton) {
        subview.isExclusiveTouch = true
      }
    }
  }
  
  func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
      else {
        return nil
    }
    do {
      var contents = try String(contentsOfFile: filepath, encoding: .utf8)
      contents = cleanRows(file: contents)
      return contents
    } catch {
      print("File Read Error for file \(filepath)")
      return nil
    }
  }
  
  
  func cleanRows(file:String)->String{
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
    return cleanFile
  }
  
  func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
      let columns = row.components(separatedBy: ",")
      result.append(columns)
    }
    return result
  }
  
}

extension Double {
    
  var cleanValue: String {
    return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
  }
    
    var radianValue: Double {
        return self * .pi / 180.0
    }
    var degreeValue: Double {
        return self * 180.0 / .pi
    }
    
    
    
   
    
}

extension Array where Element: Equatable {
  
  @discardableResult mutating func remove(object: Element) -> Bool {
    if let index = index(of: object) {
      self.remove(at: index)
      return true
    }
    return false
  }
  
  @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
    if let index = self.index(where: { (element) -> Bool in
      return predicate(element)
    }) {
      self.remove(at: index)
      return true
    }
    return false
  }
  
}

extension Array where Element : Any{
    
    
    func toJson() -> String {
        do {
            let data = self
            
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
            var string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) ?? ""
            string = string.replacingOccurrences(of: "\n", with: "") as NSString
            debugPrint(string)
            string = string.replacingOccurrences(of: "\\", with: "") as NSString
            debugPrint(string)
            //            string = string.replacingOccurrences(of: "\"", with: "") as NSString
           // string = string.replacingOccurrences(of: " ", with: "") as NSString
            debugPrint(string)
            return string as String
        }
        catch let error as NSError{
            debugPrint(error.description)
            return ""
        }
    }
    
    
    
    func indexOfObject(object : Any) -> NSInteger {
        return (self as NSArray).index(of: object)
    }
    
}

extension GMSMapView {
  func setMarker(
    location:CLLocationCoordinate2D
    , marker:GMSMarker
    , imageName:String
    , rotateHead:CLLocationDirection?
    , isSetCameraOnMarker:Bool)
  {
    if rotateHead != nil
    {
      marker.rotation = rotateHead ?? 0
    }
    
    let lat = /location.latitude
    let long = /location.longitude
    //    let markerImage = UIImage(named: imageName)!
   // marker.iconView = EventMarkerView.loadNibMarker() Maninder
    marker.position = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
    //    marker.icon = markerImage
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.map = self
    
    if isSetCameraOnMarker{
      let currentLoc = GMSCameraPosition.camera(withLatitude: lat,
                                                longitude: long,
                                                zoom: 17)
      self.camera = currentLoc
    }
  }
  
  func setMarker(
    location:CLLocationCoordinate2D
    , marker:GMSMarker
    , isBoy:Bool
    , rotateHead:CLLocationDirection?
    , isSetCameraOnMarker:Bool)
  {
    if rotateHead != nil
    {
      marker.rotation = rotateHead ?? 0
    }
    
    let lat = /location.latitude
    let long = /location.longitude
    let markerImage = isBoy ? #imageLiteral(resourceName: "boy.png") : #imageLiteral(resourceName: "girl .png")
    marker.iconView = UIImageView(image: markerImage)
    marker.position = CLLocationCoordinate2D(latitude: Double(lat), longitude: Double(long))
    //    marker.icon = markerImage
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.map = self
    
    if isSetCameraOnMarker {
      let currentLoc = GMSCameraPosition.camera(withLatitude: lat,
                                                longitude: long,
                                                zoom: 17)
      self.camera = currentLoc
    }
  }
  
}


extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
    }
    var iPhoneX: Bool{
        return UIDevice.current.hasNotch
//        return UIScreen.main.nativeBounds.height == 2436
    }
    
}
extension Data {
    
    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.pointee }
    }
}

