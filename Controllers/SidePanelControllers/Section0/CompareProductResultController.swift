//
//  CompareProductResultController.swift
//  Clikat
//
//  Created by cblmacmini on 7/18/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompareProductResultController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden =/*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.register(UINib(nibName: CellIdentifiers.SupplierListingCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.SupplierListingCell)
        }
    }
    
    //MARK:- Variables
    var result : CompareProductResult?{
        didSet{
            tableView.isHidden  = false
            tableView.reloadData()
        }
    }
    var product : ProductF?
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        getComparisonResult()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Comparison Result Web Service
extension CompareProductResultController {
    
    func getComparisonResult(){
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CompareProductResult(FormatAPIParameters.CompareProductResult(sku: product?.sku).formatParameters())) { [weak self] (response) in
            switch response {
            case .Success(let object):
                self?.result = object as? CompareProductResult
            default:
                break
            }
        }
    }
}
//MARK: - Button Actions
extension CompareProductResultController {
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
    @IBAction func actionMenu(sender : UIButton){
        toggleSideMenuView()
    }
}

//MARK: - Compare Product Result
class CompareProductResult {
    var products : [ProductF]?
    var suppliers : [Supplier]?
    
    init(attributes : SwiftyJSONParameter){
        products = []
        suppliers = []
        var compareResult = attributes?["details"]?.arrayValue ?? []
        
        compareResult = compareResult.sorted { (p1, p2) -> Bool in
            let product1 = ProductF(attributes: p1.dictionaryValue)
            let product2 = ProductF(attributes: p2.dictionaryValue)
            return (product1.getPrice() ?? 0.0) < (product2.getPrice() ?? 0.0)
        }
        
        for supplier in compareResult {
            products?.append(ProductF(attributes: supplier.dictionaryValue))
            suppliers?.append(Supplier(attributes: supplier.dictionaryValue))
        }
    }
}

//MARK: - TableDataSource
extension CompareProductResultController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (result?.suppliers?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row == 0 ? CellIdentifiers.CompareProductsCell : CellIdentifiers.SupplierListingCell) else { return UITableViewCell() }
        cell.selectionStyle = .none
        if cell is CompareProductsCell {
            (cell as? CompareProductsCell)?.product = product
        }
        if cell is SupplierListingCell {
            (cell as? SupplierListingCell)?.supplier = result?.suppliers?[indexPath.row - 1]
            (cell as? SupplierListingCell)?.compareProduct = result?.products?[indexPath.row - 1]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 105 : 136
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row >= 1 {
            let VC = StoryboardScene.Main.instantiateProductDetailViewController()
            VC.passedData.productId = result?.products?[indexPath.row - 1].id
            VC.suplierBranchId = result?.suppliers?[indexPath.row - 1].supplierBranchId
            let supplier = result?.suppliers?[indexPath.row - 1]
            supplier?.categoryId = result?.products?[indexPath.row - 1].categoryId
            GDataSingleton.sharedInstance.currentSupplier = supplier
            pushVC(VC)
        }
    }
}
