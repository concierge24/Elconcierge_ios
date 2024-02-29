//
//  RateReviewsVC.swift
//  Sneni
//
//  Created by Mac_Mini17 on 19/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

protocol RateReviewsVCDelegate: class {
    func updateProductDetail()
}

class RateReviewsVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!{
        didSet{
              tableView.tableFooterView = UIView()
        }
    }
    var products : [ProductF]?
    var orderDetails : OrderDetails?
    var rateType: RateType = .product

    weak var delegate: RateReviewsVCDelegate?
    var tableDataSource : TableViewDataSource?{
        didSet{
            tableView.reloadData()
        }
    }

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }

}

// MARK: - configureTableView
extension RateReviewsVC {
    
    func configureTableView(){
        
        var items = [Any]()
        items.append(1)
        if rateType == .product {
            items = products ?? []
        }
        tableDataSource = TableViewDataSource(items: items, height: 372, tableView: tableView, cellIdentifier: CellIdentifiers.RateReviewCell, configureCellBlock: { [weak self] (cell, item) in
            
            self?.configureCell(cell: cell, item: item)
            
            }, aRowSelectedListener: { [weak self] (indexPath) in
                
                
        })
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    func configureCell(cell : Any?,item : Any?){
        if let cell = cell as? RateReviewCell {
            cell.rateType = rateType
            if rateType == .product {
                cell.orderDetails = orderDetails
                cell.product = item as? ProductF
//                cell.productRated = { [weak self] in
//                    guard let `self` = self else { return }
//                    if let index = self.products?.firstIndex(where: { $0.product_id == (item as? ProductF)?.product_id}) {
//                        self.products?.remove(at: index)
//                        if (self.products ?? []).count == 0 {
//                            self.popVC()
//                        }
//                        else {
//                            self.tableDataSource?.items = self.products
//                            self.tableView.reloadData()
//                        }
//
//                    }
//                }
            }
            else {
                cell.orderDetails = orderDetails
            }
            cell.configureCell()
        }
    }
}

extension RateReviewsVC{
    
    @IBAction func crossBtnClick(sender:UIButton){
        
        self.popVC()
        
    }
}
