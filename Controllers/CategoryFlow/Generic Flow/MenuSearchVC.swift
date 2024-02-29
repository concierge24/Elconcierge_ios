//
//  MenuSearchVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 13/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class MenuSearchVC: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchbar: UISearchBar! {
        didSet {
            searchbar.setAlignment()
            searchbar.placeholder = "Search".localized()

        }
    }
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.registerCells(nibNames: [ProductListCell.identifier])
            tableview.tableFooterView = UIView()
            tableview.delegate = self
            tableview.dataSource = self
            tableview.estimatedRowHeight = 90
        }
    }
    
    var filterData : [ProductList] = []
    var tileForSection : [String]?
    var arrayProducts : [ProductList]?
    
    var delegate : UpdateCartProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchbar.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.updateList()
    }
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
//        filterData = searchText.isEmpty ? arrayProductList : arrayProductList?.filter({($0.productValue?.contains(where: {($0.name?.lowercased().contains(searchText.lowercased()) ?? false)}) ?? false)})
        
//        filterData = searchText.isEmpty ? [] : arrayProductList?.filter( {($0.productValue?.filter({($0.name?.lowercased().contains(searchText.lowercased()) ?? false)}).count)! > 0 } )
        
        if searchText.isEmpty {
            filterData = []
        }else {
            filterData = []
            arrayProducts?.forEach({ (list) in
                let filtered = list.productValue?.filter({($0.name?.lowercased().contains(searchText.lowercased()) ?? false)})
                if /filtered?.count > 0 {
                    let tempObj = ProductList()
                    tempObj.catName = list.catName
                    tempObj.productValue = filtered

                    filterData.append(tempObj)
                }
                
            })
            
        }

        print(filterData)
        
        tableview.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchbar.showsCancelButton = false
        searchbar.text = ""
        searchbar.resignFirstResponder()
        self.view.endEditing(true)
        self.filterData = []
        //     viewHeaderTable.btnManu.isHidden = isFilterEnable
        //  viewHeaderTable.lblBlank.isHidden = isFilterEnable
        //   viewHeaderTable.btnSearch.isHidden = isFilterEnable
        //   viewHeaderTable.searchBar.isHidden = !isFilterEnable
    }
    
    
}


//MARK:- UITableViewDelegate , UITableViewDataSource
extension MenuSearchVC : UITableViewDelegate , UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return /filterData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterData[section].productValue?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as? ProductListCell else {
            fatalError("Missing ServiceCell identifier")
        }
        cell.selectionStyle = .none
        let products = filterData[indexPath.section].productValue
        
        cell.selectedIndex = indexPath.row
        if let data = products?[indexPath.row] {
            cell.product = data
            
            let purchased = data.purchasedQuantity
            let total = data.totalMaxQuantity
            
            if (total-purchased) == 0 {
                cell.labelOutOfStock.isHidden = false
                cell.stepper?.isHidden = true
            } else {
                cell.labelOutOfStock.isHidden = true
                cell.stepper?.isHidden = false
            }
        }
        
        
        
        cell.addonsCompletionBlock = { [weak self] value in
            guard let self = self else {return}
            GDataSingleton.sharedInstance.fromCart = false
            if let data = value as? (ProductF,Bool,Double){
                if data.1 { // data.1 == true for open customization controller
                    data.0.addOnValue?.removeAll()
                    self.openCustomizationView(cell: cell, product: data.0, cartData: nil, quantity: data.2, index: indexPath.row)
                }
            } else if let data = value as? (ProductF,Cart,Bool,Double) {
                //for open checkcustomization controller
                self.openCheckCustomizationController(cell: cell, productData: data.0,cartData: data.1, shouldShow: data.2, index: indexPath.row)
            }
        }
        
        
        cell.lblSupplierName?.isHidden = true
        cell.viewSingleStarRating.isHidden = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return filterData[section].catName ?? ""
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pushNextVc()
        if SKAppType.type.isJNJ {
            return
        }
        //        let obj: ProductList? = isFilterEnable ? filterData?[indexPath.section] : arrayProductList?[indexPath.section]
        //        obj?.productValue?[indexPath.row].openDetail()
        
        searchbar.resignFirstResponder()

        let products = filterData[indexPath.section].productValue
        guard let data = products?[indexPath.row].desc else { return }
        
        let vc = RestaurantDescVC.getVC(.options)
        vc.data = data
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        
        self.present(vc, animated: true) {
            // self.createTempView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchbar.resignFirstResponder()
    }
    
    func openCustomizationView(cell:ProductListCell?,product: ProductF?,cartData: Cart?,quantity: Double?,shouldHide:Bool = false,index:Int?) {
        
        searchbar.resignFirstResponder()

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
                if let _ = quantity { // called when add to card button is added
                    cell?.product = obj.1
                }
            }
            self.removeViewAndSaveData()
        }
        
        self.present(vc, animated: true) {
            self.createTempView()
        }
        
    }
    
    func openCheckCustomizationController(cell:ProductListCell?,productData: ProductF?,cartData: Cart?, shouldShow: Bool, index:Int?) {
        
        searchbar.resignFirstResponder()

        let vc = StoryboardScene.Options.instantiateCheckCustomizationViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.cartProdcuts = cartData
        vc.product = productData
        vc.completionBlock = {[weak self] data in
            guard let self = self else {return}
            guard let productCell = cell else {return}
            if let dataValue = data as? (Bool,ProductF) {
                productCell.product = dataValue.1
                if !dataValue.0 {
                    dataValue.1.addOnValue?.removeAll()
                    self.removeViewAndSaveData()
                }
            } else if let dataValue = data as? (ProductF,Cart,Bool),let productCell = cell{
                let obj = ProductF(cart: dataValue.1)
                dataValue.0.addOnValue?.removeAll()
                let addonId = Int(obj.addOnId ?? "0")
                self.openCustomizationView(cell: cell, product: dataValue.0,cartData: dataValue.1, quantity: productCell.stepper?.value ?? 0.0, index: addonId)
            } else if let _ = data as? Bool{
                //productCell.stepper?.stepperState = !obj ? .ShouldDecrease : .ShouldIncrease
                self.removeViewAndSaveData()
            } else if let obj = data as? ProductF {
                productCell.product = obj
            } else if let _ = data as? Int {
                self.removeViewAndSaveData()
            } else if let value = data as? (Bool,Double) {
                if value.1 == 0 {
                    self.removeViewAndSaveData()
                }
                productCell.stepper?.stepperState = .ShouldDecrease
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
    
}


//MARK:- UIViewControllerTransitioningDelegate
extension MenuSearchVC : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

