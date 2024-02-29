//
//  OrderHistoryViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

enum OrderType: String {
    case pending = "pending"
    case upcoming = "upcoming"
}

class OrderHistoryViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var placeholder_label: ThemeLabel! {
        didSet {
            placeholder_label.textColor = SKAppType.type.color
            if APIConstants.defaultAgentCode == "yummy_0122"{
                if let term = TerminologyKeys.noOrderFound.localizedValue() as? String{
                    self.placeholder_label.text = term
                }
            }else{
                let term = TerminologyKeys.order.englishText() ?? TerminologyKeys.order.defaultEnglishText()
                self.placeholder_label.text = String(format: "No %@ found!", "\(term)").localized()//"You have no past " + term

//                if let term = TerminologyKeys.order.localizedValue() as? String{
//            }
            }
        }
    }
    @IBOutlet weak var bottom_view: UIView! {
        didSet{
            bottom_view.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var placeholder_imageView: UIImageView!{
        didSet{
            self.placeholder_imageView.isHidden = true
        }
    }
    @IBOutlet weak var completed_button: UIButton! {
        didSet{
            completed_button.setTitleColor(SKAppType.type.color, for: .normal)
            if let term = TerminologyKeys.orders.localizedValue() as? String {
                completed_button.setTitle("Completed ".localized() + term, for: .normal)
            }

        }
    }
    @IBOutlet weak var pending_button: UIButton!{
        didSet{
            pending_button.setTitleColor(SKAppType.type.color, for: .normal)
            if let term = TerminologyKeys.orders.localizedValue() as? String {
                pending_button.setTitle("Pending ".localized() + term, for: .normal)
            }
        }
    }
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var top_view: UIView!
    @IBOutlet weak var bottomView_leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var title_label: ThemeLabel! {
        didSet {
            title_label.textColor = .white
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewPlaceholder : UIView!
    
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
        }
    }
    
    //MARK:- Variable
    
    var isHiddenBack = true
    var dataSource : TableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
        }
    }
    var orderListing : [OrderDetails]?
    var upcomingOrderListing : [OrderDetails]?
    var orderType: OrderType = .pending
    var skipUpcoming = 0
    var skipPast = 0
    var totalCountUpcoming = 0
    var totalCountPast = 0

    private var refreshControl : UIRefreshControl?

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        back_button.isHidden = isHiddenBack
        if let term = TerminologyKeys.order.localizedValue() as? String{
            self.labelTitle.text = term + " \("History".localized())"
        }
        addLoadMore()

        tableView.register(UINib(nibName: CellIdentifiers.OrderParentCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.OrderParentCell)
        configureTableViewInitialization()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)

        tableView.addSubview(refreshControl!)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            top_view.isHidden = true
            viewPlaceholder.isHidden = false
            tableView.isHidden = true
            return
        }
        top_view.isHidden = false
        viewPlaceholder.isHidden = true
        tableView.isHidden = false
        
        refreshTableData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
    
    func addLoadMore() {
        tableView.es.addInfiniteScrolling { [weak self] in
            guard let `self` = self else { return }
            if self.orderType == .pending {
                if self.totalCountPast == /self.orderListing?.count {
                    self.tableView.es.stopLoadingMore()
                    self.tableView.es.removeRefreshFooter()
                    return
                }
            }
            else {
                if self.totalCountUpcoming == /self.upcomingOrderListing?.count {
                    self.tableView.es.stopLoadingMore()
                    self.tableView.es.removeRefreshFooter()
                    return
                }
            }
            
            self.refreshTableData(loadMore: true)
        }
    }
    
    @objc func refreshTableData(loadMore: Bool = false) {
        if L102Language.isRTL {
            if self.bottomView_leadingConstraint.constant == self.pending_button.frame.x {
                self.webService(loadMore: loadMore)
            } else if self.bottomView_leadingConstraint.constant == self.completed_button.frame.x {
                 self.upcomingOrders(loadMore: loadMore)
            }
        }else {
            if self.bottomView_leadingConstraint.constant == self.pending_button.frame.x {
                self.upcomingOrders(loadMore: loadMore)
            } else if self.bottomView_leadingConstraint.constant == self.completed_button.frame.x {
                 self.webService(loadMore: loadMore)
            }
        }
    }
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func completed_buttonAction(_ sender: Any) {
        self.webService()
        UIView.animate(withDuration: 0.35) {
            if L102Language.isRTL {
                self.bottomView_leadingConstraint.constant = self.pending_button.frame.x
            }else {
                self.bottomView_leadingConstraint.constant = self.completed_button.frame.x
            }
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pending_buttonAction(_ sender: Any) {
        self.upcomingOrders()
        UIView.animate(withDuration: 0.35) {
            if L102Language.isRTL {
                self.bottomView_leadingConstraint.constant = self.completed_button.frame.x
            }else {
                self.bottomView_leadingConstraint.constant = self.pending_button.frame.x
            }
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Webservice Methods
extension OrderHistoryViewController {
    
    func webService(loadMore: Bool = false) {
        if !loadMore {
            skipPast = 0
            addLoadMore()
        }
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderHistory(FormatAPIParameters.OrderHistory(skip: skipPast).formatParameters())) { [weak self] (response) in
            
            guard let `self` = self else { return }
            self.tableView.es.stopLoadingMore()

            if self.refreshControl?.isRefreshing ?? false {
                self.refreshControl?.endRefreshing()
            }
            switch response{
                
            case .Success(let listing):
                self.orderType = .upcoming
                
                let objModel = listing as? OrderListing
                self.totalCountPast = objModel?.count ?? 0
                let arr = objModel?.orders ?? []
                if self.skipPast == 0 {
                    self.orderListing = arr
                }
                else {
                    self.orderListing?.append(contentsOf: arr)
                }
                if !arr.isEmpty {
                    self.skipPast += 1
                }
                self.reloadTable()
                break
            default :
                break
            }
            
        }
        
    }
    
    func upcomingOrders(loadMore: Bool = false) {
        if !loadMore {
            skipUpcoming = 0
        }
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderUpcoming(FormatAPIParameters.OrderUpcoming(skip: skipUpcoming).formatParameters())) { [weak self] (response) in
            
            guard let `self` = self else { return }
            self.tableView.es.stopLoadingMore()

            if self.refreshControl?.isRefreshing ?? false {
                self.refreshControl?.endRefreshing()
            }
            switch response{
            case .Success(let listing):
                self.orderType = .pending
                let objModel = listing as? OrderListing
                self.totalCountUpcoming = objModel?.count ?? 0
                let arr = objModel?.orders ?? []
                if self.skipUpcoming == 0 {
                    self.upcomingOrderListing = arr
                }
                else {
                    self.upcomingOrderListing?.append(contentsOf: arr)
                }
                if !arr.isEmpty {
                    self.skipUpcoming += 1
                }
                self.reloadTable()
                
                break
            default :
                break
            }
            
        }
    }
   
    func reloadTable() {
        if orderType == .pending {
            dataSource.items = upcomingOrderListing
            tableView?.reloadTableViewData(inView: view)
            
            guard let orders = upcomingOrderListing, orders.count > 0 else{
                viewPlaceholder?.isHidden = false
                return
            }
            viewPlaceholder?.isHidden = true
        }
        else {
            dataSource.items = orderListing
            tableView?.reloadTableViewData(inView: view)
            
            guard let orders = orderListing, orders.count > 0 else{
                viewPlaceholder?.isHidden = false
                return
            }
            viewPlaceholder?.isHidden = true
        }
    }
}


//MARK: - TableView Configuration
extension OrderHistoryViewController{
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orderListing, height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }

            self.configureCell(withCell : cell , item : item)
            
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }

            let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
            orderDetailVc.type = self.orderType == .pending ? .OrderUpcoming : .OrderHistory
            if self.orderType == .pending {
                orderDetailVc.orderDetails = self.upcomingOrderListing?[indexPath.row]
            }else {
                orderDetailVc.orderDetails = self.orderListing?[indexPath.row]
            }
            if let terminology = orderDetailVc.orderDetails?.terminology {
                AppSettings.shared.appThemeData?.terminology = terminology
            }
            if let type = orderDetailVc.orderDetails?.appType {
                AppSettings.shared.appType = type.rawValue
            }
            self.pushVC(orderDetailVc)
        })
        tableView.reloadData()
    }
    
    func configureCell(withCell cell : Any , item : Any? ){
        
        (cell as? OrderParentCell)?.orderType = self.orderType
        (cell as? OrderParentCell)?.cellType = self.orderType == .pending ? .OrderUpcoming : .OrderHistory
        (cell as? OrderParentCell)?.order = item as? OrderDetails
        (cell as? OrderParentCell)?.orderDelegate = self
        
    }
    
    func itemClicked(withIndexPath : IndexPath){
        
    }
    
}

//MARK: - Button Actions
extension OrderHistoryViewController{
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}

//MARK: - Order Parent cell delegate
extension OrderHistoryViewController : OrderParentCellDelegate {
    
    func actionPayNow(cell: OrderParentCell, order: OrderDetails?) {
//        guard let type = getAllowedPaymentType() else { return }
//        makePayment(order: order!, type: order?.paymentType == .Card ? .Card : type)
    }
    
    func actionOrderTypeButton(cell: OrderParentCell, order: OrderDetails?) {
        
        if cell.btnOrderType.titleLabel?.text == L10n.CANCELORDER.stringFor(appType: order?.appType) {
            cancelOrder(orderId: /order?.orderId, appType: order?.appType)
        }
        else {
            //Haspinder Singh
            //Check cart -> If cart == nil then direct reorder
            DBManager.sharedManager.getCart { (products) in
                if products.count > 0{
                    
                    UtilityFunctions.showAlert(title: nil, message: L10n.ReOrderingWillClearYouCart.string, success: {
                        weak var weakSelf = self
                        weakSelf?.reorderAllitems(orderDetails: order)
                    }) {
                        
                    }}
                else{
                    self.reorderAllitems(orderDetails: order)
                }
            }
        }
        
    }
    
    func actionOrderTypeButton(cell: OrderParentCell, orderId: String?) {
        
    }
    
    func reorderAllitems(orderDetails : OrderDetails?){
        
        AdjustEvent.Reorder.sendEvent()
        //        DBManager.sharedManager.cleanCart()
        guard let products = orderDetails?.product else { return }
        //        GDataSingleton.sharedInstance.currentSupplierId = orderDetails?.supplierBranchId
        for product in products {
            guard let quantity = Int(product.quantity ?? "") else { return }
            product.supplierBranchId = orderDetails?.supplierBranchId
            DBManager.sharedManager.manageCart(product: product, quantity: quantity)
        }
        GDataSingleton.sharedInstance.currentCategoryId = products.first?.categoryId
        let VC = StoryboardScene.Options.instantiateCartViewController()
        pushVC(VC)
    }
    
    
//    func actionScheduleOrder() {
//
//        let schedularVC = StoryboardScene.Order.instantiateOrderSchedularViewController()
//        schedularVC.orderId = orderDetails?.orderId
//        pushVC(schedularVC)
//    }
    
    func cancelOrder(orderId: String, appType: SKAppType?) {
        
        UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.DoYouReallyWantToCancelThisOrder.stringFor(appType: appType), success: { [weak self] in
            self?.cancelOrderWebservice(orderId: orderId)
            }, cancel: {
                
        })
    }

}

extension OrderHistoryViewController{
    
    func cancelOrderWebservice(orderId: String){
       // guard let indexpath = tableView.indexPath(for: cell) else { return }
//        tableView.beginUpdates()
//        dataSource.items?.remove(at: indexpath.row)
//        orderListing?.orders?.remove(at: indexpath.row)
//        tableView.deleteRows(at: [indexpath], with: .top)
//        tableView.endUpdates()
      //  viewPlaceholder?.isHidden = (dataSource.items?.count ?? 0) > 0 ? true : false
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CancelOrder(FormatAPIParameters.CancelOrder(orderId: orderId, isScheduled: "0").formatParameters())) { (response) in
            switch response {
            case .Success(_):
                
                self.refreshTableData()
                break
            case .Failure(_):
                break
            }
        }
    }
    
}
