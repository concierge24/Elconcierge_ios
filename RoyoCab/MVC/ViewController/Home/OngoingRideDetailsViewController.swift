//
//  OngoingRideDetailsViewController.swift
//  Trava
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import HCSStarRatingView

class OngoingRideDetailsViewController: UIViewController {

    //MARK:- Outlet

    @IBOutlet var imgViewDriver: UIImageView!
    
    @IBOutlet var lblDriverRatingTotalCount: UILabel!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblDriverStatus: UILabel!
    @IBOutlet var lblTimeEstimation: UILabel!
    
    @IBOutlet weak var viewStarRating: HCSStarRatingView!
    @IBOutlet weak var imageViewDriverCar: UIImageView!
    
    @IBOutlet var lblVehicleType: UILabel!
    @IBOutlet var lblVehicleNumber: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblBookingId: UILabel!
    @IBOutlet var lblBookingStatus: UILabel!
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblPickUpAddress: UILabel!
    @IBOutlet var lblDropOffAddress: UILabel!
    
    @IBOutlet weak var labelStop1: UILabel!
    @IBOutlet weak var labelStop2: UILabel!
    @IBOutlet weak var labelStop3: UILabel!
    @IBOutlet weak var labelStop4: UILabel!
    
    
    @IBOutlet weak var ViewStop1: UIView!
    @IBOutlet weak var ViewStop2: UIView!
    @IBOutlet weak var ViewStop3: UIView!
    @IBOutlet weak var ViewStop4: UIView!
    
    @IBOutlet weak var buttonPanic: UIButton!
    @IBOutlet weak var ConstraintHeightViewShareRide: NSLayoutConstraint!
    @IBOutlet weak var viewRideShare: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackViewBreakDown: UIStackView!
    @IBOutlet weak var stackViewHalfWayStop: UIStackView!
    @IBOutlet weak var stackViewRideShare: UIStackView!
    @IBOutlet weak var stackViewCancel: UIStackView!
    
    @IBOutlet weak var labelBreakDown: UILabel!
    @IBOutlet weak var labelHalfWayStop: UILabel!
    @IBOutlet weak var labelRideShare: UILabel!
    @IBOutlet weak var labelCancel: UILabel!
    
    @IBOutlet weak var labelEnjoyYourRide: UILabel!
    @IBOutlet weak var buttonCall: UIButton!
    @IBOutlet weak var buttonCancelSharing: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    
    
    //MARK:- Properties
    var delegate : BookRequestDelegate?
    var currentOrder: OrderCab?
    var trackingModal : TrackingModel?
    var rideStatus: String?
    var estimatedTime: String?
    var tableDataSource : TableViewDataSourceCab?
    var arrayShareWithContacts = [ContactNumberModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
}

extension OngoingRideDetailsViewController {
    
    func initialSetup() {
        
        configureTableView()
        setupUI()
        setupData()
        showStopsIfAny()
    }
    
    func setupUI() {
        
        view.layoutIfNeeded()
        buttonPanic.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        showHideRideShareView()
        
        stackViewBreakDown.isHidden = (/UDSingleton.shared.appTerminology?.key_value?.breakdown_stop) == "0"
        stackViewHalfWayStop.isHidden = (/UDSingleton.shared.appTerminology?.key_value?.halfway_ride_stop) == "0"
        buttonPanic.isHidden = (/UDSingleton.shared.appTerminology?.key_value?.panic_button) == "0"
        
        lblDriverStatus.setTextColorTheme()
        lblTimeEstimation.setTextColorTheme()
        lblBookingStatus.setTextColorTheme()
        
        buttonCall.setButtonWithTintColorSecondary()
        buttonCancelSharing.setButtonWithTitleColorTheme()
        buttonEdit.setButtonWithTitleColorTheme()
    }
    
    func setupData() {
            
        guard let order = currentOrder else {return}
        guard let driverDetail = order.driverAssigned else{return}
        lblDriverName.text = /driverDetail.driverName
        lblDriverStatus.text = rideStatus
        lblTimeEstimation.text = estimatedTime
            
        viewStarRating.value = CGFloat(/driverDetail.driverRatingAverage?.toFloat())
        lblDriverRatingTotalCount.text = "\(/driverDetail.driverRatingCount)"
            
        lblVehicleType.text =  driverDetail.vehicle_name
        lblVehicleNumber.text =  driverDetail.vehicle_number
            
        lblBookingId.text = "Id: " + /order.orderToken
        
        lblDropOffAddress?.text = /order.dropOffAddress
        lblPickUpAddress.text = /order.pickUpAddress
        
        lblAmount.text =  (/UDSingleton.shared.appSettings?.appSettings?.currency) + " - " + (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + (/order.payment?.finalCharge).getTwoDecimalFloat()
        
        if let orderDate = order.orderLocalDate {
            lblDate.text = orderDate.getBookingDateStr()
        }
        
        if let  driverimage = driverDetail.driverProfilePic {
            
            if let url = URL(string: driverimage) {
                imgViewDriver.sd_setImage(with: url , completed: nil)
            }else{
                imgViewDriver.image = #imageLiteral(resourceName: "ic_user")
            }
        }
            
      /*  if order.serviceId == 7 {  //Cab
            lblDriverStatus.text = order.myTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
        } else {
            lblDriverStatus.text = order.myTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
        }

        if order.orderStatus == .reached {
            lblDriverStatus.text = "driver_is_reached".localizedString
        } */
    
        
        labelCancel.text = "Cancel".localizedString + " " + /UDSingleton.shared.appTerminology?.categoryData?.text
        
        switch order.serviceId {
            
        case 4: // Pickup delivery - 4 , cab - 7, ambulance - 10
            labelRideShare.text = "Share_Parcel_Location".localizedString
            labelEnjoyYourRide.text = "Delivery_In_Progress".localizedString
            
        default:
            labelRideShare.text = "Ride_Share".localizedString
            labelEnjoyYourRide.text = "Enjoy_Your_Ride".localizedString
        }
        
    }
    
    func showStopsIfAny() {
        
        currentOrder?.ride_stops?.forEachEnumerated({[weak self] (index, stop) in
            
            switch /stop.priority {
                
            case 1:
                self?.setupUIAndData(label: self?.labelStop1, view: self?.ViewStop1, index: index)
                
            case 2:
                self?.setupUIAndData(label: self?.labelStop2, view: self?.ViewStop2, index: index)
                
            case 3:
                self?.setupUIAndData(label: self?.labelStop3, view: self?.ViewStop3, index: index)
                    
            case 4:
                self?.setupUIAndData(label: self?.labelStop4, view: self?.ViewStop4, index: index)
                
            default:
                break
            }
        })
        
    }
    
    func setupUIAndData(label: UILabel?, view: UIView?, index: Int) {
        
        view?.isHidden = false
        label?.text = currentOrder?.ride_stops?[index].address
        
        view?.isUserInteractionEnabled = false
    }
    
    func showHideRideShareView() {
        
        viewRideShare.isHidden = /currentOrder?.shareWith?.count == 0
        ConstraintHeightViewShareRide.constant = CGFloat((/currentOrder?.shareWith?.count) > 0 ? (/currentOrder?.shareWith?.count * 50) + 50 : 0) // 50 - other views
        
        arrayShareWithContacts = currentOrder?.shareWith ?? []
        tableDataSource?.items = arrayShareWithContacts
        tableView.reloadData()
        
    }
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? PhoneNumberTableViewCell {
                cell.assignData(item: item as? ContactNumberModal, indexPath: indexpath)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if let cell = cell as? PhoneNumberTableViewCell {
               // self?.didSelectRowPressed(index: indexPath.row)
                cell.setSelected(true, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayShareWithContacts, tableView: tableView, cellIdentifier: R.reuseIdentifier.phoneNumberTableViewCell.identifier, cellHeight: 50)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
    
    func showCancellationFormVC(reasonType: ReasonType?, order: OrderCab? = nil, modalTracking: TrackingModel? = nil , delegateVC: UIViewController? = nil) {
        
        guard let vc = R.storyboard.bookService.cancellationVC() else { return }
        
       // vc.view.backgroundColor = UIColor.colorDarkGrayPopUp
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.currentOrder = order
        vc.trackingModal = modalTracking
        vc.isFromOngoingDetail = true
        vc.reasonType = reasonType
        vc.delegateCancellation = delegateVC as? RequestCancelDelegate
        
        addAsChildViewController(vc, toView: view)
    }
    
    func showShareRideVC() {
        
        guard let vc = R.storyboard.bookService.shareRideViewController() else { return }
        
        vc.currentOrder = currentOrder
        vc.view.backgroundColor = UIColor.colorDarkGrayPopUp
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        addAsChildViewController(vc, toView: view)
    }
    
    func showEditLocationVC() {
        
        guard let vc = R.storyboard.bookService.editLocationViewController() else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.currentOrder = currentOrder
        vc.delegate = (presentingViewController as? UINavigationController)?.topViewController as? HomeVC
        addAsChildViewController(vc, toView: view)
    }
    
    func setOrderStatus(tracking : TrackingModel) {
    //        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way".localizedString : "driver_completing_nearby_order".localizedString
    //        lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_completing_nearby_order".localizedString
        
        
        self.trackingModal = tracking
        
            if currentOrder?.serviceId == 7 || currentOrder?.serviceId == 4 || currentOrder?.serviceId == 10 {  //Cab
                lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
            } else {
                lblDriverStatus.text = tracking.orderTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
            }
            if tracking.orderStatus == .reached {
                lblDriverStatus.text = "driver_is_reached".localizedString
            }
    }
    
    func setOrderStatus(modal : OrderCab) {
        
        currentOrder = modal
        
        if currentOrder?.serviceId == 7 || currentOrder?.serviceId == 4 || currentOrder?.serviceId == 10 {  //Cab
            lblDriverStatus.text = modal.orderTurn == .MyTurn ? "driver_is_on_the_way_DriveStarted".localizedString : "driver_accepted_request".localizedString
        } else {
            lblDriverStatus.text = modal.orderTurn == .MyTurn ? "truck_driver_is_on_the_way".localizedString : "driver_accepted_request".localizedString
        }
        if modal.orderStatus == .reached {
            lblDriverStatus.text = "driver_is_reached".localizedString
        }
    }
    
}

//MARK:- Button Selectors
extension OngoingRideDetailsViewController {
    
    @IBAction func buttonClicked(_ sender: UIButton) {
       
     // 1- DownArrow, 2- Panic, 3- Chat, 4-Call, 5-Breakdown, 6- HalfWayStop, 7- RideShare, 8-CancelRide, 9- EditLocation , 10- RideShare
        
        switch sender.tag {
            case 1:
            debugPrint("DownArrow")
            dismissVC(completion: nil)
            
            case 2:
            debugPrint("Panic")
            
            guard let vc = R.storyboard.bookService.panicModelViewController() else { return }
            addAsChildViewController(vc, toView: view)
            
            case 3:
            debugPrint("Chat")
            
            case 4:
            debugPrint("Call")
            
            case 5:
            debugPrint("Breakdown")
            
            guard let status = currentOrder?.orderStatus, status == OrderStatus.Ongoing else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "NoOngoigRide".localizedString , type: .error )
                return
            }
            showCancellationFormVC(reasonType: .breakdown, order: currentOrder, modalTracking: trackingModal, delegateVC: (presentingViewController as? UINavigationController)?.topViewController as? HomeVC)
            
            case 6:
            debugPrint("HalfWayStop")
            guard let status = currentOrder?.orderStatus, status == OrderStatus.Ongoing else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "NoOngoigRide".localizedString , type: .error )
                return
            }
            showCancellationFormVC(reasonType: .halfWayStop, order: currentOrder, modalTracking: trackingModal, delegateVC: (presentingViewController as? UINavigationController)?.topViewController as? HomeVC)
            
            case 7:
            debugPrint("RideShare")
            guard let status = currentOrder?.orderStatus, status == OrderStatus.Ongoing else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "NoOngoigRide".localizedString , type: .error )
                return
            }
            showShareRideVC()
            
            case 8:
            debugPrint("CancelRide")
            
            guard let acceptedDate = currentOrder?.accepted_at?.getLocalDate() else {return}
                 
            let secondsDifference = acceptedDate.secondsInBetweenDate(Date())
            debugPrint("Seconds ========= \(secondsDifference)")
            
            if secondsDifference > 20 {
                
                alertBoxOption(message: "cancel_ride_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
                    
                    self?.showCancellationFormVC(reasonType: .cancel, order: self?.currentOrder, delegateVC: (self?.presentingViewController as? UINavigationController)?.topViewController as? HomeVC)
                    }, cancel: {})
                
            } else {
                 showCancellationFormVC(reasonType: .cancel, order: currentOrder, delegateVC: (presentingViewController as? UINavigationController)?.topViewController as? HomeVC)
            }
            
            case 9:
            debugPrint("EditLocation")
            showEditLocationVC()
            
            case 10:
            debugPrint("Cancel Sharing")
            cancelRideShare()
            
        default:
            break
        }
        
        
    }
    
}

//MARK:- API
extension OngoingRideDetailsViewController {
    
    func cancelRideShare() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.cancelShareRide(orderId: currentOrder?.orderId)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(_):
                debugPrint("Successs")
                
                DispatchQueue.main.async {[weak self] in
                    self?.arrayShareWithContacts.removeAll()
                    self?.currentOrder?.shareWith = self?.arrayShareWithContacts
                    self?.showHideRideShareView()
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}


//MARK: ShareRideViewControllerDelegate
extension OngoingRideDetailsViewController: ShareRideViewControllerDelegate {
    
    func rideShared(order: OrderCab?) {
        
        arrayShareWithContacts.append(contentsOf: order?.shareWith ?? [])
        currentOrder?.shareWith = arrayShareWithContacts
        showHideRideShareView()
    }
    
}
