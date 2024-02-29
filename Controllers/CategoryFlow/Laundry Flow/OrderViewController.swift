//
//  OrderViewController.swift
//  Clikat
//
//  Created by cblmacmini on 6/4/16.
//  Copyright © 2016 Rajat. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class OrderViewController: CategoryFlowBaseViewController {

    var laundryOrder : LaundryProductListing?{
        didSet{
            
            viewPlaceHolder?.isHidden = laundryOrder?.arrDetailedSubCategories?.count == 0 ? false : true
            viewSearch?.isHidden = laundryOrder?.arrDetailedSubCategories?.count == 0 ? true : false
            tableView?.isHidden = laundryOrder?.arrDetailedSubCategories?.count == 0 ? true : false
            viewHeader.isHidden = tableView.isHidden
            if (laundryOrder?.arrDetailedSubCategories?.count ?? 0) > 0{
                configureTableDataSource()
                configureBarbuttonView()
                refreshNetAmount()
            }
            labelSupplierName.text = laundryOrder?.supplierName
            labelSupplierAddress.text = laundryOrder?.supplierAddress
        }
    }
    var barViewDataSource = BarButtonDataSource()
    var tableDataSource = LaundryOrderDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var constraintHeader : NSLayoutConstraint!
    
    @IBOutlet weak var sideMenu_button: ThemeButton!
    @IBOutlet weak var labelNetAmount: UILabel!{
        didSet{
            labelNetAmount.text = "AED 0.0"
        }
    }
    @IBOutlet weak var buttonBarView: ButtonBarView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelSupplierName : UILabel!
    @IBOutlet weak var labelSupplierAddress : UILabel!
    @IBOutlet weak var viewPlaceHolder : UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnContinue: UIButton!{
        didSet{
            btnContinue.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var constraintBarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableviewBottom: NSLayoutConstraint!
    
    //MARK: - ButtonBarView Properties
    var changeCurrentIndexProgressive: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    var changeCurrentIndex: ((_ oldCell: ButtonBarViewCell?, _ newCell: ButtonBarViewCell?, _ animated: Bool) -> Void)?
    
    lazy var buttonBarItemSpec: ButtonBarItemSpec<ButtonBarViewCell> = .NibFile(nibName: "ButtonCell", bundle: Bundle(for: ButtonBarViewCell.self), width:{ [weak self] (childItemInfo) -> CGFloat in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = childItemInfo.title
        let labelSize = label.intrinsicContentSize
        return labelSize.width + (LowPadding) * 2
        })

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllLaundryProducts()
    }
}

//MARK: - Laundry Products Web Service 
extension OrderViewController {
    
    func getAllLaundryProducts(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LaundryProductListing(FormatAPIParameters.LaundryProductListing(categoryId: passedData.categoryId, supplierBranchId: passedData.supplierBranchId).formatParameters())) { [weak self] (response) in
            
            switch response {
            case .Success(let object):
                ez.runThisAfterDelay(seconds: 0.2, after: { 
                    self?.laundryOrder = (object as? LaundryProductListing)
                })
            default:
                break
            }
        }
    }
}

//MARK: - Configure Button Bar View
extension OrderViewController {
    func configureBarbuttonView(){
        
        buttonBarView.scrollsToTop = false
        let flowLayout = buttonBarView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        let sectionInset = flowLayout.sectionInset
        flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top,left: sectionInset.left, bottom: sectionInset.bottom, right: sectionInset.right)
        
        buttonBarView.showsHorizontalScrollIndicator = false
        buttonBarView.backgroundColor = UIColor.clear
        buttonBarView.selectedBar.backgroundColor = Colors.MainColor.color()
        
        buttonBarView.selectedBarHeight = 2
        // register button bar item cell
        switch buttonBarItemSpec {
        case .NibFile(let nibName, let bundle, _):
            buttonBarView.register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier:"Cell")
        case .CellClass:
            buttonBarView.register(ButtonBarViewCell.self, forCellWithReuseIdentifier:"Cell")
        }
        
        barViewDataSource = BarButtonDataSource(items: laundryOrder?.arrDetailedSubCategories ?? [], barButtonView: buttonBarView,tableView: tableView)
        buttonBarView.delegate = barViewDataSource
        buttonBarView.dataSource = barViewDataSource
        buttonBarView.moveToIndex(toIndex: 0, animated: false, swipeDirection: .None, pagerScroll: .ScrollOnlyIfOutOfScreen)
    }
}
//MARK: - Configure table data source 

extension OrderViewController {
    
    func configureTableDataSource(){
        
        tableDataSource = LaundryOrderDataSource(laundryOrder: laundryOrder, tableView: tableView, configureCellBlock: { (cell, item) in
            weak var weakSelf = self
            weakSelf?.configureTableCell(cell: cell, item: item)
            }, aRowSelectedListener: { (indexPath) in
                
        })
        tableView.reloadTableViewData(inView: view)
    }
    
    func configureTableCell(cell : Any?,item : Any?){
        
        guard let indexPath = item as? IndexPath else { return }
        
        if let currentCell = cell as? LaundryProductCell {
            let currentProduct = tableDataSource.laundryOrder?.arrDetailedSubCategories?[indexPath.section].arrProducts?[indexPath.row]
            currentCell.product = currentProduct
            currentCell.stepper.stepperValueListener = {
                [weak self] (value) in
                guard let self = self else { return }
                if let data = value as? Double {
                self.tableDataSource.laundryOrder?.arrDetailedSubCategories?[indexPath.section].arrProducts?[indexPath.row].quantity = String(data)
                }
                
                self.refreshNetAmount()
                self.tableView.reloadData()
            }
        }
        
    }
}

//MARK: - Button Actions
extension OrderViewController {
    
    @IBAction func actionCart(sender: UIButton) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionContinue(sender: AnyObject) {
        
        guard let arrDSC = tableDataSource.laundryOrder?.arrDetailedSubCategories else { return }
        var cartProducts : [Cart] = []
        for sc in arrDSC {
            guard let products = sc.arrProducts else { continue }
            for product in products {
                if let quantity = product.quantity, quantity != "0"{
                    cartProducts.append(product)
                }
            }
        }
        
        addToCartWebService(cart: cartProducts)
    }
}

extension OrderViewController {

    func addToCartWebService(cart : [Cart]){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.AddToCart(FormatAPIParameters.AddToCart(cart: cart, supplierBranchId: cart[0].supplierBranchId,promotionType: nil, remarks: nil).formatParameters())) { (response) in
            weak var weakSelf = self
            switch response {
            case .Success(let object):
                weakSelf?.handleAddToCart(cartProducts: cart, cartId: object)
            default: break
            }
        }
        
    }
    
    func handleAddToCart(cartProducts : [Cart],cartId : Any?){
        guard let tempCartId = cartId as? String else { return }
        let VC = StoryboardScene.Order.instantiateDeliveryViewController()
        VC.orderSummary = OrderSummary(items: cartProducts)
        VC.orderSummary?.pickupAddress = laundryData?.pickupAddress
        VC.orderSummary?.pickupDate = laundryData?.pickupDate
        VC.orderSummary?.cartId = tempCartId
        pushVC(VC)
    }
}

//MARK: - update Net Total

extension OrderViewController {
    func refreshNetAmount(){
        var amount : Double = 0.0
        guard let arrDetailCategories = tableDataSource.laundryOrder?.arrDetailedSubCategories else { return }
        for subCategory in arrDetailCategories {
            guard let products = subCategory.arrProducts else { continue }
            for product in products {
                guard let price = Double(product.price ?? "0.0"),let quantity = Double(product.quantity ?? "0") else { continue }
                amount += price * quantity
            }
        }
        
        labelNetAmount.text = amount.addCurrencyLocale
    }
}

//MARK: - TextField Methods

extension OrderViewController : UITextFieldDelegate {
    
    @IBAction func textFieldValueChanged(sender: UITextField) {

        var tempDetailSubCat : [DetailedSubCategories] = []
        for detailSubCat in laundryOrder?.arrDetailedSubCategories ?? [] {
            let filterProducts = detailSubCat.arrProducts?.filter({ (product) -> Bool in
                return /product.name?.lowercased().trim().hasPrefix((sender.text?.lowercased())!)
            })
            
            tempDetailSubCat.append(DetailedSubCategories(strTitle: detailSubCat.strTitle, products: filterProducts))
        }
        let laundryListing = LaundryProductListing()
        laundryListing.arrDetailedSubCategories = sender.text?.length == 0 ? laundryOrder?.arrDetailedSubCategories : tempDetailSubCat
        
        tableDataSource.laundryOrder = laundryListing
        view.updateConstraints()
        refreshNetAmount()
        tableView.reloadData()
    }
    
    @IBAction func actionSearch(sender: UIButton) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        constraintTableviewBottom?.constant = 260
        constraintHeader?.constant = 0
        view.layoutIfNeeded()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        constraintTableviewBottom.constant = 0
        if textField.text?.trim().length == 0 {
            constraintHeader?.constant = 136
        }
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

