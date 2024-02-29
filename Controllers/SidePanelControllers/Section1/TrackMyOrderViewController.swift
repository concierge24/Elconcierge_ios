//
//  TrackMyOrderViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class TrackMyOrderViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
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
        tableView.register(UINib(nibName: CellIdentifiers.OrderParentCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.OrderParentCell)
        configureTableViewInitialization()
        webService()

    }
}


//MARK: - Webservice Methods
extension TrackMyOrderViewController {
    
    
    func webService (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderTrackingList(FormatAPIParameters.OrderTrackingList.formatParameters())) { (response) in
            
            weak var weak : TrackMyOrderViewController? = self
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

extension TrackMyOrderViewController{
    
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orderListing?.orders , height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            self.configureCell(withCell : cell , item : item)
            
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }

                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
                orderDetailVc.orderDetails = self.orderListing?.orders?[indexPath.row]
                orderDetailVc.type = .OrderTracking
                self.pushVC(orderDetailVc)
        })
        tableView.reloadData()
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
        
        (cell as? OrderParentCell)?.cellType = .OrderTracking
        (cell as? OrderParentCell)?.order = item as? OrderDetails
        (cell as? OrderParentCell)?.orderDelegate = self
        (cell as? OrderParentCell)?.btnOrderType.isHidden = (item as? OrderDetails)?.status == .Tracked ? true : false
    }
    
}


//MARK: - Button Actions

extension TrackMyOrderViewController{
    
    @IBAction func actionCart(sender: AnyObject) {
        
        let vc = CartViewController.getVC(Stortyboad.options)
        pushVC(vc)
        
    }

    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
}

//MARK: Order cell delegate
extension TrackMyOrderViewController : OrderParentCellDelegate {
    
    func actionOrderTypeButton(cell: OrderParentCell, order: OrderDetails?) {
        let index = orderListing?.orders?.index(where: { (orderDetails) -> Bool in
            orderDetails.orderId == order?.orderId
        })
        (dataSource.items as? [OrderDetails])?[/index].status = .Tracked
        tableView.reloadData()
        webServiceTrackOrder(orderId: order?.orderId)
    }
    func actionOrderTypeButton(cell: OrderParentCell, orderId: String?) {
    }
}

//MARK: - Track Order web service
extension TrackMyOrderViewController {
    
    func webServiceTrackOrder(orderId : String?){
        
        AdjustEvent.TrackOrder.sendEvent()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderTrack(FormatAPIParameters.OrderTrack(orderId: orderId).formatParameters())) { (response) in
            weak var weakSelf = self
            switch response {
            case .Success(let object):
                SKToast.makeToast(object as? String)
            case .Failure(_):
                break
            }
        }
    }
}
