//
//  PromotionsViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
// https://invis.io/FC70NOKR5#/151930110_Bg_Splash-3x

import UIKit
import EZSwiftExtensions

class PromotionsViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
        }
    }
    @IBOutlet weak var viewPlaceholder : UIView!
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
    
    var promotionListing : PromotionListing? {
        didSet{
            dataSource.items = promotionListing?.arrayPromotions
            ez.runThisInMainThread {
                weak var weakSelf : PromotionsViewController? = self
                weakSelf?.tableView.reloadTableViewData(inView: weakSelf?.view)
                
                guard let promotions = weakSelf?.promotionListing?.arrayPromotions, promotions.count > 0 else{
                    weakSelf?.viewPlaceholder?.isHidden = false
                    return
                }
                weakSelf?.viewPlaceholder?.isHidden = true
            }
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        webService()
        AdjustEvent.Promotions.sendEvent()
        
    }
    
}

//MARK: - Web Service Methods
extension PromotionsViewController {
    func webService(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.PromotionProducts(FormatAPIParameters.PromotionProducts.formatParameters())) { (response) in
            weak var weakSelf : PromotionsViewController? = self
            switch response{
            case .Success(let listing):
                weakSelf?.promotionListing = listing as? PromotionListing
            default :
                break
            }
        }
        
    }
}

//MARK: - TableView configuration Methods
extension PromotionsViewController{
    
    func configureTableView(){
        
        dataSource = TableViewDataSource(items: promotionListing?.arrayPromotions , height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.PromotionsCell , configureCellBlock: { (cell, item) in
            (cell as? PromotionsCell)?.promotion = item as? Promotion
        }, aRowSelectedListener: { [weak self] (indexPath) in
            
            
            self?.handleCellSelection(indexPath: indexPath)
        })
    }
    
    func handleCellSelection(indexPath : IndexPath){
        let VC = StoryboardScene.Main.instantiateProductDetailViewController()
        let promotion = promotionListing?.arrayPromotions?[indexPath.row]
        APIManager.sharedInstance.showLoader()
        
        let objR = API.SupplierImage(FormatAPIParameters.SupplierImage(supplierBranchId: promotion?.supplierBranchId).formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            
            APIManager.sharedInstance.hideLoader()
            switch response {
            case .Success(let object):
                guard let image = object as? String else { return }
                let supplier = Supplier()
                supplier.id = promotion?.supplierId
                supplier.supplierBranchId = promotion?.supplierBranchId
                supplier.logo = image.components(separatedBy: " ").first?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                GDataSingleton.sharedInstance.currentSupplier = supplier
                VC.passedData.supplierId = promotion?.supplierId
                VC.suplierBranchId = promotion?.supplierBranchId
                VC.passedData.categoryId = promotion?.categoryId
                VC.passedData.productId = promotion?.id
                VC.isPromotion = true
                self?.pushVC(VC)
            default :
                break
            }
        }
    }
}

//MARK: - Button Actions
extension PromotionsViewController {
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
}
