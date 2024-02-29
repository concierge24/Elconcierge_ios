//
//  BookingDetailVC.swift
//  Buraq24
//
//  Created by MANINDER on 10/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import HCSStarRatingView

enum TabType : String  {
    case Past = "Past"
    case Upcoming = "Upcoming"
}

class BookingDetailVC: BaseVCCab {
    
    //MARK:- Outlets
    @IBOutlet weak var previousChargesLabel: UILabel!
    @IBOutlet weak var previousChargesView: UIStackView!
    @IBOutlet var lblDropOffText: UILabel?
    @IBOutlet weak var imgDropOff: UIImageView!
    @IBOutlet weak var lblSurCharge: UILabel!
    
    @IBOutlet var imgViewMap: UIImageView!
    @IBOutlet var lblOrderToken: UILabel!
    @IBOutlet var lblOrderStatus: UILabel!
    
    @IBOutlet var lblOrderPrice: UILabel!
    @IBOutlet var lblOrderDate: UILabel!
    @IBOutlet var lblDropLocationAddress: UILabel?
    @IBOutlet weak var labelPickupAddress: UILabel!
    
    @IBOutlet var lblComment: UILabel!
    
    @IBOutlet var viewDriver: UIView!
    @IBOutlet var constraintDriverHeight: NSLayoutConstraint?
    
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var imgViewRating: UIImageView?
    @IBOutlet var imgViewDriver: UIImageView!
    @IBOutlet weak var viewStarRating: HCSStarRatingView!
    
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var constraintTopPricingView: NSLayoutConstraint?
    @IBOutlet var constraintDateViewHeight: NSLayoutConstraint?
    
    @IBOutlet var lblStartDate: UILabel?
    @IBOutlet var lblEndDate: UILabel?
    @IBOutlet var viewTime: UIView?
    @IBOutlet weak var btnCall: UIButton?
    
    @IBOutlet weak var constraintHeightViewDriver: NSLayoutConstraint!
    
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
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var orderDetailStack: UIStackView!
    @IBOutlet weak var checkLIstStack: UIStackView!
    @IBOutlet weak var checklistTableView: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    
    
    
    
    //MARK:- Properties
    
    var order : OrderCab?
    var type : TabType = .Past
    var delegateCancellation: RequestCancelDelegate?
    var checkListArray = [CheckLists]()
    var amount = 0
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderDetails()
        // Do any additional setup after loading the view.
        checklistTableView.delegate = self
        checklistTableView.dataSource = self
        
        
        if order?.serviceId == 4 {
            lblDropOffText?.text = R.string.localizable.delivery_location()
        }
        
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            imgDropOff.image = #imageLiteral(resourceName: "ic_nav")
            break
            
        default:
            imgDropOff.image = #imageLiteral(resourceName: "ic_drop_location")
        }
        
        
        if /UDSingleton.shared.appTerminology?.key_value?.check_list == "1" {
            segmentController.isHidden = true
        } else {
            segmentController.isHidden = false
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lblOrderStatus.setTextColorTheme()
    }
    
    /*  override var preferredStatusBarStyle: UIStatusBarStyle {
     return .lightContent
     } */
    
    //MARK:- Action
    
    @IBAction func callDriver(_ sender: Any) {
        
        let val = "\(/self.order?.driverAssigned?.driverCountryCode)\(/self.order?.driverAssigned?.driverPhoneNumber)"
        self.callToNumber(number: val)
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
           {
           case 0:
            orderDetailStack.isHidden = false
            checkLIstStack.isHidden = true
           case 1:
            orderDetailStack.isHidden = true
            checkLIstStack.isHidden = false
           default:
               break
           }
    }
    
    @IBAction func actionBtnCancelPressed(_ sender: UIButton) {
        
        
        if order?.orderStatus.rawValue == "Pending" {
            showCancellationFormVC()
        } else {
            guard let acceptedDate = order?.accepted_at?.getLocalDate() else {return}
                   
                   let secondsDifference = acceptedDate.secondsInBetweenDate(Date())
                   debugPrint("Seconds ========= \(secondsDifference)")
                   
                   if secondsDifference > 18000 { // 5 hours
                       
                       alertBoxOption(message: "cancel_ride_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
                           
                           self?.showCancellationFormVC()
                           }, cancel: {})
                       
                   } else {
                       showCancellationFormVC()
                   }
        }
       
    }
    
    //MARK:- Functions
    
    func setupUI() {
        
        btnCancel.isHidden = type == .Past
        btnCancel.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
    }
    
    func assignBookingData() {
        
        guard let orderDetail = order  else {return}
        
        if let orderToken = orderDetail.orderToken {
            
            lblOrderToken.text = "Id: " + orderToken
            
            guard let lati = orderDetail.dropOffLatitude else{return}
            guard let long = orderDetail.dropOffLongitude else{return}
            
            /* let strURL = Utility.shared.getGoogleMapImageURL(long:  String(long), lati: String(lati), width: Int(imgViewMap.size.width), height: Int(imgViewMap.size.height))
             
             if let url = NSURL(string: strURL) {
             imgViewMap.sd_setImage(with: url as URL , completed: nil)
             } */
            
            let strURL = Utility.shared.setStaticPolyLineOnMap(pickUpLat: /orderDetail.pickUpLatitude, pickUpLng: /orderDetail.pickUpLongitude, dropLat: /orderDetail.dropOffLatitude, dropLng: /orderDetail.dropOffLongitude)
            
            
            //orderDetail.dropOffLatitude
            
            //orderDetail.dropOffLongitude
            let nsString  = NSString.init(string: strURL).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!
            
            if let url = NSURL(string: nsString) {
                imgViewMap.sd_setImage(with:url as URL, placeholderImage: nil, options: .refreshCached, progress: nil, completed: nil)
            }
            
            lblDropLocationAddress?.text = /orderDetail.dropOffAddress
            labelPickupAddress.text = /orderDetail.pickUpAddress
            
            if let orderDate = orderDetail.orderLocalDate{
            lblOrderDate.text = orderDate.getBookingDateStr()
            }
            
            guard let service = UDSingleton.shared.getService(categoryId: orderDetail.serviceId) else {return}
            guard let payment = orderDetail.payment else{return}
            
            lblOrderPrice.text = "\(/orderDetail.paymentType.rawValue) - \((/UDSingleton.shared.appSettings?.appSettings?.currency)) \((/payment.finalCharge).getTwoDecimalFloat())"
            
            /*  if /service.serviceCategoryId == 2 || /service.serviceCategoryId == 4 {
             lblServiceName.text = /orderDetail.orderProductDetail?.productBrandName
             }else{
             lblServiceName.text = /service.serviceName
             }
             
             let orderDet  = /service.serviceCategoryId > 3 ? (/orderDetail.orderProductDetail?.productName)   : (/orderDetail.orderProductDetail?.productName + " × " +  String(/payment.productQuantity))
             
             lblOrderDetails.text = orderDet
             
             if orderDetail.organisationCouponUserId != 0 {
             lblOrderPrice.text =  "E-Tokens - " + "\(/orderDetail.payment?.productQuantity)"
             }
             else{
             
             lblOrderPrice.text =  "cash".localizedString + " - " + "currency".localizedString + " " + (/payment.finalCharge).getTwoDecimalFloat()
             }
             
             lblTotalprice.text = "currency".localizedString + " " +  (/payment.finalCharge).getTwoDecimalFloat()
             
             var total : Double = 0.0
             
             if let initalCharge = Double(/payment.initalCharge) {
             total =  initalCharge
             }
             
             if let adminCharge = Double(/payment.adminCharge) {
             total =  total + adminCharge
             }
             
             lblBaseFair.text =  "currency".localizedString + " " + "\(total)".getTwoDecimalFloat()
             lblTax.text = "currency".localizedString + " " + "0.0".getTwoDecimalFloat()
             lblOtherPrice.text = "currency".localizedString + " " + "0.0".getTwoDecimalFloat() */
            
            let brand = orderDetail.orderProductDetail
            
            lblBrandName.text = brand?.productBrandName
            lblProductName.text = brand?.productName
            
            let currency = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " "
            
            let baseFareValue = /brand?.productAlphaPrice
            let timeValue = (/Float((orderDetail.payment?.order_time)!) * /brand?.price_per_hr)
            let distanceValue = (/Float((orderDetail.payment?.orderDistance)!) * /brand?.pricePerDistance)
            
            lblBaseFairValue.text = currency + "\(baseFareValue)".getTwoDecimalFloat()
            
            let time = "\(/orderDetail.payment?.order_time)".getTwoDecimalFloat()
            labelTime.text = "Time(\(time) min)"
            labelTimeValue.text = currency + "\(timeValue)".getTwoDecimalFloat()
            
            let distance = "\(/orderDetail.payment?.orderDistance)".getTwoDecimalFloat()
            labelDistance.text = "Distance(\(distance) km)"
            labelDistanceValue.text = currency + "\(distanceValue)".getTwoDecimalFloat()
            
            let normalValue = baseFareValue + timeValue + distanceValue
            labelNormalFareValue.text = currency + "\(normalValue)".getTwoDecimalFloat()
            
            var bookingCharge: Float
            if normalValue > /brand?.productActualPrice {
                bookingCharge = (normalValue * (/orderDetail.payment?.buraqPercentage)/100)
            } else {
                bookingCharge = ((brand?.productActualPrice)! * (/orderDetail.payment?.buraqPercentage)/100)
            }
            
            labelBookingFeeValue.text = currency + "\(bookingCharge)".getTwoDecimalFloat()
            
            let serviceCharge = (normalValue < /brand?.productActualPrice) ? (/brand?.productActualPrice - normalValue) : 0.00
            labelServiceChargeValue.text = currency + "\(serviceCharge)".getTwoDecimalFloat()
            
            
            let subtotal = normalValue + bookingCharge + serviceCharge
            labelSubTotalValue.text = currency + "\(subtotal)".getTwoDecimalFloat()
            lblFinalAmount.text =  currency + (/orderDetail.payment?.finalCharge).getTwoDecimalFloat()
            
            if let rating = orderDetail.rating?.ratingGiven {
                
                viewDriver.isHidden = false
                
                constraintDriverHeight?.constant = 32
                guard let driver = orderDetail.driverAssigned else{return}
                
                lblComment.text = orderDetail.rating?.comment
                lblDriverName.text = /driver.driverName
                guard let driverimage = driver.driverProfilePic else{return}
                if let url = URL(string: driverimage) {
                    imgViewDriver.sd_setImage(with: url , completed: nil)
                }
                // imgViewRating.setRating(rating: rating)
                viewStarRating.value = CGFloat(rating)
                
            }else {
                viewDriver.isHidden = true
                constraintDriverHeight?.constant = 0
                // constraintTopPricingView?.constant = -60
            }
            
            if orderDetail.orderStatus == .Scheduled || orderDetail.orderStatus == .DriverApprovalPending || orderDetail.orderStatus == .DriverApproval || orderDetail.orderStatus == .DriverSchCancelled || orderDetail.orderStatus == .DriverSchTimeOut  || orderDetail.orderStatus == .SystyemSchCancelled {
                
                lblOrderStatus.text = "Scheduled".localizedString
                
                //  constraintTopPricingView?.constant = 60
                
                lblDriverName.text = /orderDetail.driverAssigned?.driverName
                guard let driverimage = orderDetail.driverAssigned?.driverProfilePic else{return}
                if let url = URL(string: driverimage) {
                    imgViewDriver.sd_setImage(with: url , completed: nil)
                }
                // imgViewRating.isHidden = true
                
                viewStarRating.isHidden = true
                viewDriver.isHidden = false
                constraintDriverHeight?.constant = 32
                
            } else if  orderDetail.orderStatus == .CustomerCancel || orderDetail.orderStatus == .DriverCancel {
                lblOrderStatus.text = "cancelled".localizedString
                
            } else if orderDetail.orderStatus == .ServiceComplete {
                
                lblOrderStatus.text = "completed".localizedString
            }  else if orderDetail.orderStatus == .ServiceBreakdown {
                
                lblOrderStatus.text = "breakdown".localizedString
            } else if orderDetail.orderStatus == .etokenCustomerConfirm{
                lblOrderStatus.text = "OrderStatus.Confirmed".localizedString
            }
            else if orderDetail.orderStatus == .Confirmed {
                
                lblOrderStatus.text = "OrderStatus.Confirmed".localizedString
            }
            else if orderDetail.orderStatus == .SerHalfWayStop {
                    
                    lblOrderStatus.text = "HalfWayStop".localizedString
            }
            else if order?.orderStatus == .reached {
                
                lblOrderStatus.text = "OrderStatus.Reached".localizedString
            }
            else if orderDetail.orderStatus == .ServiceTimeout || orderDetail.orderStatus == .etokenTimeOut{
                
                lblOrderStatus.text = "etoken.Timeout".localizedString
            }
                
            else if orderDetail.orderStatus == .etokenCustomerPending{
                lblOrderStatus.text = "etoken.ApprovalPending".localizedString
            }
                
            else if orderDetail.orderStatus == .etokenSerCustCancel{
                lblOrderStatus.text = "etoken.Rejected".localizedString
            }
                
            else if orderDetail.orderStatus == .Ongoing {
                
                lblOrderStatus.text  = orderDetail.orderStatus.rawValue
                
                constraintTopPricingView?.constant = 60
                
                lblDriverName.text = /orderDetail.driverAssigned?.driverName
                guard let driverimage = orderDetail.driverAssigned?.driverProfilePic else{return}
                if let url = URL(string: driverimage) {
                    imgViewDriver.sd_setImage(with: url , completed: nil)
                }
                // imgViewRating.isHidden = true
                
                viewStarRating.isHidden = true
                viewDriver.isHidden = false
                constraintDriverHeight?.constant = 32
            }
            else{
                lblOrderStatus.text  = orderDetail.orderStatus.rawValue
            }
            
        }
        updateSemantic()
        
        if let orderDates = orderDetail.orderDates , let orderStartDate =  orderDates.startedDate  {
            
            viewTime?.isHidden = false
            constraintDateViewHeight?.constant = 60
            
            guard let orderCompleteDate = orderDates.completedDate else {return}
            
            lblStartDate?.text = orderStartDate.getBookingDateStr()
            lblEndDate?.text = orderCompleteDate.getBookingDateStr()
            
            self.lblEndDate?.isHidden =  false
            
            if   orderDetail.orderStatus.rawValue == "Ongoing".localizedString || orderDetail.orderStatus.rawValue == "DPending" || orderDetail.orderStatus.rawValue == "Scheduled".localizedString  {
                self.lblEndDate?.isHidden = true
            }
            
        }else{
            constraintDateViewHeight?.constant = 0
            viewTime?.isHidden = true
        }
        
        if  orderDetail.orderStatus == .Confirmed || orderDetail.orderStatus == .reached || orderDetail.orderStatus == .CustomerCancel || orderDetail.orderStatus == .DriverCancel {
            viewTime?.isHidden = true
            constraintDateViewHeight?.constant = 0
        }
        
        self.setPayment()
    }
    
    
    func setPayment() {
        guard let currentOrd = order  else {return}
        let payment = currentOrd.payment
        let previousCharges = Float(payment?.previous_charges ?? "") ?? 0
        let brand = currentOrd.orderProductDetail
        let currency = (/UDSingleton.shared.appSettings?.appSettings?.currency) + " "
        if previousCharges == 0 {
            previousChargesView.isHidden = true
            previousChargesLabel.text = ""
        }else{
            previousChargesLabel.text = /payment?.previous_charges
            previousChargesView.isHidden = false
        }
        
        if currentOrd.booking_type == "Package" {
            
            
            lblBrandName.text = brand?.productBrandName
            lblProductName.text = brand?.productName
            
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
            
            labelBookingFeeValue.text = currency + "\(bookingCharge)".getTwoDecimalFloat()
            labelServiceChargeValue.text = currency + "\(serviceCharges)".getTwoDecimalFloat()
            let subtotal = normalValue + bookingCharge + serviceCharges
            labelSubTotalValue.text = currency + "\(subtotal)".getTwoDecimalFloat()
            lblFinalAmount.text =  currency + (/currentOrd.payment?.finalCharge).getTwoDecimalFloat()
            
        }else{
            
           
            let baseFareValue = Float(/currentOrd.payment?.productAplhaCharge)
            let timeValue = (Float(/currentOrd.payment?.waiting_time)!) * (Float(/currentOrd.payment?.product_per_hr_charge)!)
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
            
            labelBookingFeeValue.text = currency + "\(bookingCharge)".getTwoDecimalFloat()
            labelServiceChargeValue.text = currency + "\(serviceCharges)".getTwoDecimalFloat()
            let subtotal = normalValue + bookingCharge + serviceCharges
            labelSubTotalValue.text = currency + "\(subtotal)".getTwoDecimalFloat()
            lblSurCharge.text = currency + "\(/currentOrd.payment?.sur_charge)".getTwoDecimalFloat()
            lblFinalAmount.text =  currency + (/currentOrd.payment?.finalCharge).getTwoDecimalFloat()
        }
    }
    private  func updateSemantic() {
        
        if  LanguageFile.shared.isLanguageRightSemantic() {
            lblOrderPrice.textAlignment = .left
            lblOrderStatus.textAlignment = .left
            lblOrderToken.textAlignment  = .right
            lblOrderDate.textAlignment = .right
        }
    }
}

extension BookingDetailVC : RequestCancelDelegate {
    
    func showCancellationFormVC() {
        
        guard let orderId = order?.orderId , let formCancelation = R.storyboard.bookService.cancellationVC() else { return }
        // formCancelation.view.backgroundColor = UIColor.colorDarkGrayPopUp
        formCancelation.modalPresentationStyle = .overCurrentContext
        formCancelation.modalTransitionStyle = .crossDissolve
        formCancelation.orderId = orderId
        formCancelation.delegateCancellation = self
        presentVC(formCancelation, true)
        
        
    }
    
    func didSuccessOnCancelRequest() {
        if let orderId = order?.orderId {
            let nc = NotificationCenter.default
            nc.post(name: Notification.Name(rawValue: LocalNotifications.nCancelFromBookinScreen.rawValue), object: "\(orderId)")
        }
        
        
        self.delegateCancellation?.didSuccessOnCancelRequest()
        self.popVC()
    }
}

//MARK:- API

extension BookingDetailVC {
    
    func getOrderDetails() {
        
        guard let orderID = order?.orderId else {  return }
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let objDetail = BookServiceEndPoint.orderDetails(orderID: orderID)
        
        if #available(iOS 16.0, *) {
            objDetail.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
                switch response {
                    
                case .success(let data):
                    
                    if let order = data as? OrderCab {
                        self?.order = order
                        self?.setupUI()
                        self?.checkListArray = self?.order?.check_lists ?? []
                        self?.checklistTableView.reloadData()
                        self?.assignBookingData()
                        
                        if self?.checkListArray.count == 0{
                            self?.segmentController.isHidden = true
                        } else {
                            self?.segmentController.isHidden = true
                        }
                        
                        for element in  self?.checkListArray ?? [] {
                            self?.amount = self!.amount + (Int(/element.after_item_price) ?? 0)
                        }
                        
                        
                        self?.lblTotal.text = "\(self?.amount) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
                        
                        
                    }
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                    
                    //Toast.show(text: strError, type: .error)
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}


extension BookingDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return checkListArray.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath) as! CheckListCell
           cell.lblItem.text = checkListArray[indexPath.row].item_name
           cell.lblCurrency.text = /UDSingleton.shared.appSettings?.appSettings?.currency
           cell.txfPrice.text = "\(/checkListArray[indexPath.row].after_item_price)"
        cell.txfPrice.isUserInteractionEnabled = false
           cell.lblTaxPrice.text = "*Tax price \(/checkListArray[indexPath.row].tax) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
           return cell
       }
    
}

