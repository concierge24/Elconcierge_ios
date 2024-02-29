//
//  RequestAcceptedView.swift
//  Buraq24
//
//  Created by MANINDER on 28/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import HCSStarRatingView
import ObjectMapper


class RequestAcceptedView: UIView {
   
    //MARK:- IBOutlets
    //MARK:-
    
    @IBOutlet var imgViewDriverRating: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet var imgViewDriver: UIImageView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var fullDetailStack: UIStackView!
    @IBOutlet weak var btnFullDetails: UIButton!
    
    @IBOutlet var lblDriverRatingTotalCount: UILabel!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblDriverStatus: UILabel!
    @IBOutlet var lblTimeEstimation: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblP: UILabel!
    @IBOutlet var lblPeople: UILabel!

    @IBOutlet weak var viewStarRating: HCSStarRatingView!
    @IBOutlet weak var imageViewDriverCar: UIImageView!
    
    @IBOutlet var lblVehicleType: UILabel!
    @IBOutlet var lblVehicleNumber: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var lblOtp: UILabel!
    
    //MARK:- Properties
    //MARK:-
    
    var viewSuper : UIView?
    var delegate : BookRequestDelegate?
    var isAdded : Bool = false
    var orderCurrent : OrderCab?
    var frameHeight : CGFloat = 255
    var trackingModal: TrackingModel?
    
    
    

    //MARK:- Actions
    @IBAction func actionBtnCancelTrackingOrder(_ sender: Any) {
        cancelOngoingOrder()
    }
    @IBAction func btnChatAction(_ sender: Any) {
        
        guard let vc = R.storyboard.mainCab.chatVC() else {return}
        
        vc.otherUserId =   "\(/orderCurrent?.driverAssigned?.driverUserId)"
        vc.otherUserDetailId = "\(/orderCurrent?.driverAssigned?.driverUserDetailId)"
        vc.name = "\(/orderCurrent?.driverAssigned?.driverName)"
        vc.profilePic = "\(/orderCurrent?.driverAssigned?.driverProfilePic)"
        
        (ez.topMostVC as? HomeVC)?.pushVC(vc)
         
    }
    
    @IBAction func buttonExpandViewClicked(_ sender: Any) {
        guard let vc = R.storyboard.bookService.ongoingRideDetailsViewController() else {return}
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = (ez.topMostVC as? HomeVC)
        vc.currentOrder = orderCurrent
        vc.rideStatus = lblDriverStatus.text
        vc.estimatedTime = lblTimeEstimation.text
        vc.trackingModal = trackingModal
        (ez.topMostVC as? HomeVC)?.presentVC(vc)
    }
    
    
    @IBAction func actionBtnCallDriverPressed(_ sender: UIButton) {
        guard let order = orderCurrent else {return}
        guard let driverDetail = order.driverAssigned else{return}
        guard let intNumber = driverDetail.driverPhoneNumber else {return}
        self.callToNumber(number: String(intNumber))
    }
    
    
    @IBAction func btnShowFullDetails(_ sender: UIButton) {
        guard let orderDetials = R.storyboard.bookService.fullOrderDetails() else { return }
        orderDetials.orderCheckList =  UDSingleton.shared.userData?.order?.first?.check_lists ?? []
        ez.topMostVC?.presentVC(orderDetials)
    }
    
    
    
    //MARK:- Functions
    //MARK:-

    
    func minimizeDriverView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func maximizeDriverView() {
        
        
        btnChat.isHidden =  !(/UDSingleton.shared.appSettings?.appSettings?.isChatEnable)
        
        
        if orderCurrent?.serviceId == 4 {
            if /UDSingleton.shared.appTerminology?.key_value?.check_list == "1" {
                fullDetailStack.isHidden = true
            } else {
                fullDetailStack.isHidden = false
            }
        } else {
              fullDetailStack.isHidden = true
        }
        
        if /UDSingleton.shared.appSettings?.appSettings?.user_otp_check == "true"{
            
            viewOtp.isHidden = false

        } else{
            
            viewOtp.isHidden = true
        }
       
        
        btnCall.setButtonWithTintColorSecondary()
        lblDriverStatus.setTextColorTheme()
        lblOtp.setTextColorTheme()
        lblTimeEstimation.setTextColorTheme()
        btnCancel.setButtonWithTitleColorTheme()
        btnFullDetails.setButtonBorderTitleAndTintColor()
        
        frameHeight = UIDevice.current.iPhoneX ? 255 + 34 : 255
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          // ANkush  self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.frameHeight , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            
            // 10 - for hide bottom corner radius
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.frameHeight + 10 , width: BookingPopUpFrames.WidthPopUp, height: /self?.frameHeight)
            }, completion: { (done) in
        })
    }
    
    func showDriverAcceptedView(superView: UIView, order: OrderCab) {
        orderCurrent = order
        if !isAdded {
           // Ankush frameHeight =  superView.frame.size.width*60/100
            viewSuper = superView
          // Ankush  self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)
            superView.addSubview(self)
            isAdded = true
            
            self.sizeToFit()
            self.layoutIfNeeded()
            frameHeight =  self.frame.height
          // Ankush  self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) , width: BookingPopUpFrames.WidthPopUp, height: frameHeight)

        }
        assignPopUpData()
        maximizeDriverView()
    }
    
    
    func assignPopUpData() {
        
        guard let order = orderCurrent else {return}
        guard let driverDetail = order.driverAssigned else{return}
        lblDriverName.text = /driverDetail.driverName
        lblDriverStatus.text = "driver_accepted_request".localizedString
        
        viewStarRating.value = CGFloat(/driverDetail.driverRatingAverage?.toFloat())
        lblDriverRatingTotalCount.text = "\(/driverDetail.driverRatingCount)"
        lblOtp.text = "OTP - \(/order.otp)"
        lblVehicleType.text = order.orderProductDetail?.productBrandName
        lblVehicleNumber.text = order.orderProductDetail?.productBrandName
        
        //lblVehicleType.text =  order.driverAssigned?.vehicle_name//driverDetail.vehicle_name
        //lblVehicleNumber.text = order.driverAssigned?.vehicle_number //driverDetail.vehicle_number
        
        imageViewDriverCar.sd_setImage(with: URL(string : order.driverAssigned?.icon_image_url ?? ""), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
        
        
        let valDouble = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + (/order.payment?.finalCharge).getTwoDecimalFloat()

        if (order.serviceId == 4 || order.serviceId == 7 || order.serviceId == 10) {
            lblAddress.text = order.orderProductDetail?.productBrandName
        }
        lblP.text = valDouble
        lblPeople.text = /order.orderProductDetail?.productName
//        lblPrice.text = valDouble
        
    //  lblDriverStatus.text = order.myTurn == .MyTurn ? "driver_is_on_the_way".localizedString : "driver_completing_nearby_order".localizedString
        
        if let  driverimage = driverDetail.driverProfilePic {
        
          if let url = URL(string: driverimage) {
            print("Driver Image Url", url)
               // imgViewDriver.sd_setImage(with: url , completed: nil)
            imgViewDriver.sd_setImage(with: url,
            placeholderImage: #imageLiteral(resourceName: "ic_user"),
                     options: [],
                   completed: nil)
            
          }else{
                imgViewDriver.image = #imageLiteral(resourceName: "ic_user")
            }
        }
        
     
//        guard let driverRating = driverDetail.driverRatingCount else { return }
//        guard let driverAverage = driverDetail.driverRatingAverage else { return }
        
//        if let intAverage = Int(driverAverage) {
        
//            imgViewDriverRating.isHidden =  driverRating == 0
//            lblDriverRatingTotalCount.isHidden =  driverRating == 0
//            lblDriverRatingTotalCount.text = "\(driverRating)"
//            imgViewDriverRating.setRatingSmall(rating: intAverage)
//        }
        
//        lblDriverStatus.text = order.myTurn == .MyTurn ? "driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
        if order.serviceId == 7 || order.serviceId == 4 || order.serviceId == 10{  //Cab
            lblDriverStatus.text = order.myTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
        } else {
            lblDriverStatus.text = order.myTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
        }

        if order.orderStatus == .reached {
            lblDriverStatus.text = "driver_is_reached".localizedString
        }
    }
    
    
    func setOrderStatus(tracking : TrackingModel) {
//        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way".localizedString : "driver_completing_nearby_order".localizedString
//        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_completing_nearby_order".localizedString
        
        self.trackingModal = tracking
        
        if orderCurrent?.serviceId == 7 || orderCurrent?.serviceId == 4 || orderCurrent?.serviceId == 10{  //Cab
            lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
        } else {
            lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
        }
        if tracking.orderStatus == .reached {
            lblDriverStatus.text = "driver_is_reached".localizedString
        }
    }
    
    
    func setOrderStatus(modal : OrderCab) {
    //        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way".localizedString : "driver_completing_nearby_order".localizedString
    //        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_completing_nearby_order".localizedString
            
           // self.trackingModal = tracking
        
            orderCurrent = modal
            
            if orderCurrent?.serviceId == 7 || orderCurrent?.serviceId == 4 || orderCurrent?.serviceId == 10 {  //Cab
                lblDriverStatus.text = modal.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
            } else {
                lblDriverStatus.text = modal.orderTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
            }
            if modal.orderStatus == .reached {
                lblDriverStatus.text = "driver_is_reached".localizedString
            }
        }
    
    func cancelOngoingOrder() {
        
        guard let acceptedDate = orderCurrent?.accepted_at?.getLocalDate() else {return}
             
        let secondsDifference = acceptedDate.secondsInBetweenDate(Date())
        debugPrint("Seconds ========= \(secondsDifference)")
        
        if secondsDifference > 20 {
            
            alertBoxOption(message: "cancel_ride_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
                
                self?.delegate?.didSelectNext(type: .CancelTrackingOrder)
                }, cancel: {})
            
        } else {
            self.delegate?.didSelectNext(type: .CancelTrackingOrder)
        }
    }
   
}
