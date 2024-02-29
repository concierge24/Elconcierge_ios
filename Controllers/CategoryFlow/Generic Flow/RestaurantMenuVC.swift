//
//  RestaurantMenuVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 10/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import SkeletonView
import EZSwiftExtensions
import AVKit
import AVFoundation


protocol UpdateCartProtocol: class {
    func updateList()
}

class RestaurantMenuVC: CategoryFlowBaseViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var cartView_heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnPlayVideo: UIButton!

    // Restaurant Header Info View outlets
    @IBOutlet weak var imgRestaurantCover: UIImageView!
    @IBOutlet weak var btnFav: UIButton! {
        didSet {
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.id {
                btnFav.isHidden = /AppSettings.shared.appThemeData?.is_supplier_wishlist != "1"
            } else{
                btnFav.isHidden = true
            }
        }
    }
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var lblNationality: UILabel!
    
    @IBOutlet weak var viewSpeciality: UIView!
    @IBOutlet weak var lblSpeciality: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var viewBrand: UIView!
    @IBOutlet weak var viewNationality: UIView!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var btnInstaLink: UIButton!
    @IBOutlet weak var btnFbLink: UIButton!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblSupplierRating: UILabel!
    @IBOutlet weak var lblSupplierRatingText: UILabel!
    @IBOutlet weak var lblSupplierAddress: UILabel!
    @IBOutlet weak var lblSupplierName: UILabel!
    @IBOutlet weak var imgSupplier: UIImageView!
    @IBOutlet var constHeightPrescription: NSLayoutConstraint!
    
    
    @IBOutlet var viewStatusBar: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCells(nibNames: [ProductListCell.identifier,FlickeringRestMenuCell.identifier])
            //            tableView.tableFooterView = UIView()
            //            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 90
        }
    }
    @IBOutlet weak var menu_button: UIButton! {
        didSet{
            menu_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            menu_button.isUserInteractionEnabled = false
            if let term = TerminologyKeys.catalogue.localizedValue() as? String{
                menu_button.setTitle(term, for: .normal)
            }
        }
    }
    
    //MARK:- ======== Variables ========
    //    var topConstraintRange = ((CGFloat(72) + ez.screenStatusBarHeight - 20)..<CGFloat(300))
    //    var oldContentOffset = CGPoint.zero
    var isFilterEnable : Bool = false
    var isSearchBarClicked : Bool = false
    var filterData : [ProductList]?
    var tileForSection : [String]?
    var arrayProductList : [ProductList]? {
        didSet {
            tableView?.reloadData()
        }
    }
    var supplierData: Supplier?
    var collectionDataSource = SupplierInfoHeaderDataSource()
    var isOpen: Bool = true
    
    //MARK:- ======== LifeCycle ========
    @objc func updateDelegate() {
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.startSkeletonAnimation(tableView)
        
        lblPrescriptionImageName.isHidden = true
        btnCancel.isHidden = true
        constHeightPrescription.constant = 0
        
        getProductListing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sizeHeaderToFit()
    }
    
    func setupHeaderData() {
        if let supplier = passedData.supplier {
            if supplier.user_request_flag == 1 {
                constHeightPrescription.constant = 72
            }
            lblSupplierAddress.text = /supplier.address
            lblSupplierRating.text = "\(/supplier.rating?.toDouble())"
            lblSupplierName.text = /supplier.name
            imgSupplier.loadImage(thumbnail: /supplier.logo, original: nil)
            lblDeliveryTime.text = "\(/supplier.deliveryMaxTime)\("mins".localized())"
            btnFav.isSelected = supplier.Favourite == "1" ? true : false
            
            let calendar = Calendar(identifier: .gregorian)
            var currentWeekday = calendar.component(.weekday, from: Date()) - 2
            
            currentWeekday = currentWeekday < 0 ? 6 : currentWeekday
            
            let currentDayObj = supplier.timing?.first(where: {/$0.week_id == currentWeekday})
            
            if /currentDayObj?.is_open == 1 {
                let currentTime = Date().toStringTime().toDate(format: .time) ?? Date()
                if currentDayObj?.start_time?.toDate(format: .time) ?? Date() < currentTime && currentTime < currentDayObj?.end_time?.toDate(format: .time) ?? Date() {
                    lblDeliveryStatus.text = "Open".localized()
                }else {
                    isOpen = false
                    lblDeliveryStatus.text = "Closed".localized()
                }
            }else {
                isOpen = false
                lblDeliveryStatus.text = "Closed".localized()
            }
            
            if /supplier.speciality?.isEmpty {
                headerView.frame.size.height = headerView.frame.size.height-13
            }else {
                viewSpeciality.isHidden = false
                lblSpeciality.text = supplier.speciality
            }
            if /supplier.nationality?.isEmpty {
                headerView.frame.size.height = headerView.frame.size.height-13
            }else {
                viewNationality.isHidden = false
                lblNationality.text = supplier.nationality

            }
            if /supplier.brand?.isEmpty {
                headerView.frame.size.height = headerView.frame.size.height-13
            }else {
                viewBrand.isHidden = false
                lblBrand.text = supplier.brand
            }
            
            if !(/supplier.facebook_link?.isEmpty) {
                btnFbLink.isHidden = false
            }
            if !(/supplier.linkedin_link?.isEmpty) {
                btnInstaLink.isHidden = false
            }


            collectionView.register(UINib(nibName: CellIdentifiers.SupplierInfoHeaderCollectionCell,bundle: nil), forCellWithReuseIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell)
            
            btnPlayVideo.isHidden = true

            if /supplier.supplierImages?.count > 0 {
                
//                self.configureCollectionView()
//                imgRestaurantCover.isHidden = true
                
                if let img = supplier.supplierImages?.first {
                    if img.contains(".mp4") {
                        imgRestaurantCover.image = URL(string: img)?.generateThumbnail()
                        btnPlayVideo.isHidden = false
                    }else {
                        imgRestaurantCover.loadImage(thumbnail: img, original: nil)
                    }
                }
            }else {
                imgRestaurantCover.loadImage(thumbnail: /supplier.logo, original: nil)
            }
            tableView.sizeHeaderToFit()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        setupHeaderData()
        
    }
    
    @IBAction func actionFbLink(_ sender: Any) {
        passedData.supplier?.facebook_link?.openWebLink()
    }
    @IBAction func actionInstaLink(_ sender: Any) {
        passedData.supplier?.linkedin_link?.openWebLink()
    }
    @IBAction func actionPlayVideo(_ sender: Any) {
        if let url = URL(string: /passedData.supplier?.supplierImages?.first) {
            let player = AVPlayer(url: url)

            let vc = AVPlayerViewController()
            vc.player = player

            self.present(vc, animated: true) { vc.player?.play() }
        }
        
    }
    @IBAction func buttonBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func btnSearchAction(_ sender: Any) {
        
        //        isFilterEnable = !isFilterEnable
        // viewHeaderTable.btnManu.isHidden = isFilterEnable
        // viewHeaderTable.lblBlank.isHidden = isFilterEnable
        //  viewHeaderTable.btnSearch.isHidden = isFilterEnable
        // viewHeaderTable.searchBar.isHidden = !isFilterEnable
        //        viewHeaderTable.searchBar.becomeFirstResponder()
        
        let VC = MenuSearchVC.getVC(.splash)
        VC.arrayProducts = self.arrayProductList
        VC.delegate = self
        self.presentVC(VC)
        
    }
    
    @IBAction func actionCart(sender: AnyObject) {
        pushVC(StoryboardScene.Options.instantiateCartViewController())
        
    }
    
    func scrollToCat(id: String) {
        
    }
    
    @IBAction func favourite_buttonAction(_ sender: UIButton) {
        
        
        if sender.isSelected {
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.UnFavoriteSupplier(FormatAPIParameters.UnFavoriteSupplier(supplierId: passedData.supplier?.id).formatParameters()), completion: { [weak self] (response) in
                
                guard let self = self else { return }
                
                print(response)
                
                switch response{
                case APIResponse.Success( _):
                    print("Done")
                    
                    sender.isSelected = !sender.isSelected

                    self.supplierData?.Favourite = "0"

                    SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") removed from \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")

                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "FavouritePressed"),object: self.supplierData))

                default : break
                    
                }
            })
            
        } else {
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.MarkSupplierFav(FormatAPIParameters.MarkSupplierFavorite(supplierId: passedData.supplier?.id).formatParameters()), completion: { [weak self] (response) in
                
                guard let self = self else { return }
                
                print(response)
                
                switch response{
                case APIResponse.Success( _):
                                  
                    sender.isSelected = !sender.isSelected
                    
                    self.supplierData?.Favourite = "1"
                    
                    SKToast.makeToast("\((TerminologyKeys.supplier.localizedValue() as? String) ?? "Supplier") added to \((TerminologyKeys.wishlist.localizedValue() as? String) ?? "Wishlist")")

                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "FavouritePressed"),object: self.supplierData))

                    print("Done")
                    
                default : break
                    
                }
            })
        }
        
    
    }
    
    @IBAction func menu_buttonAction(_ sender: UIButton) {
        if filterData?.count == 0 {return}
        let frame = sender.bounds
        let popoverContentController = PopOverVC.getVC(.splash)
        popoverContentController.modalPresentationStyle = .popover
        popoverContentController.filterData = filterData
        
        var height = 0
        if let data = filterData{
            height = (data.count * 50) + 50
        }
        
        if let popoverPresentationController = popoverContentController.popoverPresentationController {
            popoverContentController.preferredContentSize = CGSize(width: 200, height: height)
            popoverPresentationController.permittedArrowDirections = .down
            popoverPresentationController.sourceView = sender
            popoverPresentationController.sourceRect = frame
            popoverPresentationController.delegate = self
            popoverPresentationController.dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            present(popoverContentController, animated: true, completion: nil)
            
            popoverContentController.blockSelectSection = {
                [weak self] section in
                self?.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: true)
                if let cell = self?.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                    self?.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self?.tableView.frame.height ?? 0.0), animated: true)
                }
            }
        }
    }
    
    //UIPopoverPresentationControllerDelegate inherits from UIAdaptivePresentationControllerDelegate, we will use this method to define the presentation style for popover presentation controller
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //UIPopoverPresentationControllerDelegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFilterEnable = true
        
        filterData = searchText.isEmpty ? arrayProductList : arrayProductList?.filter({($0.productValue?.contains(where: {($0.name?.lowercased().contains(searchText.lowercased()) ?? false)}) ?? false)})
        //        filterData = searchText.isEmpty ? arrayProductList : arrayProductList?.filter { (item: ProductList) -> Bool in
        //            return item.productValue?.first?.name?.lowercased().contains(searchText.lowercased()) ?? false
        //        }
        print(filterData)
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        viewHeaderTable.searchBar.showsCancelButton = true
        isSearchBarClicked = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        isFilterEnable = false
        isSearchBarClicked = false
        self.filterData = self.arrayProductList
        //     viewHeaderTable.btnManu.isHidden = isFilterEnable
        //  viewHeaderTable.lblBlank.isHidden = isFilterEnable
        //   viewHeaderTable.btnSearch.isHidden = isFilterEnable
        //   viewHeaderTable.searchBar.isHidden = !isFilterEnable
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        
    }
    
}

extension RestaurantMenuVC : UpdateCartProtocol {
    func updateList() {
        self.tableView.reloadData()
    }
}

//MARK:- ======== Api's ========
extension RestaurantMenuVC {
    
    func getProductListing()  {
        var lati : Double?
        var longi: Double?
        
        if let _ = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
            
        } else if let _ = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0
        }
        
        let objR = API.getProductList(supplierId: /passedData.supplierId, latitude: lati ?? nil, longitude: longi ?? nil)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: false, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            self.stopSkeletonAnimation(self.tableView)
            switch response {
            case APIResponse.Success(let object):
                guard let objModel = object as? MenuProductSection else { return }
                self.arrayProductList = objModel.arrayProduct ?? []
                self.supplierData = objModel.supplier
                self.passedData.supplier = objModel.supplier
                self.setupHeaderData()
                self.filterData = self.arrayProductList
                self.tileForSection = self.arrayProductList?.compactMap({ $0.catName})
                
                //                self.viewHeaderTable.supplier = objModel.supplier
                
                if let section = self.arrayProductList?.firstIndex(where: { $0.catName?.lowercased() ==  /self.passedData.categoryName?.lowercased() }) {
                    //                    self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: true)
                    
                    // self.tableView.scrollToRow(at: IndexPath(row: NSNotFound, section: section), at: .middle, animated: false)
                    if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: section)) {
                        //self.tableView.scrollRectToVisible(CGRect(x: 0, y: cell.frame.minY-40.0-35.0-44.0, w: cell.frame.width, h: self.tableView.frame.height ), animated: false)
                    }
                }
                self.menu_button.isUserInteractionEnabled = true
                break
            default :
                break
            }
        }
    }
    
    func openCustomizationView(cell:ProductListCell?,product: ProductF?,cartData: Cart?,quantity: Double?,shouldHide:Bool = false,index:Int?) {
        
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

//MARK:- UITableViewDelegate , UITableViewDataSource
extension RestaurantMenuVC : UITableViewDelegate , SkeletonTableViewDataSource {
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return FlickeringRestMenuCell.identifier
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return isFilterEnable ? (/filterData?.count) : (/arrayProductList?.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isFilterEnable ? (filterData?[section].productValue?.count ?? 0) : (arrayProductList?[section].productValue?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.identifier) as? ProductListCell else {
            fatalError("Missing ServiceCell identifier")
        }
        cell.selectionStyle = .none
        let obj = isFilterEnable ? filterData?[indexPath.section] : arrayProductList?[indexPath.section]
        let products = obj?.productValue
        cell.isOpen = self.isOpen
        cell.selectedIndex = indexPath.row
        if let data = products?[indexPath.row] {
            data.supplierAddrerss = self.supplierData?.address ?? ""
            cell.product = data
//            let subCatArr = obj?.detailedSubCategory?.filter({ $0.id == data.detailed_sub_category_id })
//            let count = subCatArr?.count ?? 0
            let firstIndex = products?.firstIndex(where: { $0.detailed_sub_category_id == data.detailed_sub_category_id})
            if indexPath.row == firstIndex {
                cell.headerTitle = obj?.detailedSubCategory?.first(where: { $0.id == data.detailed_sub_category_id })?.name
            }
            else {
                cell.headerTitle = nil
            }
            let purchased = data.purchasedQuantity
            let total = data.totalMaxQuantity
            
            if (total-purchased) == 0 {
                cell.labelOutOfStock.isHidden = false
                cell.stepper?.isHidden = true
            } else {
                cell.labelOutOfStock.isHidden = true
                cell.stepper?.isHidden = false
            }
            
            cell.lblSupplierName?.isHidden = true
            cell.viewSingleStarRating.isHidden = true
            if AppSettings.shared.appThemeData?.is_health_theme == "1" {
                cell.viewSingleStarRating.isHidden = false
                cell.viewPrescriptionReq.isHidden = data.prescription_required != "1"
                cell.btnMoreDetails.isHidden = false
                cell.btnMoreDetails.semanticContentAttribute = .forceRightToLeft
                
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
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        return CGFloat.leastNormalMagnitude//0.001
    //    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return isFilterEnable ? (filterData?[section].catName ?? "") : (arrayProductList?[section].catName ?? "")
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableSectionHeader"),
    //            let lblTitle = cell.contentView.viewWithTag(11) as? UILabel else {
    //                fatalError("Missing ServiceCell identifier")
    //        }
    //        let products = isFilterEnable ? filterData?[section] : arrayProductList?[section]
    //        lblTitle.text = /products?.catName
    //        return cell
    //    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pushNextVc()
        if SKAppType.type.isJNJ {
            return
        }
        //        let obj: ProductList? = isFilterEnable ? filterData?[indexPath.section] : arrayProductList?[indexPath.section]
        //        obj?.productValue?[indexPath.row].openDetail()
        
        let products = isFilterEnable ? filterData?[indexPath.section].productValue : arrayProductList?[indexPath.section].productValue
        guard let data = products?[indexPath.row].desc else { return }
        
        let vc = RestaurantDescVC.getVC(.options)
        vc.data = data
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        
        self.present(vc, animated: true) {
            // self.createTempView()
        }
    }
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //        let delta =  scrollView.contentOffset.y - oldContentOffset.y
    //        viewHeaderTable.frame.origin.y = scrollView.contentOffset.y
    //
    //        var height = viewHeaderTable.frame.size.height
    //
    //        if delta > 0 && viewHeaderTable.frame.height > topConstraintRange.lowerBound && scrollView.contentOffset.y > -topConstraintRange.upperBound {
    //            height -= delta
    //        }
    //
    //        if delta < 0 && viewHeaderTable.frame.height < topConstraintRange.upperBound && scrollView.contentOffset.y < 0 {
    //            height -= delta
    //        }
    //
    //        height = [height, topConstraintRange.lowerBound].max() ?? 0.0
    //        height = [height, topConstraintRange.upperBound].min() ?? 0.0
    //        if height <= topConstraintRange.lowerBound {
    //            viewStatusBar.alpha = 1
    //            backButton.isHidden = true
    //        }
    //        else {
    //            viewStatusBar.alpha = 0
    //            backButton.isHidden = false
    //        }
    //        viewHeaderTable.frame.size.height = height
    //        if isSearchBarClicked {
    //            scrollView.contentOffset.y =  oldContentOffset.y
    //        }
    //        oldContentOffset = scrollView.contentOffset
    //
    //        scrollView.insertSubview(viewHeaderTable, at: scrollView.subviews.count-1)
    //        //        viewHeaderTable.bringSubviewToFront(scrollView)
    //    }
}

////MARK:- UIViewControllerTransitioningDelegate
//extension RestaurantMenuVC : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}


extension RestaurantMenuVC {
    
    func configureCollectionView(){
        
        //        let pages = supplier?.supplierImages?.count ?? 0
        
        let images = passedData.supplier?.supplierImages ?? []
        
        collectionDataSource = SupplierInfoHeaderDataSource(
            items: images,
            tableView: collectionView,
            cellIdentifier: CellIdentifiers.SupplierInfoHeaderCollectionCell,
            headerIdentifier: nil,
            cellHeight: 190,
            cellWidth: ScreenSize.SCREEN_WIDTH,
            configureCellBlock: {
                (cell, item) in
                
                if let cell = cell as? SupplierInfoHeaderCollectionCell,
                    let imageUrl = item as? String
                {
                    cell.btnPlay.isHidden = true
                    
                    if imageUrl.contains(".mp4") {
                        cell.imageViewCover.image = URL(string: imageUrl)?.generateThumbnail()
                        cell.btnPlay.isHidden = false
                    }else {
                        cell.imageViewCover.loadImage(thumbnail: imageUrl, original: nil)
                    }
                    
                }
                
        }, aRowSelectedListener: {
            [weak self] (indexPath) in
            guard let self = self else { return }
            if let url = URL(string: /self.passedData.supplier?.supplierImages?[indexPath.row]) {
                if url.absoluteString.contains(".mp4") {
                    let player = AVPlayer(url: url)

                    let vc = AVPlayerViewController()
                    vc.player = player

                    self.present(vc, animated: true) { vc.player?.play() }
                }
                
            }
//            self.imageDelegate?.imageCliked(atIndexPath: indexPath, cell: self.collectionView?.cellForItem(at: indexPath), images: self.imagesToSKPhotoArray(withImages: images, caption: nil) ?? [])
            
        }) { [weak self] (scrollView) in
            guard let self = self else { return }
        }
        
        collectionView.delegate = collectionDataSource
        collectionView.dataSource = collectionDataSource
    }
    
}
