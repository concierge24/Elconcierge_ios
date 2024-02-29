//
//  LoyalityPointsViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class LoyalityPointsViewController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
        }
    }
    @IBOutlet var btnRedeem: UIButton!{
        didSet{
            btnRedeem?.kern(kerningValue: ButtonKernValue)
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!{
        didSet{
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.allowsMultipleSelection = true
        }
    }
    
    //MARK:- Variables
    var selectedProducts : [LoyalityPoints] = []
    var header : LoyalityPointsHeader?
    var loyalityPointsListing : LoyalityPointsListing? {
        didSet{
            collectionView?.reloadData()
        }
    }
    var selectedIndexPath : [IndexPath] = []{
        didSet{
            
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        AdjustEvent.LoyaltyPoints.sendEvent()
        let width = collectionView?.bounds.width ?? 0
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: width, height: ScreenSize.SCREEN_WIDTH * 0.6)
        webServiceLoyalityPoints()
        
    }
    
}
//MARK: - Web Service
extension LoyalityPointsViewController {
    func webServiceLoyalityPoints(){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LoyalityPointScreen(FormatAPIParameters.LoyalityPointScreen.formatParameters())) { (response) in
            
            weak var weak : LoyalityPointsViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.loyalityPointsListing = (listing as? LoyalityPointsListing)
            default :
                break
            }
        }
        
    }
}

//MARK: - Button Actions
extension LoyalityPointsViewController {
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionRedeem(sender: AnyObject) {
        
        if selectedProducts.count == 0 {
           return
        }
        
        guard let strTotalPoints = loyalityPointsListing?.totalPoints, strTotalPoints != "0" else {
            SKToast.makeToast(L10n.YouHavenTEarnedAnyLoyaltyPointsYet.string)
            return
        }
       
        var totalSelectedPoints = 0
        for product in selectedProducts {
            guard let points = Int(product.loyalty_points ?? "0") else { return }
            totalSelectedPoints += points
        }
        if (Int(strTotalPoints) ?? 0) < totalSelectedPoints {
            SKToast.makeToast(L10n.SorryNotEnoughPointsToRedeem.string)
            return
        }
        
        let VC = StoryboardScene.Order.instantiateDeliveryViewController()
        VC.cartFlowType = .LoyaltyPoints
        let summary = LoyaltyPointsSummary(items: selectedProducts, netTotal: String(totalSelectedPoints) + " " + L10n.Points.string)
        summary.totalPoints = totalSelectedPoints.toString
        VC.loyaltyPointsSummary = summary
        
        pushVC(VC)
    }
    
    @IBAction func actionBtnOrders(sender: UIButton) {
        
        let VC = StoryboardScene.Options.instantiateLoyaltyPointOrdersController()
        VC.orders = loyalityPointsListing?.orders
        pushVC(VC)
    }
    
}

//MARK: - CollectionView DataSource and Delegates
extension LoyalityPointsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.LoyalityPointsCell ,for: indexPath)
        (cell as? LoyalityPointsCell)?.loyalityPoints = loyalityPointsListing?.arrProduct?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loyalityPointsListing?.arrProduct?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else{
            return CGSize.zero
        }
        let numberOfColoumns = 2
        let padding = (layout.sectionInset.left + layout.sectionInset.right + CGFloat(numberOfColoumns - 1) * (layout.minimumLineSpacing))
        let width = floor(((view.bounds.width - padding)  / CGFloat(numberOfColoumns)))
        let height = width + 64.0
        return CGSize(width : width, height: height)
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellIdentifiers.LoyalityPointsHeader , for: indexPath) as! LoyalityPointsHeader
            headerView.backgroundColor = UIColor.clear
            headerView.lblLoyalityPoints?.text = loyalityPointsListing?.totalPoints ?? "0"
            updatePoints()
            header = headerView
            return headerView
            
        default: return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as? LoyalityPointsCell
        cell?.imgTick.isHidden = selectedIndexPath.contains(indexPath) == true ? false : true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        handleCellSelection(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        handleCellSelection(indexPath: indexPath)
    }
    
    func updatePoints() -> Bool{
        guard let totalPoints = loyalityPointsListing?.totalPoints?.toInt() else { return false}
        
        let price = selectedProducts.reduce(0, { (initial, product) -> Int in
            
            return initial + (product.loyalty_points?.toInt() ?? 0)
        })
        
        if totalPoints < price {
            return false
        }
        header?.lblLoyalityPoints.text = (totalPoints - price).toString
        return true
    }
    
    
    func handleCellSelection(indexPath : IndexPath){
    
        guard let strTotalPoints = loyalityPointsListing?.totalPoints, strTotalPoints != "0" else {
            SKToast.makeToast(L10n.YouHavenTEarnedAnyLoyaltyPointsYet.string)
            return
        }
        
        
        guard let currentProduct = loyalityPointsListing?.arrProduct?[indexPath.row],let currentSupplierId = currentProduct.supplier_id else { return }
        
        
        
        
        
        
        for product in selectedProducts {
            if currentSupplierId != product.supplier_id {
                if selectedProducts.count > 0 {
                    SKToast.makeToast(L10n.SelectProdutsFromSameSupplier.string)
                    return
                }
            }
        }
        
        
       

        
        if !selectedIndexPath.contains(indexPath){
            selectedIndexPath.append(indexPath)
            selectedProducts.append(currentProduct)
            
        }else {
            
            if let index = selectedIndexPath.index(of:indexPath) {
                selectedIndexPath.remove(at: index)
            }
            if let index = selectedProducts.index(of:currentProduct) {
                selectedProducts.remove(at: index)
            }
            
        }
        
        
        //Haspinder Singh
        if !updatePoints(){
            if selectedIndexPath.contains(indexPath){
                if let index = selectedIndexPath.index(of:indexPath) {
                    selectedIndexPath.remove(at: index)
                }
                if let index = selectedProducts.index(of:currentProduct) {
                    selectedProducts.remove(at: index)
                }
            }
            SKToast.makeToast(L10n.SorryNotEnoughPointsToRedeem.string)
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? LoyalityPointsCell else{
            return
        }
        cell.imgTick?.isHidden = !(/cell.imgTick?.isHidden)
    }
    
}
