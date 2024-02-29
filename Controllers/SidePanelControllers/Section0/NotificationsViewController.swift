//
//  NotificationsViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class NotificationsViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
//            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
        }
    }
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet var btnClearAll: UIButton!{
        didSet{
            btnClearAll?.isEnabled = false
            btnClearAll?.isHidden = true
        }
    }
    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView?.estimatedRowHeight = 44.0
            tableView?.rowHeight = UITableView.automaticDimension
        }
    }
    
    //MARK:- Variables
    var dataSource : TableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
        }
    }
    var arrNotifications: [NotificationClass] = []

    var skip = 0
    var totalCount = 0
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addLoadMore()
        webServiceGetAllNotifications()

    }
    
    func addLoadMore() {
           tableView.es.addInfiniteScrolling { [weak self] in
               guard let `self` = self else { return }
               if self.totalCount == self.arrNotifications.count {
                   self.tableView.es.stopLoadingMore()
                   return
               }
               self.webServiceGetAllNotifications()
           }
       }
    
    func reloadTable() {
        viewPlaceholder?.isHidden = !arrNotifications.isEmpty
        btnClearAll?.isEnabled = !arrNotifications.isEmpty

        dataSource.items = arrNotifications
        ez.runThisInMainThread {
            weak var weakSelf : NotificationsViewController? = self
            weakSelf?.tableView.reloadTableViewData(inView: weakSelf?.view)
        }
    }
}

//MARK: - WebService
extension NotificationsViewController{
    
    func webServiceGetAllNotifications(){
        let api = API.AllNotifications(skip: skip)
        APIManager.sharedInstance.opertationWithRequest(withApi: api) { [weak self] (response) in
            
            guard let `self` = self else { return }
            self.tableView.es.stopLoadingMore()

            switch response{
            case .Success(let listing):
                guard let objModel = listing as? NotificationListing else { return }
                self.totalCount = objModel.totalCount ?? 0
                let arr = objModel.arrayNotifications ?? []
                if self.skip == 0 {
                    self.arrNotifications = arr
                }
                else {
                    self.arrNotifications.append(contentsOf: arr)
                }
                if !arr.isEmpty {
                    self.skip += 1
                }
                self.reloadTable()
            default :
                break
            }
        }
    }
    
    func webServiceClearAllNotifications(){
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ClearAllNotifications(FormatAPIParameters.ClearAllNotifications.formatParameters())) { (response) in
            
            weak var weakSelf : NotificationsViewController? = self
            switch response{
            case .Success(_):
                weakSelf?.skip = 0
                weakSelf?.arrNotifications = []
                weakSelf?.reloadTable()
            default :
                break
            }
        }
    }
}

//MARK: - TableView configuration Methods
extension NotificationsViewController{
    
    func configureTableView (){
        
        dataSource = TableViewDataSource(items: arrNotifications , height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.NotificationsCell , configureCellBlock: { (cell, item) in
            weak var weakSelf = self
            weakSelf?.configureTableCell(cell: cell, item: item)
            }, aRowSelectedListener: { [weak self] (indexPath) in
                self?.configureCellSelection(indexPath: indexPath)
        })
        
    }
    
    func configureTableCell(cell : Any?, item : Any?){
        (cell as? NotificationsCell)?.notification = item as? NotificationClass
    }
    
    func configureCellSelection(indexPath : IndexPath) {
        guard let notifications = dataSource.items as? [NotificationClass] else { return }
        let order = OrderDetails(orderId: notifications[indexPath.row].orderId)
//        tableView.beginUpdates()
//        dataSource.items?.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .right)
//        tableView.endUpdates()
        
        let VC = StoryboardScene.Order.instantiateOrderDetailController()
        VC.orderDetails = order
        VC.type = .OrderUpcoming
        pushVC(VC)
    }
}


//MARK: - Button Actions
extension NotificationsViewController{
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
        
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionClearAll(sender: AnyObject) {
        btnClearAll.isEnabled = true
        webServiceClearAllNotifications()
    }
}
