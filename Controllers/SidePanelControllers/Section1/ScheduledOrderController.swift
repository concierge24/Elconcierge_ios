//
//  ScheduledOrderController.swift
//  Clikat
//
//  Created by cblmacmini on 8/16/16.
//  Copyright © 2016 Rajat. All rights reserved.
//

import UIKit

class ScheduledOrderController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    
    //MARK:- Variables
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
        
        AdjustEvent.ScheduledOrders.sendEvent()
        tableView.register(UINib(nibName: CellIdentifiers.OrderParentCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.OrderParentCell)
        configureTableViewInitialization()
        webService()
        
    }
}

//MARK: - Webservice Methods
extension ScheduledOrderController {
    
    
    func webService (){
        
        let api = API.ScheduledOrders(FormatAPIParameters.RateOrderListing.formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: api) {[weak self] (response) in
            
            switch response{

            case .Success(let listing):
                self?.orderListing = listing as? OrderListing
            default :
                break
            }
        }
        
    }
    
}


//MARK: - TableView Configuration

extension ScheduledOrderController{
    
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orderListing?.orders , height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: { [weak self] (cell, item) in
            
            
            self?.configureCell(withCell : cell , item : item)
            
            }, aRowSelectedListener: { [weak self] (indexPath) in
                self?.configureCellSelection(indexPath: indexPath)
        })
        tableView.reloadData()
    }
    
    
    func configureCell(withCell cell : Any, item : Any? ){
        
        (cell as? OrderParentCell)?.cellType = .OrderScheduled
        (cell as? OrderParentCell)?.order = item as? OrderDetails
        (cell as? OrderParentCell)?.orderDelegate = self
        (cell as? OrderParentCell)?.btnOrderType.isHidden = (item as? OrderDetails)?.status == .Confirmed ? true : false
    }
    
    func configureCellSelection(indexPath : IndexPath){
        let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
        orderDetailVc.orderDetails = self.orderListing?.orders?[indexPath.row]
        orderDetailVc.type = .OrderScheduled
        orderDetailVc.cancelOrder = { [unowned self] in
            self.handleCancelOrder(indexPath: indexPath, orderId: self.orderListing?.orders?[indexPath.row].orderId , orderStatus: self.orderListing?.orders?[indexPath.row].status )
        }
        self.pushVC(orderDetailVc)
    }
    
    func handleCancelOrder(indexPath : IndexPath,orderId : String?, orderStatus : OrderDeliveryStatus?){
        
        tableView.beginUpdates()
        dataSource.items?.remove(at: indexPath.row)
        orderListing?.orders?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .top)
        tableView.endUpdates()
        viewPlaceholder?.isHidden = (dataSource.items?.count ?? 0) > 0 ? true : false
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CancelOrder(FormatAPIParameters.CancelOrder(orderId: orderId , isScheduled: orderStatus == .Schedule ? "1" : "0").formatParameters())) { (response) in
            switch response {
            case .Success(_):
                UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.YouHaveCancelledYourOrderSuccessfully.string, style: .Success)
            case .Failure(_):
                break
            }
        }
    }
    
}


//MARK: - Button Actions

extension ScheduledOrderController{
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}

//MARK: - Order Parent Cell Delegate {

extension ScheduledOrderController : OrderParentCellDelegate {
    
    func actionOrderTypeButton(cell: OrderParentCell, orderId: String?) {
        if cell.btnOrderType.titleLabel?.text == L10n.CONFIRMORDER.string {
            let VC = StoryboardScene.Order.instantiatePaymentMethodController()
            VC.orderId = orderId
            VC.isConfirmOrder = true
            pushVC(VC)
            return
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
