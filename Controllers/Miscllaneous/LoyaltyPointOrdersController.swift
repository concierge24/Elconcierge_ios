//
//  LoyaltyPointOrdersController.swift
//  Clikat
//
//  Created by cbl20 on 9/13/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LoyaltyPointOrdersController: UIViewController {

    
    @IBOutlet weak var menu_button: ThemeButton!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var viewPlaceholder : UIView!
    
    var orders : [OrderDetails]?
    var dataSource : TableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = dataSource
            tableView?.delegate = dataSource
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifiers.OrderParentCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.OrderParentCell)
        viewPlaceholder?.isHidden = (orders?.count ?? 0) > 0 ? true : false
        tableView?.isHidden = (orders?.count ?? 0) > 0 ? false : true
        
        configureTableViewInitialization()
    }
}

//MARK: - Configure Tableview
extension LoyaltyPointOrdersController {
    
    func configureTableViewInitialization(){
        dataSource = TableViewDataSource(items: orders, height: 283, tableView: tableView, cellIdentifier: CellIdentifiers.OrderParentCell , configureCellBlock: { [weak self] (cell, item) in
            
            
            self?.configureCell(withCell : cell , item : item)
            
            }, aRowSelectedListener: { /*[weak self] */(indexPath) in
                
//                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
//                orderDetailVc.orderDetails = self?.orders?[indexPath.row]
//                self?.pushVC(orderDetailVc)
            })
        tableView.reloadData()
    }
    func configureCell(withCell cell : Any , item : Any? ){
        
        (cell as? OrderParentCell)?.cellType = .LoyaltyPoints
        (cell as? OrderParentCell)?.order = item as? OrderDetails
    }
}

//MARK: - Button Actions
extension LoyaltyPointOrdersController {
    
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
    
}
