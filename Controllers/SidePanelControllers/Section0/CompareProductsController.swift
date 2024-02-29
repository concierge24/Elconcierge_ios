//
//  CompareProductsController.swift
//  Clikat
//
//  Created by cblmacmini on 7/18/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import ESPullToRefresh

class CompareProductsController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var constraintTableViewBottom : NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }

    //MARK:- Variables
    var pageNo : Int = 0
    var isHomeSearch = false
    var searchKey : String?
    var tableDataSource : TableViewDataSource?{
        didSet{
            tableView.reloadData()
        }
    }
    var productListing : filteredProducts?{
        didSet{
            viewPlaceholder?.isHidden = productListing?.products?.count == 0 ? false : true
            configureTableView()
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        AdjustEvent.CompareProducts.sendEvent()

        if isHomeSearch {
            tfSearch?.text = searchKey
            getAllProducts(name: searchKey)
        }
        tableView.es.addInfiniteScrolling { [weak self] in
            self?.tableView.es.stopLoadingMore()
            self?.pageNo = /self?.tableDataSource?.items?.count + 1
            self?.getAllProductsPaging(startValue: self?.pageNo.toString)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - Products Web Service
extension CompareProductsController {
    
    func getAllProducts(name : String?){
        if name == "" { return }
        
//        let objR = API.CompareProducts(FormatAPIParameters.CompareProducts(productName: name, startValue: "0").formatParameters())
        let objR = API.ProductFilteration(FormatAPIParameters.ProductFilteration(
            subCategoryId: [],
            low_to_high: "1",
            is_availability: "1",
            max_price_range: "100000",
            min_price_range: "0",
            is_discount: "0",
            is_popularity: "0",
            product_name: name,
            variant_ids: [],
            supplier_ids: [],
            brand_ids: []).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {[weak self] (response) in
            switch response {
            case .Success(let object):
                self?.productListing  = object as? filteredProducts
            default:
                break
            }
        }
    }
    
    func getAllProductsPaging(startValue : String?){
        
//        let objR = API.CompareProducts(FormatAPIParameters.CompareProducts(productName: self.searchKey, startValue: startValue).formatParameters())
        let objR = API.ProductFilteration(FormatAPIParameters.ProductFilteration(
            subCategoryId: [],
            low_to_high: "1",
            is_availability: "1",
            max_price_range: "100000",
            min_price_range: "0",
            is_discount: "0",
            is_popularity: "0",
            product_name: self.searchKey,
            variant_ids: [],
            supplier_ids: [],
            brand_ids: []).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            
            switch response {
            case .Success(let object):
                var products = (self?.tableDataSource?.items as? [ProductF]) ?? []
                guard let newProducts = (object as? filteredProducts)?.products, newProducts.count > 0 else {
                    self?.tableView.es.noticeNoMoreData()
                    return
                }
                products.append(contentsOf: newProducts)
                self?.tableDataSource?.items = products
                self?.tableView.reloadTableViewData(inView: self?.view)
            default:
                break
            }
        }
    }
    
    func configureTableView(){
        tableDataSource = TableViewDataSource(items: productListing?.products, height: 105, tableView: tableView, cellIdentifier: CellIdentifiers.CompareProductsCell, configureCellBlock: { [weak self] (cell, item) in
            self?.configureCell(cell: cell, item: item)
            }, aRowSelectedListener: { [weak self] (indexPath) in
                self?.configureCellSelection(indexPath: indexPath)
        })
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
    }
    
    func configureCellSelection(indexPath : IndexPath){
        
        self.view.endEditing(true)
        let VC = StoryboardScene.Options.instantiateCompareProductResultController()
        VC.product = tableDataSource?.items?[indexPath.row] as? ProductF
        pushVC(VC)
    }
    func configureCell(cell : Any?,item : Any?){
        (cell as? CompareProductsCell)?.product = item as? ProductF
    }
}

//MARK: - Button Actions

extension CompareProductsController {
    
    
    @IBAction func actionMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    @IBAction func actionBarcodeScan(sender: UIButton) {
        if UtilityFunctions.isCameraPermission() {
            let barCodeVc = StoryboardScene.Options.instantiateBarCodeScannerViewController()
            barCodeVc.isCompareProducts = true
            pushVC(barCodeVc)
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    @IBAction func actionSearch(sender: UIButton) {
        searchProduct(sender: tfSearch)
        view.endEditing(true)
    }
}

//MARK: - TextFieldAction
extension CompareProductsController {
    
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        
    }

    func searchProduct(sender : UITextField) {
        guard let searchKey = sender.text, searchKey.trim().count != 0 else {
            return
        }
        if self.searchKey != searchKey {
            tableDataSource?.items = []
            pageNo = 0
        }
        self.searchKey = searchKey
        getAllProducts(name: searchKey)

//        let tempArr = productListing?.arrProducts?.filter({ (product) -> Bool in
//            guard let name = product.name?.lowercaseString else { return false }
//            return name.contains(searchKey.lowercaseString)
//        })
//        
//        
//        if tempArr?.count > 0 {
//            tableDataSource?.items = tempArr
//            tableView.reloadData()
//        }else {
//            tableDataSource?.items = []
//            productListing?.arrProducts = []
//            tableView.reloadData()
//        }

    }
}

//MARK: - TextField Delegates

extension CompareProductsController : UITextFieldDelegate {
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
        searchProduct(sender: textField)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
