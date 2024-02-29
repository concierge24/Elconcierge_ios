//
//  NewHomeScreenVC.swift
//  Sneni
//
//  Created by admin on 24/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import RCPageControl

class NewHomeScreenVC: CategoryFlowBaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
        @IBOutlet weak var pgControl: UIPageControl?
    @IBOutlet var viewBar: NavigationView! {
        didSet {
            if let headerColor = AppSettings.shared.appThemeData?.theme_color {
                let header = UIColor(hexString: headerColor)
                viewBar.backgroundColor = .white// header ?? UIColor.white
            }
            viewBar.shadowOpacity = SKAppType.type.isJNJ ? 0.0 : 1.0
            //Nitin
            viewBar.btnMenu?.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .carRental || SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .eCom ? true : false
        }
    }
    
    var strArea: String? {
        didSet {
            var txt = /strArea
            if txt.isEmpty {
                txt = L11n.select.string
            }
            viewBar?.btnArea?.setTitle(txt, for: .normal)
        }
    }
    var collectionViewDataSource: SKCollectionViewDataSource?{
        didSet{
            collectionView.delegate = collectionViewDataSource
            collectionView.dataSource = collectionViewDataSource
        }
    }
    var arrayItems : [ServiceType] = []
    var supplierId: String?
    var categoriesFromHome : [Categorie]?
    
    var totalPage: Int = 0
    
    var currentPage: Int = 0

    var pageControl : RCPageControl?
    var collectionBannerDataSource = CollectionViewDataSource(){
        didSet{
            collectionViewBanner.delegate = collectionBannerDataSource
            collectionViewBanner.dataSource = collectionBannerDataSource
        }
    }
    
    var banners : [Banner]? {
        didSet{
            totalPage = /banners?.count
            updateUI()
        }
    }
    
    var bannerClickedBlock : BannerClickListener?
    var timer = Timer()
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if categoriesFromHome == nil {
            if refreshControl.superview == nil {
                setupRefreshControl()
            }
        }
        GDataSingleton.sharedInstance.currentSupplier = nil
        if let searchedAddress = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress {
            if strArea != searchedAddress {
                locationFetched()
            }
        }
        else if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                let area = name + " " + locality
                if strArea != area {
                    locationFetched()
                }
            }
        }
    }

    @IBAction func actionArea(sender : UIButton) {
        self.openLocationController()
        
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
            
            strongSelf.isLoadingFirstTime = true
//            strongSelf.startSkeletonAnimation(strongSelf.tableView)
//            strongSelf.isDataFetched = true
            if let lat = lati, let long = longi {
                strongSelf.webserviceHomeData(latitude: lat, longitude: long)
            } else {
                strongSelf.webserviceHomeData(latitude: nil, longitude: nil)
            }
            
        }
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func locationFetched() {
        //Nitin
        
        if let searchedAddress = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress {
            strArea = searchedAddress
            self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
            return
        } else if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                strArea = name + " " + locality
            }
            self.webserviceHomeData(latitude: nil, longitude: nil)
            return
        }
        
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func updateUI(){
        pgControl?.pageIndicatorTintColor = UIColor.lightGray
        pgControl?.currentPageIndicatorTintColor = UIColor.white
        pgControl?.isHidden = true//totalPage < 2
        pgControl?.numberOfPages = totalPage > 5 ? 5 : 0
        pgControl?.currentPage = currentPage > 5 ? 5 : 0
        pageControl?.currentPage = currentPage > 5 ? 5 : 0
        
        // Reload Collection View
        
        pgControl?.numberOfPages = (banners?.count ?? 0) > 5 ? 5 : banners?.count ?? 0
        pageControl?.numberOfPages = (banners?.count ?? 0) > 5 ? 5 : banners?.count ?? 0
        pageControl?.isHidden = /banners?.count == 0
      
        var height = (ScreenSize.SCREEN_WIDTH - 48)/2
        var width = height
        var startTimer = false
        if DeliveryType.shared == .delivery && !AppSettings.shared.halfWidthBanner {
            height = (ScreenSize.SCREEN_WIDTH - 16)/2
            width = (ScreenSize.SCREEN_WIDTH - 16)
            startTimer = true
        }
        collectionViewBanner.reloadData()
        collectionViewBanner.contentOffset = CGPoint.zero
        totalPage = /banners?.count
        
        collectionBannerDataSource = CollectionViewDataSource(
            items: banners,
            tableView: collectionViewBanner,
            cellIdentifier: CellIdentifiers.BannerCell,
            headerIdentifier: nil, cellHeight: height,
            cellWidth: width
            , configureCellBlock: {
                (cell, item) in
                
            (cell as? BannerCell)?.banner = item as? Banner
                
        }, aRowSelectedListener: { [weak self] (indexPath) in
            guard let block = self?.bannerClickedBlock, let objBanner = self?.banners?[indexPath.row], let _ = objBanner.category_id else { return }
            block(objBanner)
        })
        
        collectionBannerDataSource.scrollViewListener = {
            [weak self] scrollView in
            
            let page = Int(scrollView.contentOffset.x/scrollView.frame.width)
            self?.currentPage = page
            
            
        }
        if startTimer {
            addTimer()
        }
        else {
            timer.invalidate()
        }
    }
    
    deinit {
        print("Timer removed")
        timer.invalidate()
    }
    
    func setupView() {
        

        self.bannerClickedBlock = {
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
                                
                                
                                self.passedData.supplierId = banner?.supplierId
                                self.passedData.supplierBranchId = banner?.supplierBranchId
                                let flow = "Category>SubCategory>Suppliers>Pl"
                                self.passedData.categoryFlow = flow
                                self.passedData.hasSubCats = banner?.is_subcategory == 1
                                self.passedData.categoryId = banner?.category_id
                                self.pushNextVc()
                                
            //                    let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
            //                    VC.passedData.supplierId = banner?.supplierId
            //                    VC.passedData.categoryId = banner?.category_id
            //                    VC.passedData.supplierBranchId = banner?.supplierBranchId
            //                    VC.passedData.categoryFlow = banner?.categoryFlow
            //                    self.pushVC(VC)
                            }
        }
        
        if let items = categoriesFromHome {
            arrayItems = items.map { (category) -> ServiceType in
                var service = category.toServiceType
                service.supplierId = supplierId
                return service
            }
            self.configureCollectionView()
        }
        else {
            refreshTableData()
        }
    }
    
    func setupRefreshControl() {
        refreshControl.frame = CGRect(x: 0, y: 0, w: 20, h: 20)
        refreshControl.tintColor = SKAppType.type.color
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        refreshControl.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        refreshControl.subviews[0].frame = CGRect(x: 90, y: 20, w: 20, h: 30)
        
    }
    
    @objc func refreshTableData() {
        self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
    }
    
    
    func webserviceHomeData(latitude: Double?,longitude: Double?)  {
        APIManager.sharedInstance.showLoader()
        let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
        let objR = API.Home(latitude: latitude ?? nil, longitude: longitude ?? nil, catId: catId)
        APIManager.sharedInstance.opertationWithRequest(refreshControl: refreshControl, withApi: objR) {
            [weak self] (response) in
            APIManager.sharedInstance.hideLoader()
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                guard let homeObj = object as? Home else {return}
                self.arrayItems = homeObj.arrayServiceTypesEN ?? []
                self.banners = homeObj.arrayBanners
                self.configureCollectionView()
            default :
                break
            }
        }
    }
}

//MARK: - Configure CollectionView
extension NewHomeScreenVC {
    
    
    func configureCollectionView(){
        
        let width: CGFloat = min(CGFloat(UIScreen.main.bounds.width-(4*16))/3.0, 96)
        
        if collectionViewDataSource == nil {
            collectionView?.registerCells(nibNames: [HomeServiceCategoryCollectionCell.identifier])
            collectionViewDataSource = SKCollectionViewDataSource(
                items: arrayItems,
                collectionView: collectionView,
                cellIdentifier: HomeServiceCategoryCollectionCell.identifier,
                cellHeight: width + 40,
                cellWidth: width)
        }
        
        collectionViewDataSource?.configureCellBlock = {
            (index, cell, item) in
            
            if let cell = cell as? HomeServiceCategoryCollectionCell, let item = item as? ServiceType {
                cell.imgProfile.layer.cornerRadius = width/2.0
                cell.imgProfile.clipsToBounds = true
                cell.objModel = item
            }
            
        }
        
        collectionViewDataSource?.aRowSelectedListener = {
            [weak self] (indexpath, cell) in
            guard let self = self else { return }
            self.openCategory(category: self.arrayItems[indexpath.row])
        }
        collectionViewDataSource?.reload(items: arrayItems)
    }
}

//MARK: - Automatic Scrolling collectionView
extension NewHomeScreenVC {

    func addTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BannerParentCell.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }

    func resetIndexpath() -> IndexPath{
        let currentIndexPath = collectionView.indexPathsForVisibleItems.last
        let currentIndexpathReset = IndexPath(row: currentIndexPath?.item ?? 0, section: 0)

        //        collectionView.scrollToItemAtIndexPath(currentIndexpathReset, atScrollPosition: .CenteredHorizontally, animated: true)
        return currentIndexpathReset
    }

    @objc func nextPage(){
        if self.banners?.count == 0 {
            return
        }
        let currentIndexPathReset = resetIndexpath()

        var nextItem = currentIndexPathReset.item + 1
        var nextSection = currentIndexPathReset.section
        if (nextItem == self.banners?.count) {
            nextItem = 0
            nextSection = 0
        }
        let nextIndexPath = IndexPath(row: nextItem, section: nextSection)
        currentPage = nextItem

        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }

    func removeTimer(){
        timer.invalidate()
    }

}

////MARK:- UIViewControllerTransitioningDelegate
//extension NewHomeScreenVC : UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
