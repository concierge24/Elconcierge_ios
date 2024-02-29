//
//  SearchViewController.swift
//  Clikat
//
//  Created by cblmacmini on 4/29/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

let SearchTableViewCellHeight : CGFloat = 240.0

class SearchViewController: CategoryFlowBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton! {
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet var viewPlaceholder: UIView!
    @IBOutlet var lblPlaceholder: UILabel!{
        didSet{
            lblPlaceholder.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagsView: TLTagsControl!{
        didSet{
            tagsView.tagPlaceholder = L10n.Search.string
            tagsView.tagsBackgroundColor = Colors.MainColor.color()
            tagsView.tagsTextColor = UIColor.white
            tagsView.tagInputField?.returnKeyType = .done
        }
    }
    
    @IBOutlet weak var viewBg: UIView!{
        didSet{
            viewBg.layer.borderWidth = 1.0
            viewBg.layer.borderColor = Colors.lightGrayBackgroundColor.color().cgColor
        }
    }
    
    //MARK:- Variables
    var tableDataSource = SearchDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var searchResults : SearchResult? {
        didSet{
            ez.runThisAfterDelay(seconds: 0.2, after: {
                weak var weakSelf : SearchViewController? = self
                weakSelf?.tableDataSource.items = weakSelf?.searchResults?.arrSearchResults
                weakSelf?.tableView?.reloadTableViewData(inView: weakSelf?.view)
                
                guard let results = weakSelf?.searchResults?.arrSearchResults, results.count > 0 else{
                    weakSelf?.tableView?.isHidden = true
                    weakSelf?.viewPlaceholder?.isHidden = false
                    return
                }
                weakSelf?.tableView?.isHidden = false
                weakSelf?.viewPlaceholder?.isHidden = true
                
            })
        }
    }
    
}
//MARK: - View Hierarchy Methods

extension SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadVisibleCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tagsView?.tagInputField?.becomeFirstResponder()
    }
}



extension SearchViewController {
    
    func reloadVisibleCells(){
        DBManager.sharedManager.getCart { (cartProducts) in
            weak var weakSelf = self
            let tableVisibleCells = weakSelf?.tableView.visibleCells ?? []
            
            for tableVisibleCell in tableVisibleCells {
                guard let cell = tableVisibleCell as? SearchTableCell else { return }
                
                let collectionVisibleCells = cell.collectionView.visibleCells
                
                for collecitonVisibleCell in collectionVisibleCells {
                    guard let cell = collecitonVisibleCell as? ProductCollectionCell else { return }
                    cell.stepper.value = 0
                    for cartProduct in cartProducts {
                        guard let product = cartProduct as? Cart,let quantity = product.quantity, cell.product?.id == product.id  else { break }
                        
                        cell.stepper.value = Double(quantity) ?? 0
                    }
                }
            }
        }
    }
}

//MARK: - WebService Methods
extension SearchViewController {
    
    func webServiceMultiSearch (withKeys keys : String?){
        
        guard let tempKeys = keys else{
            return
        }
        
        let parameters = FormatAPIParameters.MultiSearch(supplierBranchId: passedData.supplierBranchId ?? "" , categoryId: passedData.categoryId ?? "", searchList: tempKeys).formatParameters()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.MultiSearch(parameters)) { (response) in
            
            weak var weak : SearchViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.searchResults = (listing as? SearchResult)
                break
            default :
                break
            }
        }
    }
    
}


extension SearchViewController {
    
    func configureTableView(){

        tableDataSource = SearchDataSource(items: searchResults?.arrSearchResults, height: SearchTableViewCellHeight , tableView: tableView, cellIdentifier: CellIdentifiers.SearchTableCell, configureCellBlock: { (cell, item) in
            
            guard let c = cell as? SearchTableCell,let searchResult = item as? Search else { return }
            c.delegate = self
            c.configureCollectionView(arrProducts: searchResult.arrProducts)
            }, aRowSelectedListener: { (indexPath) in
                
        })
    }
}




//MARK: - Button Actions 

extension SearchViewController {
    
    @IBAction func actionMultiSearch(sender: AnyObject) {
        view.endEditing(true)
        
        if (tagsView.tagInputField.text ?? "").count > 0{
            tagsView?.addTag(tagsView.tagInputField.text)
        }
        guard let tags = tagsView?.tags, tags.count > 0 else{
            return
        }
        webServiceMultiSearch(withKeys: tags.componentsJoined(by: ","))
        tagsView?.tagInputField?.text = ""
    }
    
    @IBAction func actionSideMenu(sender: UIButton) {
        toggleSideMenuView()
    }
    
    @IBAction func actionFilter(sender: UIButton) {
    }
    
    @IBAction func actionCart(sender: UIButton) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
    @IBAction func actionBack(sender: UIButton) {
        popVC()
    }
}

extension SearchViewController : SearchProductDelegate {
    
    func productClicked(atIndexPath indexPath: IndexPath, product: ProductF?) {
        let productDetailVc = StoryboardScene.Main.instantiateProductDetailViewController()
        productDetailVc.passedData.productId = product?.id
        productDetailVc.suplierBranchId = product?.supplierBranchId
        pushVC(productDetailVc)
    }
}




