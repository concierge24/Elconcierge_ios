//
//  SubCategoryViewController.swift
//  Sneni
//
//  Created by MAc_mini on 18/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class FilterSubCategoryViewController: CategoryFilterBaseVC {
    
//    var objFilter: FilterCategory = FilterCategory()
    var oldFilter: FilterCategory?

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            self.tableView.tableFooterView = UIView()
            configureTableViewInitialization()
        }
    }
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var lblNavTitle: UILabel!
    
    var passedData : PassedData = PassedData()
    
    var tableViewDataSource = TableViewDataSource(){
        didSet {
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    
    var subCategories: [SubCategory] = [] {
        didSet {

            subCategories.forEach({ $0.isSelected = /self.navigation?.objVc.objFilter.isSelected(catOrSubCat: /$0.subCategoryId) })
            
            tableViewDataSource.items = subCategories
            tableView?.reloadTableViewData(inView: view)
            
            reloadDoneBtn()
        }
    }
    
    
    func reloadDoneBtn() {
//        self.btnDone.isHidden = self.subCategories.first(where: { $0.isSelected }) == nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldFilter = navigation?.objVc.objFilter
        
        lblNavTitle.text = passedData.categoryName
        webServiceSubCategoriesListing()
    }
}


//MARK: - WebService Methods
extension FilterSubCategoryViewController{
    
    func webServiceSubCategoriesListing() {
        
        let objR = API.SubCategoryListing(supplierId: passedData.supplierId, categoryId: passedData.categoryId)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
                
            case .Success(let listing):
                self.subCategories = ((listing as? SubCategoriesListing)?.subCategories ?? [])
                
            default :
                break
            }
        }
    }
}

//MARK: - TableView Configuration Methods
extension FilterSubCategoryViewController {
    
    func configureTableViewInitialization(){
        
        tableViewDataSource = TableViewDataSource(
            items: subCategories,
            height: UITableView.automaticDimension,
            tableView: tableView,
            cellIdentifier: CellIdentifiers.FilterSubcategoryTableViewCell,
            configureCellBlock: {
            (cell, item) in
                
                if let cell = cell as? FilterSubcategoryTableViewCell, let item = item as? SubCategory {
                    
//                    let hasAllItemsEqual = subCategories?.allSatisfy({ $0.is_cub_category == "0"})
//                    cell.isAllCategory = hasAllItemsEqual ?? false
                    cell.subCategory = item
                }
                
            }, aRowSelectedListener: {
                [weak self] (indexPath) in
                guard let self = self else { return }
                
                let item = self.subCategories[indexPath.row]
//                let cell = self.tableView.cellForRow(at: indexPath) as! FilterSubcategoryTableViewCell
                
                if item.is_cub_category == "0" {
                    item.isSelected = !item.isSelected
                    
                    if item.isSelected {
                        self.navigation?.objVc.objFilter.arraySubCatIds.append(/item.subCategoryId)
                        self.navigation?.objVc.objFilter.arraySubCatNames.append(/item.name)

                    } else {
                        if let index = self.navigation?.objVc.objFilter.arraySubCatIds.firstIndex(of: /item.subCategoryId) {
                            self.navigation?.objVc.objFilter.arraySubCatIds.remove(at: index)
                            self.navigation?.objVc.objFilter.arraySubCatNames.remove(at: index)
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("SubCategoryCountChanged"), object: nil)
                } else if item.is_cub_category == "1" {
                    if !item.isSelected {
                        for obj in self.subCategories.filter({ ($0.isSelected) }) {
                            if let index = self.navigation?.objVc.objFilter.arrayCatIds.firstIndex(of: /obj.subCategoryId) {
                                while /self.navigation?.objVc.objFilter.arrayCatIds.count <= index {
                                    self.navigation?.objVc.objFilter.arrayCatIds.remove(at: index)
                                    self.navigation?.objVc.objFilter.arrayCatNames.remove(at: index)
                                }
                            }
                            
                            if let index = self.oldFilter?.arrayCatIds.firstIndex(of: /obj.subCategoryId) {
                                while /self.oldFilter?.arrayCatIds.count <= index {
                                    self.oldFilter?.arrayCatIds.remove(at: index)
                                    self.oldFilter?.arrayCatNames.remove(at: index)
                                }
                            }
                            obj.isSelected = false
                        }
                        item.isSelected = true
                        self.navigation?.objVc.objFilter.arrayCatIds = (self.oldFilter?.arrayCatIds ?? []) + [/item.subCategoryId]
                        self.navigation?.objVc.objFilter.arrayCatNames = (self.oldFilter?.arrayCatNames ?? []) + [/item.name]   
                    }
                    
                    
//                    self.subCategories.forEach({
//                        (obj) in
//                        if obj.is_cub_category == "1" {
//                            if let index = self.navigation?.objVc.objFilter.arrayCatIds.firstIndex(of: /item.subCategoryId) {
//                                self.navigation?.objVc.objFilter.arrayCatIds.remove(at: index)
//                                self.navigation?.objVc.objFilter.arrayCatNames.remove(at: index)
//                            }
//                            obj.isSelected = false
//                        }
//                    })
                    
//                    item.isSelected = true
                    
                    let subCategoryVC  = FilterSubSubCategeoryVC.getVC(.main)
//                    subCategoryVC.objFilter = self.objFilter
                    subCategoryVC.objSubCat = item
                    self.pushVC(subCategoryVC)
//                    subCategoryVC.view.openAnimate(parentVC: self, childVC: subCategoryVC, leftMargin: 0.0, width: 128.0)

                }
                self.tableView.reloadData()
                self.reloadDoneBtn()
        })
    }
}

extension FilterSubCategoryViewController{
    
    @IBAction func backBtnClick(sender:UIButton){
        self.popVC()
//        self.view.closeAnimate(childVC: self, leftMargin: 0.0, width: 128.0)
    }
    
    @IBAction func doneBtnClick(sender:UIButton) {
        
//        subCategories.filter({ $0.isSelected }).forEach {
//            (obj) in
//
//            if obj.is_cub_category == "0" {
//                self.navigation?.objVc.objFilter.arraySubCatIds.append(/obj.subCategoryId)
//                self.navigation?.objVc.objFilter.arraySubCatNames.append(/obj.name)
//
//            } else if obj.is_cub_category == "1"  {
////                self.objFilter.arrayCatIds.append(/obj.subCategoryId)
////                self.objFilter.arrayCatNames.append(/obj.name)
//            }
//        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: FilterNotification), object: self.navigation?.objVc.objFilter)
    }
}
