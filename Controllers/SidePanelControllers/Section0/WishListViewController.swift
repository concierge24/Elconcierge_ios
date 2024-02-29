//
//  WishListViewController.swift
//  Sneni
//
//  Created by Sandeep Kumar on 24/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum ListType: String {
    case products
    case suppliers
}

class WishListViewController: UIViewController {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var bottom_view: UIView! {
        didSet{
            bottom_view.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var topViewHgt: NSLayoutConstraint!
    @IBOutlet weak var suppliers_button: UIButton! {
        didSet{
            suppliers_button.setTitleColor(SKAppType.type.color, for: .normal)
            if let term = TerminologyKeys.suppliers.localizedValue() as? String {
                suppliers_button.setTitle(term, for: .normal)
            }
            
        }
    }
    @IBOutlet weak var products_button: UIButton!{
        didSet{
            products_button.setTitleColor(SKAppType.type.color, for: .normal)
            if let term = TerminologyKeys.products.localizedValue() as? String {
                products_button.setTitle(term, for: .normal)
            }
        }
    }
    @IBOutlet weak var top_view: UIView!
    @IBOutlet weak var bottomView_leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblTitle: ThemeLabel! {
        didSet {
            if let term = TerminologyKeys.wishlist.localizedValue() as? String, !term.isEmpty {
                lblTitle.text = term
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView()
            configureTableView()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configCollection()
        }
    }
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    
    //MARK:- ======== Variables ========
    var collectionViewDataSource: SKCollectionViewDataSource!
    var tableDataSource: SKTableViewDataSource!
    
    var arrayProducts: [ProductF] = [] {
        didSet {
            viewPlaceholder?.isHidden = !arrayProducts.isEmpty
            collectionViewDataSource.reload(items: arrayProducts)
        }
    }
    var arraySuppliers : [Supplier] = [] {
        didSet{
            viewPlaceholder?.isHidden = !arraySuppliers.isEmpty
            tableDataSource.reloadTable(items: arraySuppliers)
        }
    }
    
    var listType: ListType = .products
    
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        initalSetup()
        
    }

    
    
    func reloadData() {
        if listType == .products {
            collectionView.isHidden = false
            tableView.isHidden = true
            
        }
        else {
            collectionView.isHidden = true
            tableView.isHidden = false

        }
    }
    
    
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func actionBack(sender: AnyObject) {
        FilterCategory.shared.arraySubCatIds.removeAll()
        FilterCategory.shared.arraySubCatNames.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name("SubCategoryCountChanged"), object: nil)
        popVC()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        let vc = StoryboardScene.Options.instantiateCartViewController()
        pushVC(vc)
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func suppliers_buttonAction(_ sender: Any) {
        webServiceSupplierListing()
        UIView.animate(withDuration: 0.35) {
            if L102Language.isRTL {
                self.bottomView_leadingConstraint.constant = self.products_button.frame.x
            }else {
                self.bottomView_leadingConstraint.constant = self.suppliers_button.frame.x
            }
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func products_buttonAction(_ sender: Any) {
        self.webServiceItemListing()
        UIView.animate(withDuration: 0.35) {
            if L102Language.isRTL {
                self.bottomView_leadingConstraint.constant = self.suppliers_button.frame.x
            }else {
                self.bottomView_leadingConstraint.constant = self.products_button.frame.x
            }
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavs(notification:)), name: Notification.Name("FavouritePressed"), object: nil)
        if (/AppSettings.shared.appThemeData?.is_supplier_wishlist == "1" && /AppSettings.shared.appThemeData?.is_product_wishlist == "1") {
            top_view.isHidden = false
            topViewHgt.constant = 50
            webServiceItemListing()
            
        }else {
            top_view.isHidden = true
            topViewHgt.constant = 0
            
            if /AppSettings.shared.appThemeData?.is_supplier_wishlist == "1" {
                webServiceSupplierListing()
            } else if /AppSettings.shared.appThemeData?.is_product_wishlist == "1" {
                webServiceItemListing()
            }
        }
        
    }
    
    
    
    @objc func updateFavs(notification: Notification) {
        if let product = notification.object as? ProductF {
            if let index = arrayProducts.firstIndex(where: {$0.id == product.id}) {
                arrayProducts.remove(at: index)
                collectionView.reloadData()
            }
        }else if let supplier = notification.object as? Supplier {
            if let index = arraySuppliers.firstIndex(where: {$0.id == supplier.id}) {
                
                arraySuppliers.remove(at: index)
                
                viewPlaceholder?.isHidden = !arraySuppliers.isEmpty
                tableDataSource.reloadTable(items: arraySuppliers)
                
            }else {
                arraySuppliers.append(supplier)
                tableDataSource.reloadTable(items: arraySuppliers)

            }
        }
    }
    
    private func configCollection() {
        
        let height = CGFloat(240.0)
        let width = CGFloat(collectionView.frame.size.width/2-20)
        
        if collectionViewDataSource == nil {
            collectionView.registerCells(nibNames: [HomeProductCell.identifier, CellIdentifiers.SupplierCollectionCell])
            collectionViewDataSource = SKCollectionViewDataSource(
                items: arrayProducts,
                collectionView: collectionView,
                cellIdentifier: HomeProductCell.identifier,
                cellHeight: height,
                cellWidth: width)
        }
        
        collectionViewDataSource.configureCellBlock = {
            (index, cell, item) in
            
            if let cell = cell as? HomeProductCell {
                cell.productListing = item as? ProductF
            }
            
        }
        
        collectionViewDataSource.aRowSelectedListener = {
            (index, cell) in
            
            if let cell = cell as? HomeProductCell {
                self.openProductDetails(objProduct: cell.productListing)
            }
        }
        
        collectionViewDataSource.reload(items: arrayProducts)
    }
    
    
    func configureTableView(){
        
        if tableDataSource == nil {
            let identifierRest = HomeFoodRestaurantTableCell.identifier
            tableView.registerCells(nibNames: [identifierRest])
        }
        
        tableDataSource = SKTableViewDataSource(items: arraySuppliers, tableView: tableView, cellIdentifier: HomeFoodRestaurantTableCell.identifier)
        
        
        tableDataSource.configureCellBlock = {
            [weak self] (indexPath, cell, item) in
            guard let self = self else { return }
            
            if let cell = cell as? HomeFoodRestaurantTableCell, let item = item as? Supplier {
                cell.isSkeletonable = true
                cell.objModel = item
                cell.selectionStyle = .none
                
                cell.blockSelect = {
                    [weak self] supplier in
                    guard let self = self else { return }
                    self.openSupplier(supplier: supplier)
                }
            }
        }
        
        
        tableDataSource.reloadTable(items: arraySuppliers)
    }
    
    func openProductDetails(objProduct: ProductF?) {
        
        guard let objProduct = objProduct else { return }
        let productDetailVc = StoryboardScene.Main.instantiateProductVariantVC()
        productDetailVc.passedData.productId = objProduct.id
        productDetailVc.is_question = objProduct.is_question
        productDetailVc.suplierBranchId = objProduct.supplierBranchId
        self.pushVC(productDetailVc)
        
        productDetailVc.blockUpdataData = {
            [weak self] in
            guard let self = self else { return }
            self.webServiceItemListing(isLoader: false)
        }
    }
    
    func openSupplier(supplier: Supplier?) {
        
        guard let supplier = supplier else { return }
        
        let arrayCat = supplier.categories ?? []
        
        
        if SKAppType.type.isFood {
            let category = arrayCat.first
            if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                let VC = RestaurantMenuVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                VC.passedData.subCats = supplier.categories
                VC.passedData.supplier = supplier
                
                self.pushVC(VC)
            }else {
                let VC = RestaurantDetailVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                VC.passedData.subCats = supplier.categories
                VC.passedData.supplier = supplier
                
                self.pushVC(VC)
            }
            
            
            return
        }
        
        if arrayCat.count < 2 {
            let category = arrayCat.first
            
            if SKAppType.type.isFood {
                if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                    let VC = RestaurantMenuVC.getVC(.splash)
                    let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                    VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                    VC.passedData.subCats = supplier.categories
                    
                    self.pushVC(VC)
                }else {
                    let VC = RestaurantDetailVC.getVC(.splash)
                    let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                    VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                    VC.passedData.subCats = supplier.categories
                    
                    self.pushVC(VC)
                }
                
            } else {
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                let objP = PassedData(withCatergoryId: category?.category_id,
                                      categoryFlow: flow,
                                      supplierId: supplier.id,
                                      subCategoryId: nil,
                                      productId: nil,
                                      branchId: supplier.supplierBranchId,
                                      subCategoryName: nil,
                                      categoryOrder: category?.order,
                                      categoryName: category?.category_name)
                objP.subCats = supplier.categories
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                VC.passedData = objP
                self.pushVC(VC)
            }
            return
        }
        
        let catSelectionVc = StoryboardScene.Options.instantiateCategorySelectionController()
        catSelectionVc.supplier = supplier
        catSelectionVc.ISPushAnimation = true
        catSelectionVc.arrCategory = supplier.categories
        self.pushVC(catSelectionVc)
    }
    
    func webServiceItemListing(isLoader: Bool = true) {
        
        let api = API.listAllFav
        APIManager.sharedInstance.opertationWithRequest(isLoader: isLoader, withApi: api) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let listing):
                self.listType = .products
                
                self.arrayProducts = (listing as? [ProductF]) ?? []
                self.reloadData()
            default :
                break
            }
        }
    }
    
    func webServiceSupplierListing (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.MyFavorites(FormatAPIParameters.MyFavorites.formatParameters())) { [weak self] (response) in
            guard let self = self else { return }
            switch response{
                
            case .Success(let listing):
                self.listType = .suppliers
                
                self.arraySuppliers = (listing as? SupplierListing)?.suppliers ?? []
                self.reloadData()
                break
            default :
                break
            }
        }
    }
    
    
    
}
