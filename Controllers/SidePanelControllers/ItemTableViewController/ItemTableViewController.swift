//
//  ViewController.swift
//  ecommerce
//
//  Created by Guy Daher on 02/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import DropDown

class ItemTableViewController: UIViewController {
    @IBOutlet var constWidthSearchType: NSLayoutConstraint! {
        didSet {
            //0 product search
            //1 supplier search
            //2 for both
            constWidthSearchType.constant = AppSettings.shared.appThemeData?.search_by == "2" ? 100 : 0
        }
    }
    @IBOutlet weak var btnBack: ThemeButton! {
        didSet {
            btnBack.imageView?.mirrorTransform()
        }
    }
    
    @IBOutlet var constHeightViewAs: NSLayoutConstraint! //37
    @IBOutlet var constHeightFilters: NSLayoutConstraint! //45
    @IBOutlet var tagListView: TagListView! {
        didSet {
            tagListView.delegate = self
        }
    }
    //MARK:- IBOutlet
    @IBOutlet weak var labelPlaceholder: ThemeLabel! {
        didSet{
            labelPlaceholder.textColor = SKAppType.type.color
            if SKAppType.type.isFood {
                let term = TerminologyKeys.product.englishText() ?? TerminologyKeys.product.defaultEnglishText()
                labelPlaceholder.text = String(format: "No %@ found.", "\(term)").localized()
                
            }
            else {
                labelPlaceholder.text = "No data found.".localized()
            }
        }
    }
    @IBOutlet weak var navigation_view: NavigationView! {
        didSet {
            if /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom {
                navigation_view.btnMenu?.isHidden = true
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBarNavigationItem: UINavigationItem!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var nbHitsLabel: UILabel!
    @IBOutlet weak var btnArea : UIButton!
    @IBOutlet weak var viewPlaceholder: UIView!
    @IBOutlet weak var viewSearchType: UIView!
    @IBOutlet weak var btnSearchType: UIButton! {
        didSet {
            self.btnSearchType.setTitle(TerminologyKeys.product.localizedValue() as! String, for: .normal)
        }
    }
    @IBOutlet var btnFilters: ThemeButton!
    @IBOutlet var btnSearchTag: ThemeButton!
    @IBOutlet var constHeightTagListView: NSLayoutConstraint!
    
//    AppSettings.shared.appThemeData?.header_text_color
    @IBOutlet weak var viewProductAs: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnGrid: UIButton!
    @IBOutlet weak var lblTitle: ThemeLabel! {
        didSet {
            if SKAppType.type == .food {
                lblTitle.text = "View food items as".localized()
            }
                
            else if SKAppType.type == .home {
                lblTitle.text = "View services as".localized()
            }
            else {
                lblTitle.text = "View products as".localized()
            }
        }
    }
    
    @IBOutlet var searchTextField: UITextField!{
        didSet{
            searchTextField.setAlignment()
            if SKAppType.type == .food {

                 let term = TerminologyKeys.products.englishText() ?? TerminologyKeys.products.defaultEnglishText()
                searchTextField.placeholder = String(format: "Search %@", "\(term)").localized()

            }
            else {
                searchTextField.placeholder = "What are you looking for?".localized();
            }
        }
    }

    //MARK:- Variables
    var arrayAutocomplete = [String]()
    var dropDownSearchType = DropDown()
    var dropDownTag:DropDown?
    let dropDownTop = VPAutoComplete()
    
    var isList = true {
        didSet {
            tableView.isHidden = !isList
            collectionView.isHidden = isList
            btnList.tintColor = isList ? ButtonThemeColor.shared.btnBorderThemeColor : UIColor.lightGray
            btnGrid.tintColor = !isList ? ButtonThemeColor.shared.btnBorderThemeColor : UIColor.lightGray
        }
    }
    var restaurantSearch = false
    var tagSearch = false
    var txtSearch: String = "" {
        didSet {
            searchTextField.text = txtSearch
            FilterCategory.shared.txtSearch = txtSearch
            if restaurantSearch {
                self.getRestorents(search: txtSearch)
            }else{
                getAllProducts(name: txtSearch)
            }
        }
    }
    var collectionViewDataSource: SKCollectionViewDataSource!
    var tableDataSource: SKTableViewDataSource!
    var arrayProducts: [ProductF] = [] {
        didSet {
            collectionView.isHidden = false
            viewPlaceholder?.isHidden = !arrayProducts.isEmpty
            viewProductAs.isHidden = arrayProducts.isEmpty
            //topBarView.isHidden = arrayProducts.isEmpty
            let txt = "\(arrayProducts.count) " + (arrayProducts.count > 1 ? L11n.results.string : L11n.result.string)
            nbHitsLabel.text = txt
            nbHitsLabel.isHidden = (searchTextField.text ?? "").isEmpty
            isList = false
            DispatchQueue.main.async {
                self.collectionViewDataSource.reload(items: self.arrayProducts)
                self.configureTableView()
                self.tableDataSource.reloadTable(items: self.arrayProducts)
            }
        }
    }
    
    var arraySuppliers: [Supplier] = [] {
        didSet {
            isList = true
            viewPlaceholder?.isHidden = !arraySuppliers.isEmpty
            viewProductAs.isHidden = true//arrayProducts.isEmpty
            tableView.isHidden = arraySuppliers.isEmpty
            //topBarView.isHidden = arrayProducts.isEmpty
            let txt = "\(arraySuppliers.count) " + (arraySuppliers.count > 1 ? L11n.results.string : L11n.result.string)
            nbHitsLabel.text = txt
            if tagSearch {
                nbHitsLabel.isHidden = tagListView.tagViews.isEmpty
            }
            else {
                nbHitsLabel.isHidden = (searchTextField.text ?? "").isEmpty
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavs(notification:)), name: NSNotification.Name("FavouritePressed"), object: nil)

        print("Class : " + String(describing: type(of: self)))
       
        FilterCategory.shared.reset()
        FilterCategory.supplierId = nil
        FilterCategory.shared.txtSearch = ""
        
        FilterCategory.shared.arrayCatIds = []
        FilterCategory.shared.arrayCatNames = []
        
        configureCollectionView()
        
        self.addDropDown()
        
        isList = false
        
        topBarView.isHidden = false
        if SKAppType.type == .eCom {
            btnFilters.isHidden = false
            //constHeightFilters.constant = 45
        }
        else {
            btnFilters.isHidden = true
        }
//        else {
//            constHeightFilters.constant = 0
//        }
        if AppSettings.shared.appThemeData?.search_by == "1" {
            self.restaurantSearch = true
            self.searchTextField.placeholder = "Search Restaurant".localized()
            constHeightViewAs.constant = 0
        }
        if tagSearch {
            restaurantSearch = true
            searchTextField.placeholder = "Search".localized();
            constHeightViewAs.constant = 0
            constWidthSearchType.constant = 100
            btnSearchType.isHidden = true
            btnSearchTag.isHidden = false
            constHeightTagListView.isActive = false
        }
        else {
            constWidthSearchType.constant = SKAppType.type == .food ? 100 : 0
            constHeightTagListView.constant = 0
            btnSearchType.isHidden = false
            btnSearchTag.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                let strArea = name + " " + locality
                self.btnArea.setTitle(strArea, for: .normal)
            }
        } else if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            self.btnArea.setTitle(address, for: .normal)

        }
        
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

extension ItemTableViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if tagSearch { return }
        arrayAutocomplete =  GDataSingleton.sharedInstance.autoSearchedArray ?? [String]()
        if !SKAppType.type.isJNJ {
            dropDownTop.dataSource = SKAppType.type.isJNJ ? [] : arrayAutocomplete
            dropDownTop.tableView?.reloadData()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if tagSearch { return }
        txtSearch = /textField.text
        if !txtSearch.isEmpty && !arrayAutocomplete.contains(txtSearch) {
            
            if arrayAutocomplete.count == 3 {
                
                arrayAutocomplete.removeFirst()
                arrayAutocomplete.insertFirst(txtSearch)
                
            } else {
                arrayAutocomplete.append(txtSearch)
            }
        }
        GDataSingleton.sharedInstance.autoSearchedArray = arrayAutocomplete
       // getAllProducts(name: txtSearch)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if tagSearch {
            if let text = textField.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                searchTag(search: updatedText)
            }
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()

//        txtSearch = /textField.text
//        if !txtSearch.isEmpty && !arrayAutocomplete.contains(txtSearch) {
//
//            if arrayAutocomplete.count == 3 {
//
//                arrayAutocomplete.removeFirst()
//                arrayAutocomplete.insertFirst(txtSearch)
//
//            } else {
//                arrayAutocomplete.append(txtSearch)
//            }
//        }
//        GDataSingleton.sharedInstance.autoSearchedArray = arrayAutocomplete
//        getAllProducts(name: txtSearch)
        return true
    }
    
}

extension ItemTableViewController {
    
    @IBAction func actionSearchType(sender:UIButton) {
                    dropDownSearchType.anchorView = viewSearchType
        dropDownSearchType.dataSource = [TerminologyKeys.product.localizedValue() as! String,"Restaurant".localized()]
                    dropDownSearchType.width = 100

        dropDownSearchType.show()
        
        dropDownSearchType.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.btnSearchType.setTitle(item, for: .normal)
            print(self.btnSearchType.currentTitle)
            self.restaurantSearch = index == 1
            
            if self.restaurantSearch {
                self.getRestorents(search: self.txtSearch)
                self.searchTextField.placeholder = "Search Restaurant".localized()
                self.constHeightViewAs.constant = 0
            }else{
                let term = TerminologyKeys.products.englishText() ?? TerminologyKeys.products.defaultEnglishText()
                self.searchTextField.placeholder = String(format: "Search %@", "\(term)").localized()
                self.getAllProducts(name: self.txtSearch)
                self.constHeightViewAs.constant = 37
            }
            self.view.layoutIfNeeded()
        }
     }
    
    @IBAction func filterBtnClick(sender:UIButton) {
        
        let filterVC = FilterVC.getVC(.main)
        filterVC.searchProduct = txtSearch
        filterVC.delegate  = self
        presentVC(filterVC)
        
//        let filterVC = FilterVC.getVC(.main)
//        filterVC.delegate  = self
//
////        if let sectionData = self.sectionData {
////
////            filterVC.sectionData = sectionData
////            filterVC.objFilter.maxPrice = self.maxValue
////            filterVC.objFilter.minPrice = self.minValue
////        }
//        pushVC(filterVC)
    }
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func actionArea(sender : UIButton) {
        
        let vc = ChooseLocationVC.getVC(.register)
        vc.delegate = self
        presentVC(vc)
        
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func listBtnClick(sender: UIButton) {
        isList = true
        configureTableView()
        tableDataSource.reloadTable(items: arrayProducts)

    }
    
    @IBAction func searchSelectedTags(_ sender: Any) {
        let tags: [String] = tagListView.tagViews.map({ $0.title(for: .normal) ?? "" })
        if tags.isEmpty {
            return
        }
        searchRestaurants(tags: tags)
        print(tags)
    }
    
    @IBAction func gridBtnClick(sender: UIButton) {
        isList = false
    }
    
    @IBAction func backBtnClick(sender: UIButton) {
        self.popVC()
    }
}

//MARK: -//MARK: - Splash Delegate
extension ItemTableViewController : SplashViewControllerDelegate {
    func locationSelected() {
        btnArea.setTitle(LocationSingleton.sharedInstance.location?.getArea()?.name ?? "", for: .normal)
    }
}

extension ItemTableViewController{
    

    
    func getAllProducts(name : String?){

        if name == "" {
            tableDataSource?.items = []
            return
        }

        let objF = FilterCategory.shared

        let params = (FormatAPIParameters.ProductFilteration(
            subCategoryId: objF.apiSubIds,
            low_to_high: objF.lowToHigh.toInt.toString,
            is_availability:objF.availablity.toString,
            max_price_range: objF.maxPrice.toString,
            min_price_range: objF.minPrice.toString,
            is_discount: objF.discount.toString,
            is_popularity: objF.popularity.toInt.toString,
            product_name: objF.txtSearch,
            variant_ids: objF.variantIdArray,
            supplier_ids: FilterCategory.supplierIds,
            brand_ids: []).formatParameters())

        let objR = API.ProductFilteration(params)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            
            switch response {
            case .Success(let object):
                self?.arrayProducts = (object as? filteredProducts)?.products ?? []
                
            default:
                break
            }
        }
    }
    
    func configureTableView(){
        
        if tableDataSource == nil {
            let identifier = ProductListingCell.identifier
            let identifierRest = HomeFoodRestaurantTableCell.identifier
            tableView.registerCells(nibNames: [identifier, identifierRest])
        }
        if restaurantSearch {
            tableDataSource = SKTableViewDataSource(items: arraySuppliers, tableView: tableView, cellIdentifier: HomeFoodRestaurantTableCell.identifier)
        }
        else {
            tableDataSource = SKTableViewDataSource(items: arrayProducts, tableView: tableView, cellIdentifier: ProductListingCell.identifier)
        }
        
        tableDataSource.configureCellBlock = {
            [weak self] (indexPath, cell, item) in
            guard let self = self else { return }
            if let cell = cell as? ProductListingCell, let item = item as? ProductF {
                cell.product = item
                cell.selectionStyle = .none
                cell.isForCart = false
//                cell.category = self.passedData.categoryOrder
                cell.categoryId = item.categoryId
                
                cell.productClicked = {
                    [weak self] product in
                    if !SKAppType.type.isFood {
                         guard let self = self else { return }
                         self.openProduct(objProduct: product)
                    }

                }
                
                cell.addonsCompletionBlock = { [weak self] value in
                    guard let self = self else {return}
                    GDataSingleton.sharedInstance.fromCart = false

                    if let data = value as? (ProductF,Bool,Double){
                        if data.1 { // data.1 == true for open customization controller
                            self.openCustomizationView(cell: cell, product: data.0, cartData: nil, quantity: data.2, index: indexPath.row)
                        }
                    } else if let data = value as? (ProductF,Cart,Bool,Double) {
                        //for open checkcustomization controller
                       self.openCheckCustomizationController(cell: cell, productData: data.0,cartData: data.1, shouldShow: data.2, index: indexPath.row)
                    }
                }
                
            }
            else if let cell = cell as? HomeFoodRestaurantTableCell, let item = item as? Supplier {
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
        
//        tableDataSource.aRowSelectedListener = {
//            [weak self] (indexPath, cell) in
//            guard let self = self else { return }
//
//            if let cell = cell as? ProductListingCell {
//                //self.openProduct(objProduct: cell.product)
//            }
//        }
        if restaurantSearch {
                   tableDataSource.reloadTable(items: arraySuppliers)
               }
               else {
                   tableDataSource.reloadTable(items: arrayProducts)
               }
    }
    
//    func configureTableViewRestaurant(){
//        if tableDataSource == nil {
//
//                   let identifier = HomeFoodRestaurantTableCell.identifier
//                   tableView.registerCells(nibNames: [identifier])
//                   tableDataSource = SKTableViewDataSource(items: arraySuppliers, tableView: tableView, cellIdentifier: identifier)
//               }
//
//
//                tableDataSource.configureCellBlock = {
//                    [weak self] (indexPath, cell, item) in
//                    guard let self = self else { return }
//                    if let cell = cell as? HomeFoodRestaurantTableCell, let item = item as? Supplier {
//                        cell.isSkeletonable = true
//                        cell.objModel = item
//                        cell.selectionStyle = .none
//
//                        cell.blockSelect = {
//                            [weak self] supplier in
//                            guard let self = self else { return }
//                            self.openSupplier(supplier: supplier)
//                        }
//                    }
//                }
//        tableDataSource.reloadTable(items: arraySuppliers)
//
//    }
    
    func openProduct(objProduct: ProductF?) {
        
        guard let objProduct = objProduct else { return }
        let productDetailVc = StoryboardScene.Main.instantiateProductVariantVC()
        productDetailVc.passedData.productId = objProduct.id
        productDetailVc.is_question = objProduct.is_question
        productDetailVc.suplierBranchId = objProduct.supplierBranchId
        self.pushVC(productDetailVc)
    }
}

extension ItemTableViewController:FilterVCDelegate{

    func FilterVariantData(_ sectionData: [SectionData]?,  filterdProductListing: filteredProducts?, filteredResults:Bool,maxValue:Int,minValue:Int) {
        arrayProducts = filterdProductListing?.products ?? []
    }
    
    func resetData(isReset: Bool) {
        if isReset {
            FilterCategory.shared.reset()
            getAllProducts(name: txtSearch)
        }
    }
//    func FilterVariantData(_ sectionData: [SectionData]?,  filterdProductListing: filteredProducts?, filteredResults:Bool,maxValue:Int,minValue:Int) {
//
//        self.maxValue = maxValue
//        self.minValue = minValue
//        self.filteredResults = filteredResults
//        self.sectionData = sectionData
//        self.filterdProductListing = filterdProductListing
//
//    }
}

//MARK: - Configure CollectionView
extension ItemTableViewController{
    
    func configureCollectionView(){
        super.viewDidLayoutSubviews()
        
        if SKAppType.type == .food {
            let height = CGFloat(240.0)
            let width = CGFloat(UIScreen.main.bounds.width/2-20)
            
            if collectionViewDataSource == nil {
                let identifier = TempCollectionViewCell.identifier
                collectionView.registerCells(nibNames: [identifier])
                
                collectionViewDataSource = SKCollectionViewDataSource(
                    items: arrayProducts,
                    collectionView: collectionView,
                    cellIdentifier: TempCollectionViewCell.identifier,//TempCollectionViewCell.identifier,HomeProductCell.identifier,
                    cellHeight: height,
                    cellWidth: width)
            }
            
            collectionViewDataSource.configureCellBlock = {
                (index, cell, item) in
                
                if let cell = cell as? TempCollectionViewCell {
                    let product = item as? ProductF
                    cell.productListing = product
                    
                    cell.addonsCompletionBlock = { [weak self] value in
                        guard let self = self else {return}
                        GDataSingleton.sharedInstance.fromCart = false
                        if let data = value as? (ProductF,Bool,Double){
                            if data.1 { // data.1 == true for open customization controller
                                self.openCustomizationView(cell: cell, product: data.0, cartData: nil, quantity: data.2, index: index.row)
                            }
                        } else if let data = value as? (ProductF,Cart,Bool,Double) {
                            //for open checkcustomization controller
                            self.openCheckCustomizationController(cell: cell, productData: data.0,cartData: data.1, shouldShow: data.2, index: index.row)
                        }
                    }
                    
                }
                
            }
            
            collectionViewDataSource.aRowSelectedListener = {
                (index, cell) in
                
                if let cell = cell as? HomeProductCell {
                    if SKAppType.type == .food {return}
                    self.openProduct(objProduct: cell.productListing)
                }
            }
            
            collectionViewDataSource.reload(items: arrayProducts)
        }
        else {
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
}

extension ItemTableViewController {
    
    func addDropDown(){
        if tagSearch { return }
        if !SKAppType.type.isJNJ {
            
            dropDownTop.dataSource = SKAppType.type.isJNJ ? [] : arrayAutocomplete
            dropDownTop.isHidden = true
            dropDownTop.onTextField = searchTextField
            dropDownTop.onView = self.view
            dropDownTop.show {
                [weak self] (str, index) in
                guard let self = self else { return }
                
                self.txtSearch = str
                self.searchTextField.resignFirstResponder()
                
            }
        }
        
    }
}

extension ItemTableViewController : UIViewControllerTransitioningDelegate {
    
    func openCustomizationView(cell:Any,product: ProductF?,cartData: Cart?,quantity: Double?,shouldHide:Bool = false,index:Int?) {
        
        let vc = StoryboardScene.Options.instantiateCustomizationViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.product = product
        vc.hideAddCustom = shouldHide
        vc.index = index
        vc.cartData = cartData
        
        vc.completionBlock = { [weak self] data in
            guard let self = self else {return}
            if let obj = data as? (Bool,ProductF) {
                
                if let cell = cell as? ProductListingCell {
                    if let _ = quantity { // called when add to card button is added
                       cell.product = obj.1
                    }
                } else if let cell = cell as? TempCollectionViewCell {
                    if let _ = quantity { // called when add to card button is added
                        cell.productListing = obj.1
                    }
                }
               
            }
            self.removeViewAndSaveData()
        }
        
        self.present(vc, animated: true) {
            self.createTempView()
        }
        
    }
    
    func openCheckCustomizationController(cell:Any,productData: ProductF?,cartData: Cart?, shouldShow: Bool, index:Int?) {
        
        let vc = StoryboardScene.Options.instantiateCheckCustomizationViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.cartProdcuts = cartData
        vc.product = productData
        vc.completionBlock = {[weak self] data in
            guard let self = self else {return}
            if let cell = cell as? ProductListingCell {
                
                if let dataValue = data as? (Bool,ProductF) {
                    cell.product = dataValue.1
                    if !dataValue.0 {
                        self.removeViewAndSaveData()
                    }
                } else if let dataValue = data as? (ProductF,Cart,Bool){
                    let obj = ProductF(cart: dataValue.1)
                    dataValue.0.addOnValue?.removeAll()
                    let addonId = Int(obj.addOnId ?? "0")
                    self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: cell.stepper?.value ?? 0.0, index: addonId)
                } else if let _ = data as? Bool{
                    self.removeViewAndSaveData()
                } else if let obj = data as? ProductF {
                    cell.product = obj
                } else if let _ = data as? Int {
                    self.removeViewAndSaveData()
                } else if let value = data as? (Bool,Double) {
                    if value.1 == 0 {
                        self.removeViewAndSaveData()
                    }
                    cell.stepper?.stepperState = .ShouldDecrease
                }
                
            } else if let cell = cell as? TempCollectionViewCell {
                
                if let dataValue = data as? (Bool,ProductF) {
                    cell.productListing = dataValue.1
                    if !dataValue.0 {
                        self.removeViewAndSaveData()
                    }
                } else if let dataValue = data as? (ProductF,Cart,Bool){
                    let obj = ProductF(cart: dataValue.1)
                    dataValue.0.addOnValue?.removeAll()
                    let addonId = Int(obj.addOnId ?? "0")
                    self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: cell.stepper?.value ?? 0.0, index: addonId)
                } else if let _ = data as? Bool{
                    self.removeViewAndSaveData()
                } else if let obj = data as? ProductF {
                    cell.productListing = obj
                } else if let _ = data as? Int {
                    self.removeViewAndSaveData()
                } else if let value = data as? (Bool,Double) {
                    if value.1 == 0 {
                        self.removeViewAndSaveData()
                    }
                    cell.stepper?.stepperState = .ShouldDecrease
                }
                
            }
            
        }
        
        self.present(vc, animated: true) {
            self.createTempView()
        }
        
    }
    
    func removeViewAndSaveData() {
        self.view.subviews.forEach { (view) in
            if view.tag == 10001 {
                view.removeFromSuperview()
            }
        }
    }
    
    func createTempView(){
        let view = UIView()
        view.frame = self.view.frame
        view.backgroundColor = UIColor(white: 0.10, alpha: 0.8)
        view.tag = 10001
        self.view.addSubview(view)
    }
    
    //MARK:- UIViewControllerTransitioningDelegate
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
    
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
            
        }
}

extension ItemTableViewController{
func openSupplier(supplier: Supplier?) {
    
    guard let supplier = supplier else { return }
    
    let arrayCat = supplier.categories ?? []
    
    //Nitin
    if !SKAppType.type.isFood {
        if arrayCat.isEmpty {
            return
        }
    }
    
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
    
    

    func getRestorents( search: String?)  {
            
        if search == "" {
            tableDataSource?.items = []
            return
        }
        
            let objR = API.getRestorentList(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0, search: search)
            APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
                [weak self] (response) in
                guard let self = self else { return }
                switch response {
                case APIResponse.Success(let object):
                    self.arraySuppliers = (object as? [Supplier]) ?? []
                    self.configureTableView()
                    break
                default :
                    print("Hello Nitin")
                    break
                }
                
            }
        }
    
    func searchTag(search: String)  {
        let objR = API.searchTag(text: search, skip: 0)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            self.tableView.es.stopLoadingMore()

            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? TagList else { return }
                self.showTagsInDropdown(arr: objModel.products?.map({ /$0.name }) ?? ["No results"])
                break
            default :
                break
            }
        }
    }
    
    func searchRestaurants(tags: [String])  {
        self.view.endEditing(true)
        let objR = API.searchSupplierTags(productName: tags)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            self.tableView.es.stopLoadingMore()

            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? TagSuppliers else { return }
                self.arraySuppliers = (objModel.arrayItems) ?? []
                self.configureTableView()
                break
            default :
                break
            }
        }
        
        
    }
    
    func showTagsInDropdown(arr: [String]) {
        if dropDownTag == nil {
            dropDownTag = DropDown()
                      dropDownTag?.anchorView = searchTextField
            dropDownTag?.dataSource = arr
            dropDownTag?.width = searchTextField.frame.size.width
            dropDownTag?.direction = .bottom
            dropDownTag?.bottomOffset = CGPoint(x: 0, y: searchTextField.frame.size.height)
            dropDownTag?.shadowColor = UIColor.clear
            dropDownTag?.show()
            
            dropDownTag?.selectionAction = { [unowned self] (index: Int, item: String) in
              print("Selected item: \(item) at index: \(index)")
                self.tagListView.addTag(item)
                self.searchTextField.text = ""
            }
        }
        else {
            dropDownTag?.dataSource = arr
            dropDownTag?.show()
            dropDownTag?.layoutSubviews()
        }

    }
}

extension ItemTableViewController: TagListViewDelegate {
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagListView.removeTag(title)
    }
}
