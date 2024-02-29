//
//  RateMyOrderController.swift
//  Clikat
//
//  Created by cblmacmini on 5/31/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class RateMyOrderController: BaseViewController {

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

    var rateSupplierView = SupplierRatingPopUp(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: ScreenSize.SCREEN_HEIGHT))
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: - Webservice Methods
extension RateMyOrderController {
    
    
    func webService (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.RateOrderListing(FormatAPIParameters.RateOrderListing.formatParameters())) { (response) in
            
            weak var weak : RateMyOrderController? = self
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

extension RateMyOrderController{
    
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orderListing?.orders, height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: { (cell, item) in
            
            weak var weakSelf : RateMyOrderController? = self
            weakSelf?.configureCell(withCell : cell , item : item)
            
            }, aRowSelectedListener: { (indexPath) in
                weak var weak : RateMyOrderController? = self
                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
                orderDetailVc.orderDetails = weak?.orderListing?.orders?[indexPath.row]
                weak?.pushVC(orderDetailVc)
        })
        tableView.reloadData()
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
        
        (cell as? OrderParentCell)?.cellType = .RateOrder
        (cell as? OrderParentCell)?.order = item as? OrderDetails
        let tap = UITapGestureRecognizer(target: self, action: #selector(RateMyOrderController.handleReviewViewTap(sender:)))
        (cell as? OrderParentCell)?.viewRating.addGestureRecognizer(tap)
    }
    
    func itemClicked(withIndexPath : IndexPath){
    }
    
    @objc func handleReviewViewTap(sender : UITapGestureRecognizer){
        self.view.addSubview(rateSupplierView)
        rateSupplierView.presentingViewController = self
        let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView))
        rateSupplierView.presentRatingView { (rating, comment) in
            weak var weakSelf = self
            weakSelf?.rateSupplierView.dismissRatingView()
            weakSelf?.webServiceRateOrder(indexPath: indexPath, rating: rating, comment: comment)
            weakSelf?.rateOrder(indexPath: indexPath,rating: rating)
        }
    }
    
    func rateOrder(indexPath : IndexPath?,rating : Int?){
        guard let indexpath = indexPath, let cell = tableView.cellForRow(at: indexpath) as? OrderParentCell else { return }
        cell.rateControl?.rating = rating ?? 0
    }
}

//MARK: - Actions

extension RateMyOrderController {
    
    
    @IBAction func actionMenu(sender: UIButton) {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    @IBAction func actionCart(sender: UIButton) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
}

//MARK: - Rate Order webService

extension RateMyOrderController {
    
    func webServiceRateOrder(indexPath : IndexPath?, rating : Int?,comment : String?){
        guard let index = indexPath?.row else { return }
        
        AdjustEvent.RateOrder.sendEvent()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.RateMyOrder(FormatAPIParameters.RateMyOrder(orderId: orderListing?.orders?[index].orderId, rating: rating?.toString, comment: comment).formatParameters())) { (response) in
            
            
            switch response {
            case .Success(_):
                UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.SupplierRatedSuccessfully.string, style: .Success, success: {})
            case .Failure(_):
                SKToast.makeToast(L10n.SomewhereSomehowSomethingWentWrong.string)
            }
        }
    }
}
