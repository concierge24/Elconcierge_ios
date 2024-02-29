//
//  DrawerViewController.swift
//  Clikat
//
//  Created by Night Reaper on 14/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import GooglePlacePicker
import GoogleMaps
import SkeletonView

class HomeViewController: CategoryFlowBaseViewController {
    
    @IBOutlet weak var buttonSearch: UIButton!{
        didSet{
            buttonSearch?.isHidden =  (AppSettings.shared.isSingleVendor && SKAppType.type == .food) ? true : false
            if let headerColor = AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                buttonSearch?.setTitleColor(header ?? UIColor.darkGray, for: .normal)
                buttonSearch?.tintColor = header ?? .gray
            }
        }
    }
    @IBOutlet weak var btnNotification: UIButton! {
        didSet{
            if let headerColor = AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                btnNotification?.setTitleColor(header ?? UIColor.darkGray, for: .normal)
                btnNotification?.tintColor = header ?? .gray
            }
        }
    }
    //MARK:- ======== Outlets ========
    @IBOutlet weak var appHeader_view: UIView!{
        didSet {
            appHeader_view.isHidden = AppSettings.shared.isSingleVendor ? false : true
            if let headerColor = AppSettings.shared.appThemeData?.logo_background {
                let header = UIColor(hexString: headerColor)
                appHeader_view.backgroundColor = .white// header ?? UIColor.white
            }
        }
    }
    @IBOutlet weak var appLogoHeader_heightConstraint: NSLayoutConstraint! {
        didSet{
            if SKAppType.type == .eCom {
                appLogoHeader_heightConstraint.constant =  0.0
            }
            else {
                appLogoHeader_heightConstraint.constant = 0.0//AppSettings.shared.isSingleVendor ? 50.0 : 0.0
            }
        }
    }
    @IBOutlet weak var appLogoHeader_imageView: UIImageView!{
        didSet{
            appLogoHeader_imageView.isHidden = AppSettings.shared.isSingleVendor ? false : true
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.tintColor = SKAppType.type.color
            searchBar.delegate = self
            searchBar.setAlignment()

        }
    }
    @IBOutlet weak var searchView: ThemeView!{
        didSet {
            if SKAppType.type.isHome {
                searchView.isHidden = true
            } else {
                searchView.isHidden = false
            }
        }
    }
    @IBOutlet weak var svDelivery_button: UIButton!
    @IBOutlet weak var svPickup_button: UIButton!
    @IBOutlet weak var menu_button: UIButton! {
        didSet {
            menu_button.isHidden = (SKAppType.type.isFood && AppSettings.shared.isSingleVendor) ? false : true
            menu_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var singleVendorDelivery_view: UIView! {
        didSet {
            singleVendorDelivery_view.isHidden =  AppSettings.shared.isSingleVendor ? false : true
        }
    }
    @IBOutlet weak var sv_heightConstraint: NSLayoutConstraint! {
        didSet {
            sv_heightConstraint.constant = 0
        }
    }
    @IBOutlet weak var viewCurrentOrders : HomeScreenCurrentOrdersView? {
        didSet {
            arrayCurrentOrders = []
            viewCurrentOrders?.blockOpenOrderDetail = {
                [weak self] oredr in
                guard let self = self else { return }
                
                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
                orderDetailVc.orderDetails = oredr
                orderDetailVc.type = .OrderUpcoming
                self.pushVC(orderDetailVc)
            }
        }
    }
    @IBOutlet var btn_language: UIButton! {
        didSet {
            btn_language.isHidden = SKAppType.type.isJNJ
        }
    }
    @IBOutlet var btnChatBot: UIButton! {
        didSet {
            //btnChatBot.isHidden = SKAppType.type != .food
            btnChatBot.isHidden = true
            if GDataSingleton.sharedInstance.zendeskEnabled {
                btnChatBot.isHidden = false
            }
            btnChatBot.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        }
    }
    @IBOutlet var viewSearch: UIView! {
        didSet {
            if SKAppType.type.isHome {
                viewSearch.isHidden = true
                viewSearch.shadowOpacity = 0.0
            } else {
                viewSearch.isHidden =  AppSettings.shared.isSingleVendor ? false : true
                viewSearch.shadowOpacity = AppSettings.shared.isSingleVendor ? 1.0 : 0.0
            }
        }
    }
    @IBOutlet var constraintHeightSearchBar: NSLayoutConstraint! {
        didSet {
            if SKAppType.type.isHome || SKAppType.type == .eCom {
                constraintHeightSearchBar.constant = 0.0
            } else {
                constraintHeightSearchBar.constant = AppSettings.shared.isSingleVendor ? 56.0 : 0.0
            }
        }
    }
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
    @IBOutlet var tableView : UITableView! {
        didSet {
            self.tableView.tableFooterView = UIView()
            self.tableView.tableHeaderView = UIView()
        }
    }
    @IBOutlet var imageViewBg: UIImageView! {
        didSet {
            UtilityFunctions.addParallaxToView(view: imageViewBg)
        }
    }
    //    @IBOutlet weak var btnArea : UIButton! {
    //        didSet{
    //            if let headerColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "header_text_color") {
    //                let header = UIColor(hexString: headerColor)
    //                btnArea.setTitleColor(header ?? UIColor.darkGray, for: .normal)
    //                btnArea.tintColor = header ?? .gray
    //            }
    //        }
    //    }
    @IBOutlet weak var profile_button: UIButton!
    @IBOutlet weak var placeholder_view: UIView!
    @IBOutlet var deliveryViewButtons: [UIButton]! {
        didSet{
            if let headerColor = AppSettings.shared.appThemeData?.theme_color{ //AppSettings.shared.appThemeData?.header_text_color {
                let header = UIColor(hexString: headerColor)
                deliveryViewButtons.forEach { (button) in
                    button.tintColor = SKAppType.type.color
                    button.setTitle("Delivery".localized(), for: .normal)
                    button.setTitleColor(header ?? UIColor.darkGray, for: .normal)
                    
                }
            }
        }
    }
    
    //MARK:- ======== Variables ========
    private var refreshControl = UIRefreshControl()
    var placePicker : GMSPlacePickerViewController?
    var arrayCurrentOrders: [OrderDetails] = [] {
        didSet {
            viewCurrentOrders?.items = arrayCurrentOrders
            let itH = !SKAppType.type.isJNJ || arrayCurrentOrders.isEmpty
            viewCurrentOrders?.isHidden = itH
            let bottomInset = itH ? 0.0 : (viewCurrentOrders?.bounds.height ?? 0.0)
            tableView.contentInset = .init(top: -34, left: 0, bottom: bottomInset, right: 0)
        }
    }
    var home : Home? = GDataSingleton.sharedInstance.homeData {
        didSet {
            homeDataSource?.home = home
            tableView.reloadData()//?.reloadTableViewData(inView: view)
            arrayCurrentOrders = home?.itemsOrders ?? []
        }
    }
    var homeDataSource : HomeDataSource? = HomeDataSource() {
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
            viewBar?.btnArea?.setTitle(txt, for: .normal)
        }
    }
    var checkingNo:Int = 0
    var deliveryType:Int = 0 // 0- delivery, 1- pickup
    var isDataFetched = false
    var arrayAllSubcategories = [SubCategory]()
    //var filterData : [ProductList]?
//    var isFilterEnable : Bool = false
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let type = DeliveryType(rawValue: 0) ?? .delivery
        //
        //        DeliveryType.shared = type
        
        self.configureTableViewInitialization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationFetched), name: NSNotification.Name("LocationFetched"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotFetched), name: NSNotification.Name("LocationNotFetched"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateFavs(notification:)), name: Notification.Name("FavouritePressed"), object: nil)
        
        refreshControl.frame = CGRect(x: 0, y: 0, w: 20, h: 20)
        refreshControl.tintColor = SKAppType.type.color
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        refreshControl.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        refreshControl.subviews[0].frame = CGRect(x: 90, y: 20, w: 20, h: 30)
        
        btn_language.isSelected = Localize.currentLanguage() == Languages.Arabic ? true : false
        
        self.profile_button.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage ?? "", original: nil, placeHolder: UIImage(asset: Asset.User_placeholder))
        
        AdjustEvent.Home.sendEvent()
        
        if SKAppType.type == .food {
            foodCategoryListing()
            DeliveryType.blockChangeState = {
                [weak self] state in
                guard let self = self else { return }
                //self.tableView.reloadData()
                guard let homeObj = self.home else {return}
                self.checkingNo += 1
                if self.checkingNo == 1 {
                    self.isLoadingFirstTime = true
                    self.startSkeletonAnimation(self.tableView)
                }
                self.reloadApi(homeObj: homeObj)
            }
        }
        
        GDataSingleton.sharedInstance.pickupDate = nil
        FilterCategory.shared.reset()
        
       // self.perform(#selector(openLoc), with: nil, afterDelay: 0.02)
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            self.profile_button.setImage(UIImage(asset: Asset.User_placeholder), for: .normal)
            return}
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        // strArea = LocationSingleton.sharedInstance.location?.getArea()?.name
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
    
    @IBAction func actionNotificationBtn(_ sender: Any) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            return
        }
        let VC = StoryboardScene.Options.instantiateNotificationsViewController()
        self.pushVC(VC)
    }
    
    @objc func locationFetched() {
        //Nitin
        self.startSkeletonAnimation(tableView)
        
        self.isDataFetched = true
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
    
    @objc func locationNotFetched() {
        if !LocationSingleton.sharedInstance.isLocationSelected() {
            refreshControl.endRefreshing()
            return
        }
    }
    
    @objc func updateFavs(notification: Notification) {
        if let product = notification.object as? Cart {
            for item in home?.arrPopularProducts ?? [] {
                if item.id == product.id {
                    item.isFav = product.isFav
                }
            }
            for item in home?.arrayOffersEN ?? [] {
                if item.id == product.id {
                    item.isFav = product.isFav
                }
            }
        }else if let supplier = notification.object as? Supplier {
            for item in home?.arrayRecommendedEN ?? [] {
                if item.id == supplier.id {
                    item.Favourite = supplier.Favourite
                }
            }
        }
        for cell in tableView.visibleCells {
            if let listCell = cell as? HomeOffersHListTableCell {
                if SKAppType.type == .eCom && listCell.type == .PopularProducts {
                    listCell.arrayItems = home?.arrPopularProducts
                }
                else {
                    listCell.arrayItems = home?.arrayOffersEN
                }
            }
        }
        //tableView.reloadData()
    }
    
    @objc func refreshTableData() {
        locationFetched()
        //        if !isDataFetched {
        //            locationFetched()
        //        } else {
        //            if self.refreshControl.isRefreshing {
        //                self.refreshControl.endRefreshing()
        //            }
        //        }
    }
    
    @objc func openLoc() {
        if !LocationSingleton.sharedInstance.isLocationSelected(){
            let VC = ChooseLocationVC.getVC(.register)
            VC.delegate = self
            presentVC(VC)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    deinit {
        print("Notification removed")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadVisibleCells(){
        
        DBManager.sharedManager.getCart {
            [weak self] (array) in
            guard let self = self else { return }
            
            for cell in self.tableView.visibleCells {
                if let cell = cell as? ProductListingCell {
                    if let product = array.first(where: {($0 as? Cart)?.id == cell.product?.id})  {
                        cell.product?.quantity = (product as? Cart)?.quantity
                        cell.product?.dateModified = (product as? Cart)?.dateModified
                    }
                }
                if let cell = cell as? ProductListCell {
                    //GDataSingleton.sharedInstance.homeProductList
                    if let product = array.first(where: {($0 as? Cart)?.id == cell.product?.id})  {
                        cell.product?.quantity = (product as? Cart)?.quantity
                        cell.product?.dateModified = (product as? Cart)?.dateModified
                    }
                }
                if let cell = cell as? HomeProductParentCell {
                    for collectionCell in cell.products ?? [] {
                        if let product = array.first(where: {($0 as? Cart)?.id == collectionCell.id})  {
                            collectionCell.quantity = (product as? Cart)?.quantity
                            collectionCell.dateModified = (product as? Cart)?.dateModified
                        }
                        else {
                            collectionCell.quantity = nil
                        }
                    }
                    for collectionCell in cell.collectionView.visibleCells {
                        if let cell = collectionCell as? HomeProductCell {
                            cell.stepper?.value = cell.product?.quantity?.toDouble() ?? 0.0
                        }
                    }
                }
                if let cell = cell as? HomeOffersHListTableCell {
                    for collectionCell in cell.arrayItems ?? [] {
                        if let product = array.first(where: {($0 as? Cart)?.id == collectionCell.id})  {
                            collectionCell.quantity = (product as? Cart)?.quantity
                            collectionCell.dateModified = (product as? Cart)?.dateModified
                        }
                        else {
                            collectionCell.quantity = nil
                        }
                    }
                    for collectionCell in cell.collectionView?.visibleCells ?? [] {
                        if let cell = collectionCell as? HomeProductCell {
                            cell.stepper?.value = cell.product?.quantity?.toDouble() ?? 0.0
                        }
                    }
                }
            }
        }
        
    }
    
}

//MARK: - WebService Configuration
extension HomeViewController {
    
    func reloadApi (homeObj: Home) {
        
        var lati : Double?
        var longi: Double?
        
        if let _ = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.tempAddAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.tempAddAddress?.long ?? 0.0
            
        } else if let _ = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            lati = LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0
            longi = LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0
        }
        self.getRestorents(home: homeObj, showSkelton: true, latitude: lati ?? nil, longitude: longi ?? nil)
        
    }
    
    func webserviceHomeData(latitude: Double?,longitude: Double?)  {
        
        //        if !LocationSingleton.sharedInstance.isLocationSelected() {
        //            refreshControl.endRefreshing()
        //            return
        //        }
        let catId = AppSettings.shared.selectedCategoryId//GDataSingleton.sharedInstance.selectedCatId
        let objR = API.Home(latitude: latitude ?? nil, longitude: longitude ?? nil, catId: catId)
        // let objR = API.Home(FormatAPIParameters.Home.formatParameters(), longitude: <#Double#>)
        APIManager.sharedInstance.opertationWithRequest(refreshControl: refreshControl, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                //                self.home = object as? Home
                if AppSettings.shared.isSingleVendor {
                    self.webserviceHomeOffers(home: object as? Home, latitude: latitude ?? nil, longitude: longitude ?? nil)
                } else {
                    if AppSettings.shared.isPickupOrder == 1 {
                        DeliveryType.shared = DeliveryType(rawValue: 1) ?? .pickup
                        guard let homeObj = object as? Home else {return}
                        self.getRestorents(home: homeObj, showSkelton: true, latitude: latitude ?? nil, longitude: longitude ?? nil)
                        return
                    } else if AppSettings.shared.isPickupOrder == 0 {
                        DeliveryType.shared = DeliveryType(rawValue: 0) ?? .delivery
                        guard let homeObj = object as? Home else {return}
                        self.getRestorents(home: homeObj, showSkelton: true, latitude: latitude ?? nil, longitude: longitude ?? nil)
                        return
                    } else {
                        self.webserviceHomeOffers(home: object as? Home, latitude: latitude ?? nil, longitude: longitude ?? nil)
                    }
                }
                
            default :
                break
            }
        }
    }
    
    func foodCategoryListing(){//webServiceSubCategoriesListing(){

    //passedData.supplierId

    APIManager.sharedInstance.opertationWithRequest(withApi: API.SubCategoryListing(supplierId: nil , categoryId: AppSettings.shared.selectedCategoryId)) {
    [weak self] (response) in
    guard let self = self else { return }
    switch response{
    case .Success(let listing):
    let objCatData = (listing as? SubCategoriesListing)

    objCatData?.subCategories?.forEach({ [weak self] (subCat) in
    self?.arrayAllSubcategories.append(subCat)
    })

    self.tableView.reloadData()
    default :
    break
    }
    }
    }
    
    func webserviceHomeOffers(home: Home?,latitude: Double?,longitude: Double?)  {
        
        //        if !LocationSingleton.sharedInstance.isLocationSelected() {
        //            self.home = home
        //            return
        //        }
        
        let objR = API.offers(latitude: latitude ?? nil, longitude: longitude ?? nil)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case APIResponse.Success(let object):
                if let object = object as? Home {
                    
                    let objH = home
                    
                    objH?.arrayOffersAR = object.arrayOffersAR
                    objH?.arrayOffersEN = object.arrayOffersEN
                    objH?.arrayRecommendedAR = object.arrayRecommendedAR
                    objH?.arrayRecommendedEN = object.arrayRecommendedEN
                    objH?.arrOffersHomeAr = object.arrOffersHomeAr
                    
                    if SKAppType.type == .eCom {
                        self.getPopularProducts(home: objH, latitude: latitude ?? nil, longitude: longitude ?? nil)
                    }
                    
                    if AppSettings.shared.isSingleVendor {
                        self.getProductListing(home: objH, latitude: latitude ?? nil, longitude: longitude ?? nil)
                        return
                    } else {
                        if SKAppType.type == .food {
                            self.getRestorents(home: objH, showSkelton: true, latitude: latitude ?? nil, longitude: longitude ?? nil)
                            return
                        }
                    }
                    
                    self.stopSkeletonAnimation(self.tableView)
                    if objH?.arrayOffersEN?.count == 0 && objH?.arrayOffersAR?.count == 0 && objH?.arrayRecommendedEN?.count == 0 && objH?.arrayRecommendedAR?.count == 0 && objH?.arrayServiceTypesEN?.count == 0 && objH?.itemsBanners?.count == 0{
                        
                        self.placeholder_view.isHidden = false
                        self.viewSearch.isHidden = true
                    } else {
                        self.placeholder_view.isHidden = true
                        self.viewSearch.isHidden = false
                        
                        self.home = objH//GDataSingleton.sharedInstance.homeData
                    }
                }
                break
                
            default :
                break
            }
            
            if self.home == nil {
                self.home = home
            }
            
        }
    }
    
    func getRestorents(home: Home?,showSkelton: Bool = false,latitude: Double?,longitude: Double?)  {
        
        //        if !LocationSingleton.sharedInstance.isLocationSelected() {
        //            self.home = home
        //            return
        //        }
        
        let objR = API.getRestorentList(latitude: latitude ?? nil, longitude: longitude ?? nil, search: "")
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            if showSkelton {
                self.stopSkeletonAnimation(self.tableView)
            }
            switch response {
            case APIResponse.Success(let object):
                let objH = home
                //objH?.arrayAllRecommended = (object as? [Supplier]) ?? []
                objH?.arrayRecommendedEN = (object as? [Supplier]) ?? []
                self.home = objH
                self.tableView.reloadData()
                break
            default :
                print("Hello Nitin")
                break
            }
            
            if self.home == nil{
                self.home = home
            }
            
        }
    }
    
    
    func getProductListing(home: Home?,latitude: Double?,longitude: Double?)  {
        
        let supplierId = String(AppSettings.shared.supplierId)
        let objR = API.getProductList(supplierId: supplierId, latitude: latitude ?? nil, longitude: longitude ?? nil)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: false, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            self.stopSkeletonAnimation(self.tableView)
            switch response {
            case APIResponse.Success(let object):
                let objH = home
                guard let objModel = object as? MenuProductSection else { return }
                objH?.arrProductsList = objModel.arrayProduct ?? []
                GDataSingleton.sharedInstance.homeData = objH
                //self.filterData = objH?.arrProductsList
                
                //  self.homeDataSource?.home = objH
                self.home = objH
                self.isDataFetched = false
                break
            default :
                break
            }
        }
    }
    
    func getPopularProducts(home: Home?, latitude: Double?, longitude: Double?)  {
        
        let objR = API.getPopularProducts(lat: /latitude, lng: /longitude)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: false, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            self.stopSkeletonAnimation(self.tableView)
            switch response {
            case APIResponse.Success(let object):
                let objH = home
                guard let objModel = object as? PopularProductsList else { return }
                objH?.arrPopularProducts = objModel.arrayProduct ?? []
                GDataSingleton.sharedInstance.homeData = objH
                //self.filterData = objH?.arrProductsList
                
                //  self.homeDataSource?.home = objH
                self.home = objH
                self.isDataFetched = false
                break
            default :
                break
            }
        }
    }
    
}

//MARK: - TableView Configuration
extension HomeViewController {
    
    func configureTableViewInitialization() {
        
        homeDataSource = HomeDataSource(home: home, tableView: tableView, configureCellBlock: {
            [weak self] (indexPath,cell, item , type) in
            guard let self = self else { return }
            self.configureCell(withCell: cell, item: item, type: type, indexPath: indexPath)
            
            }, aRowSelectedListener: {
                [weak self] (indexPath , type) in
                guard let self = self else { return }
                self.itemClicked(atIndexPath: indexPath, type: type)
        })
    }
    
    func configureCell(withCell cell : Any , item : Any , type : HomeScreenSection,indexPath:IndexPath) {
        
        if let cell = cell as? HomeServiceCategoriesTableCell, let item = item as? Home {
            cell.selectionStyle = .none
            cell.delegate = self
            cell.type = type
            var count = /item.arrayServiceTypesEN?.count
            
            if type == .listCategories1st2 {
                //                if SKAppType.type.isJNJ {
                //                    if count >= 5 {
                //                        count = 5
                //                    }
                //                } else {
                //                    if count >= 2 {
                //                        // count = 2
                //                    }
                //                }
                cell.arrayItems = Array(item.arrayServiceTypesEN?[0..<count] ?? [])
            } else {
                if SKAppType.type.isJNJ {
                    cell.arrayItems = Array(item.arrayServiceTypesEN?[5...] ?? [])
                } else {
                    cell.arrayItems = Array(item.arrayServiceTypesEN?[0..<count] ?? [])
                }
            }
            return
        } else if let cell = cell as? HomeOffersHListTableCell, let item = item as? Home {
            cell.selectionStyle = .none
            cell.type = type
            if SKAppType.type == .eCom && type == .PopularProducts {
                cell.arrayItems = item.arrPopularProducts
            }
            else if SKAppType.type == .food {
                cell.arrayItems = item.arrayOffersEN
            } else {
                cell.arrayItems = item.arrayOffersEN
            }
            
            return
        }
        
        switch type {
        case .Menu :
            if let cell = cell as? HomeMenuCollectionTableCell {
                cell.selectionStyle = .none
                
                cell.blockSelectMenu = {
                    (objManu) in
                    
                    switch objManu {
                        
                    case .discountItems:
                        let index = IndexPath(row: NSNotFound, section: 4)
                        if (self.home?.arrayOffersEN ?? []).isEmpty {
                            return
                        }
                        self.tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.middle, animated: true)
                        
                    case .brands:
                        let index = IndexPath(row: NSNotFound, section: 5)
                        if (self.home?.arrayBrands ?? []).isEmpty {
                            return
                        }
                        self.tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.middle, animated: true)
                        
                    case .recommended:
                        let index = IndexPath(row: NSNotFound, section: 7)
                        if (self.home?.arrayRecommendedEN ?? []).isEmpty {
                            return
                        }
                        self.tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.middle, animated: true)
                    }
                }
            }
        case .Brands :
            if let cell = cell as? HomeBrandsCollectionTableCell {
                cell.selectionStyle = .none
                if SKAppType.type == .eCom {
                    cell.arrayBrands = (item as? Home)?.arrayBrands
                }
                else if SKAppType.type == .food {
                    cell.arraySuppliers = (item as? Home)?.arrayRecommendedEN
                    
                } else {
                    cell.arraySuppliers = (item as? Home)?.arrayRecommendedEN
                    
                    //                    cell.arrayBrands = (item as? Home)?.arrayBrands
                }
                
                cell.blockSelectSupplier = {
                    (objSupplier) in
                    self.openSupplier(supplier: objSupplier)
                    
                }
                
                cell.blockSelectBrand = {
                    (objBrand) in
                    
                    let vc =  ItemListingViewController.getVC(.main)
                    vc.brandName = objBrand.name
                    vc.passedData = PassedData(withCatergoryId: nil, categoryFlow: nil, supplierId: nil ,subCategoryId: nil ,productId: nil,branchId: objBrand.id.toString, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
                    self.pushVC(vc)
                    
                }
            }
            else if let cell = cell as? HomeSupplierTableCell {
                if let supplier = (item as? Home)?.arrayRecommendedEN?[indexPath.row] {
                    cell.objModel = supplier
                    cell.blockSelect = {
                        [weak self] supplier in
                        guard let self = self else { return }
                        self.openSupplier(supplier: supplier)
                    }
                }
            }
            
        case .listCategories :
            if let tempCell = cell as? ServiceTypeParentCell{
                tempCell.selectionStyle = .none
                if SKAppType.type == .food {
                let selectedCatId = AppSettings.shared.selectedCategoryId
                let catgeories = L102Language.currentAppleLanguage() == Languages.Arabic ? (item as? Home)?.arrayServiceTypesAR : (item as? Home)?.arrayServiceTypesEN
                
                let selectedCat = catgeories?.filter{$0.id == /selectedCatId}.first
            
                tempCell.categoryTypes = arrayAllSubcategories
                }
                else{
                tempCell.serviceTypes = Localize.currentLanguage() == Languages.Arabic ? (item as? Home)?.arrayServiceTypesAR : (item as? Home)?.arrayServiceTypesEN
                }
                tempCell.delegate = self
            }
            
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
                    
                    
                    //                                    self.passedData.supplierId = banner?.supplierId
                    //                                    self.passedData.supplierBranchId = banner?.supplierBranchId
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
            
        case .Offers, .Offers1st3, .Offers2nd3:
            
            if let cell = cell as? ProductListingCell, let item = item as? ProductF {
                cell.selectionStyle = .none
                
                cell.isHideStepper = SKAppType.type == .eCom
                cell.isForCart = false
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.category = self.passedData.categoryOrder
                cell.categoryId = self.passedData.categoryId
                cell.product = item
                cell.viewBG.shadowOpacity = 0.0
                cell.leadingBGView.constant = 8.0
                //   cell.lblLine.isHidden = false
                cell.lblLine.isHidden = true
                cell.productClicked = {
                    [weak self] product in
                    guard let self = self else { return }
                    self.openProduct(objProduct: product)
                }
            } else if let cell = cell as? HomeFoodRestaurantTableCell, let item = item as? Supplier {
                cell.isSkeletonable = true
                cell.objModel = item
                cell.selectionStyle = .none
                
                cell.blockSelect = {
                    [weak self] supplier in
                    guard let self = self else { return }
                    self.openSupplier(supplier: supplier)
                }
                
            }else if let tempCell = cell as? HomeProductParentCell{
                tempCell.selectionStyle = .none
                
                tempCell.isRecomented = false
                tempCell.lblSubTitle.text = L11n.awesomeDealsUnlockedEveryday.string
                
                tempCell.products = Localize.currentLanguage() == Languages.Arabic ? (item as? Home)?.arrayOffersAR : (item as? Home)?.arrayOffersEN
                tempCell.delegate = self
            }
        case .Search:
            break
            
        case .ProductList:
            if let tempCell = cell as? ProductListCell, let itemValue = GDataSingleton.sharedInstance.homeProductList, itemValue.count > 0{
                
                tempCell.selectionStyle = .none
                var newSection : Int?
                newSection = indexPath.section
                if AppSettings.shared.isSingleVendor {
                    let offset = HomeScreenSection.allValues.firstIndex(of: .ProductList)
                    let products = itemValue[indexPath.section - /offset].productValue
                    tempCell.selectedIndex = indexPath.row
                    tempCell.product = products?[indexPath.row]
                    
                    //                    if newSection ?? 0 == 2 {
                    //                        if let products = itemValue[0].productValue {
                    //                            tempCell.selectedIndex = indexPath.row
                    //                            tempCell.product = products[indexPath.row]
                    //                        }
                    //                    } else if newSection ?? 0 == 3 {
                    //                        if let products = itemValue[1].productValue {
                    //                            tempCell.selectedIndex = indexPath.row
                    //                            tempCell.product = products[indexPath.row]
                    //                        }
                    //                    }
                } else {
                    if newSection ?? 0 >= itemValue.count-1   {
                        let diff = newSection! - (itemValue.count-1)
                        if let products = itemValue[diff].productValue {
                            tempCell.selectedIndex = indexPath.row
                            tempCell.product = products[indexPath.row]
                        }
                    }
                }
                
            }
        default :
            if let tempCell = cell as? HomeProductParentCell{
                tempCell.selectionStyle = .none
                
                tempCell.isRecomented = true
                tempCell.lblSubTitle.text = L11n.checkoutSomeRecommendationsFromOurSide.string
                tempCell.suppliers = Localize.currentLanguage() == Languages.Arabic ? (item as? Home)?.arrayRecommendedAR : (item as? Home)?.arrayRecommendedEN
                tempCell.delegate = self
            }
            break
        }
        
    }
    
    func itemClicked(atIndexPath indexPath : IndexPath , type : HomeScreenSection) {
        
        switch type{
        case .Search :
            self.didTapSearch(UIButton())
            break
        case .listCategories :
            break
        case .Banners :
            break
        default :
            break
        }
    }
}

//MARK: - Product Click Listerner
extension HomeViewController : HomeProductCollectionViewDelegate {
    
    func openSupplier(supplier: Supplier?) {
        
        guard let supplier = supplier else { return }
        
        let arrayCat = supplier.categories ?? []
        
        if SKAppType.type == .home {
            collectionViewItemClicked(atIndexPath: IndexPath(item: 0, section: 0), type: supplier)
            return
        }
        
        //Nitin
        if !SKAppType.type.isFood {
            if arrayCat.isEmpty {
                return
            }
        }
        
        if SKAppType.type.isFood {
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
        
        if arrayCat.count < 2 {
            let category = arrayCat.first
            
            if SKAppType.type.isFood {
                
                let VC = RestaurantDetailVC.getVC(.splash)
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                VC.passedData.subCats = supplier.categories
                
                self.pushVC(VC)
            } else {
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                let objP = PassedData(withCatergoryId: category?.category_id,
                                      categoryFlow: flow,
                                      supplierId: supplier.id,
                                      subCategoryId: nil,
                                      productId: nil,
                                      branchId: supplier.supplierBranchId,
                                      subCategoryName: nil,
                                      categoryOrder: category?.order,
                                      categoryName: category?.category_name)
                objP.subCats = supplier.categories
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                VC.passedData = objP
                self.pushVC(VC)
            }
            return
        }
        
        let catSelectionVc = StoryboardScene.Options.instantiateCategorySelectionController()
        catSelectionVc.supplier = supplier
        catSelectionVc.ISPushAnimation = true
        catSelectionVc.arrCategory = supplier.categories
        self.pushVC(catSelectionVc)
    }
    
    func collectionViewItemClicked(atIndexPath indexPath: IndexPath, type: Any?) {
        
        if let tempSupplier = type as? Supplier {
            
            let arrayCat = tempSupplier.categories ?? []
            
            if SKAppType.type == .home {
                if let cat = arrayCat.first, cat.is_subcategory == 1 {
//                    let catVC = StoryboardScene.Main.instantiateSubcategoryViewController()
//                    let listing = SubCategoriesListing(attributes: [:])
//                    listing.arrayCategories = arrayCat
//                    catVC.objCatData = listing
//                    catVC.supplierId = tempSupplier.id
//                    pushVC(catVC)

                    guard let subCatId = cat.category_id,
                        let subCatName = cat.category_name else {
                            return
                    }
            let flow = "Category>SubCategory>Suppliers>Pl"
            self.passedData.categoryFlow = flow
            self.passedData.hasSubCats = cat.is_subcategory == 1
            self.passedData.categoryId = cat.category_id
                    FilterCategory.shared.arrayCatIds.append(subCatId)
                                   FilterCategory.shared.arrayCatNames.append(subCatName)
                                   
                                   let subcategoryViewController = StoryboardScene.Main.instantiateSubcategoryViewController()
                                   subcategoryViewController.passedData.supplierId = tempSupplier.id
                                   subcategoryViewController.passedData.categoryId = subCatId
                                   subcategoryViewController.passedData.mainCategoryId = subCatId
                                   subcategoryViewController.passedData.subCategoryName = subCatName
                                   subcategoryViewController.passedData.categoryFlow = self.passedData.categoryFlow
//                                   subcategoryViewController.passedData.supplierBranchId = self.passedData.supplierBranchId
                    self.passedData.isQuestion = false
                                   self.pushVC(subcategoryViewController)
                    
                }
                else {
                    
                    //                    self.passedData.supplierId = tempSupplier.id
                    //                    self.passedData.supplierBranchId = tempSupplier.supplierBranchId
                    //
                    //                    let flow = "Category>Suppliers>Pl" //as there are no sub cats
                    //                    passedData.categoryFlow = flow
                    //                    passedData.hasSubCats = false
                    //                    passedData.supplier = tempSupplier
                    //                    passedData.categoryId = tempSupplier.categoryId
                    //
                    //                    self.pushNextVc()
                    //
                    let vc =  ItemListingViewController.getVC(.main)
                    vc.brandName = tempSupplier.name
                    vc.passedData = PassedData(withCatergoryId: nil, categoryFlow: nil, supplierId: tempSupplier.id ,subCategoryId: nil ,productId: nil,branchId: nil, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
                    self.pushVC(vc)
                }
                return
            }
            
            
            if arrayCat.isEmpty {
                return
            }
            if SKAppType.type.isJNJ || arrayCat.count < 2 {
                let category = arrayCat.first
                let supplier = tempSupplier
                
                if SKAppType.type.isFood || SKAppType.type.isJNJ {
                    //                    let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
                    let VC = RestaurantDetailVC.getVC(.splash)
                    var flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                    if SKAppType.type.isJNJ {
                        flow = "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl"
                        VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: "5" ,subCategoryId: nil ,productId: nil,branchId: "1", subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                    } else {
                        VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: supplier.id ,subCategoryId: nil ,productId: nil,branchId: supplier.supplierBranchId, subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                    }
                    
                    VC.passedData.subCats = tempSupplier.categories
                    self.pushVC(VC)
                } else {
                    let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                    let objP = PassedData(withCatergoryId: category?.category_id,
                                          categoryFlow: flow,
                                          supplierId: supplier.id,
                                          subCategoryId: nil,
                                          productId: nil,
                                          branchId: supplier.supplierBranchId,
                                          subCategoryName: nil,
                                          categoryOrder: category?.order,
                                          categoryName: category?.category_name)
                    objP.subCats = tempSupplier.categories
                    let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                    VC.passedData = objP
                    self.pushVC(VC)
                }
                return
            }
            
            if SKAppType.type.isFood {
                //Nitin
                //            let catSelectionVc = StoryboardScene.Options.instantiateCategorySelectionController()
                //            catSelectionVc.supplier = tempSupplier
                //            catSelectionVc.ISPushAnimation = true
                //            catSelectionVc.arrCategory = tempSupplier.categories
                //            self.pushVC(catSelectionVc)
                //
                
                // for opening direct categories of a supplier
                
                let category = tempSupplier.categories?[0]
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                
                let flow = (category?.order == "3" || category?.order == "5") ? "Category>Suppliers>SupplierInfo>SubCategory>Ds-Pl" : category?.category_flow
                VC.passedData = PassedData(withCatergoryId: category?.category_id, categoryFlow: flow,supplierId: tempSupplier.id ,subCategoryId: nil ,productId: nil,branchId: tempSupplier.supplierBranchId,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.category_name)
                pushVC(VC)
                //            if VC.passedData.categoryOrder == "2" {
                //                tempSupplier.status = .Online
                //            }
                
                //  pushNextVc()
            }
            else {
                let vc = CategoryTabVC.getVC(.main)
                vc.supplierId = tempSupplier.id
                vc.categoriesFromHome = tempSupplier.categories
                self.pushVC(vc)
                //                let vc =  ItemListingViewController.getVC(.main)
                //                vc.brandName = tempSupplier.name
                //                vc.passedData = PassedData(withCatergoryId: nil, categoryFlow: nil, supplierId: tempSupplier.id ,subCategoryId: nil ,productId: nil,branchId: nil, subCategoryName: nil , categoryOrder: nil, categoryName : nil)
                //                self.pushVC(vc)
            }
            
        }
        else if let tempProduct = type as? ProductF {
            openProduct(objProduct: tempProduct)
        }
    }
}

//MARK: - Service Type Delegate Conformance
extension HomeViewController : ServiceTypeDelegate {
    
    func categoryClicked(service: ServiceType?) {
        openCategory(category: service)
    }
    
    func configureBeautySalonFlow(title : String,indexPath : IndexPath) {
        let category = home?.arrayServiceTypesEN?[indexPath.row]
        
        passedData = PassedData(withCatergoryId: category?.id, categoryFlow: category?.category_flow,supplierId: nil ,subCategoryId: nil ,productId: nil,branchId: nil,subCategoryName: nil , categoryOrder: category?.order,categoryName : category?.name)
        
        print(L10n.HOMESERVICE.string)
        
        switch title {
        case L10n.HOMESERVICE.string:
            let VC = PickupDetailsController.getVC(.laundry)
            VC.isBeautySalon = true
            VC.passedData = passedData
            pushVC(VC)
            
        case L10n.ATPLACESERVICE.string:
            pushNextVc()
        default:
            break
        }
        
    }
}



//MARK: - Splash Delegate
extension HomeViewController: SplashViewControllerDelegate {
    func locationSelected() {
        //Nitin
        if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
                strArea = name + " " + locality
            }
            webserviceHomeData(latitude: nil, longitude: nil)
            return
        } else if let address = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress{
            strArea = address
            webserviceHomeData(latitude:LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0 , longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0 )
            return
        }
        //strArea = LocationSingleton.sharedInstance.location?.getArea()?.name
        
    }
}
