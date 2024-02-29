//
//  DrinkingWaterETokenDeliver.swift
//  Buraq24
//
//  Created by Apple on 03/01/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import IBAnimatable
import CoreLocation

class DrinkingWaterETokenDeliver: UIViewController, RequestCancelDelegate , EtokenRatingDelegate{
   
    
    //MARK:-Outlets
    
    @IBOutlet weak var imgViewMap: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDropOffTitle: UILabel!
    @IBOutlet weak var lblDropOffAddress: UILabel!
    
    @IBOutlet weak var lblDriverNam: UILabel!
    @IBOutlet weak var imgCustomer: AnimatableImageView!
    
    @IBOutlet var acceptRejectpopup: AnimatableView!
    @IBOutlet var ratingView: DriverRatingView!
    
    @IBOutlet weak var lblPopUpServiceName: UILabel!
    @IBOutlet weak var lblProductDetailPopup: UILabel!
    
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblBrandQuantity: UILabel!
    
    //MARK:-PROPERTIES
    
    var order : OrderCab?
    var type : TabType = .Past
    
    
    //MARK:- View Controller Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ratingView.delegateEtoken = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.getOrderDetails()
    }
    
    //MARK:- Custom Methods
    
    func setupController(){
        
          NotificationCenter.default.addObserver(self, selector: #selector(getOrderDetails), name: NSNotification.Name(rawValue: "\(LocalNotifications.ETokenRefresh.rawValue)\(/order?.orderId)"), object: nil)
       
        
        self.lblDriverNam.text = /self.order?.driverAssigned?.driverName
        self.lblDropOffAddress.text = /self.order?.dropOffAddress
        
        print( /order?.orderToken)
        
        self.lblId.text = "Id: " + /order?.orderToken
        
        guard let orderDate = order?.orderLocalDate else {return}
        lblDate.text = orderDate.getBookingDateStr()
        
        lblService.text = "E-Tokens · \(/self.order?.payment?.productQuantity)"
        
        guard let driverimage = self.order?.driverAssigned?.driverProfilePic else{return}
        if let url = URL(string: driverimage) {
            imgCustomer.sd_setImage(with: url , completed: nil)
        }
        
        
        let strURL = Utility.shared.setStaticPolyLineOnMap(pickUpLat: /order?.pickUpLatitude, pickUpLng: /order?.pickUpLongitude, dropLat: /order?.dropOffLatitude, dropLng: /order?.dropOffLongitude)
        
        if let url = NSURL(string: strURL) {
            imgViewMap.sd_setImage(with: url as URL , completed: nil)
        }
        
        self.lblBrandName.text = self.order?.orderProductDetail?.productBrandName
        self.lblBrandQuantity.text  =  "\(/self.order?.orderProductDetail?.productName) x \(/self.order?.payment?.productQuantity)"
        
        if  order?.orderStatus == .CustomerCancel || order?.orderStatus == .DriverCancel {
            
            lblStatus.text = "cancelled".localizedString
        }else if order?.orderStatus == .ServiceComplete {
            
            lblStatus.text = "completed".localizedString
        }
            
        else if order?.orderStatus == .etokenCustomerConfirm{
            lblStatus.text = "OrderStatus.Confirmed".localizedString
        }
        else if order?.orderStatus == .Confirmed {
            
            lblStatus.text = "OrderStatus.Confirmed".localizedString
        }
         else if order?.orderStatus == .reached {
            
            lblStatus.text = "OrderStatus.Reached".localizedString
         }
        else if order?.orderStatus == .ServiceTimeout || order?.orderStatus == .etokenTimeOut{
            lblStatus.text = R.string.localizable.eTokenTimeOut()
        }
            
        else if order?.orderStatus == .etokenCustomerPending{
            lblStatus.text = R.string.localizable.eTokenApprovalPending()
        }
            
        else if order?.orderStatus == .etokenSerCustCancel{
            lblStatus.text = R.string.localizable.eTokenRejected()
        }
        else{
            lblStatus.text  = order?.orderStatus.rawValue
        }
        
        
    }
    
    //MARK:- Button Action Methods
    
    @IBAction func actionAcceptDelivery(_ sender: Any) {
        
        guard let orderId = order?.orderId else{return}

        let req = BookServiceEndPoint.EtokenOrderAcceptReject(order_id: "\(orderId)", status: "1")
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        req.request(header: ["access_token" :  token, "secretdbkey": APIBasePath.secretDBKey, "language_id" : LanguageFile.shared.getLanguage()]) { [weak self] (response) in
            switch response {
            case .success(let _):
                
                self?.ratingView.frame = CGRect.init(x: 18.0 , y: ( /self?.view.frame.height - 10) - CGFloat(400.0), width: /self?.view.frame.width - 36.0, height: CGFloat(400.0))
                self?.ratingView.fromEtoken = true
                
                guard let driverimage = self?.order?.driverAssigned?.driverProfilePic else{return}
                if let url = URL(string: driverimage) {
                    self?.ratingView.imgViewDriver.sd_setImage(with: url , completed: nil)
                }
                self?.ratingView.lblDriverName.text = self?.order?.driverAssigned?.driverName
                self?.view.addSubview(/(self?.ratingView))
             
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    @IBAction func actionRejectDelivery(_ sender: Any) {
        
        guard let orderId = order?.orderId else{return}
        
        let req = BookServiceEndPoint.EtokenOrderAcceptReject(order_id: "\(orderId)", status: "0")
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        
        req.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                self?.navigationController?.popViewController(animated: true)
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func didRatingSubmit(ratingValue: Int, comment: String) {
     
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let rating = BookServiceEndPoint.rateDriver(orderId: order?.orderId, rating: ratingValue, comment: comment)
        
        rating.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {[weak self] (response) in
            switch response {
                
            case .success(_):
                self?.navigationController?.popToRootViewController(animated: true)
                self?.ratingView.removeFromSuperview()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    @IBAction func actionCancelOrder(_ sender: Any) {
        
        guard let orderId = order?.orderId else{return}
        guard let formCancelation = R.storyboard.bookService.cancellationVC() else { return }
        
        formCancelation.view.backgroundColor = UIColor.colorDarkGrayPopUp
        formCancelation.modalPresentationStyle = .overCurrentContext
        formCancelation.modalTransitionStyle = .crossDissolve
        formCancelation.orderId = orderId
        formCancelation.delegateCancellation = self
        presentVC(formCancelation, true)
        
    }
    
    func didSuccessOnCancelRequest() {
        self.popVC()
    }
    
    @IBAction func actionCallDriver(_ sender: Any) {
        
        let number = "\(/order?.driverAssigned?.driverCountryCode)\(/order?.driverAssigned?.driverPhoneNumber)"
        self.callToNumber(number: number)
    }
    
    @IBAction func actionTrackOrder(_ sender: Any) {
        
        guard let trackVC = R.storyboard.drinkingWater.trackEtokenViewController() else{return}
        
        trackVC.model = AllOrdersOngoing.ordersOngoing["\(/order?.orderId)"]
        
        if AllOrdersOngoing.ordersOngoing["\(/order?.orderId)"]?.driverLatitude == nil{
            Alerts.shared.show(alert: "AppName".localizedString, message: R.string.localizable.eTokenTrackingNotAvailable(), type: .info)
            return
        }
        
        trackVC.OrderDestination = CLLocationCoordinate2D.init(latitude: /order?.dropOffLatitude, longitude: /order?.dropOffLongitude)
        pushVC(trackVC)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Network Request
    
    @objc func getOrderDetails() {
        
        guard let orderID = order?.orderId else {  return }
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let objDetail = BookServiceEndPoint.orderDetails(orderID: orderID)
        
        objDetail.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                
                if let order = data as? OrderCab {
                    self?.order = order
                    
                    if /self?.order?.orderStatus.rawValue == OrderStatus.etokenCustomerPending.rawValue{
                        self?.acceptRejectpopup.frame = CGRect.init(x: 18.0 , y: ( /self?.view.frame.height - 10) - CGFloat(154.0), width: /self?.view.frame.width - 36.0, height: CGFloat(154.0))
                                                
                      self?.lblPopUpServiceName.text = self?.order?.orderProductDetail?.productBrandName
                        self?.lblProductDetailPopup.text  =  "\(/self?.order?.orderProductDetail?.productName) x \(/self?.order?.payment?.productQuantity)"
                    
                        self?.view.addSubview(/(self?.acceptRejectpopup))
                    }
                    else{
                        self?.acceptRejectpopup.removeFromSuperview()
                    }
                    
                    self?.setupController()
                    
                }
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}
