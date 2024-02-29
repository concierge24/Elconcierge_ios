//
//  MyFavoritesViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class MyFavoritesViewController: ExpandingViewController {

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
    @IBOutlet weak var viewPlaceholder : UIView!
    @IBOutlet weak var imageViewbackground: UIImageView!{
        didSet{
            imageViewbackground.image = UIImageEffects.imageByApplyingDarkEffect(to: imageViewbackground.image)
        }
    }
    
    //MARK:- Variables
    
//    @IBOutlet var collectionView: UICollectionView!
    var dataSource = CollectionViewDataSource(){
        didSet{
//            collectionView?.dataSource = dataSource
//            collectionView?.delegate = dataSource
        }
    }
    var arraySuppliers : [Supplier]? {
        didSet{
            dataSource.items = arraySuppliers
            viewPlaceholder.isHidden = arraySuppliers?.count == 0 ? false : true
            collectionView?.reloadData()
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        AdjustEvent.Favourites.sendEvent()
        let nib = UINib(nibName: CellIdentifiers.SupplierCollectionCell, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: CellIdentifiers.SupplierCollectionCell)
        addGestureToView(toView: collectionView!)
//        configureCollectionView()
        webServiceFavorites()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
    
}

//MARK: - CollectionView delegates
extension MyFavoritesViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySuppliers?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.SupplierCollectionCell, for: indexPath)
        (cell as? SupplierCollectionCell)?.supplier = arraySuppliers?[indexPath.row]
        // configure cell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SupplierCollectionCell else { return }
        if !cell.isOpened {
            cell.cellIsOpen(true)
        }else {
            handleSelection(indexPath: indexPath)
        }
    }
    
    func handleSelection(indexPath : IndexPath){
        
        let arrayCat = arraySuppliers?[indexPath.row].categories ?? []
        if arrayCat.isEmpty {
            return
        }
        if arrayCat.count < 2 {
            let category = arrayCat.first
            let supplier = arraySuppliers?[indexPath.row]
            
            if SKAppType.type.isFood {
                //                let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
                let VC = RestaurantDetailVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier?.id ,subCategoryId: nil ,productId: nil,branchId: supplier?.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                pushVC(VC)
            } else {
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
                
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier?.id ,subCategoryId: nil ,productId: nil,branchId: supplier?.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                pushVC(VC)
            }
            
            return
        }
        
        let VC = StoryboardScene.Options.instantiateCategorySelectionController()
        VC.arrCategory = arraySuppliers?[indexPath.row].categories
        VC.supplier = arraySuppliers?[indexPath.row]
        
        if Localize.currentLanguage() == Languages.Arabic {
            VC.ISPushAnimation = true
            pushVC(VC)
            return
        }
        
        pushToViewController(VC)
    }
}
//MARK: - Web Service
extension MyFavoritesViewController {
    func webServiceFavorites (){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.MyFavorites(FormatAPIParameters.MyFavorites.formatParameters())) { (response) in
            
            weak var weak : MyFavoritesViewController? = self
            switch response{
                
            case .Success(let listing):
                weak?.arraySuppliers = (listing as? SupplierListing)?.suppliers
                
                weak?.collectionView?.reloadData()
                break
            default :
                break
            }
        }
    }
}

//MARK: - Button Actions
extension MyFavoritesViewController{
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
    }
    
}

//MARK: - Gesture Recognizer helpers
extension MyFavoritesViewController {
    
    private func addGestureToView(toView: UIView) {
        let gesutereUp = Init(UISwipeGestureRecognizer(target: self, action: #selector(MyFavoritesViewController.swipeHandler(sender:)))) {
            $0.direction = .up
        }
        
        let gesutereDown = Init(UISwipeGestureRecognizer(target: self, action: #selector(MyFavoritesViewController.swipeHandler(sender:)))) {
            $0.direction = .down
        }
        toView.addGestureRecognizer(gesutereUp)
        toView.addGestureRecognizer(gesutereDown)
    }
    
    @objc func swipeHandler(sender: UISwipeGestureRecognizer) {
//        let indexPath = NSIndexPath(forRow: currentIndex, inSection: 0)
        guard let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView)) else { return }
        guard case let cell as SupplierCollectionCell = collectionView?.cellForItem(at: indexPath) else {
            return
        }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            handleSelection(indexPath: indexPath)
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
    }
}
