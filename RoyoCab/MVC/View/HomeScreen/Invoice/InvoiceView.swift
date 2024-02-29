//
//  InvoiceView.swift
//  Buraq24
//
//  Created by MANINDER on 28/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class InvoiceView: UIView {
    
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var previousChargesStackView: UIStackView!
    @IBOutlet weak var baseFareHeadingLabel: UILabel!
    @IBOutlet weak var lblPreviousCharges: UILabel!
    @IBOutlet weak var lblWaitingCharges: UILabel!
    @IBOutlet var lblBrandName: UILabel!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblBaseFairValue: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelTimeValue: UILabel!
    @IBOutlet var labelDistance: UILabel!
    @IBOutlet var labelDistanceValue: UILabel!
    @IBOutlet var labelNormalFareValue: UILabel!
    @IBOutlet var labelBookingFeeValue: UILabel!
    @IBOutlet var labelServiceChargeValue: UILabel!
    @IBOutlet var labelSubTotalValue: UILabel!
    @IBOutlet var lblFinalAmount: UILabel!
    @IBOutlet weak var buttonFinish: UIButton!
    @IBOutlet weak var stackTip: UIStackView!
    @IBOutlet weak var lblSurCharge: UILabel!
    @IBOutlet weak var lblCheckListCharge: UILabel!
    
    
    //MARK:- Properties
    //MARK:-
    var viewSuper : UIView?
    var delegate : BookRequestDelegate?
    var isAdded : Bool = false
    var orderDone : OrderCab?
    var frameHeight : CGFloat = 342
    
    
    //MARK:- Actions
    //MARK:-
    @IBAction func actionBtnFinishOrder(_ sender: Any) {
        self.minimizeInvoiceView()
        self.delegate?.didSelectNext(type: .DoneInvoice)
    }
    
    @IBAction func showCheckListData(_ sender: Any) {
        self.delegate?.didShowCheckList(order: orderDone)
    }
    
    //MARK:- Functions
    //MARK:-
    
    func minimizeInvoiceView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeInvoiceView() {
        
        if orderDone?.payment?.paymentType == PaymentType.Card  || /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id == "stripe" || /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id == "epayco" {
            frameHeight = UIDevice.current.iPhoneX ? 416 + 34 : 416  //410
        } else {
            frameHeight = UIDevice.current.iPhoneX ? 348 + 34 : 348   //342
        }
       
        
        // 10 - to hide bottom corner radius
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    func setupUI() {
        
        
        print("======>>>>>>>> Payment Type", orderDone?.payment?.paymentType)
        
        
        if orderDone?.payment?.paymentType == PaymentType.Card  || /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id == "stripe" || /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id == "epayco"{
            stackTip.isHidden = false
        } else {
            stackTip.isHidden = true
        }
        
        buttonFinish.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func showInvoiceView(superView : UIView ,order : OrderCab ) {
        orderDone = order
        if !isAdded {
            //frameHeight =  superView.frame.size.width*76/100
            viewSuper = superView
            self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
        }
        
        assignPopUpData()
        maximizeInvoiceView()
    }
    
    
    func assignPopUpData() {
        
        guard let currentOrd = orderDone else{return}
        
        let brand = currentOrd.orderProductDetail
        let currency = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " "
        lblBrandName.text = brand?.productBrandName
        lblProductName.text = brand?.productName
        let payment = currentOrd.payment
        let previousCharges = Float(payment?.previous_charges ?? "") ?? 0
        if previousCharges == 0 {
            previousChargesStackView.isHidden = true
            lblPreviousCharges.text = ""
        }else{
            lblPreviousCharges.text = /payment?.previous_charges
            previousChargesStackView.isHidden = false
        }
        
        if currentOrd.booking_type == "Package" {
            
            let baseFareValue = Float(/currentOrd.payment?.productAplhaCharge)
            let timeValue = (Float(/currentOrd.payment?.extra_time)!) * (Float(/currentOrd.payment?.price_per_min)!)
            let distanceValue = (Float(/currentOrd.payment?.extra_distance)!) * (Float(/currentOrd.payment?.price_per_km)!)
            
            lblBaseFairValue.text = currency + "\(baseFareValue)".getTwoDecimalFloat()
            
            let time = "\(/currentOrd.payment?.extra_distance)".getTwoDecimalFloat()
            labelTime.text = "Extra Time(\(time) min)"
            labelTimeValue.text = currency + "\(timeValue)".getTwoDecimalFloat()
            
            let distance = "\(/currentOrd.payment?.extra_distance)".getTwoDecimalFloat()
            labelDistance.text = "Extra Distance(\(distance) km)"
            labelDistanceValue.text = currency + "\(distanceValue)".getTwoDecimalFloat()
            
            let bookingCharge: Float = 0.0
            let serviceCharges: Float = 0.0
            
            let normalValue = baseFareValue! + timeValue + distanceValue
            labelNormalFareValue.text = currency + "\(normalValue)".getTwoDecimalFloat()
            
            lblCheckListCharge.text = currency + "\(/currentOrd.check_list_total)"
            labelBookingFeeValue.text = currency + "\(bookingCharge)".getTwoDecimalFloat()
            labelServiceChargeValue.text = currency + "\(serviceCharges)".getTwoDecimalFloat()
            let subtotal = normalValue + bookingCharge + serviceCharges
            labelSubTotalValue.text = currency + "\(subtotal)".getTwoDecimalFloat()
            lblFinalAmount.text =  currency + (/currentOrd.payment?.finalCharge).getTwoDecimalFloat()
            
        }else{
            
            
            let baseFareValue = Float(/currentOrd.payment?.productAplhaCharge)
            let timeValue = (Float(/currentOrd.payment?.waiting_time)!) * (Float(/currentOrd.payment?.product_per_hr_charge!)!)
            let distanceValue = (Float(/currentOrd.payment?.orderDistance)!) * (Float(/currentOrd.payment?.product_per_distance_charge)!)
            
            lblBaseFairValue.text = currency + "\(baseFareValue)".getTwoDecimalFloat()
            
            let time = "\(/currentOrd.payment?.waiting_time)".getTwoDecimalFloat()
            labelTime.text = "Waiting Time(\(time) min)"
            labelTimeValue.text = currency + "\(timeValue)".getTwoDecimalFloat()
            
            let distance = "\(/currentOrd.payment?.orderDistance)".getTwoDecimalFloat()
            labelDistance.text = "Distance(\(distance) km)"
            labelDistanceValue.text = currency + "\(distanceValue)".getTwoDecimalFloat()
            
            let normalValue = baseFareValue! + timeValue + distanceValue
            labelNormalFareValue.text = currency + "\(normalValue)".getTwoDecimalFloat()
            
            var bookingCharge: Float
            var serviceCharges: Float
            
            let actualValue = /brand?.productActualPrice
            let totalPercentage = ((/currentOrd.payment?.buraqPercentage)/100)
            if normalValue > actualValue {
                let exactValue = normalValue + previousCharges
                bookingCharge = exactValue * totalPercentage
                serviceCharges = 0.0
            }else {
                let exactValue = actualValue + previousCharges
                bookingCharge = actualValue * totalPercentage
                if exactValue > actualValue {
                    serviceCharges = exactValue - actualValue
                }else{
                    serviceCharges = actualValue - exactValue
                }
            }
            
             lblCheckListCharge.text = currency + "\(/currentOrd.check_list_total)"
            labelBookingFeeValue.text = currency + "\(bookingCharge)".getTwoDecimalFloat()
            labelServiceChargeValue.text = currency + "\(serviceCharges)".getTwoDecimalFloat()
            let subtotal = normalValue + bookingCharge + serviceCharges
            lblSurCharge.text = currency + "\(/currentOrd.payment?.sur_charge)".getTwoDecimalFloat()
            labelSubTotalValue.text = currency + "\(subtotal)".getTwoDecimalFloat()
            lblFinalAmount.text =  currency + (/currentOrd.payment?.finalCharge).getTwoDecimalFloat()
        }
        // lblWaitingCharges.text = currency + (currentOrd.payment?.waiting_charges ?? "")
        
        
        
        /*  guard let service = UDSingleton.shared.getService(categoryId: currentOrd.serviceId) else {return}
         guard let payment = currentOrd.payment else{return}
         
         
         if /service.serviceCategoryId == 2 || /service.serviceCategoryId == 4 {
         lblBrandName.text = /currentOrd.orderProductDetail?.productBrandName
         }else{
         lblBrandName.text = /service.serviceName
         }
         
         
         let productName  = /service.serviceCategoryId > 3 ? (/currentOrd.orderProductDetail?.productName)   : (/currentOrd.orderProductDetail?.productName + " × " +  String(/payment.productQuantity)) */
        
        
        
        
        
        
        //        lblBaseFairValue.text =  (/payment.initalCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        //        lblTaxValue.text = (/payment.adminCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        //        lblFinalAmount.text =  (/payment.finalCharge).getTwoDecimalFloat() + " " + "currency".localizedString
        
        /* var total : Double = 0.0
         
         if let initalCharge = Double(/payment.initalCharge) {
         total =  initalCharge
         }
         
         if let adminCharge = Double(/payment.adminCharge) {
         total =  total + adminCharge
         } */
        
        
        
    }
}


extension InvoiceView {
    
    @IBAction func showTip(_ sender : UIButton) {
        delegate?.didSelectAddTip(order : self.orderDone!)
    }
    
}
