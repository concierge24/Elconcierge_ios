//
//  SupplierViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import SkeletonView

class SupplierListingViewController: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var labelPlaceholder: UILabel!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet var lblNavTitle: UILabel!
    @IBOutlet var btnCart: CartButton!
    @IBOutlet weak var viewBg: UIView? {
        didSet{
            viewBg?.layer.borderWidth = 0.5
            //viewBg?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField! {
        didSet {
            tfSearch.setAlignment()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            //isLast ? LoadMorePTableCell.identifier : (SKAppType.type == .food ? HomeFoodRestaurantTableCell.identifier : ProductListingCell.identifier)
            if SKAppType.type == .food {
                tableView.registerCells(nibNames: [HomeFoodRestaurantTableCell.identifier])
            }
            else {
                tableView.registerCells(nibNames: [SupplierListingCell.identifier])
            }
            configureTableViewInitialization()
        }
    }
    
    //MARK:- Variables
    var filters : FilterAssocitedValue = .Filter([],[],[],[],.DoesntMatter)
    var tableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    var suppliers : [Supplier]? = [] {
        didSet{
            tableViewDataSource.items = suppliers
            viewPlaceholder?.isHidden = suppliers?.count == 0 ? false : true
            labelPlaceholder?.text = laundryData?.pickupDate == nil ? L10n.NoSupplierFound.string : L10n.ChangePickUpTimeNoSuppliersAreAvailableForThisPickupTiming.string
            tableView?.reloadTableViewData(inView: view)
        }
    }
    var sponsor : Sponsor?
    var fromCat = false
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNavTitle.text = passedData.subCategoryName ?? passedData.categoryName
        
        tableViewDataSource.items = suppliers
        viewPlaceholder.isHidden = suppliers?.count == 0 ? false : true
        labelPlaceholder.text = laundryData?.pickupDate == nil ? L10n.NoSupplierFound.string : L10n.ChangePickUpTimeNoSuppliersAreAvailableForThisPickupTiming.string
        tableView?.reloadTableViewData(inView: view)
        tableViewDataSource.headerHeight = sponsor?.id != nil ? 72 : 0
        
//        if APIConstants.defaultAgentCode == "bletani_0675" {
//            webServiceSupplierListing()
//        }
        if fromCat{
            webServiceSupplierListing()
        }
      //  self.stopSkeletonAnimation(self.tableView)

        if suppliers?.count != 1 {
//            itemClicked(atIndexPath: IndexPath(row: 0, section: 0))
        } else {
            
//            webServiceSupplierListing()
        }
        
        
    }
}

//MARK: - WebService Methods
extension SupplierListingViewController {
    
    class func getSuppliers(categoryId: String?, subCategoryId: String?, order: OrderSummary?, blockSuppliers: (([Supplier]) -> ())?) {
        
        var parameters : Dictionary<String,Any>? = [:]
        if let pickup = order?.pickupDate {
            parameters = FormatAPIParameters.LaundrySupplierList(categoryId: categoryId, pickupDate: pickup).formatParameters()
        }else {
            parameters = FormatAPIParameters.SupplierListing(categoryId: categoryId, subCategoryId: subCategoryId).formatParameters()
        }
        let api = order?.pickupDate == nil ? API.SupplierListing(parameters) : API.LaundrySupplierList(parameters)
        
        APIManager.sharedInstance.opertationWithRequest(withApi: api) {
            (response) in
            var array = [Supplier]()
            
            switch response {
            case .Success(let listing):
                array = (listing as? SupplierListing)?.suppliers ?? []
            default :
                break
            }
            
            blockSuppliers?(array)
        }
    }
    
    func webServiceSupplierListing () {
        
        var parameters : Dictionary<String,Any>? = [:]
        if let pickup = laundryData?.pickupDate {
            parameters = FormatAPIParameters.LaundrySupplierList(categoryId: passedData.categoryId, pickupDate: pickup).formatParameters()
        }else {
            parameters = FormatAPIParameters.SupplierListing(categoryId: APIConstants.defaultAgentCode == "bletani_0675" ? passedData.categoryId : passedData.categoryId,subCategoryId: passedData.subCategoryId).formatParameters()
        }
        let api = laundryData?.pickupDate == nil ? API.SupplierListing(parameters) : API.LaundrySupplierList(parameters)
        APIManager.sharedInstance.opertationWithRequest(withApi: api) { [weak self] (response) in
            
            weak var weak : SupplierListingViewController? = self
            switch response{
                
            case .Success(let listing):
                
                self?.tableViewDataSource.headerHeight = weak?.sponsor?.id != nil ? 72 : 0
                self?.suppliers = (listing as? SupplierListing)?.suppliers
                
            default :
                break
            }
        }
    }
    
}

//MARK: - TableView Configuration Methods
extension SupplierListingViewController  {
    
    func configureTableViewInitialization(){
//        self.startSkeletonAnimation(self.tableView)
        var identifier = SupplierListingCell.identifier
        if SKAppType.type == .food {
            identifier = HomeFoodRestaurantTableCell.identifier
        }
        tableViewDataSource = TableViewDataSource(items: suppliers, height: 104.0 , tableView: tableView, cellIdentifier: identifier , configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            
            if SKAppType.type == .food {
                if let cell = cell as? HomeFoodRestaurantTableCell {
                    cell.objModel = item as? Supplier
                    cell.selectionStyle = .none
                    cell.blockSelect = {
                        [weak self] supplier in
                        guard let self = self else { return }
                        if let indexPath = self.tableView.indexPath(for: cell) {
                            self.itemClicked(atIndexPath: indexPath)
                        }
                    }
                }
            }
            else {
                self.configureCell(withCell: cell, item: item)
            }
            
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }
                if SKAppType.type != .food {
                    self.itemClicked(atIndexPath: indexPath)
                }
        })
       
//        tableViewDataSource.viewforHeaderInSection = { (section) in
//            weak var weakSelf = self
//            let sponsorView = SponsorView(frame: CGRect(x: 0, y: 0, w: ScreenSize.SCREEN_WIDTH, h: 48))
//            guard let image = weakSelf?.sponsor?.logo,url = NSURL(string: image) else { return nil }
//            sponsorView.imageViewSponsor.yy_setImageWithURL(url, options: .ProgressiveBlur)
//            return sponsorView
//        }
        
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
      
        guard let tempCell = cell as? SupplierListingCell else{
            return
        }
        tempCell.supplier = item as? Supplier
    }

    func itemClicked(atIndexPath indexPath : IndexPath){
 
        guard let supplier = (tableViewDataSource.items?[indexPath.row] as? Supplier), let supplierId = supplier.id,
            let supplierBranchId = (tableViewDataSource.items?[indexPath.row] as? Supplier)?.supplierBranchId
            else { return }
//        guard let supplier = tableViewDataSource.items?[indexPath.row] as? Supplier else {return}
//
//        let arrayCat = supplier.categories ?? []
//        if arrayCat.isEmpty {
//            return
//        }
//
//        if SKAppType.type.isFood {
//            let category = arrayCat.first
//        let VC = RestaurantDetailVC.getVC(.splash)
//        let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
//        VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
//        VC.passedData.subCats = supplier.categories
//        VC.passedData.supplier = supplier
//
//        self.pushVC(VC)
  
//        if SKAppType.type == .home && passedData.isQuestion {
//            getQuestions(supplier: supplier, supplierId: supplierId, supplierBranchId: supplierBranchId)
//        }
//        else {
        
        if APIConstants.defaultAgentCode == "lconcierge_0676"{
            
            let arrayCat = supplier.categories ?? []
            let category = arrayCat.first

            let VC = RestaurantDetailVC.getVC(.splash)
            let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
            VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
            VC.passedData.subCats = supplier.categories
            VC.passedData.supplier = supplier
            
            self.pushVC(VC)
        }else{
            SupplierListingViewController.showProducts(supplier: supplier, supplierId: supplierId, supplierBranchId: supplierBranchId)
        }
        
        
        
//        }
        

        
//        ez.runThisInMainThread {
//            [weak self] in
//            guard let self = self else { return }
//
//        }
    
    }
    
    static func showProducts(supplier: Supplier, supplierId: String, supplierBranchId: String) {
        guard let vc = ez.topMostVC as? CategoryFlowBaseViewController else { return }
        GDataSingleton.sharedInstance.currentSupplier = supplier
        let supp = GDataSingleton.sharedInstance.currentSupplier
        supp?.categoryId = vc.passedData.categoryId
        GDataSingleton.sharedInstance.currentSupplier = supp

        vc.passedData.supplierId = supplierId
        vc.passedData.supplierBranchId = supplierBranchId
        vc.pushNextVc()
    }
}


//MARK: - Button Actions
extension SupplierListingViewController{
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionSearch(sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionFilter(sender: AnyObject) {
        
         let filterVC = FilterVC.getVC(.main)
//        filterVC.delegate  = self
//        filterVC.filters = filters
        presentVC(filterVC)
    }

}


extension SupplierListingViewController : FilterViewControllerDelegate {
    func filterApplied (withFilter filter : FilterAssocitedValue){
        
        filters = filter
        if case .Filter(let status ,let delivery , let commission , let rating,let sortBy) = filter {
            var filterSuppliers = suppliers?.filter({ (supplier) -> Bool in                
                                
                var statusBool = false
                var paymentBool = false
                var commissionBool = false
                var ratingBool = false
                
                if status.isEmpty || status.contains(supplier.status) || supplier.status == .DoesntMatter {
                    statusBool = true
                }
                if delivery.isEmpty || delivery.contains(supplier.paymentMethod) || supplier.paymentMethod == .DoesntMatter {
                    paymentBool = true
                }
                if commission.isEmpty || commission.contains(supplier.commissionPackage) {
                    commissionBool = true
                }
                let supplierRating = supplier.rating?.toInt() ?? 0
                
                if rating.isEmpty || rating.contains(Rating(rawValue: supplierRating) ?? .DoesntMatter) || (supplierRating >= 4 && rating.contains(.Star4Above)){
                    ratingBool = true
                }
                return statusBool && paymentBool && commissionBool && ratingBool
            })
            filterSuppliers?.sort(by: {
                switch sortBy {
                case .MinOrderAmount:
                    return ($0.minOrder?.toInt() ?? 0) < ($1.minOrder?.toInt() ?? 0)
                case .MinDelTime:
                    return ($0.deliveryMinTime?.toInt() ?? 0) < ($1.deliveryMinTime?.toInt() ?? 0)
                default:
                    break
                }
                return false
            })
            viewPlaceholder?.isHidden = filterSuppliers?.count == 0 ? false : true
            tableViewDataSource.items = filterSuppliers
            tableView.reloadData()
        }
    }

}

//MARK: - SearchField handlers

extension SupplierListingViewController : UITextFieldDelegate {    
    
    @IBAction func textFieldValueChanged(sender: UITextField) {
        let filterSuppliers = suppliers?.filter({ (supplier) -> Bool in
            guard let match = supplier.name?.contains(sender.text!, compareOption: .caseInsensitive) else { return false }
            return match
        })
        
        tableViewDataSource.items = sender.text?.count == 0 ? suppliers : filterSuppliers
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      //  constraintTableViewBottom.constant = 260
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //constraintTableViewBottom.constant = 0
        view.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
