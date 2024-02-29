//
//  UtilityFunctions.swift
//  Clikat Supplier
//
//  Created by Night Reaper on 08/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import TYAlertController
import RMDateSelectionViewController
import EZSwiftExtensions
import SystemConfiguration
import NVActivityIndicatorView
import AVFoundation


extension UIWindow : Dimmable {
    
}
class UtilityFunctions {
    
    class func startLoader(){

//        UtilityFunctions.sharedAppDelegateInstance().window?.addSubview(activityIndicator)
    }
    
    class func stopLoader(){
//        GiFHUD.dismiss()
    }
    
    

    class func shareContentOnSocialMedia (withViewController controller : UIViewController?,message : String?){
        let  activityController = UIActivityViewController(activityItems: [message ?? ""], applicationActivities: [])
        controller?.present(activityController, animated: true, completion: nil)
    }
    
    class func appendOptionalStrings(withArray array : [String?]) -> String {

        return array.compactMap{$0}.joined(separator: " ")
    }
    
    class func  appendOptionalStrings(withArray array : [String?],separatorString : String) -> String {
        
        return array.compactMap{$0}.joined(separator: separatorString)
    }
    
    class func blendImage(blendingImage: UIImage?, color: UIColor) -> UIImage?{
        
        guard let image = blendingImage else{return nil}
        
        let ciImage = CIImage(image: image)
        guard let filter = CIFilter(name: "CIMultiplyCompositing"), let colorFilter = CIFilter(name: "CIConstantColorGenerator") else {return UIImage()}
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
        return UIImage(ciImage: filter.outputImage!)
        
    }
    
    
    class func sharedAppDelegateInstance() -> AppDelegate  {
        
        let delegate = UIApplication.shared.delegate
        return delegate as! AppDelegate
    }
    
    class func showAlert(message : String?){
        
        let alert = TYAlertView(title: "", message: message)
        alert?.buttonDefaultBgColor = Colors.MainColor.color()
        alert?.add(TYAlertAction(title: "OK", style: TYAlertActionStyle.default, handler: { (action) in
            alert?.hide()
        }))
        alert?.showInWindow()
    }
    
    class func showAlert(title : String?,message : String?,success: @escaping () -> (),cancel: @escaping () -> ()){
        let alert = TYAlertView(title: title,message: message)
        alert?.buttonDefaultBgColor = Colors.MainColor.color()
        alert?.add(TYAlertAction(title: "Cancel", style: TYAlertActionStyle.default, handler: { (action) in
            alert?.hide()
            cancel()
        }))
        alert?.add(TYAlertAction(title: "OK", style: TYAlertActionStyle.default, handler: { (action) in
            alert?.hide()
            success()
        }))

        alert?.showInWindow()
    }
    
    static func showDatePicker(viewController : UIViewController, datePickerMode : UIDatePicker.Mode, initialDate : Date = Date()  , minDate : Date?,title : String?,message : String?, selectedDate: @escaping (Date) -> (),cancel: @escaping () -> ()){
        
        var selectAction: RMAction<UIDatePicker>? = nil
        var cancelAction: RMAction<UIDatePicker>? = nil
        
        selectAction = RMAction<UIDatePicker>.init(title: "Select", style: .additional, andHandler: { (controller) in
            selectedDate(controller.contentView.date)
        })
        
        cancelAction = RMAction<UIDatePicker>.init(title: "Cancel", style: .cancel, andHandler: { (controller) in
            cancel()
        })
        
        guard let datePicker = RMDateSelectionViewController(style: .white, title: title, message: message, select: selectAction, andCancel: cancelAction)else { return }
        
        datePicker.datePicker.date = initialDate
        datePicker.datePicker.datePickerMode = datePickerMode
        datePicker.datePicker.minimumDate = minDate
        ez.runThisAfterDelay(seconds: 0.01) {
            viewController.presentVC(datePicker)
        }
        
    }
    
    class func showActionSheet(withTitle title : String? , subTitle : String? , vc : UIViewController? , senders : [Any] , success : @escaping (Any,Int) -> ()){
        let alertView = TYAlertView(title: title, message: subTitle)
        alertView?.buttonDefaultBgColor = Colors.MainColor.color()
        let alert = TYAlertController(alert: alertView , preferredStyle: TYAlertControllerStyle.actionSheet , transitionAnimation: TYAlertTransitionAnimation.fade)
        
        for (index,element) in senders.enumerated() {
            alertView?.add(TYAlertAction(title: element as? String, style: TYAlertActionStyle.default, handler: { (action) in
                alertView?.hide()
                success(element,index)
            }))
        }
        alertView?.add(TYAlertAction(title: L10n.Cancel.string, style: TYAlertActionStyle.cancel, handler: { (action) in
            alertView?.hide()
        }))
        vc?.presentVC(alert ?? TYAlertController(alert: alertView))
        
    }


    
    static func showDatePicker(viewController : UIViewController,minDate : Date?,title : String?,message : String?, selectedDate: @escaping (Date) -> (),cancel: @escaping () -> ()){
        
        var selectAction: RMAction<UIDatePicker>? = nil
        var cancelAction: RMAction<UIDatePicker>? = nil
        
        selectAction = RMAction<UIDatePicker>.init(title: "Select", style: .done, andHandler: { (controller) in
            selectedDate(controller.contentView.date)
        })
        
        
        cancelAction = RMAction<UIDatePicker>.init(title: "Cancel", style: .cancel, andHandler:{ (controller) in
            cancel()
        })
        
        guard let datePicker = RMDateSelectionViewController(style: .white, title: title, message: message, select: selectAction, andCancel: cancelAction) else { return }
        datePicker.datePicker.minimumDate = minDate
        ez.runThisAfterDelay(seconds: 0.01) {
            viewController.presentVC(datePicker)
        }
        
    }
    
    static func getDateFormatted(format : String,date : Date?) -> String?{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        return dateformatter.string(from: date ?? Date())
    }
    
    static func getTimeFormatted(format : String,date : Date?) -> String{
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = format
        return timeformatter.string(from: date ?? Date())
    }

    
    
    static func addParallaxToView(view : UIView){
        let leftRightMin = -20.0
        let leftRightMax = 20.0
        
        let upDownMin = -20.0
        let upDownMax = 20.0
        
        
        let leftRight = UIInterpolatingMotionEffect(keyPath: "center.x",type: .tiltAlongHorizontalAxis)
        leftRight.minimumRelativeValue = leftRightMin
        leftRight.maximumRelativeValue = leftRightMax
        let upDown = UIInterpolatingMotionEffect(keyPath: "center.y",type: .tiltAlongVerticalAxis)
        upDown.minimumRelativeValue = upDownMin
        upDown.maximumRelativeValue = upDownMax
        
        //Create a motion effect group
        let meGroup = UIMotionEffectGroup()
        meGroup.motionEffects = [leftRight, upDown]
        
        view.addMotionEffect(meGroup)
    }
    static func showSweetAlert(title : String?,message : String?,success: @escaping () -> (),cancel: @escaping () -> ()){
        SweetAlert().showAlert(title: /title, subTitle: message, style: AlertStyle.Warning, buttonTitle:L10n.Cancel.string, buttonColor:UIColor.darkGray , otherButtonTitle:  L10n.OK.string, otherButtonColor: Colors.AlertButton.color()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                cancel()
            }else {
                success()
            }
        }
        
        
    }
    
    
    static func showSweetAlert(title : String?,message : String?,style:AlertStyle,success: @escaping () -> (),cancel: @escaping () -> ()){
        SweetAlert().showAlert(title: /title, subTitle: message, style: style, buttonTitle:L10n.Cancel.string, buttonColor:UIColor.darkGray , otherButtonTitle:  L10n.OK.string, otherButtonColor: Colors.AlertButton.color()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                cancel()
            }else {
                success()
            }
        }
        
        
    }
    
    static func showSweetAlert(title : String?,message : String?,style : AlertStyle,success: @escaping () -> ()){
        
        SweetAlert().showAlert(title: title ?? "", subTitle: message, style: style, buttonTitle:L10n.OK.string, buttonColor:Colors.AlertButton.color()) { (isOtherButton) -> Void in
            if isOtherButton == true {
                success()
            }
        }
    }
    static func showSweetAlert(title : String?,message : String?,style : AlertStyle){
        
        SweetAlert().showAlert(title: title ?? "", subTitle: message, style: AlertStyle.Success)
    }
    
    static func isCameraPermission() -> Bool{
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
            
        case .authorized: return true
        case .restricted: return false
        case .denied: return false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                
            })
            return true
        }
    }
    
}

extension UtilityFunctions {
    //Show Camera Unavailable Alert
    
    static func alertToEncourageCameraAccessWhenApplicationStarts(viewController : UIViewController?){
        //Camera not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: L10n.CameraUnavailable.string, message: L10n.ItLooksLikeYourPrivacySettingsArePreventingUsFromAccessingYourCamera.string, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: L10n.Settings.string, style: .destructive) { (_) -> Void in
            let settingsUrl = URL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: L10n.OK.string, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        viewController?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    static func alertToEncourageLocationAccess(viewController : UIViewController?){
        //Camera not available - Alert
        let cameraUnavailableAlertController = UIAlertController (title: L10n.LocationUnavailable.string, message: L10n.PleaseCheckToSeeIfYouHaveEnabledLocationServices.string, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: L10n.Settings.string, style: .destructive) { (_) -> Void in
            let settingsUrl = URL(string:UIApplication.openSettingsURLString)
            if let url = settingsUrl {
                DispatchQueue.main.async {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: L10n.OK.string, style: .default, handler: nil)
        cameraUnavailableAlertController .addAction(settingsAction)
        cameraUnavailableAlertController .addAction(cancelAction)
        viewController?.present(cameraUnavailableAlertController , animated: true, completion: nil)
    }
    
    static func convertArrayIntoJson(array: [Dictionary<String,String>]?) -> String? {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: array ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
            
            var string = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
            print(string)
            string = string.replacingOccurrences(of: "\n", with: "")
            string = string.replacingOccurrences(of: "\\\"", with: "\"")
            string = string.replacingOccurrences(of: "\"", with: "")
            string = string.replacingOccurrences(of: "\\", with: "") // removes \
            string = string.replacingOccurrences(of: " ", with: "")
            string = string.replacingOccurrences(of: "/", with: "")
            print(string)
            return string as String
        }catch let error as NSError {
            
            print(error.description)
            return ""
        }
    }
}


//MARK: - ImageScaling
extension UIImage {
   
    func resizeWith(width: CGFloat,height : CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height:height )))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
