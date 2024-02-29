//
//  UnderProcessingView.swift
//  Buraq24
//
//  Created by MANINDER on 28/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class UnderProcessingView: UIView {

    //MARK:- Outlets
    //MARK:-
    
    @IBOutlet var lblDropOffLocation: UILabel!
    @IBOutlet var lblFinalAmount: UILabel!
    @IBOutlet var lblServiceBrandName: UILabel!
    @IBOutlet var lblOrderDetails: UILabel!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet var progressBarTimeOut: UIProgressView!
    

    //MARK:- Properties
    //MARK:-
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    var isAdded : Bool = false
    var orderCurrent : OrderCab?
    var serviceRequest = ServiceRequest()
    var frameHeight : CGFloat = 277
    var delegate : BookRequestDelegate?
    
    var requestTimeOutTimer : Timer?
    var currentSeconds: Float  = 0.0
    var viewSuper : UIView?
    var bgTask : UIBackgroundTaskIdentifier?
    var timeOutTime : Float = 120
    var isHalfWayStop: Bool = false
    var isVehicleBreakdown: Bool = false
    
    
    //MARK:- Actions
    //MARK:-
    
    @IBAction func actionBtnCancelPressed(_ sender: UIButton) {
     // minimizeProcessingView()
        
        if isHalfWayStop {
            self.delegate?.didSelectNext(type: .CancelHalfwayStop)
        } else if isVehicleBreakdown {
            self.delegate?.didSelectNext(type: .CancelVehiclebreakdown)
        } else {
            self.delegate?.didSelectNext(type: .CancelOrderOnSearch)
        }
        
        guard let timer = requestTimeOutTimer else{return}
        timer.invalidate()
    }
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeProcessingView() {
        
        requestTimeOutTimer?.invalidate()
        currentSeconds = 0.0
        progressBarTimeOut.progress = 0.0
        endBackgroundTask()
        
//          Alerts.shared.show(alert: "AppName".localizedString, message: "currently_no_driver_available".localizedString , type: .info )
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeProcessingView() {
        
        frameHeight = UIDevice.current.iPhoneX ? 277 + 34 : 277
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          // Ankush  self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    func setupUI() {
        buttonCancel.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        progressBarTimeOut.progressTintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
    }
    
    func showWaitingView(superView : UIView ,order : OrderCab, isHalfWayStop: Bool = false, isVehicleBreakdown: Bool = false, serviceRequest: ServiceRequest ) {
        
        orderCurrent = order
        self.serviceRequest = serviceRequest
        
        self.isHalfWayStop = isHalfWayStop
        self.isVehicleBreakdown = isVehicleBreakdown
        
        if !isAdded {
            
            // Ankush frameHeight =  superView.frame.size.width*75/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        assignPopUpData()
         maximizeProcessingView()
        startTimer()
    }
    
    ///Assign Data to Pop up Outlets
    func assignPopUpData() {
        
        guard let order = orderCurrent else {return}
        //timeOutTime = order.bookingType == .Future ? 50 : 46
        lblDropOffLocation.text = /order.dropOffAddress
        

        if  /order.serviceId == 4 ||  /order.serviceId == 2 {
            
            lblServiceBrandName.text = /order.orderProductDetail?.productBrandName
        }else{
            
            guard let service = UDSingleton.shared.getService(categoryId: order.serviceId) else {return}
            lblServiceBrandName.text = /service.serviceName
        }
        
        if /order.serviceId  > 3 {
            
            lblOrderDetails.text = /order.orderProductDetail?.productName

            
//            if let pricePPD = request.selectedProduct?.pricePerDistance {
//                totalCost = (pricePPD * request.distance)
//
//            }
//
//            if let pricePPQ = request.selectedProduct?.pricePerQuantity{
//                totalCost = totalCost + (pricePPQ * Float(request.quantity))
//            }
//            totalCost = totalCost + Float(/request.selectedProduct?.alphaPrice)
//
//
//
//            lblFinalPrice.text =  String(totalCost).getTwoDecimalFloat() +  " " + "currency".localizedString
            
            
            
            
//             if let chargePerKiloMet = Float(/order.payment?.productPerDistanceCharge)  , let distance = Float(/order.payment?.orderDistance){
//                finalCharge
//
//                var firstPrice = (distance * chargePerKiloMet) + Float(/order.orderProductDetail?.productAlphaPrice)
//                firstPrice = firstPrice + firstPrice.getBuraqShare(percent: /(order.payment?.buraqPercentage))
            
            
            
        } else{
            
            guard let quantity =  order.payment?.productQuantity else { return }
            lblOrderDetails.text = /order.orderProductDetail?.productName + " × " +  String(quantity)
          
//            if let chargeQuantity = Float(/order.payment?.productPerQuantityCharge) {
//                var firstPrice = (chargeQuantity * Float(quantity)) + Float(/order.orderProductDetail?.productAlphaPrice)
//                firstPrice = firstPrice + firstPrice.getBuraqShare(percent: /(order.payment?.buraqPercentage))
//                 lblFinalAmount.text =  String(firstPrice).getTwoDecimalFloat() + " " + "currency".localizedString
//            }
        }
    
        lblFinalAmount.text =  (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/order.payment?.finalCharge?.toFloat())
 
    }
    
    
    func  startTimer() {
        
        registerBackgroundTask()
        requestTimeOutTimer?.invalidate()
        requestTimeOutTimer = nil
        currentSeconds = 0.0
        
        self.requestTimeOutTimer = Timer.scheduledTimer(timeInterval: 1, target: self , selector: #selector(UnderProcessingView.updateProgressBar), userInfo: nil, repeats: true)
    }
    
    @objc func updateProgressBar() {
        
       
        if currentSeconds < timeOutTime {
            
            // Ankush -- getting issue during halfway stop
         /*   if Int(currentSeconds) % 5  == 0 {
                self.delegate?.didRequestTimeout()
            } */
            print("Current Second", currentSeconds)
            print("tineouttime", timeOutTime)
            currentSeconds = currentSeconds + 1
            progressBarTimeOut.progress = currentSeconds / timeOutTime
        } else{
            
            
            requestTimeOutTimer?.invalidate()
            progressBarTimeOut.progress = 1.0
            endBackgroundTask()
            
            if /orderCurrent?.isContinueFromBreakdown {
                delegate?.didSelectNext(type: .CancelOrderOnSearch)
                alertBoxOk(message: "no_driver".localizedString, title: "AppName".localizedString, ok: {})

            } else if isHalfWayStop {
                self.delegate?.didSelectNext(type: .CancelHalfwayStop)
            } else if isVehicleBreakdown {
                self.delegate?.didSelectNext(type: .CancelVehiclebreakdown)
            } else {
                self.delegate?.didRequestTimeout()
            }

            guard let timer = requestTimeOutTimer else{return}
            timer.invalidate()
            
            
        }
    }
    
    //MARK:- Background Tasks
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {

        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }

}
