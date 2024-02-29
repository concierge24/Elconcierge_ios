//
//  FilterViewController.swift
//  Sneni
//
//  Created by MAc_mini on 16/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

import ENSwiftSideMenu

protocol FilterVCDelegate: class {
    func FilterVariantData(_ sectionData: [SectionData]?,filterdProductListing:filteredProducts?,filteredResults:Bool,maxValue:Int,minValue:Int)
    func resetData(isReset: Bool)
}

class FilterVC: UIViewController, priceRangeChanges {

    //MARK:- IBOutlet
    @IBOutlet weak var tableViewOptions: UITableView! {
        didSet {
            self.tableViewOptions.tableFooterView = UIView()
            configTableOptions()    
        }
    }
    @IBOutlet weak var viewContainerTableView: UIView!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            self.tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet weak var vwShadow: UIView!
    @IBOutlet weak var btnDone: ThemeButton!
    
    //MARK:- Variables
    weak var delegate: FilterVCDelegate?
    var sectionData : [SectionData]? {
        didSet {
            tableView.reloadData()
        }
    }
    var sectionValient : Variant? {
        didSet {
            var items: [TableViewSectionTypes] = [.category, .sortedBy, .priceRange, .discount, .availability]
            if !((sectionValient?.brands ?? []).isEmpty) || !((sectionValient?.variantData ?? []).isEmpty){
                items.append(.others)
            }
//            sectionValient?.variantData?.forEach({
//                (obj) in
//                if let type = TableViewSectionTypes(rawValue: obj.variantName), obj.variantValues.count > 0 {
//                    items.append(type)
//                }
//            })
            itemsOptions = items
            self.tableViewOptions.reloadData()

        }
    }
    let SectionHeaderHeight: CGFloat = 50
    var isHomePageFlow :Bool = false
    var searchProduct:String?
    var tableOptionsDataSource: SKTableViewDataSource!
    private var objCateVC:FilterCategoryNavigationVC!
    var objFilter: FilterCategory = FilterCategory()
    
    var itemsOptions: [TableViewSectionTypes] = [.category, .sortedBy, .priceRange, .discount, .availability] {
        didSet {
            tableOptionsDataSource.reloadTable(items: itemsOptions)
        }
    }
    var seletedOptions = TableViewSectionTypes.category {
        didSet {
            self.tableViewOptions.reloadData()
            sectionData = SectionData.setSectionData(type: seletedOptions, variant: sectionValient)
            getCatNav().view.isHidden = seletedOptions != .category
            
            if seletedOptions == .category {
                getCatNav().reset()
            }
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objFilter = FilterCategory.shared
        subCategorySelected()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FilterVC.doneReceivedNotification(notification:)), name: NSNotification.Name(rawValue: FilterNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.subCategorySelected), name: NSNotification.Name("SubCategoryCountChanged"), object: nil)

        if sectionData == nil {
            seletedOptions = TableViewSectionTypes.category
        } else {
            self.tableView.reloadData()
        }
        
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = false
        self.sideMenuController()?.sideMenu?.allowRightSwipe = false
        self.webServiceProductVariantList()
    }
    
    @objc func doneReceivedNotification(notification: NSNotification) {
        if let objFilter = notification.object as? FilterCategory {
            self.objFilter = objFilter
            FilterCategory.shared = objFilter
            tableView.reloadData()
            
            vwShadow.isHidden = true
            children.forEach({ $0.willMove(toParent: nil); $0.view.removeFromSuperview(); $0.removeFromParent() })
            
            self.webServiceProductVariantList()
        }
    }
    
    func getCatNav() -> FilterCategoryNavigationVC {
        if objCateVC == nil {
            objCateVC = FilterCategoryNavigationVC.getVC(.main)
            tableView.addSubview(objCateVC.view)
            self.addChild(objCateVC)
            objCateVC.objVc = self
        }
        objCateVC.view.frame = tableView.bounds
        objCateVC.view.layoutIfNeeded()
        
        objCateVC.blockUpdate = {
            [weak self] in
            guard let self = self else { return }
            self.webServiceProductVariantList()
        }
        //
        return objCateVC
    }
}

extension FilterVC {
    
    func configTableOptions() {
        
        let identifier = "Cell"//ProductListingCell.identifier
//        tableView.registerCells(nibNames: [identifier])
        
        tableOptionsDataSource = SKTableViewDataSource(tableView: tableViewOptions, cellIdentifier: identifier, cellHeight: 56.0)
        
        tableOptionsDataSource.configureCellBlock = {
            [weak self] (indexPath, cell, item) in
            guard let self = self else { return }
            if let cell = cell as? UITableViewCell, let item = item as? TableViewSectionTypes {
                cell.textLabel?.text = item.rawValue
                cell.isSelected = self.seletedOptions == item
                let viewBG = UIView()
                viewBG.backgroundColor = .white
                    cell.selectedBackgroundView = viewBG
            }
        }
        
        tableOptionsDataSource.aRowSelectedListener = {
            [weak self] (indexPath, cell) in
            
            guard let self = self else { return }
            
            self.seletedOptions = self.itemsOptions[indexPath.row]
            
//            if self.seletedOptions == .category {
//                if self.objVC != nil {
//                    self.children.forEach({ $0.willMove(toParent: nil); $0.view.removeFromSuperview(); $0.removeFromParent() })
//                }
//                self.vwShadow.isHidden = false
//                self.objVC  = CategoryViewController.getVC(.main)
//                self.objVC.objFilter = self.objFilter
//                self.objVC.view.openAnimate(parentVC: self, childVC: self.objVC, leftMargin: 128.0, width: 128.0)
//
////                objVC.view.frame = self.tableView.frame
////                self.viewContainerTableView.addSubview(objVC.view)
////                self.addChild(objVC)
////                objVC.view.layoutIfNeeded()
//            }
            
        }
        tableOptionsDataSource.reloadTable(items: itemsOptions)
    }
    
    
    @objc func subCategorySelected() {
        if objFilter.apiSubIds.count > 0 {
            btnDone.isUserInteractionEnabled = true
            btnDone.alpha = 1
        }
        else {
            btnDone.isUserInteractionEnabled = false
            btnDone.alpha = 0.5
        }
    }
}

extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return /self.sectionData?.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sectionData?[section]
        let cellsArr  = sectionType?.cells
        return /cellsArr?.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = sectionData?[section]
        return CGFloat(/sectionType?.headerHeight)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CustomHeaderCell) as? CustomHeaderCell  {
            
            let sectionType = sectionData?[section]
            let title = sectionType?.title
//            if title == .category {
//
//                cell.headerTitleLabel.text = ""
//                cell.headerTitleLabel.isHidden = true
//
//            } else {
                
                cell.headerTitleLabel.isHidden = false
                cell.headerTitleLabel.text =  title?.uppercased()
                return cell
//            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let sectionType = sectionData?[indexPath.section]
        return UITableView.automaticDimension//CGFloat(sectionType?.rowHeight ?? Int(0.0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = sectionData?[indexPath.section]
        let sortedData: Sorted? = sectionType?.cells?[indexPath.row] as? Sorted
        
        switch (sectionType?.type ?? .none) {
        case .sortedBy:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.FilterTableViewSortedCell, for: indexPath) as? FilterTableViewSortedCell {
                sortedData?.id = self.objFilter.getValue(type: sortedData?.type ?? .none)

                cell.sorted = sortedData
                cell.radioButton.tag = indexPath.row
                cell.radioButton.isUserInteractionEnabled = false
                
                return cell
            }
            
        case .discount, .availability:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewYesNoCell", for: indexPath) as? FilterTableViewSortedCell {
                sortedData?.id = (sectionType?.type == .discount ? ((self.objFilter.discount == 1) ? (indexPath.row == 0).toInt : (indexPath.row == 1).toInt) : ((self.objFilter.availablity == 1) ? (indexPath.row == 0).toInt : (indexPath.row == 1).toInt))
                cell.sorted = sortedData
                cell.radioButton.tag = indexPath.row
                cell.radioButton.isUserInteractionEnabled = false
                return cell
            }
            
        case .priceRange:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.PriceRangeTableViewCell, for: indexPath) as? PriceRangeTableViewCell {
                cell.objFilter = objFilter
                cell.delegate = self
                return cell
            }
            
        case .category:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.CategoryTableViewCell, for: indexPath) as? CategoryTableViewCell {
                
                let sortedData = sectionType?.cells?[indexPath.row]
                cell.sorted = sortedData as? Sorted
                cell.objFilter = objFilter
                return cell
            }
            
        case .size , .color, .style:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.VairantTableViewCell, for: indexPath) as? VairantTableViewCell {
                //cell.heightConstrantVarient?.constant = tableView.frame.height-50.0
                cell.vcFilter = self
                cell.level = indexPath.row
                cell.sectionData = sectionType

                return cell
            }
            
        default:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.VairantTableViewCell, for: indexPath) as? VairantTableViewCell {
                //cell.heightConstrantVarient?.constant = tableView.frame.height-50.0
                cell.vcFilter = self
                cell.level = indexPath.row
                cell.sectionData = sectionType
                
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sectionType = sectionData?[indexPath.section]
        let sortedData: Sorted? = sectionType?.cells?[indexPath.row] as? Sorted
        
        if sortedData?.type == TableViewSectionTypes.category {
            
            vwShadow.isHidden = false
//            let objVC  = CategoryViewController.getVC(.main)
//            self.objVC.objFilter = objFilter
//            self.objVC.view.openAnimate(parentVC: self, childVC: objVC, leftMargin: 50.0, width: 50.0)
            
        } else if sectionType?.type == TableViewSectionTypes.sortedBy {
            if sortedData?.type == TableViewSectionTypes.lowToHigh {
                self.objFilter.lowToHigh = true
                self.objFilter.popularity = false

            } else if sortedData?.type == TableViewSectionTypes.higtToLow {
                self.objFilter.lowToHigh = false
                self.objFilter.popularity = false

            } else if sortedData?.type == TableViewSectionTypes.popularity {
                self.objFilter.lowToHigh = true
                self.objFilter.popularity = true
            }
            tableView.reloadData()
        } else if sectionType?.type == TableViewSectionTypes.discount {
            self.objFilter.discount = (indexPath.row == 0).toInt
            tableView.reloadData()

        } else if sectionType?.type == TableViewSectionTypes.availability {
            self.objFilter.availablity = (indexPath.row == 0).toInt
            tableView.reloadData()

        }

    }
}

extension FilterVC {
    
    @IBAction func resetBtnClick(sender:UIButton) {
        
        objFilter = FilterCategory()
        sectionValient = nil
        self.tableView.reloadData()
        
        seletedOptions = .category
        self.delegate?.resetData(isReset: true)
        self.dismissVC(completion: nil)
    }
    
    @IBAction func backBtnClick(sender:UIButton) {
        dismissVC(completion: nil)
        self.popVC()
    }
    
    @IBAction func doneBtnClick(sender:UIButton) {
        
        if objFilter.arrayCatIds.isEmpty {
            
            UtilityFunctions.showAlert(message: "\(L10n.please.string) \(AppSettings.shared.isFoodApp ? L10n.selectCuisine.string : L10n.selectCategory.string).")
            return
        }
        
        self.webServiceProductfilteration()
    }
}

extension FilterVC {
    
    func webServiceProductfilteration() {
        
        let objF = objFilter
        
        var arrBrandsIds = [Int]()

        for item in objF.arrayBrandId {
            arrBrandsIds.append(Int(item))
        }
        
        let objR = API.ProductFilteration(FormatAPIParameters.ProductFilteration(
            subCategoryId: objF.apiSubIds,
            low_to_high: objF.lowToHigh.toInt.toString,
            is_availability:objF.availablity.toString,
            max_price_range: objFilter.maxPrice.toString,
            min_price_range: objFilter.minPrice.toString,
            is_discount: objF.discount.toString,
            is_popularity: objF.popularity.toInt.toString,
            product_name: searchProduct,
            variant_ids: objF.variantIdArray,
            supplier_ids: FilterCategory.supplierIds,
            brand_ids: arrBrandsIds).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):

                FilterCategory.shared = self.objFilter

                let filterdProductListing = object as? filteredProducts
                self.delegate?.FilterVariantData(self.sectionData, filterdProductListing: filterdProductListing, filteredResults: true, maxValue: self.objFilter.maxPrice, minValue: self.objFilter.minPrice)
//                self.popVC()
                self.dismissVC(completion: nil)
                
            default:
                break
            }
        }
    }
    
    func webServiceProductVariantList () {

        let objR = API.ProductVariantList(FormatAPIParameters.ProductVariantList(categoryId: objFilter.arrayCatIds.first).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                
                self.sectionValient = object as? Variant
//                self.sectionData?.removeAll()
//                self.sectionData = SectionData.setSectionData(type: self.seletedOptions)
//                self.sectionData = SectionData.getItems(backendObj: object, sectionDataArr: self.sectionData ?? [] )
                
            default:
                break
            }
        }
    }
    
    func getPriceValues(upperValue: Int, lowerValue: Int) {
        
        objFilter.maxPrice = upperValue
        objFilter.minPrice = lowerValue
    }
}
