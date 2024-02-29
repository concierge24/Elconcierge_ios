//
//  ProductDetailViewController.swift
//  Clikat
//
//  Created by cbl73 on 5/3/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import EZSwiftExtensions

class ProductDetailViewController: CategoryFlowBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton! {
        didSet {
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var suplierBranchId : String?
    var isPromotion : Bool = false
    var isPackage : Bool = false
    var product : ProductF? {
        didSet {
            product?.supplierBranchId = suplierBranchId
            lblProductTitle?.text = L10n.ItemDetail.string
            tableDataSource.product = product
            headerView.product = product

            ez.runThisAfterDelay(seconds: 0.2) {
                weak var weakSelf  = self
                weakSelf?.tableView?.isHidden = false
                guard let contentView = weakSelf?.view else { return }
                weakSelf?.tableView?.reloadTableViewData(inView: contentView)
            }
        }
    }
    var headerHeight = (ScreenSize.SCREEN_WIDTH * (3/4))+96
    let headerView = ProductInfoHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH, height: (ScreenSize.SCREEN_WIDTH * (3/4))+96))
    var tableDataSource = ProductDetailDataSource()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        webServiceProductDetail()
        AdjustEvent.ProductDetail.sendEvent()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTableHeaderView()
        reloadVisibleCells()
    }
}


//MARK: - WebService Methods
extension ProductDetailViewController {
    
    func webServiceProductDetail (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ProductDetail(FormatAPIParameters.ProductDetail(productId: passedData.productId,supplierBranchId: suplierBranchId,offer: isPromotion ? "3" : (isPackage ? "2" : nil)).formatParameters())) { (response) in
            
            weak var weak : ProductDetailViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.product = listing as? ProductF
                
            default :
                break
            }
        }
    }
    
}

extension ProductDetailViewController {
    
    func configureTableView(){
        
        tableDataSource = ProductDetailDataSource(
            product: product,
            height: UITableView.automaticDimension,
            tableView: tableView,
            cellIdentifier: nil,
            configureCellBlock: {
            [weak self] (cell, indexPath) in
            guard let self = self else { return }
            
            guard let currentCell = cell as? UITableViewCell else { return }
            self.configureTableViewCell(cell: currentCell,indexPath: indexPath)
            
            }, aRowSelectedListener: { (indexPath) in
                
            }, scrollViewListener: {
                [weak self](scrollView) in
                guard let self = self else { return }

                self.updateHeaderView(headerView: self.headerView)
        })
        
        defer{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    
    func configureTableHeaderView(){
        
        headerView.imageDelegate = self
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView(headerView: headerView)
    }
    
    func updateHeaderView(headerView : ProductInfoHeaderView){
        
        var headerRect = CGRect(x: 0, y: -headerHeight, width: ScreenSize.SCREEN_WIDTH, height: headerHeight )
        if (tableView.contentOffset.y < -headerHeight) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
        headerView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func configureTableViewCell(cell : UITableViewCell,indexPath : IndexPath){
        
        (cell as? SupplierDescriptionCell)?.htmlString = product?.desc
        if isPromotion {
            product?.category = "Promotion"
        }
        (cell as? ProductDetailFirstCell)?.product = product
        
    }
}


//MARK: - Image Click Delegate
extension ProductDetailViewController : ImageClickListenerDelegate {
    
    func imageCliked(atIndexPath indexPath: IndexPath, cell: UICollectionViewCell?, images: [SKPhoto]) {
        
        guard let currentCell = cell as? SupplierInfoHeaderCollectionCell , let originImage = currentCell.imageViewCover.image, images.count > 0 else{
            return
        }
        let browser = SKPhotoBrowser(originImage: originImage, photos: images, animatedFromView: currentCell)
        browser.initializePageIndex(indexPath.row)
        presentVC(browser)
        
    }
    
    
    
}
extension ProductDetailViewController {
    
    func reloadVisibleCells(){
        
        DBManager.sharedManager.getCart { (cartProducts) in
            weak var weakSelf = self
            let visibleCells = weakSelf?.tableView.visibleCells ?? []
            
            for visibleCell in visibleCells {
                guard let cell = visibleCell as? ProductDetailFirstCell else { return }
                cell.stepper.value = 0
                for cartProduct in cartProducts {
                    guard let product = cartProduct as? Cart,let quantity = product.quantity, cell.product?.id == product.id  else { return }
                    
                    cell.stepper.value = Double(quantity) ?? 0
                }
            }
        }
    }
}

//MARK: - Button Actions
extension ProductDetailViewController {
    
    @IBAction func actionSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
}
