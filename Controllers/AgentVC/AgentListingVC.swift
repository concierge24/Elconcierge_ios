//
//  AgentListingVC.swift
//  Sneni
//
//  Created by Mac_Mini17 on 10/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
typealias SelectedAgentBlock = (CblUser, Date) -> ()

class AgentListingVC: BaseViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var viewNoData: UIView!
    @IBOutlet var tfSearch: ThemeTextField!
    
    var arrayServiceId = [Int]()
    var arrayCart:[Cart]?
    
//    var orderSummary : OrderSummary?
    var selectedDate : Date?
    var timeInterVal : Double = 0
    
    var remarks : String?
    var completion: SelectedAgentBlock?
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    var tableDataSource : TableViewDataSource?{
        didSet{
            tableView.reloadData()
        }
    }
    
    var agentListing:AgentListing?{
        didSet {
            arrData = agentListing?.agentListingData ?? []
            self.configureTableView()
        }
    }
    var arrData : [AgentListingData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text =   "\(L11n.select.string) \(TerminologyKeys.agent.localizedValue() as? String ?? "")"
        
        for cart in arrayCart ?? []{
            
            arrayServiceId.append(cart.id?.toInt() ?? 0)
        }
        
        tfSearch.delegate = self
        self.webServiceGetAgentDBKeys()
        
        
    }
    
    @IBAction func searchTextChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        if text.isEmpty {
            arrData = agentListing?.agentListingData ?? []
            reloadData()
            return
        }
       arrData = agentListing?.agentListingData?.filter({ (agent) -> Bool in
            return (agent.cblUser?.name?.contains(text, compareOption: .caseInsensitive) ?? false)
        }) ?? []
        reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextChanged(textField)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func showTimeSlots(_ sender: Any) {
        let vcPickUp = PickupDetailsController.getVC(.laundry)
        self.presentVC(vcPickUp)
        
        vcPickUp.blockSelectOnlyDateAndTime = {
            [weak self] date in
            guard let self = self else { return }
            self.selectedDate = date
            self.webServiceGetAgentDBKeys()
        }
    }
    
}

extension AgentListingVC {
    
    func webServiceGetAgentDBKeys() {
        let objR = API.GetAgentDBKeys
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let _):
                self.webServiceAgentListing()
                
            default:
                break
            }
            
            print(response)
        }
    }
    
    
    func webServiceAgentListing()  {
        
        let objR = API.ServiceAgentlist(FormatAPIParameters.ServiceAgentlist(serviceIds: arrayServiceId, date: selectedDate, interval: Int(timeInterVal)).formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                self.agentListing = object as? AgentListing
//                print(self.agentListing?.agentListingData)
                
            default:
                break
            }
            
            print(response)
        }
        
    }
    
}


extension AgentListingVC{
    
    // MARK: - configureTableView
    func pushToDlivery(agent: CblUser?) {
//        self.orderSummary?.agentId = agentId///agentListingData?.cblUser?.id
        guard let date = selectedDate else {
            SKToast.makeToast("Please select date time".localized())
            return
        }
        if let agent = agent {
            verifySlots(agent: agent, date: date, duration: Int(timeInterVal)) { [weak self] in
                self?.popVC()
                self?.completion?(agent, date)
            }
        }

//        
//        let branchId = orderSummary?.items?.first?.supplierBranchId
//        DeliveryViewController.getUserAdresses(isAgent: (/self.orderSummary?.isAgent), branchId: branchId) {
//            [weak self] (delivery) in
////            let deliveryAddress = GDataSingleton.sharedInstance.pickupAddress
//
//            guard let self = self,
//                let deliveryAddressId = GDataSingleton.sharedInstance.pickupAddressId,//deliveryAddress?.id,
//                let pickUp = GDataSingleton.sharedInstance.pickupDate
//                else { return }
//            
//            delivery.initalizeDelivery(cart: self.orderSummary?.items)
//            delivery.handlingAdmin = self.orderSummary?.handlingCharges
//            delivery.handlingSupplier = self.orderSummary?.handlingSupplier
//
//            let deliveryDate = pickUp//.add(seconds: Int(60.0*self.timeInterVal))
//            
//            DeliveryViewController.updateCart(
//                delivery: delivery,
//                order: self.orderSummary,
//                deliverySpeed: DeliverySpeedType.Standard,
//                addressId: deliveryAddressId,
//                deliveryDate: deliveryDate,
//                remarks: self.remarks) {
//                    [weak self] in
//                    guard let self = self else { return }
//                    APIManager.sharedInstance.hideLoader()
//                    let VC = StoryboardScene.Order.instantiateOrderSummaryController()
//                    VC.orderSummary = self.orderSummary
//                    VC.remarks = self.remarks
//                    self.pushVC(VC)
//            }
//            
//        }
    }
    
    func reloadData() {
        tableDataSource?.items = arrData
        tableView.reloadData()
        viewNoData.isHidden = !arrData.isEmpty

    }
    
    func configureTableView(){
        viewNoData.isHidden = !arrData.isEmpty
        tableDataSource = TableViewDataSource(items: arrData, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.AgentListingTblCell, configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            self.configureCell(cell: cell, item: item)
            }, aRowSelectedListener: {
                (indexPath) in
        })
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    func viewSlots(agentListingData: AgentListingData?) {
        
        AgentTimeSlotVC.getAvailabilty(id: /agentListingData?.cblUser?.id, block: {
            [weak self] (dates) in
            guard let self = self else { return }
            
            if dates.isEmpty {
                return
            }
            
            let vc = AgentTimeSlotVC.getVC(.order)
            vc.arrayDates = dates
            vc.seletedTime = self.selectedDate
            vc.timeInterVal = self.timeInterVal
            vc.objModel = agentListingData
            vc.selectedAgentId = /agentListingData?.cblUser?.id
            self.presentVC(vc)
            
            vc.blockDone = {
                [weak self] (dateSlot) in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    if let date = dateSlot {
                        self.selectedDate = date
                    }
                    self.pushToDlivery(agent: agentListingData?.cblUser)
                }

            }
        })
    }
    
    func configureCell(cell : Any?,item : Any?){
        if let cell = cell as? AgentListingTblCell {
            cell.agentListingData = item as? AgentListingData
            
            cell.blockBookSlots = {
                [weak self] agent in
                guard let self = self else { return }
                self.pushToDlivery(agent: agent?.cblUser)
            }
            
            cell.blockViewSlots = {
                [weak self] agent in
                guard let self = self else { return }
                self.viewSlots(agentListingData: agent)
            }
        }
    }
    
    func verifySlots(agent: CblUser, date: Date, duration: Int, completion: @escaping EmptyBlock) {
        let objR = API.verifySlot(agentId: /agent.id, duration: duration, datetime: date)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (response) in
            
            switch response {
            case .Success(let object):
                completion()
                
            default:
               break
            }
        }
    }
}


extension AgentListingVC{
    
    @IBAction func backBtnClick(sender:UIButton){
        self.popVC()
    }
    
}
