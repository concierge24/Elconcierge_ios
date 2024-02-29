//
//  CancellationVC.swift
//  Buraq24
//
//  Created by MANINDER on 03/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.


import UIKit
import CoreLocation


//MARK:- Enum
enum ReasonType {
    case cancel
    case halfWayStop
    case breakdown
    
    func getText() -> String? {
        
        switch self {
        case .cancel:
            return "cancellation"
            
        case .halfWayStop:
            return "half way stop"
            
        case .breakdown:
            return "breakdown"
        }
    }
}


protocol RequestCancelDelegate {
    func didSuccessOnCancelRequest()
    func didSuccessOnHalfWayStopped()
    func didSuccessOnVehicleBreakdown()
}

extension RequestCancelDelegate {
    func didSuccessOnHalfWayStopped() {}
    func didSuccessOnVehicleBreakdown() {}
}

class CancellationVC: UIViewController {
    
    
    //MARK:- OUTLETS
    @IBOutlet var viewOuter: UIView!
    @IBOutlet var txtViewCancelReson: PlaceholderTextView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    //MARK:- PROPERTIES
    
    var orderId : Int?
    var delegateCancellation: RequestCancelDelegate?
    var currentOrder: OrderCab?
    var trackingModal: TrackingModel?
    var isFromOngoingDetail: Bool = false
    var reasonType: ReasonType?
    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUpNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- ACTIONS
 
    @IBAction func actionBtnSubmitPressed(_ sender: Any) {
        
        view.endEditing(true)
        if (Validations.sharedInstance.validateCancellingReason(strReason: txtViewCancelReson.text)) {
            let strTrimmed = txtViewCancelReson.text.trimmed()
            
            if isFromOngoingDetail {
                
                guard let type = reasonType else {return}
                switch type {
               
                case .cancel:
                    debugPrint("cancel")
                    cancelRequest(cancelReson: strTrimmed, orderId: currentOrder?.orderId)
                    
                case .halfWayStop:
                    debugPrint("halfWayStop")
                    halfWayStopRequest(cancelReson: strTrimmed)
                    
                case .breakdown:
                    debugPrint("breakdown")
                    breakdownRequest(cancelReson: strTrimmed)
                    
                }
            } else {
                cancelRequest(cancelReson: strTrimmed, orderId: self.orderId)
            }
        }
    }
    
     //MARK:- FUNCTIONS
    
    func setupUI() {
        
        view.backgroundColor = UIColor.colorDarkGrayPopUp

        txtViewCancelReson.placeholder = "write_your_msg_here".localizedString as NSString
        txtViewCancelReson.setAlignment()
        
        view.layoutIfNeeded()
        
        labelTitle.text =  "Type your reason for " + (/isFromOngoingDetail ? /reasonType?.getText() : /ReasonType.cancel.getText())
        
        buttonSubmit.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func setUpNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(CancellationVC.dismissPopUp), name: Notification.Name(rawValue: LocalNotifications.DismissCancelPopUp.rawValue), object: nil)
    }
    
   
    func cancelPopUp() {
        dismissVC(completion: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LocalNotifications.DismissCancelPopUp.rawValue), object: nil)
    }
    
    
    @objc func dismissPopUp(notifcation : Notification) {
        
        if let objOrder = notifcation.object as? OrderCab {
            if /objOrder.orderId == /orderId {
               // cancelPopUp()
                
                if isFromOngoingDetail {
                    removeChildViewController()
                } else {
                    cancelPopUp()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            if hitView === viewOuter {
                
                if isFromOngoingDetail {
                  removeChildViewController()
                } else {
                    cancelPopUp()
                }
            }
        }
    }
    
    
}



extension CancellationVC {
    func cancelRequest(cancelReson : String, orderId: Int?) {
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let objCancel = BookServiceEndPoint.cancelRequest(orderId: /orderId, cancelReason: txtViewCancelReson.text)
        objCancel.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            switch response {
            case .success(_):
                
                if /self?.isFromOngoingDetail {
                    
                    DispatchQueue.main.async {[weak self] in
                        
                        self?.removeChildViewController()
                        self?.delegateCancellation?.didSuccessOnCancelRequest()

                        (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {[weak self] in
                        self?.delegateCancellation?.didSuccessOnCancelRequest()
                        self?.cancelPopUp()
                    }
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func halfWayStopRequest(cancelReson : String) {
        
        let pickUpLocation = CLLocation(latitude: /currentOrder?.pickUpLatitude, longitude: /currentOrder?.pickUpLongitude)
        let DropOffLocation = CLLocation(latitude: /trackingModal?.driverLatitude, longitude: /trackingModal?.driverLongitude)
        
        let distance = GoogleMapsDataSource.getDistance(newPosition: DropOffLocation, previous: pickUpLocation)
        let distanceInKM = Double(Float(distance)/1000)
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.halfWayStop(orderId: currentOrder?.orderId, latitude: trackingModal?.driverLatitude, longitude: trackingModal?.driverLongitude, order_distance: distanceInKM, half_way_stop_reason: cancelReson, payment_type: currentOrder?.paymentType.rawValue)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(_):
                debugPrint("Successs")
                
                DispatchQueue.main.async {[weak self] in
                        
                    self?.removeChildViewController()
                    self?.delegateCancellation?.didSuccessOnHalfWayStopped()
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func breakdownRequest(cancelReson : String) {
        
        let pickUpLocation = CLLocation(latitude: /currentOrder?.pickUpLatitude, longitude: /currentOrder?.pickUpLongitude)
        let DropOffLocation = CLLocation(latitude: /trackingModal?.driverLatitude, longitude: /trackingModal?.driverLongitude)
        
        let distance = GoogleMapsDataSource.getDistance(newPosition: DropOffLocation, previous: pickUpLocation)
        let distanceInKM = Double(Float(distance)/1000)
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.breakdownRequest(orderId: currentOrder?.orderId, latitude: trackingModal?.driverLatitude, longitude: trackingModal?.driverLongitude, order_distance: distanceInKM, reason: cancelReson)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(_):
                debugPrint("Successs")
                
                DispatchQueue.main.async {[weak self] in
                    self?.removeChildViewController()
                    self?.delegateCancellation?.didSuccessOnVehicleBreakdown()
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}

