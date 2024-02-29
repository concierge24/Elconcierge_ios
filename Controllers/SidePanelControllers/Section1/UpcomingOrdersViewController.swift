//
//  UpcomingOrdersViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class UpcomingOrdersViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    
    //MARK:- Variable
    var dataSource : TableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
        }
    }
    var orderListing : OrderListing? {
        didSet{
            dataSource.items = orderListing?.orders
            tableView?.reloadTableViewData(inView: view)
            
            guard let orders = orderListing?.orders, orders.count > 0 else{
                viewPlaceholder?.isHidden = false
                return
            }
            viewPlaceholder?.isHidden = true

        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AdjustEvent.PendingOrders.sendEvent()
        tableView.register(UINib(nibName: CellIdentifiers.OrderParentCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.OrderParentCell)
        configureTableViewInitialization()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webService()

    }
}


//MARK: - Webservice Methods
extension UpcomingOrdersViewController {
    
    
    func webService (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderUpcoming(FormatAPIParameters.RateOrderListing.formatParameters())) { (response) in
            
            weak var weak : UpcomingOrdersViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.orderListing = listing as? OrderListing
                
                break
            default :
                break
            }
        }
        
    }
    
}


//MARK: - TableView Configuration

extension UpcomingOrdersViewController{
    
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orderListing?.orders , height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: { (cell, item) in
            
            weak var weakSelf : UpcomingOrdersViewController? = self
            weakSelf?.configureCell(withCell : cell , item : item)
            
            }, aRowSelectedListener: { (indexPath) in
                weak var weak : UpcomingOrdersViewController? = self
                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
                orderDetailVc.orderDetails = weak?.orderListing?.orders?[indexPath.row]
                orderDetailVc.type = .OrderUpcoming
                weak?.pushVC(orderDetailVc)
        })
        tableView.reloadData()
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
        
        (cell as? OrderParentCell)?.cellType = .OrderUpcoming
        (cell as? OrderParentCell)?.order = item as? OrderDetails
        (cell as? OrderParentCell)?.orderDelegate = self
        (cell as? OrderParentCell)?.btnOrderType.isHidden = ((item as? OrderDetails)?.status != .Pending) ? true : false
        
    }
    
}


//MARK: - Button Actions

extension UpcomingOrdersViewController{
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}

//MARK: - Order Parent Cell Delegate {

extension UpcomingOrdersViewController : OrderParentCellDelegate {
    
    func actionOrderTypeButton(cell: OrderParentCell, orderId: String?) {
        if cell.btnOrderType.titleLabel?.text == L10n.CONFIRMORDER.string {
            let VC = StoryboardScene.Order.instantiatePaymentMethodController()
            VC.orderId = orderId
            pushVC(VC)
            return
        }
        UtilityFunctions.showSweetAlert(title: L10n.CancelOrder.stringFor(appType: cell.order?.appType), message: L10n.DoYouReallyWantToCancelThisOrder.stringFor(appType: cell.order?.appType), success: { [weak self] in
            UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.YouHaveCancelledYourOrderSuccessfully.string, style: .Success)
            self?.cancelOrderWebservice(cell: cell, orderId: orderId)
            }) {
        }
    }
    
    func actionOrderTypeButton(cell: OrderParentCell, order: OrderDetails?) {
        
    }
    
    
    func cancelOrderWebservice(cell : OrderParentCell, orderId :String?){
        guard let indexpath = tableView.indexPath(for: cell) else { return }
        tableView.beginUpdates()
        dataSource.items?.remove(at: indexpath.row)
        orderListing?.orders?.remove(at: indexpath.row)
        tableView.deleteRows(at: [indexpath], with: .top)
        tableView.endUpdates()
        viewPlaceholder?.isHidden = (dataSource.items?.count ?? 0) > 0 ? true : false
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CancelOrder(FormatAPIParameters.CancelOrder(orderId: orderId,isScheduled: "0").formatParameters())) { (response) in
            switch response {
            case .Success(_):
                break
            case .Failure(_):
                break
            }
        }
    }
    func handleCancelOrder(cell : OrderParentCell?){
        
    }
}
