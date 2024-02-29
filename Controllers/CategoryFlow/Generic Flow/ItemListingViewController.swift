//
//  ItemListingViewController.swift
//  Clikat
//
//  Created by cblmacmini on 4/24/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

enum Category : String {
    case Laundry = "2"
    case BeautySalon = "10"
    case Grocery = "0"
    case Electronics = "1"
}

class ItemListingViewController: CategoryFlowBaseViewController {
    
    @IBOutlet var lblViewProductAs: ThemeLabel! {
        didSet {
            if SKAppType.type == .food {
                lblViewProductAs.text = "View food items as".localized()
            }
            else if SKAppType.type == .home {
                lblViewProductAs.text = "View services as".localized()
            }
            else {
                lblViewProductAs.text = "View products as".localized()
            }
        }
    }
    @IBOutlet weak var labelPlaceholder: ThemeLabel! {
        didSet {
            labelPlaceholder.textColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewFilters: UIView!
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton! {
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    //@IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerSearchHeight: NSLayoutConstraint!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var btnBarCode : UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lblNavTitle: UILabel!
    @IBOutlet weak var constraintTableviewBottom: NSLayoutConstraint!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var viewSearch: SKSearchView! {
        didSet {
            viewSearch.tfSearch?.delegate = self
            viewSearch.blockSearching = {
                [weak self] txt in
                guard let self = self else { return }
                self.txtSearch = txt
            }
        }
    }
    
    //MARK:- Variables
    var barViewDataSource = BarButtonDataSource()
    var tableDataSource: SKTableViewDataSource!
    var collectionViewDataSource: SKCollectionViewDataSource!
    var brandName: String?
    var isCatBrand = false
    var isOffers = false
    var isList = true {
        didSet {
            
            tableView.isHidden = !isList
            collectionView.isHidden = isList
            
            btnList.tintColor = isList ? ButtonThemeColor.shared.btnBorderThemeColor : UIColor.lightGray
            btnGrid.tintColor = !isList ? ButtonThemeColor.shared.btnBorderThemeColor : UIColor.lightGray
            
            let txt = txtSearch
            txtSearch = txt
            
        }
    }

    var allProducts: [ProductF] = [] {
        didSet {
            arrayProducts = allProducts
        }
    }
    
    var txtSearch: String = "" {
        didSet {
            if txtSearch.isEmpty {
                arrayProducts = allProducts
            } else {
                arrayProducts = allProducts.filter({ /$0.name?.contains(txtSearch, compareOption: .caseInsensitive) })
            }
        }
    }
    
    var arrayProducts: [ProductF] = [] {
        didSet {
            if allProductsFetched {
                viewPlaceholder?.isHidden = !arrayProducts.isEmpty
            }
            viewHeader.isHidden = arrayProducts.isEmpty
            nbHitsLabel.isHidden = arrayProducts.isEmpty
            //vwHeader.isHidden = arrayProducts.isEmpty

            let txt = "\(arrayProducts.count) " + (arrayProducts.count > 1 ? L11n.results.string : L11n.result.string)
            nbHitsLabel.text = txt
            
            collectionViewDataSource.reload(items: arrayProducts)
            tableDataSource.reloadTable(items: arrayProducts)
        }
    }
    
    var changeCurrentIndexProgressive: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    var changeCurrentIndex: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ animated: Bool) -> Void)?
    var hideDetailedSubCategoriesBar : Bool = false
    var allProductsFetched = false
    var initialFilters: FilterCategory = FilterCategory()

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        FilterCategory.shared.reset()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavs(notification:)), name: NSNotification.Name("FavouritePressed"), object: nil)
        print("Class : " + String(describing: type(of: self)))

        viewPlaceholder.isHidden = true
        FilterCategory.supplierId = passedData.supplierId
        
        if /passedData.supplierBranchId?.toInt() > 0 {
            FilterCategory.shared.arrayBrandId = [/passedData.supplierBranchId?.toInt()]
        }
        FilterCategory.shared.txtSearch = ""
        
        if let id = passedData.subCategoryId, SKAppType.type == .home {
            FilterCategory.shared.arraySubCatIds.append(id)
        }
        
//        FilterCategory.shared.arrayCatIds = [/passedData.subCategoryId]
//        FilterCategory.shared.arrayCatNames = [/passedData.categoryName]
        
        configureTableView()
        configureCollectionView()
        initialFilters = FilterCategory.shared
        webServiceItemListing()
        
        if isOffers {
            isList = true
            if SKAppType.type == .eCom {
                lblNavTitle?.text = L10n.SpecialOffers.string
            }
            else {
                lblNavTitle?.text = L10n.Offers.string
            }
            btnSearch?.isHidden = true
            //headerHeight.constant = 0
            viewHeader.isHidden = true
            viewFilters.isHidden = true
            headerSearchHeight.constant = 0
            viewSearch.clipsToBounds = true
            vwHeader.isHidden = true
            collectionView.isHidden = true
            tableView.isHidden = false
            self.view.layoutIfNeeded()
            
        } else {
            isList = false
            let txt = /FilterCategory.shared.arraySubCatNames.first
            lblNavTitle.text = txt.isEmpty ? (SKAppType.type.isFood ? "Food Items" : /brandName) : txt
            if SKAppType.type == .eCom {
                viewFilters.isHidden = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleCells()
        
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    @objc func updateFavs(notification: Notification) {
        if let product = notification.object as? Cart {
            for item in arrayProducts {
                if item.id == product.id {
                    item.isFav = product.isFav
                }
            }
            self.collectionViewDataSource.reload(items: self.arrayProducts)
        }
//        getAllProducts(name: txtSearch)
    }
}

//MARK: - WebService Methods
extension ItemListingViewController{
    
    @objc func webServiceItemListing() {
        
        let params : [String : Any]?
        if isOffers {
            params = FormatAPIParameters.ViewAllOffers.formatParameters()
            lblNavTitle?.text = L10n.Offers.string
        } else {
            
            let objF = FilterCategory.shared
//            let objBids =

            params = (FormatAPIParameters.ProductFilteration(
                subCategoryId: isCatBrand ? [] : objF.apiSubIds,
                low_to_high: objF.lowToHigh.toInt.toString,
                is_availability:objF.availablity.toString,
                max_price_range: objF.maxPrice.toString,
                min_price_range: objF.minPrice.toString,
                is_discount: objF.discount.toString,
                is_popularity: objF.popularity.toInt.toString,
                product_name: objF.txtSearch,
                variant_ids: objF.variantIdArray,
                supplier_ids: FilterCategory.supplierIds,
                brand_ids: objF.arrayBrandId).formatParameters())
        }
        
        let api = isOffers ? API.ViewAllOffers(params) : API.ProductFilteration(params)
        APIManager.sharedInstance.opertationWithRequest(withApi: api) {
            [weak self] (response) in
            guard let self = self else { return }
            self.allProductsFetched = true
            switch response {
            case .Success(let listing):
                if let listing = listing as? ProductListing {
                    self.allProducts = listing.arrDetailedSubCategories?.first?.arrProducts ?? []
                } else if let listing = listing as? filteredProducts {
                    self.allProducts = listing.products ?? []
                } else {
                    self.allProducts = (listing as? OfferListing)?.arrOffers ?? []
                }
            default :
                break
            }
        }
    }
}


//MARK: - Configure CollectionView
extension ItemListingViewController {
    
    func configureCollectionView(){
        
        let width = CGFloat(UIScreen.main.bounds.width/2-20)
        let height = width * 1.33//CGFloat(240.0)

        if collectionViewDataSource == nil {
            collectionView?.registerCells(nibNames: [HomeProductCell.identifier])
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
                if !SKAppType.type.isFood {
                    self.openProduct(objProduct: cell.productListing)
                }
            }
        }
        
        collectionViewDataSource.reload(items: arrayProducts)
    }
}

//MARK: - Configure TableView
extension ItemListingViewController {
    
    func configureTableView() {

        if tableDataSource == nil {
            let identifier = ProductListingCell.identifier
            tableView.registerCells(nibNames: [identifier])

            tableDataSource = SKTableViewDataSource(items: arrayProducts, tableView: tableView, cellIdentifier: identifier)
        }
        
        tableDataSource.configureCellBlock = {
            [weak self] (indexPath, cell, item) in
            guard let self = self else { return }
            if let cell = cell as? ProductListingCell, let item = item as? ProductF {
                cell.backgroundColor = .clear
                cell.product = item
                cell.selectionStyle = .none
                cell.isForCart = false
                cell.category = self.passedData.categoryOrder
                cell.categoryId = self.passedData.categoryId
                
                cell.productClicked = {
                    [weak self] product in
                    guard let self = self else { return }
                    if SKAppType.type != .food {
                        self.openProduct(objProduct: product)
                    }
                }
            }
        }
        
        tableDataSource.aRowSelectedListener = {
            [weak self] (indexPath, cell) in
            guard let self = self else { return }
            
            if let cell = cell as? ProductListingCell {
               // self.openProduct(objProduct: cell.product)
            }
        }
        tableDataSource.reloadTable(items: arrayProducts)
    }
}

//MARK: - Reload Visible Cells
extension ItemListingViewController {
    
    @objc func reloadVisibleCells(){
        
        DBManager.sharedManager.getCart {
            [weak self] (array) in
            guard let self = self else { return }
            
            for product in self.arrayProducts.enumerated() {
                
                for savedProduct in array.enumerated() {
                    if (savedProduct.element as? Cart)?.id == product.element.id {
                        product.element.quantity = (savedProduct.element as? Cart)?.quantity
                        product.element.dateModified = (savedProduct.element as? Cart)?.dateModified
                    }
                }
            }
            let txt = self.txtSearch
            self.txtSearch = txt
        }
        
//        DBManager.sharedManager.getCart {
//            [weak self] (cartProducts) in
//            guard let self = self else { return }
//
//            for visibleCell in self.tableView.visibleCells {
//                guard let cell = visibleCell as? ProductListingCell else { continue }
//                cell.stepper?.value = 0
//                for cartProduct in cartProducts {
//                    guard let product = cartProduct as? Cart,
//                        let quantity = product.quantity, cell.product?.id == product.id
//                        else { continue }
//
//                    cell.stepper?.value = Double(quantity) ?? 0
//                }
//            }
//        }
    }
}

extension ItemListingViewController{
    
    @IBAction func actionCart(sender: AnyObject) {
        let vc = StoryboardScene.Options.instantiateCartViewController()
        pushVC(vc)
    }
    
    @IBAction func actionSearchLocal(sender: UIButton) {
        view.endEditing(true)
    }
    
    @IBAction func actionBack(sender: AnyObject) {

        FilterCategory.shared.arraySubCatIds.removeAll()
        FilterCategory.shared.arraySubCatNames.removeAll()
        FilterCategory.shared.arrayBrandId.removeAll()
        if SKAppType.type == .home {
            // to select questions again
            GDataSingleton.sharedInstance.currentSupplier = nil
        }
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionSearch(sender: AnyObject) {
        let searchVc = StoryboardScene.Main.instantiateSearchViewController()
        searchVc.passedData = passedData
        pushVC(searchVc)
    }
    
    @IBAction func actionBacrCode(sender: AnyObject) {
        let barCodeVc = StoryboardScene.Options.instantiateBarCodeScannerViewController()
        barCodeVc.passedData = passedData
        pushVC(barCodeVc)
    }
    
    @IBAction func filterBtnClick(sender: UIButton) {
        
        let filterVC = FilterVC.getVC(.main)
        filterVC.isHomePageFlow = true
        filterVC.delegate  = self
        presentVC(filterVC)
    }
    
    @IBAction func listBtnClick(sender: UIButton) {
        isList = true
    }
    
    @IBAction func gridBtnClick(sender: UIButton) {
        isList = false
    }
}

//MARK: - Search field 
extension ItemListingViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraintTableviewBottom.constant = 260
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintTableviewBottom.constant = 0
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

extension ItemListingViewController:FilterVCDelegate{
    func resetData(isReset: Bool) {
        FilterCategory.shared = initialFilters
        webServiceItemListing()
    }

    func FilterVariantData(_ sectionData: [SectionData]?,  filterdProductListing: filteredProducts?, filteredResults:Bool,maxValue:Int,minValue:Int)
    {
        allProducts = filterdProductListing?.products ?? []
    }
}
