//
//  LoyaltyPointsSummaryController.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class LoyaltyPointsSummaryController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnPlaceOrder: UIButton!
    @IBOutlet weak var deliveryDetailStackView: UIStackView!
    
    //MARK:- Variables
    var tableDataSource = OrderSummaryDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var remarks : String?
    var pickUpDate : Date?
    var pickupAddres : Address?
    var orderSummary : LoyaltyPointsSummary?
    var cartFlowType : CartFlowType = .Normal
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlaceOrder.kern(kerningValue: ButtonKernValue)
        ez.runThisAfterDelay(seconds: 0.1) {
            weak var weakSelf = self
            weakSelf?.configureTableView()
            weakSelf?.tableView.reloadTableViewData(inView: weakSelf?.view)
        }
        updateUI()
        //Nitin
        self.menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
      
    }
    
}

extension LoyaltyPointsSummaryController  {
    
    func configureTableView() {
        tableDataSource = OrderSummaryDataSource(items: orderSummary?.items, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: { (cell, item) in
            weak var weakSelf = self
            weakSelf?.configureTableViewCell(cell: cell, item: item)
            }, aRowSelectedListener: { (indexPath) in
                
        })
    }
    
    func configureTableViewCell(cell : Any?,item : Any?){
        
        (cell as? OrderSummaryCell)?.cart = item as? Cart
        (cell as? OrderSummaryCell)?.labelQuantity.text = "  "
        (cell as? OrderBillCell)?.orderSummary = orderSummary
        (cell as? OrderBillCell)?.tvRemarks.delegate = self
    }
}

//MARK: - Update UI
extension LoyaltyPointsSummaryController {
    func updateUI(){
        
        if let pickAddress = pickupAddres {
            let pickupDetailView = OrderDeliveryDetailView(frame: CGRect(x:0,y:0,w:50,h:50), type: .Pickup, address: pickAddress,date: pickUpDate)
            deliveryDetailStackView.addArrangedSubview(pickupDetailView)
        }
        
        guard let delAddress = orderSummary?.deliveryAddress else { return }
        let deliveryDetailView = OrderDeliveryDetailView(frame: CGRect(x:0,y:0,w:50,h:50), type: .Delivery, address: delAddress, date: orderSummary?.deliveryDate)
        deliveryDetailStackView.addArrangedSubview(deliveryDetailView)
    }
}

//MARK: - Button Actions

extension LoyaltyPointsSummaryController {
    
    @IBAction func actionPlaceOrder(sender: AnyObject) {
        generateOrder()
    }
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}

//MARK: - GenerateOrder Web service

extension LoyaltyPointsSummaryController {
    
    func generateOrder(){
        var deliveryType = 0
        for (index,speed) in (orderSummary?.deliveryData?.deliverySpeeds ?? []).enumerated() {
            if speed.selected{
                deliveryType = index
            }
        }
        
        AdjustEvent.LoyaltyPointsOrder.sendEvent()
        let params = FormatAPIParameters.LoyaltyPointsOrder(supplierBranchId: orderSummary?.items?[0].supplierBranchId, deliveryAddressId: orderSummary?.deliveryAddress?.id, deliveryType: String(deliveryType), deliveryDate: orderSummary?.deliveryDate, totalPoints: orderSummary?.totalPoints, urgentPrice: orderSummary?.deliveryData?.urgentPrice, remarks: remarks, cart: orderSummary?.items ?? []).formatParameters()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LoyaltyPointsOrder(params)) {[weak self](response) in
            
            switch response {
            case .Success(let object):
                self?.handleGenerateOrder(orderId: object)
            case .Failure(_):
                break
            }
            
        }
    }
    
    func handleGenerateOrder(orderId : Any?){
        UtilityFunctions.showSweetAlert(title: L10n.OrderPlacedSuccessfully.string, message: L10n.YourOrderHaveBeenPlacedSuccessfully.string, style: .Success, success: { [weak self] in
            
            self?.sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiateLoyalityPointsViewController())
            self?.toggleSideMenuView()
        })
    }
}

//TextViewDelegate

extension LoyaltyPointsSummaryController : UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        self.remarks = textView.text
    }
}
