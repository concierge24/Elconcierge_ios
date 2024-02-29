//
//  PackageSupplierListingViewController.swift
//  Clikat
//
//  Created by Night Reaper on 23/05/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class PackageSupplierListingViewController: CategoryFlowBaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var constraintTableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet var tableView: UIExpandableTableView!{
        didSet{
            tableView.register(UINib(nibName: CellIdentifiers.SupplierListingCell,bundle: nil), forCellReuseIdentifier: CellIdentifiers.SupplierListingCell)
        }
    }
    @IBOutlet weak var viewBg: UIView!{
        didSet{
            viewBg.layer.borderWidth = 0.5
            viewBg.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var viewPlaceholder: UIView!
    
    //MARK:- Variables
    var suppliers : [Supplier]? = []{
        didSet{
            tableViewDataSource.items = suppliers
            viewPlaceholder?.isHidden = (suppliers?.count ?? 0) > 0 ? true : false
            tableView?.reloadTableViewData(inView: view)
        }
    }
    var tableViewDataSource = TableViewDataSource(){
        didSet{
            tableView?.dataSource = tableViewDataSource
            tableView?.delegate = tableViewDataSource
        }
    }
    var filters : FilterAssocitedValue = .Filter([],[],[],[],.DoesntMatter)

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        webServiceSupplierListing()
        
    }
}

//MARK: - WebService Methods
extension PackageSupplierListingViewController {
    
    func webServiceSupplierListing (){
        
        let parameters = FormatAPIParameters.PackageSupplierListing.formatParameters()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.PackageSupplierListing(parameters)) { (response) in
            
            weak var weak : PackageSupplierListingViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.suppliers = (listing as? SupplierListing)?.suppliers
                
            default :
                break
            }
        }
    }
    
}

//MARK: - Button Actions
extension PackageSupplierListingViewController {
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionFilter(sender: UIButton) {
        
//        let filterVC = FilterVC.getVC(.main)
//        filterVC.delegate  = self
//        filterVC.filters = filters
//        pushVC(filterVC)
    }
    
}




//MARK: - SearchField handlers

extension PackageSupplierListingViewController : UITextFieldDelegate {
    
    @IBAction func textFieldValueChanged(sender: UITextField) {
        let filterSuppliers = suppliers?.filter({ (supplier) -> Bool in
            guard let match = supplier.name?.contains(sender.text!, compareOption: .caseInsensitive) else { return false }
            return match
        })
        tableViewDataSource.items = sender.text?.count == 0 ? suppliers : filterSuppliers
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
