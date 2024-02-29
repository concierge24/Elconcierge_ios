//
//  SubcategoryViewController.swift
//  Clikat
//
//  Created by Night Reaper on 27/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
//"Shop by Type"
//"Discount Products"
//"Popular Brands"

enum SubCategorySectionType: String {
    case categories = "Shop by Type"
    case disCountProducts = "Discount Products"
    case brands = "Popular Brands"
    
    var size:CGSize {
        let width = UIScreen.main.bounds.width
        switch self {
        case .categories:
            return CGSize(width: (width-48)/2, height: (width-20)/2.5)
        case .disCountProducts:
            return CGSize(width: (width-48)/2, height: 240.0)
        case .brands:
            return CGSize(width: width , height: 128.0)
        }
    }
}

class SubcategoryViewController: CategoryFlowBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var collectionVw: UICollectionView! {
        didSet {
            configureCollectionView()
        }
    }
    @IBOutlet weak var btnBarCode: UIButton!
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var tableView: UITableView! {
        didSet{
            tableView.register(UINib(nibName: CellIdentifiers.SubCategoryListingCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.SubCategoryListingCell)
            configureTableViewInitialization()
        }
    }
    
    //MARK:- Variables
    var collectionViewDataSource: SKCollectionViewDataSource?
    var viewForCollectionSection: ViewForHeaderInSection?
    var tableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    var items: [TableViewHeaderObjectType] = []
    var supplierId: String?
    var objCatData: SubCategoriesListing? {
        didSet{
            if let arr = objCatData?.arrayCategories, !arr.isEmpty {
                items.append(TableViewHeaderObjectType(header: L11n.shopByType.string, footer: "", rows: arr, type: SubCategorySectionType.categories, subHeader: ProductCategoryCell.identifier))
                return
            }
            items = [
                TableViewHeaderObjectType(header: L11n.shopByType.string, footer: "", rows: objCatData?.subCategories, type: SubCategorySectionType.categories, subHeader: ProductCategoryCell.identifier)
            ]

            if let arr = objCatData?.arrayOffers, !arr.isEmpty {
                items.append(TableViewHeaderObjectType(header: L11n.discountItems.string, footer: "", rows: arr, type: SubCategorySectionType.disCountProducts, subHeader: HomeProductCell.identifier))
            }
            if let arr = objCatData?.arrayBrands, !arr.isEmpty {
                items.append(TableViewHeaderObjectType(header: L11n.brands.string, footer: "", rows: [arr], type: SubCategorySectionType.brands, subHeader: HomeBrandsCollectionCollectionCell.identifier))
            }

            collectionViewDataSource?.reload(items: items)
        }
    }

    var subCategories : [SubCategory]? = []{
        didSet {
            
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
      //  if GDataSingleton.sharedInstance.selectedCatId == passedData.categoryId {
        //    webServiceSubCategoriesListing()
       // }
        //else {
            if items.count > 0 {
                collectionViewDataSource?.reload(items: items)
            }
            else {
                webServiceSubCategoriesListing()
            }
       // }
        
        var txt = /FilterCategory.shared.arrayCatNames.last
        if txt.isEmpty {
            txt = AppSettings.shared.isFoodApp ? L10n.selectCuisine.string : L10n.selectCategory.string
        }
        lblTitle.text = txt
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        collectionVw.reloadData()
    }
}


//MARK: - WebService Methods
extension SubcategoryViewController {
    
    func webServiceSubCategoriesListing (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.SubCategoryListing(supplierId: passedData.supplierId, categoryId: passedData.categoryId)) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
                
            case .Success(let listing):
                self.objCatData = (listing as? SubCategoriesListing)
                
            default :
                break
            }
        }
    }
}


//MARK: - TableView Configuration Methods
extension SubcategoryViewController {
    
    func configureTableViewInitialization(){
        
        tableView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
        tableView.estimatedRowHeight = 200.0
        tableViewDataSource = TableViewDataSource(items: subCategories, height: UITableView.automaticDimension , tableView: tableView, cellIdentifier: CellIdentifiers.SubCategoryListingCell , configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
            
            self.configureCell(withCell: cell, item: item)
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }
                
                self.itemClicked(objModel: self.subCategories?[indexPath.row])
        })
        
    }
    
    
    func configureCell(withCell cell : Any , item : Any? ){
        
        guard let tempCell = cell as? SubCategoryListingCell else{
            return
        }
        if let cat = item as? Categorie {
            tempCell.category = cat
        }
        else {
            tempCell.subCategory = item as? SubCategory
        }
    }
    
    func itemClicked(objModel : SubCategory?) {
        
        guard let subCatId = objModel?.subCategoryId,
            let subCatName = objModel?.name,
            let is_cub_category =  objModel?.is_cub_category else {
                ez.runThisInMainThread {
                    [weak self] in
                    guard let self = self else { return }
                    self.pushNextVc()
                }
                return
        }
        
        ez.runThisInMainThread {
            [weak self] in
            guard let self = self else { return }
            
            if is_cub_category == "1" {
                
                FilterCategory.shared.arrayCatIds.append(subCatId)
                FilterCategory.shared.arrayCatNames.append(subCatName)
                
                let subcategoryViewController = StoryboardScene.Main.instantiateSubcategoryViewController()
                subcategoryViewController.passedData.supplierId = self.passedData.supplierId
                subcategoryViewController.passedData.categoryId = subCatId
                subcategoryViewController.passedData.mainCategoryId = self.passedData.mainCategoryId
                subcategoryViewController.passedData.subCategoryName = subCatName
                subcategoryViewController.passedData.categoryFlow = self.passedData.categoryFlow
                subcategoryViewController.passedData.supplierBranchId = self.passedData.supplierBranchId
                self.passedData.isQuestion = false
                self.pushVC(subcategoryViewController)
                
            } else {
                
                FilterCategory.shared.arraySubCatIds.append(subCatId)
                FilterCategory.shared.arraySubCatNames.append(subCatName)
                NotificationCenter.default.post(name: NSNotification.Name("SubCategoryCountChanged"), object: nil)

                self.passedData.subCategoryId = subCatId
                self.passedData.subCategoryName = subCatName
                self.passedData.isQuestion = objModel?.is_question == 1
                self.pushNextVc()
            }
        }
        
    }
    
}


//MARK: - CollectionView Delegate Method

extension SubcategoryViewController {
    
    func configureCollectionView() {
        
        collectionVw.registerCells(nibNames: [
            ProductCategoryCell.identifier,
            ProductCollectionCell.identifier,
            HomeBrandCollectionCell.identifier,
            HomeBrandsCollectionCollectionCell.identifier
            ])
        
        let height = (UIScreen.main.bounds.size.width-20)/2.5
        let width = (UIScreen.main.bounds.size.width-40)/2
        
        print("height : \(height) , width : \(width)")
        collectionVw.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        if collectionViewDataSource == nil {
            
            collectionViewDataSource = SKCollectionViewDataSource(
                collectionView: collectionVw,
                headerIdentifier: ProductHeaderView.identifier,
                cellHeight: height,
                cellWidth: width)
        }
        
        collectionViewDataSource?.blockSizeConfigure = {
            [weak self] (index) in
            guard let self = self, let obj = self.items[index.section].type as? SubCategorySectionType else { return CGSize.zero }
            return obj.size
        }
        
        collectionViewDataSource?.blockCellIdentifier = {
            [weak self] (index) in
            guard let self = self else { return "" }
            return self.items[index.section].subHeader
        }
        
        collectionViewDataSource?.configureCellBlock = {
            (index, cell, item) in
            
            if let cell = cell as? ProductCollectionCell {
                cell.product = item as? ProductF
//                cell.backgroundColor = UIColor.orange
            }
            else if let cell = cell as? ProductCategoryCell {
                if let cat = item as? Categorie {
                    cell.category = cat
                }
                else {
                    cell.subCategory = item as? SubCategory
                }
//                cell.backgroundColor = UIColor.green
            }
            else if let cell = cell as? HomeProductCell {
                cell.productListing = item as? ProductF
//                cell.backgroundColor = UIColor.yellow
            }
            else if let cell = cell as? HomeBrandsCollectionCollectionCell {
                cell.arrayBrands = (item as? [Brands])
//                cell.backgroundColor = UIColor.red
                
                cell.blockSelectBrand = { [weak self] (objBrand) in
                    guard let self = self else { return }
                    print("Select Brand : \(/objBrand.name)")
                    
                    let vc =  ItemListingViewController.getVC(.main)
                    vc.isCatBrand = true
                    vc.passedData = PassedData(withCatergoryId: self.passedData.categoryId, categoryFlow: nil, supplierId: self.passedData.supplierId ,subCategoryId: nil ,productId: nil, branchId: objBrand.id.toString, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
                    vc.brandName = objBrand.name
                    self.pushVC(vc)
                    
                }
            }
            
        }
        
        collectionViewDataSource?.aRowSelectedListener = {            
            [weak self] (index, cell) in
            
            guard let self = self else { return }
            let section = self.items[index.section]

            if let obj = section.type as? SubCategorySectionType {
                if obj == .categories, let obj = section.rows[index.row] as? SubCategory {
                    self.itemClicked(objModel: obj)
                }
                else if obj == .categories, let cat = section.rows[index.row] as? Categorie {
                    //"Category>SubCategory>Suppliers>Pl"
                    cat.category_flow = "Category>SubCategory>Pl"
                    if self.supplierId != nil {
                        cat.supplierId = self.supplierId
                    }
                    self.openCategory(category: cat.toServiceType)
                }

            } else if let obj = section.type as? SubCategorySectionType {
                if obj == .disCountProducts, let obj = section.rows[index.row] as? ProductF {
                    self.openProduct(objProduct: obj)
                }
            }

        }
        
//        collectionViewDataSource.ds
        
        collectionViewDataSource?.blockViewHeaderSection = {
            (viewHeader,HeaderSection,item) in
            (viewHeader as? ProductHeaderView)?.lblHeaderView.text = item.header
        }
        
        collectionViewDataSource?.reload(items: [])
    }
    
    
}

//MARK: - Button Actions
extension SubcategoryViewController {
    
    @IBAction func actionBack(sender: AnyObject) {
        if !FilterCategory.shared.arrayCatIds.isEmpty {
            FilterCategory.shared.arrayCatIds.removeLast()
            FilterCategory.shared.arrayCatNames.removeLast()
        }
        
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionMultiSearch(sender: AnyObject) {
        view.endEditing(true)
        guard let _ = passedData.supplierBranchId else { return }
        let searchVc = StoryboardScene.Main.instantiateSearchViewController()
        searchVc.passedData = passedData
        pushVC(searchVc)
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionBarCode(sender : UIButton!){
        if UtilityFunctions.isCameraPermission() {
            let barCodeVc = StoryboardScene.Options.instantiateBarCodeScannerViewController()
            barCodeVc.passedData = passedData
            pushVC(barCodeVc)
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    
}

//MARK: - TextField handlers

extension SubcategoryViewController : UITextFieldDelegate {
    
    @IBAction func textFieldValueChanged(sender: UITextField) {
        
        let filterSuppliers = subCategories?.filter({ (supplier) -> Bool in
            guard let match = supplier.name?.contains(sender.text!, compareOption: .caseInsensitive) else { return false }
            return match
        })
        subCategories = sender.text?.count == 0 ? subCategories : filterSuppliers
        tableViewDataSource.items = sender.text?.count == 0 ? subCategories : filterSuppliers
        tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraintTableViewBottom.constant = 260
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintTableViewBottom.constant = 0
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
