//
//  OrderSummaryController.swift
//  Clikat
//
//  Created by cblmacmini on 5/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class OrderSummaryController: BaseViewController {
    
    //MARK:- Variables
    @IBOutlet weak var title_label: ThemeLabel!
    @IBOutlet weak var navigation_view: ThemeView!
    var tableDataSource = OrderSummaryDataSource() {
        didSet {
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var remarks : String?
    var orderSummary : OrderSummary?
    var selectedPaymentMehod : PaymentMethod?
    var cartFlowType : CartFlowType = .Normal
    var parameters = Dictionary<String,Any>()

    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var btnPlaceOrder: UIButton! {
        didSet {
            btnPlaceOrder.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var deliveryDetailStackView: UIStackView!

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnPlaceOrder.kern(kerningValue: ButtonKernValue)
//        ez.runThisAfterDelay(seconds: 0.1) {
//            weak var weakSelf = self
//            weakSelf?.configureTableView()
//            weakSelf?.tableView.reloadTableViewData(inView: weakSelf?.view)
//        }
//        updateUI()
//
//        if DeliveryType.shared == .pickup {
//            tableView.tableHeaderView = nil
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Nitin
        if hideBackButton ?? false {
            btnBack?.isHidden = true
            self.title_label.textColor = .white
        }

        btnPlaceOrder.kern(kerningValue: ButtonKernValue)
        ez.runThisAfterDelay(seconds: 0.1) {
            weak var weakSelf = self
            weakSelf?.configureTableView()
            weakSelf?.tableView.reloadTableViewData(inView: weakSelf?.view)
        }
        updateUI()
        
        if DeliveryType.shared == .pickup {
            tableView.tableHeaderView = nil
        }
        
    }

}

extension OrderSummaryController  {
    
    func configureTableView() {
        tableDataSource = OrderSummaryDataSource(
            items: orderSummary?.items,
            height: UITableView.automaticDimension,
            tableView: tableView,
            cellIdentifier: nil,
            configureCellBlock: {
                [weak self] (cell, item) in
                
                guard let self = self else { return }
                self.configureTableViewCell(cell: cell, item: item)
                
        }, aRowSelectedListener: {
            (indexPath) in
            
        })
    }
    
    func configureTableViewCell(cell : Any?,item : Any?){
        
        (cell as? OrderSummaryCell)?.cart = item as? Cart
        (cell as? OrderBillCell)?.orderSummary = orderSummary
        (cell as? OrderBillCell)?.tvRemarks.text = remarks ?? L10n.NoRemarks.string
    }
}

//MARK: - Update UI
extension OrderSummaryController {
    func updateUI(){
//        let lbl = UILabel(frame: CGRect(x:0,y:0,w:50,h:50))
//        lbl.text = "Items"
//        lbl.sizeToFit()
//        deliveryDetailStackView.addArrangedSubview(lbl)
        
        if let pickAddress = orderSummary?.pickupAddress {
            let pickupDetailView = OrderDeliveryDetailView(frame: CGRect(x:0,y:0,w:50,h:50), type: .Pickup, address: pickAddress,date: orderSummary?.pickupDate)
            deliveryDetailStackView.addArrangedSubview(pickupDetailView)
        }
        
        guard let delAddress = orderSummary?.deliveryAddress else { return }
        let deliveryDetailView = OrderDeliveryDetailView(frame: CGRect(x:0,y:0,w:50,h:50), type: .Delivery, address: delAddress, date: orderSummary?.deliveryDate)
        deliveryDetailStackView.addArrangedSubview(deliveryDetailView)
    }
}

//MARK: - Button Actions
extension OrderSummaryController {
    
    @IBAction func actionPlaceOrder(sender: AnyObject) {
        
        if !GDataSingleton.sharedInstance.isLoggedIn {
            presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        
        if orderSummary?.items?.first?.category != "Promotion" && (orderSummary?.dTotalPrice ?? 0) < (orderSummary?.minOrderAmount?.toDouble() ?? 0.0) {
            
            SKToast.makeToast(UtilityFunctions.appendOptionalStrings(withArray: [L10n.SorryYourOrderIsBelowMinimumOrderPrice.string,orderSummary?.minOrderAmount]))
        }else {
            handleGenerateOrder()
        }
        
    }
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}

//MARK: - GenerateOrder Web service
extension OrderSummaryController {
    
    func generateOrder(){
        //        APIManager.sharedInstance.opertationWithRequest(withApi: API.GenerateOrder(FormatAPIParameters.GenerateOrder(cartId: orderSummary?.cartId).formatParameters())) { [weak self] (response) in
        //
        //            switch response {
        //            case .Success(let object):
        //                self?.handleGenerateOrder()
        //            case .Failure(_):
        //                break
        //            }
        //        }
    }
    
    func handleGenerateOrder(){
        let VC = StoryboardScene.Order.instantiatePaymentMethodController()
        VC.orderSummary = orderSummary
        VC.parameters = self.parameters
        pushVC(VC)
    }
}
