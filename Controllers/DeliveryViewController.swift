//
//  DeliveryViewController.swift
//  Clikat
//
//  Created by cblmacmini on 5/19/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class DeliveryViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var address_view: UIView! {
        didSet {
           // address_view.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnContinue : UIButton!{
        didSet {
            btnContinue.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnContinue.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    //MARK:- Variables
    var tableDataSource = DeliveryDataSource() {
        didSet {
            tableView.dataSource = tableDataSource
            tableView.delegate = tableDataSource
        }
    }
    //LoyaltyPoints
    var cartFlowType : CartFlowType = .Normal
    var loyaltyPointsSummary : LoyaltyPointsSummary?
    var deliveryData = Delivery() {
        didSet {

            deliveryData.initalizeDelivery(cart: orderSummary?.items)
            ez.runThisAfterDelay(seconds: 0.2) {
                [weak self] in
                
                self?.configureTableView()
                APIManager.sharedInstance.hideLoader()
                self?.tableView.reloadTableViewData(inView: self?.view)
            }
        }
    }
    
    var orderSummary : OrderSummary?
    var cartId : String?
    var selectedDate : Date?
    var remarks : String?
    var selectedAddress: Address?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllAdresses()
        AdjustEvent.Delivery.sendEvent()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func change_buttonAction(_ sender: Any) {
        //Nitin
        self.openAdressController()
    }
    
    func openAdressController() {
        
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.foodDeliverycompletionBlock = { [weak self] data in
            guard let strongSelf = self else { return }
            guard let adressData = data as? Dictionary<String,AnyObject> else {return}
            if let selectedAddress = adressData["selectedDict"] as? Address {
                let add = selectedAddress.address ?? ""
                let area = selectedAddress.area ?? ""
                strongSelf.address_label.text = add + "," + area
                strongSelf.selectedAddress = selectedAddress
            }
            if let wholeArray = adressData["arrayAddress"] as? [Address] {
                strongSelf.deliveryData.addresses = wholeArray
            }
        
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}

//MARK: - Webservice Get all Adresses
extension DeliveryViewController {
    
    func setAddressData() {
        
        if self.deliveryData.addresses?.count ?? 0 > 0 {
            self.selectedAddress = self.deliveryData.addresses?.first
            let add = self.deliveryData.addresses?.first?.address ?? ""
            let area = self.deliveryData.addresses?.first?.area ?? ""
            self.address_label.text = add + "," + area
        } else {
            self.showSelectedAddress()
        }
        
    }
    
    func showSelectedAddress() {
        
        if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                self.address_label.text = name + " " + locality
            }
        } else if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            self.address_label.text = address
        }
    }
    
    func getAllAdresses() {

        var branchId = orderSummary?.items?.first?.supplierBranchId
        if let _ = loyaltyPointsSummary {
            branchId = loyaltyPointsSummary?.items?.first?.supplierBranchId
        }
        
        DeliveryViewController.getUserAdresses(isAgent: (/self.orderSummary?.isAgent), branchId: branchId) {
            [weak self] (delivery) in
            guard let self = self else { return }
            
            self.deliveryData = delivery
            self.setAddressData()
        }
    }
    
    class func getUserAdresses(isAgent: Bool, branchId: String?, block: ((Delivery) -> ())?) {
        
        APIManager.sharedInstance.showLoader()
        let objR = API.Addresses(FormatAPIParameters.Addresses(supplierBranchId: branchId, areaId: LocationSingleton.sharedInstance.location?.areaEN?.id).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (result) in
            
            switch result {
            case .Success(let object):
                guard let delivery = object as? Delivery else { return }
                
                if !isAgent && /GDataSingleton.sharedInstance.appSettingsData?.isScheduled {
                    
                    let objD = DeliverySpeed(selected: false, name: L10n.SCHEDULED.string)
                    objD.type = .scheduled
                    delivery.deliverySpeeds?.append(objD)
                }
                block?(delivery)
            case .Failure(_):
                break
            }
        }
    }
}

extension DeliveryViewController {
    
    func configureTableView(){
        
        if let _ = loyaltyPointsSummary,
            let standardSpeed = deliveryData.deliverySpeeds?.first
        {
            deliveryData.deliverySpeeds = [standardSpeed]
        }
        tableDataSource = DeliveryDataSource(items: deliveryData, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: {
            [weak self] (cell, indexPath, selectedDeliverySpeed) in
            guard let self = self else { return }
            self.configureTableCell(cell: cell, indexpath: indexPath, selectedDeliveryType: selectedDeliverySpeed)
            
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            self.handleTableCellSelection(indexPath: indexPath)
        })
        tableDataSource.loyaltyPointsSummary = loyaltyPointsSummary
    }
    
}

extension DeliveryViewController {
    
    func configureTableCell(cell : Any?,indexpath : IndexPath?,selectedDeliveryType : DeliverySpeedType?)
    {
        guard let indexPath = indexpath else { return }
        
        if let tempCell = cell as? DeliveryAddressCell {
            tempCell.arrAddress = deliveryData.addresses
        }
        
        if indexPath.row < (deliveryData.deliverySpeeds?.count ?? 0) {
            
            guard let tempCell = cell as? DeliverySpeedCell, let deliverySpeed = deliveryData.deliverySpeeds?[indexPath.row] else { return }
            tempCell.deliveryData = deliveryData
            tempCell.deliverySpeed = deliverySpeed
        }else {
            
            guard let maxDays = Int(deliveryData.deliveryMaxTime ?? "0") else { return }
            let timeInterval = Double(60 * maxDays)
            
            (cell as? TimeAndDateCell)?.selectedDate = selectedDate ?? (deliveryData.pickupDate ?? Date()).addingTimeInterval(timeInterval)
        }
    }
}

extension DeliveryViewController {
    
    func handleTableCellSelection(indexPath : IndexPath?){
        
        guard let deliverySpeeds = deliveryData.deliverySpeeds,let indexpath = indexPath,let index = indexPath?.row, indexpath.section > 0 else { return }
        for speed in deliverySpeeds {
            speed.selected = false
        }
        if indexpath.row < deliverySpeeds.count {
            deliverySpeeds[index].selected = true
            tableDataSource.selectedDeliverySpeed = deliverySpeeds[index].type
            tableDataSource.items = deliverySpeeds
            selectedDate = nil
            deliveryData.addresses = (tableView.visibleCells.first as? DeliveryAddressCell)?.arrAddress
            tableView.reloadTableViewData(inView: view)
        }else{
            guard let timeCell = tableView.cellForRow(at: indexpath) as? TimeAndDateCell else { return }
            guard let maxDays = Int(deliveryData.deliveryMaxTime ?? "0"), var timeInterval = Double(deliveryData.urgentDeliveryTime ?? "0") else { return }
            timeInterval = Double(60*maxDays) 
            UtilityFunctions.showDatePicker(viewController: self ,datePickerMode: .dateAndTime, initialDate:  deliveryData.pickupDate ?? Date() ,minDate: (deliveryData.pickupDate ?? Date()).addingTimeInterval(timeInterval), title: L10n.SelectTimeAndDate.string , message: "", selectedDate: {
                [weak self] (date) in
                guard let self = self else { return }
                
                timeCell.selectedDate = date
                self.selectedDate = date
            }, cancel: {
                
            })
        }
        
    }
}


//MARK: - Button Actions
extension DeliveryViewController {
    
    @IBAction func actionContinue(sender: UIButton) {
        guard let _ = self.selectedAddress?.id else {
            SKToast.makeToast("Your address is not saved,please save this address and proceed further.")
            self.openAdressController()
            return
        }
        
        if cartFlowType == .LoyaltyPoints {
            pushLoyaltyPointsSummary()
        } else {
            webServiceForUpdateCartInfo()
        }
        
    }
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
}

//MARK: - webservice for Update Cart Info

extension DeliveryViewController {
    
    class func updateCart(delivery: Delivery, order: OrderSummary?, deliverySpeed : DeliverySpeedType, addressId: String?, deliveryDate: Date?, remarks: String?, addOn: Double?, newTotal: Double? = 0.0,block: (() -> ())?) {
        
        var netTotal = Double()

        if let tempTotal = newTotal {
            netTotal = tempTotal
        } else {
            netTotal = /order?.totalAmount
        }
        
        switch deliverySpeed {
        case .Urgent:
            netTotal = (netTotal - (delivery.deliveryCharges?.toDouble() ?? 0.0)) + ((delivery.urgentPrice?.toDouble()) ?? 0.0)
        default:
            break
        }
        
        let parameters = FormatAPIParameters.UpdateCartInfo(
            cartId: order?.cartId,
            deliveryAddressId: addressId,
            deliveryType: deliverySpeed.valueAPi,
            delivery: delivery,
            deliveryDate: deliveryDate,
            netAmount: netTotal.toString,
            remarks: remarks,
            addOn: addOn).formatParameters()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.UpdateCartInfo(parameters)) {
            (response) in
            switch response {
            case .Success(_):
                
                var deliveryAddress: Address?
                if !(delivery.addresses ?? []).isEmpty {
                    if let objAddress = delivery.addresses?.first(where: { $0.id == addressId })  {
                        deliveryAddress = objAddress
                    }
                }
                
                order?.dDeliveryCharges = delivery.deliveryCharges?.toDouble()
                
                if deliverySpeed == .Urgent {
                    order?.deliveryAdditionalCharges = delivery.urgentPrice?.toDouble()
                }
                
                order?.initalizeOrderSummary(cart: order?.items)
                order?.deliveryAddress = deliveryAddress
                order?.deliveryDate = deliveryDate
                order?.currentDate = Date()
                order?.pickupAddress = delivery.pickupAddress
                order?.pickupDate = delivery.pickupDate
                order?.selectedDeliverySpeed = deliverySpeed
                
                if order?.items?.first?.category == Category.Laundry.rawValue || order?.items?.first?.category == Category.BeautySalon.rawValue {
                    order?.pickupBuffer = delivery.deliveryMaxTime
                }
                //order?.paymentMethod = delivery.paymentMethod

                block?()
//                weakSelf?.handleUpdateCartInfo()
            case .Failure(_):
                APIManager.sharedInstance.hideLoader()

            }
        }
    }
    
    func webServiceForUpdateCartInfo(){
        
        //Nitin
//        guard let visibleCell = tableView.visibleCells.first as? DeliveryAddressCell,
//            let selectedIndexPath = visibleCell.selectedIndexPath,
//            (visibleCell.arrAddress?.count ?? 0) > 0  else
//        {
//            SKToast.makeToast(L10n.PleaseSelectAnAddress.string)
//            return
//        }
//        let deliveryAddressId = visibleCell.arrAddress?[selectedIndexPath.row].id
        //Nitin
        let deliveryAddressId = self.selectedAddress?.id

        let deliveryDate = selectedDate ?? Delivery.getDeliveryDate(delivery: deliveryData, selectedType: tableDataSource.selectedDeliverySpeed)
        //Nitin
       // deliveryData.addresses = visibleCell.arrAddress

        DeliveryViewController.updateCart(
            delivery: deliveryData,
            order: orderSummary,
            deliverySpeed: tableDataSource.selectedDeliverySpeed,
            addressId: deliveryAddressId,
            deliveryDate: deliveryDate,
            remarks: remarks, addOn: orderSummary?.addOnCharge) {
                [weak self] in
                guard let self = self else { return }
                print("dfsfd4")
                self.handleUpdateCartInfo()
        }
    }
    
    func handleUpdateCartInfo(){
        print("dfsfd2")

//        guard let visibleCell = tableView.visibleCells.first as? DeliveryAddressCell,
//            (/visibleCell.arrAddress?.count) > 0
//            else { return }
//        print("dfsfd1")

        var deliveryAddress  : Address?
        
//        if let selectedIndexPath = visibleCell.selectedIndexPath {
//            deliveryAddress = visibleCell.arrAddress?[selectedIndexPath.row]
//        } else {
//            deliveryAddress = visibleCell.arrAddress?.first
//        }
        deliveryAddress = self.selectedAddress
        orderSummary?.dDeliveryCharges = deliveryData.deliveryCharges?.toDouble()
        
        if tableDataSource.selectedDeliverySpeed == .Urgent {
            orderSummary?.deliveryAdditionalCharges = deliveryData.urgentPrice?.toDouble()
        }
        
        orderSummary?.initalizeOrderSummary(cart:  orderSummary?.items, forRental: true, rentalTotal: orderSummary?.netPayableAmount)
        orderSummary?.deliveryAddress = deliveryAddress
        orderSummary?.deliveryDate = selectedDate ?? Delivery.getDeliveryDate(delivery: deliveryData, selectedType: tableDataSource.selectedDeliverySpeed)
        orderSummary?.pickupAddress = deliveryData.pickupAddress
        orderSummary?.pickupDate = deliveryData.pickupDate
        orderSummary?.selectedDeliverySpeed = tableDataSource.selectedDeliverySpeed
        
        if orderSummary?.items?.first?.category == Category.Laundry.rawValue || orderSummary?.items?.first?.category == Category.BeautySalon.rawValue {
            orderSummary?.pickupBuffer = deliveryData.deliveryMaxTime
        }
        //orderSummary?.paymentMethod = deliveryData.paymentMethod
        
        //Nitin
        let VC = StoryboardScene.Order.instantiatePaymentMethodController()
        VC.orderSummary = orderSummary
        pushVC(VC)
//        let VC = StoryboardScene.Order.instantiateOrderSummaryController()
//        VC.orderSummary = orderSummary
//        VC.remarks = remarks
//        pushVC(VC)
    }
}

//MARK: - Loyalty Points Summary
extension DeliveryViewController {
    
    func pushLoyaltyPointsSummary() {
        let VC = StoryboardScene.Order.instantiateLoyaltyPointsSummaryController()
        VC.cartFlowType = cartFlowType
        guard let visibleCell = tableView.visibleCells.first as? DeliveryAddressCell,let selectedIndexPath = visibleCell.selectedIndexPath, (visibleCell.arrAddress?.count ?? 0) > 0 else  {
            return
        }
        
        let deliveryAddress = visibleCell.arrAddress?[selectedIndexPath.row]
        loyaltyPointsSummary?.deliveryAddress = deliveryAddress
        loyaltyPointsSummary?.deliveryDate = selectedDate
        loyaltyPointsSummary?.deliveryData = deliveryData
        VC.orderSummary = loyaltyPointsSummary
        pushVC(VC)
    }
}


//MARK:- UIViewControllerTransitioningDelegate
extension DeliveryViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
