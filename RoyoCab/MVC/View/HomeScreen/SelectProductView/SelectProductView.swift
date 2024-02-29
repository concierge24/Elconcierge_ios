//
//  SelectProductView.swift
//  Buraq24
//
//  Created by MANINDER on 05/10/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SelectProductView: UIView {
    
    //MARK:- Outlets
    
    @IBOutlet var collectionViewProduct: UICollectionView!
    @IBOutlet var constraintWidthCollection: NSLayoutConstraint!
    @IBOutlet weak var tableViewSelectARide: UITableView!
    @IBOutlet weak var buttonBook: UIButton!
    @IBOutlet weak var btnSchedule: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    //MARK:- Properties
    
    lazy var products : [ProductCab] = [ProductCab]()
    var collectionViewDataSource : CollectionViewDataSourceCab?
    
    var customVehicleTypeDataSource:TableViewDataSourceCab?
    
    var request : ServiceRequest?
    var modalPackages: TravelPackages?
    var delegate : BookRequestDelegate?
    
    var heightPopUp : CGFloat = UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3.0)
    
    var isAdded : Bool = false
    var viewSuper : UIView?
    
    
    
    //MARK:- Actions
    
    @IBAction func actionBtnCancelPressed(_ sender: UIButton) {
        
        self.delegate?.didSelectNext(type: .BackFromFreightProduct)
        minimizeProductView()
    }
    
    
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        guard let product =  self.request?.selectedProduct else{return}
        self.delegate?.didSelectedFreightProduct(product: product, isSchedule: false)
        minimizeProductView()
        
    }
    
    @IBAction func actionBtnSchedulePressed(_ sender: UIButton) {
        
        guard let product =  self.request?.selectedProduct else{return}
        self.delegate?.didSelectedFreightProduct(product : product, isSchedule: true)
        minimizeProductView()
    }
    
    //MARK:- Functions
    
    func minimizeProductView() {
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.frame = CGRect(x: BookingPopUpFrames.XPopUp , y: /self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
    
            }, completion: { (done) in
        })
    }
    
    func maximizeProductView() {
        
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .GoMove:
            buttonBook.setTitle("Next", for: .normal)
            break
        case .DeliverSome:
            lblTitle.text = "Select delivery type"
            lblSubTitle.text = "Choose a delivery type or swipe up for more."
            print("Deliver Some")
            
            break
            
        default:
            print("Defualt")
        }
        
        
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
          // ANkush  self?.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - CGFloat(BookingPopUpFrames.PaddingX) - /self?.heightPopUp , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            
            self?.frame = CGRect(x: 0, y: (/self?.viewSuper?.frame.origin.y + /self?.viewSuper?.frame.size.height) - /self?.heightPopUp + CGFloat(10) , width: BookingPopUpFrames.WidthPopUp, height: /self?.heightPopUp)
            self?.layoutIfNeeded()
            self?.setupUI()
            
            }, completion: { (done) in
        })
    }
    
    
    func setupUI() {
        buttonBook.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnSchedule.setButtonWithTitleAndBorderColorSecondary()
        btnSchedule.setButtonWithTintColorSecondary()
    }
    
    func showProductView(superView : UIView , moveType : MoveType , requestPara : ServiceRequest, modalPackages: TravelPackages?) {
          viewSuper = superView
        request = requestPara
        self.modalPackages = modalPackages
        
        products = requestPara.selectedBrand?.products ?? []

        if let modal = modalPackages {
            
            products.removeAll()
            
            guard let selectedBrand = modal.package?.pricingData?.categoryBrands?.filter({$0.categoryBrandId == requestPara.selectedBrand?.categoryBrandId}).first else {return}
            
            selectedBrand.products?.forEach({[weak self] (packageProduct) in
                
                guard let filteredObject = requestPara.selectedBrand?.products?.filter({$0.productBrandId == packageProduct.productBrandId}).first else {return}
                self?.products.append(filteredObject)
                
            })
        }
        
        if request?.selectedBrand?.categoryId == 4{
            
            btnSchedule.isHidden = true
        } else{
            btnSchedule.isHidden = false
        }
        
        
       // guard let productList = requestPara.selectedBrand?.products else{return}
        
       // products.append(contentsOf: productList)
        
       /* layer.cornerRadius = 13.0
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 21 */
        
       /* if requestPara.selectedBrand?.categoryBrandId == 20 { // for car
            
            let height = (UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3.0))
            heightPopUp =  UIDevice.current.iPhoneX ? height + 34  : height
            
        } else {
            heightPopUp =  UIDevice.current.iPhoneX ? 261 + 34  : 261
        } */
        
        let screenheightTwoThird = (UIScreen.main.bounds.height - (UIScreen.main.bounds.height / 3.0))
        
        heightPopUp = CGFloat((UIDevice.current.iPhoneX ? (176 + 34)  : 176) + (products.count * 85))
        heightPopUp = heightPopUp > screenheightTwoThird ? screenheightTwoThird : heightPopUp
        
        // 10 - for hide bottom corner radius
        self.frame = CGRect(x: BookingPopUpFrames.XPopUp, y: (superView.frame.origin.y + superView.frame.size.height) + 10 , width: BookingPopUpFrames.WidthPopUp, height: heightPopUp)
        
        if !isAdded {
            superView.addSubview(self)
            if products.count > 0 {
               // Ankush configureCollectionView()
                configureSelectARideTableView()
            }
            isAdded = true
        }
        
        if moveType == .Forward && products.count > 0 {
            
            request?.selectedProduct = products[0]
            customVehicleTypeDataSource?.items = products
            
          // Ankush  self.collectionViewDataSource?.items = products
            ez.runThisAfterDelay(seconds: 0.1, after: { [weak self] in
               // Ankush   self?.collectionViewProduct.reloadData()
                self?.tableViewSelectARide.reloadData()
                
            })
        }
       // Ankush let count = CGFloat(products.count)

       // Ankush constraintWidthCollection.constant = getCollectionCellWidth() * count

        maximizeProductView()
    }
    
    func configureSelectARideTableView() {
        
        tableViewSelectARide.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24.0, right: 0)
        
       // tableViewSelectARide.isScrollEnabled = false
        
        customVehicleTypeDataSource = TableViewDataSourceCab.init(items: nil , tableView: tableViewSelectARide, cellIdentifier: R.reuseIdentifier.vehicleTypeTableViewCell.identifier, cellHeight: 85.0)
        
        customVehicleTypeDataSource?.configureCellBlock = {[weak self] (cell , item, indexPath) in
            
//            if let cell = cell as? VehicleTypeTableViewCell, let model = item as? ProductCab {
//                
//                guard let product = self?.request?.selectedProduct else {return}
//                cell.request =  self?.request
//                cell.indexPath = indexPath
//                cell.markProductSelected(selected: model.productBrandId == product.productBrandId, model: model, modalPackages: self?.modalPackages)
//            }
        }
        
        customVehicleTypeDataSource?.aRowSelectedListener = { [weak self] (indexPath, cell, item) in
            
            
//            if let _ = cell as? VehicleTypeTableViewCell, let model = item as? ProductCab {
//                self?.request?.selectedProduct = model
//                self?.tableViewSelectARide.reloadData()
//            }
        }
        
        tableViewSelectARide.delegate = customVehicleTypeDataSource
        tableViewSelectARide.dataSource = customVehicleTypeDataSource
        tableViewSelectARide.reloadData()
    }
    

    
    private func getCollectionCellWidth() -> CGFloat {
        let count = 4
        let widthCollection = BookingPopUpFrames.WidthPopUp-32.0
        return widthCollection/CGFloat(count)
    }
    
    private func configureCollectionView() {
        
        let configureCellBlock : ListCellConfigureBlockCab = {
            [weak self] (cell, item, indexPath) in
            
            if let cell = cell as? SelectBrandCell, let model = item as? ProductCab {
                
                guard let product = self?.request?.selectedProduct else {return}
                cell.markProductSelected(selected: model.productBrandId == product.productBrandId, model: model)
            }
            
        }
        
        let didSelectBlock : DidSelectedRowCab = { [weak self] (indexPath, cell, item) in
            
            if let _ = cell as? SelectBrandCell, let model = item as? ProductCab {
                self?.request?.selectedProduct = model
                self?.collectionViewProduct.reloadData()
            }
        }
        
        
        
        let widthColl = getCollectionCellWidth()
        let heightColl = collectionViewProduct.frame.height//.width/2.5
        
        collectionViewDataSource = CollectionViewDataSourceCab(items:  products , collectionView: collectionViewProduct, cellIdentifier: R.reuseIdentifier.selectBrandCell.identifier, cellHeight:  heightColl, cellWidth: widthColl , configureCellBlock: configureCellBlock, aRowSelectedListener: didSelectBlock)
        collectionViewProduct.delegate = collectionViewDataSource
        collectionViewProduct.dataSource = collectionViewDataSource
        collectionViewProduct.reloadData()
    }
    
}


