//
//  PackageProductListingViewController.swift
//  Clikat
//
//  Created by Night Reaper on 24/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class PackageProductListingViewController: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!

    //MARK:- Variables
    var productListing : PackageProductListing?{
        didSet{
            tableView.reloadTableViewData(inView: view)
        }
    }
    var tableDataSource = TableViewDataSource(){
        didSet{
            tableView.dataSource = tableDataSource
            tableView.delegate = tableDataSource
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CellIdentifiers.ProductListingCell,bundle: nil), forCellReuseIdentifier: CellIdentifiers.ProductListingCell)
        webServicePackageListing()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleCells()
    }

    func webServicePackageListing(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.PackageProductListing(FormatAPIParameters.PackageProductListing(supplierBranchId: passedData.supplierBranchId, categoryId: passedData.categoryId).formatParameters())) { (response) in
            weak var weakSelf = self
            switch response {
            case .Success(let object):
                weakSelf?.productListing = object as? PackageProductListing
                weakSelf?.configureTableView()
            case .Failure(_):
                break
            }
            
        }
        
    }
}

extension PackageProductListingViewController {
    func configureTableView(){
        tableDataSource = TableViewDataSource(items: productListing?.arrProduct, height: 136.0, tableView: tableView, cellIdentifier: CellIdentifiers.ProductListingCell, configureCellBlock: { (cell, item) in
            weak var weakSelf = self
            weakSelf?.configureTableViewCell(cell: cell, item: item)
            }, aRowSelectedListener: { [weak self] (indexPath) in
                self?.configureCellSelection(indexPath: indexPath)
        })
    }
    
    func configureTableViewCell(cell : Any?,item : Any?){
        
        (cell as? ProductListingCell)?.product = item as? PackageProduct
    }
    
    func configureCellSelection(indexPath : IndexPath){
        let productDetailVc = StoryboardScene.Main.instantiateProductDetailViewController()
        productDetailVc.passedData.productId = productListing?.arrProduct?[indexPath.row].id
        productDetailVc.suplierBranchId = productListing?.arrProduct?[indexPath.row].supplierBranchId
        productDetailVc.isPackage = true
        pushVC(productDetailVc)
    }
}


extension PackageProductListingViewController {
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionToggleMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
}

extension PackageProductListingViewController {
    func reloadVisibleCells(){
        
        DBManager.sharedManager.getCart { (cartProducts) in
            weak var weakSelf = self
            let visibleCells = weakSelf?.tableView.visibleCells ?? []
            
            for visibleCell in visibleCells {
                guard let cell = visibleCell as? ProductListingCell else { return }
                cell.stepper?.value = 0
                for cartProduct in cartProducts {
                    guard let product = cartProduct as? Cart,let quantity = product.quantity, cell.product?.id == product.id  else { return }
                    
                    cell.stepper?.value = Double(quantity) ?? 0
                }
            }
        }
    }
}
