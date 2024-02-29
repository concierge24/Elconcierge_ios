//
//  DoctorHomeVC.swift
//  Sneni
//
//  Created by Daman on 17/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class DoctorHomeVC: CategoryFlowBaseViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lblAddress: UILabel!
    
    var homeDataSource : DoctorHomeDataSource? = DoctorHomeDataSource() {
        didSet {
            tableView.dataSource = homeDataSource
            tableView.delegate = homeDataSource
        }
    }
    
    var strArea: String? {
        didSet {
            var txt = /strArea
            if txt.isEmpty {
                txt = L11n.select.string
            }
            lblAddress.text = txt
        }
    }
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if refreshControl.superview == nil {
            setupRefreshControl()
        }
    }
    
    func setupView() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationFetched), name: NSNotification.Name("LocationFetched"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotFetched), name: NSNotification.Name("LocationNotFetched"), object: nil)
        
        configureTableViewInitialization()
        locationFetched()
    }
    
    func setupRefreshControl() {
        refreshControl.frame = CGRect(x: 0, y: 0, w: 20, h: 20)
        refreshControl.tintColor = SKAppType.type.color
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        refreshControl.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        refreshControl.subviews[0].frame = CGRect(x: 90, y: 20, w: 20, h: 30)
        
    }
    
    @objc func refreshTableData() {
        self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
    }
    
    
    @objc func locationFetched() {
        if let searchedAddress = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress {
            strArea = searchedAddress
            self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
            return
        } else if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                strArea = name + " " + locality
            }
            self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.latitude ?? 0.0   , longitude: LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.longitude ?? 0.0)
            return
        }
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func locationNotFetched() {
        if !LocationSingleton.sharedInstance.isLocationSelected() {
            refreshControl.endRefreshing()
            return
        }
    }
    
    func openLocationController() {
        //Nitin
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.completionBlock = { [weak self] data in
            guard let strongSelf = self else { return }
            var lati : Double?
            var longi: Double?
            
            if let value = data as? Bool,value == true {
                // value == true is for current location selection
                if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
                    if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                        strongSelf.strArea = name + " " + locality
                    }
                }
            } else if let _ = data as? [String:Any] {
                if let address = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
                    strongSelf.strArea = address
                }
                lati = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
                longi = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
            } else if let value = data as? Bool, value == false {
                if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
                    strongSelf.strArea = address
                }
                lati = LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0
                longi = LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0
            }
            
            strongSelf.refreshTableData()
            
            
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func reloadVisibleCells(){
        
        DBManager.sharedManager.getCart {
            [weak self] (array) in
            guard let self = self else { return }
            
            for cell in self.tableView.visibleCells {
                if let cell = cell as? DoctorHomeParentCell {
                    for collectionCell in cell.model?.productValue ?? [] {
                        if let product = array.first(where: {($0 as? ProductF)?.id == collectionCell.id})  {
                            collectionCell.quantity = (product as? ProductF)?.quantity
                            collectionCell.dateModified = (product as? ProductF)?.dateModified
                        }
                        else {
                            collectionCell.quantity = nil
                        }
                    }
                    for collectionCell in cell.collectionView.visibleCells {
                        if let cell = collectionCell as? DoctorHomeProductCell {
                            cell.stepper?.value = cell.product?.quantity?.toDouble() ?? 0.0
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func actionArea(sender : UIButton) {
        self.openLocationController()
    }
}

//MARK: - TableView Configuration
extension DoctorHomeVC {
    
    func configureTableViewInitialization() {
        
        homeDataSource = DoctorHomeDataSource(tableView: tableView, configureCellBlock: {
            [weak self] (indexPath, cell, item, type) in
            guard let self = self else { return }
            self.configureCell(withCell: cell, item: item, type: type, indexPath: indexPath)
            
            }, aRowSelectedListener: {
                [weak self] (indexPath, type) in
                guard let self = self else { return }
                self.itemClicked(atIndexPath: indexPath, type: type)
        })
    }
    
    func configureCell(withCell cell: Any , item: Any , type: DoctorHomeScreenSection, indexPath: IndexPath) {
        
        switch type {
            
        case .Banners :
            (cell as? BannerParentCell)?.banners = (item as? Home)?.arrayBanners
            (cell as? BannerParentCell)?.selectionStyle = .none
            
            (cell as? BannerParentCell)?.bannerClickedBlock = {
                [weak self] (banner) in
                guard let self = self else { return }
                
                if AppSettings.shared.isSingleVendor && SKAppType.type != .home {return}
                
                if SKAppType.type.isFood {
                    if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                        let VC = RestaurantMenuVC.getVC(.splash)
                        VC.passedData.supplierId = banner?.supplierId
                        VC.passedData.categoryId = banner?.category_id
                        VC.passedData.supplierBranchId = banner?.supplierBranchId
                        VC.passedData.categoryFlow = banner?.categoryFlow
                        self.pushVC(VC)
                    }else {
                        let VC = RestaurantDetailVC.getVC(.splash)
                        VC.passedData.supplierId = banner?.supplierId
                        VC.passedData.categoryId = banner?.category_id
                        VC.passedData.supplierBranchId = banner?.supplierBranchId
                        VC.passedData.categoryFlow = banner?.categoryFlow
                        self.pushVC(VC)
                    }
                    
                } else if SKAppType.type == .home {
                    
                    //                    let flow = "Category>SubCategory>Suppliers>Pl"
                    //                    self.passedData.categoryFlow = flow
                    //                    self.passedData.hasSubCats = banner?.is_subcategory == 1
                    //                    self.passedData.categoryId = banner?.category_id
                    //                    self.pushNextVc()
                    
                }
            }
        case .Categories:
            if let tempCell = cell as? DoctorCategoryParentCell {
                let arr = GDataSingleton.sharedInstance.doctorCategories
                tempCell.configureCell(arr)
                tempCell.itemClickedBlock = { [weak self] item in
                    if let service = item as? ServiceType, let type = service.type {
                        AppSettings.shared.appThemeData?.terminology = service.terminology
                        AppSettings.shared.appType = type
                        AppSettings.shared.cartImageUpload = service.cart_image_upload == "1"
                        AppSettings.shared.orderInstructions = service.order_instructions == "1"
                        let appType = SKAppType(rawValue: type) ?? .food
                        self?.openCategory(category: service, appType: appType)
                    }
                    
                }
            }
        default:
            if let tempCell = cell as? DoctorHomeParentCell {
                tempCell.selectionStyle = .none
                
                let offset = DoctorHomeScreenSection.allValues.firstIndex(of: .ProductList)
                let newSection = indexPath.section - /offset
                
                let itemValue = GDataSingleton.sharedInstance.getOfferByCategory ?? []
                if newSection == itemValue.count {
                    if let suppliers = GDataSingleton.sharedInstance.doctorHomeProviders {
                        tempCell.configureSuppliers(suppliers)
                    }
                }
                else {
                    tempCell.configureCell(itemValue[newSection])
                }
                tempCell.itemClickedBlock = { [weak self] item in
                    if let item = item as? ProductF {
                        if let type = item.type, let appType = SKAppType(rawValue: type), appType != .food {
                            //self?.openProduct(objProduct: item)
                        }
                    }
                    else if let item = item as? Supplier, let type = item.type {
                        let appType = SKAppType(rawValue: type) ?? .food
                        self?.openSupplier(supplier: item, appType: appType)
                    }
                }
                
            }
        }
        
    }
    
    func itemClicked(atIndexPath indexPath : IndexPath , type : DoctorHomeScreenSection) {
        
        switch type{
        case .Banners :
            break
        default :
            break
        }
    }
}

//MARK: - Product Click Listerner
extension CategoryFlowBaseViewController {
    
    func openSupplier(supplier: Supplier?, appType: SKAppType) {
        
        guard let supplier = supplier else { return }
        AppSettings.shared.appType = appType.rawValue

        let arrayCat = supplier.categories ?? []
                
        if appType == .home {
            if arrayCat.count > 0 {
                let flow = "Category>SubCategory>Suppliers>Pl"
                self.passedData.categoryFlow = flow
                let catVC = StoryboardScene.Main.instantiateSubcategoryViewController()
                let listing = SubCategoriesListing(attributes: [:])
                listing.arrayCategories = arrayCat
                catVC.objCatData = listing
                catVC.supplierId = supplier.id
                catVC.passedData.categoryFlow = flow
                pushVC(catVC)
            }
            else {
                let vc =  ItemListingViewController.getVC(.main)
                vc.brandName = supplier.name
                vc.passedData = PassedData(withCatergoryId: nil, categoryFlow: nil, supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: nil, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
                self.pushVC(vc)
            }
            return
        }

        if appType.isFood {
            let category = arrayCat.first
            
            if /AppSettings.shared.appThemeData?.app_selected_template == "1" {
                let VC = RestaurantMenuVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                VC.passedData.subCats = supplier.categories
                VC.passedData.supplier = supplier
                
                self.pushVC(VC)
            }else {
                let VC = RestaurantDetailVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                VC.passedData.subCats = supplier.categories
                VC.passedData.supplier = supplier
                
                self.pushVC(VC)
            }
            return
        }
        
        if arrayCat.isEmpty {
            return
        }
        let catSelectionVc = StoryboardScene.Options.instantiateCategorySelectionController()
        catSelectionVc.supplier = supplier
        catSelectionVc.ISPushAnimation = true
        catSelectionVc.arrCategory = supplier.categories
        self.pushVC(catSelectionVc)
    }
    
    func openCategory(category: ServiceType?, appType: SKAppType) {
        
        if appType.isJNJ {
            let VC = RestaurantDetailVC.getVC(.splash)
            // VC.passedData.supplierBranchId = notification.userInfo?["branchId"]?.stringValue
            VC.passedData.supplierId = "5"
            VC.passedData.supplierBranchId = "1"
            VC.passedData.categoryId = category?.id
            VC.passedData.categoryName = category?.name

            self.pushVC(VC)
            return
        }
        if appType == .home {
            category?.category_flow = "Category>SubCategory>Suppliers>Pl"
        }
        if let flowComponents = category?.category_flow?.components(separatedBy: ">") {
            print(flowComponents)
            AdjustEvent.CategoryDetail.sendEvent()
            
            if flowComponents.contains(CategoryFlowMap.PickUpTime.rawValue)
                || flowComponents.contains(CategoryFlowMap.PackageProducts.rawValue)
                || flowComponents.contains(CategoryFlowMap.LaundryOrder.rawValue)
                || flowComponents.count == 0 {
                
                guard let _ = GDataSingleton.sharedInstance.loggedInUser?.id else {
                    self.presentVC(StoryboardScene.Register.instantiateLoginViewController())
                    return
                }
                
                self.passedData = PassedData(withCatergoryId: category?.id, categoryFlow: category?.category_flow,supplierId: nil ,subCategoryId: nil ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.name)
                self.pushNextVc()
                
            } else{
                
                ez.runThisInMainThread {
                    [weak self] in
                    guard let self = self else { return }
                    
                    //                    let category = Localize.currentLanguage() == Languages.Arabic ? self?.home?.arrayServiceTypesAR?[indexPath.row] : self?.home?.arrayServiceTypesEN?[indexPath.row]
                    
                    FilterCategory.shared.reset()
                    
                    FilterCategory.shared.arrayCatIds = [/category?.id]
                    FilterCategory.shared.arrayCatNames = [/category?.name]
                    
                    let hasSubCats = (/category?.sub_category?.count > 0) || category?.is_subcategory == 1
                    
                    //To apply filter/enable filter done button, when no sub categories available
                    if !hasSubCats {
                        FilterCategory.shared.arraySubCatIds.append(/category?.id)
                        FilterCategory.shared.arraySubCatNames.append(/category?.name)
                    }
                    
                    FilterCategory.shared.agentListFlow = category?.agent_list
                    var catFlow = category?.category_flow
                    
                    if appType != .food {
                        let str = "SupplierInfo>"
                        let newFlow = catFlow?.replacingOccurrences(of: str, with: "")
                        print(newFlow)
                        catFlow = newFlow
                    }
                    //Nitin
                    
                    self.passedData = PassedData(withCatergoryId: category?.id, categoryFlow: catFlow,supplierId: category?.supplierId ,subCategoryId: category?.id ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order, categoryName : category?.name, hasSubCats: hasSubCats)
                    self.pushNextVc()
                }
                
            }
        }
    }
}

//MARK:- APIs
extension DoctorHomeVC {
    
    func webserviceHomeData(latitude: Double?,longitude: Double?)  {
        AppSettings.shared.selectedCategoryId = nil
        //        if !LocationSingleton.sharedInstance.isLocationSelected() {
        //            refreshControl.endRefreshing()
        //            return
        //        }
        
        let objR = API.Home(latitude: latitude ?? nil, longitude: longitude ?? nil, catId: nil)
        // let objR = API.Home(FormatAPIParameters.Home.formatParameters(), longitude: <#Double#>)
        APIManager.sharedInstance.opertationWithRequest(refreshControl: refreshControl, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                self.webserviceHomeOffers(home: object as? Home, latitude: latitude ?? nil, longitude: longitude ?? nil)
            default :
                break
            }
        }
    }
    
    func webserviceHomeOffers(home: Home?,latitude: Double?,longitude: Double?)  {
        let objR = API.offers(latitude: latitude ?? nil, longitude: longitude ?? nil)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            self.stopSkeletonAnimation(self.tableView)
            
            switch response {
            case APIResponse.Success(let object):
                
                if let object = object as? Home {
                    GDataSingleton.sharedInstance.getOfferByCategory = object.getOfferByCategory
                }
                break
                
            default :
                break
            }
            
            GDataSingleton.sharedInstance.doctorHomeProviders = home?.arrayRecommendedAR
            GDataSingleton.sharedInstance.doctorCategories = home?.arrayServiceTypesEN
            self.tableView.reloadData()
            
            
        }
    }
}
//
////MARK:- UIViewControllerTransitioningDelegate
//extension DoctorHomeVC : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}


extension MainTabBarViewController {
    
//    func openHomeWith(category: String?, type: Int?) {
//        if category == nil {
//            doctorHome.tabBarItem = homeItem
//            doctorHome.refreshTableData()
//            self.viewControllers?[0] = doctorHome
//        }
//        else {
//            AppSettings.shared.appType = type ?? 1
//            if category != AppSettings.shared.selectedCategoryId {
//                //DBManager.sharedManager.cleanCart()
//                AppSettings.shared.selectedCategoryId = category
//            }
//            
//            let homeVC = StoryboardScene.Main.instantiateEcommerceHomeViewController()
//            homeVC.tabBarItem = homeItem
//            self.viewControllers?[0] = homeVC
//        }
//        //self?.openCategory(category: service)
//    }
    
    

}
