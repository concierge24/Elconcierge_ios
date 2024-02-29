//
//  CategoryViewController.swift
//  Sneni
//
//  Created by MAc_mini on 18/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CategoryFilterBaseVC: UIViewController {
    
    var navigation: FilterCategoryNavigationVC? {
        return self.navigationController as? FilterCategoryNavigationVC
    }
}

class CategoryViewController: CategoryFilterBaseVC {
    
//    var objFilter: FilterCategory = FilterCategory()
    var arrayServiceType:[ServiceType] = []
    
    @IBOutlet weak var lblNavTitle: UILabel! {
        didSet {
            lblNavTitle.text = AppSettings.shared.isFoodApp ? L10n.selectCuisine.string : L10n.selectCategory.string
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            self.tableView.tableFooterView = UIView()
            configureTableViewInitialization()
        }
    }
    
    var tableViewDataSource = TableViewDataSource() {
        didSet {
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if /navigation?.isReset {
            navigation?.isReset = false
            tableView.reloadData()
        }
    }
}

//MARK: - TableView Configuration Methods
extension CategoryViewController {
    
    func configureTableViewInitialization(){
        
        arrayServiceType = GDataSingleton.sharedInstance.arrayServiceType ?? []
        
        tableViewDataSource = TableViewDataSource(
            items: arrayServiceType,
            height: 50,
            tableView: tableView,
            cellIdentifier: CellIdentifiers.FilterTableViewSortedCell,
            configureCellBlock: {
            [weak self] (cell, item) in
            guard let self = self else { return }
                
                if let cell = cell as? FilterTableViewSortedCell, let item = item as? ServiceType {
                    let flag = /self.navigation?.objVc.objFilter.isSelected(catOrSubCat: /item.id)
                    cell.sorted = Sorted(variantName: item.name, id: flag.toInt)
                    cell.radioButton.isUserInteractionEnabled = false
                }
            
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }
                
                let item = self.arrayServiceType[indexPath.row]
                //let isSubCat = /item.category_flow?.contains("SubCategory")
                let isSubCat = /item.sub_category?.count > 0
//                self.navigation?.objVc.objFilter.arrayCatIds
//                self.navigation?.objVc.objFilter.arrayCatNames
                
                if self.navigation?.objVc.objFilter.arrayCatIds.first != item.id {
                    self.navigation?.objVc.objFilter.arrayCatIds = [/item.id]
                    self.navigation?.objVc.objFilter.arrayCatNames = [/item.name]
                    self.navigation?.objVc.objFilter.agentListFlow = item.agent_list
                    
                    self.navigation?.objVc.objFilter.arraySubCatIds.removeAll()
                    self.navigation?.objVc.objFilter.arraySubCatNames.removeAll()
                    NotificationCenter.default.post(name: NSNotification.Name("SubCategoryCountChanged"), object: nil)

                    self.navigation?.blockUpdate?()
                }
                self.selectedCategoryDetail(objCat: item, openCat: isSubCat)
                
        })
    }
    
    func selectedCategoryDetail(objCat: ServiceType, openCat: Bool) {
        
        self.tableView.reloadData()
        if !openCat {
            if (self.navigation?.objVc.objFilter.arraySubCatIds ?? []).isEmpty, let id = self.navigation?.objVc.objFilter.arrayCatIds.last , let name = self.navigation?.objVc.objFilter.arrayCatNames.last {
                
                self.navigation?.objVc.objFilter.arraySubCatIds.append(id)
                self.navigation?.objVc.objFilter.arraySubCatNames.append(name)
                NotificationCenter.default.post(name: NSNotification.Name("SubCategoryCountChanged"), object: nil)
            }

            return
        }
        
        self.navigation?.objVc.objFilter.arrayBrandId = []
        self.navigation?.objVc.objFilter.variantIdArray = []

        let subCategoryVC  = FilterSubCategoryViewController.getVC(.main)
//        subCategoryVC.objFilter = objFilter
        
        subCategoryVC.passedData.categoryId = objCat.id
        subCategoryVC.passedData.categoryName = objCat.name
        subCategoryVC.passedData.categoryOrder = objCat.order
        self.pushVC(subCategoryVC)
//        subCategoryVC.view.openAnimate(parentVC: self, childVC: subCategoryVC, leftMargin: 0.0, width: 128.0)
        
    }
}

extension CategoryViewController {
    
    @IBAction func doneBtnClick(sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FilterNotification), object: self.navigation?.objVc.objFilter)
    }
}
