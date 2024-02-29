//
//  MixedHomeVC.swift
//  Sneni
//
//  Created by Daman on 30/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class MixedHomeVC: CategoryFlowBaseViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var imgLocation: ThemeImgView!
    
    @IBOutlet var btnAddress: UIButton!
    @IBOutlet var btnAddressCutomView: UIButton!
    @IBOutlet var imgBg1: UIImageView!{
        didSet {
            imgBg1.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? true : false
        }
    }
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet var imgBg2: UIImageView!{
        didSet {
            imgBg2.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? true : false
        }
    }
    @IBOutlet weak var collectionVwBottomConst: NSLayoutConstraint!{
        didSet {
            collectionVwBottomConst.constant = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" && UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20 ? 34 : 0
        }
    }
    @IBOutlet weak var vwLocationHeader: UIView!
    @IBOutlet weak var lblBg: UILabel!{
        didSet {
            lblBg.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? false : true
            lblBg.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var stkVwLocation: UIStackView!{
        didSet {
            stkVwLocation.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? true : false
        }
    }
    @IBOutlet weak var stkVwCustomLocation: UIStackView!{
        didSet {
            stkVwCustomLocation.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? false : true
        }
    }
    @IBOutlet weak var vwLocationHeaderHeightConst: NSLayoutConstraint!{
        didSet {
            vwLocationHeaderHeightConst.constant = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? 100 : 60
        }
    }
    @IBOutlet weak var themeView: ThemeView!{
        didSet {
            themeView.backgroundColor = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? SKAppType.type.color : SKAppType.type.headerColor
            themeView.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? false : true
        }
    }
    
    
    
    var collectionViewDataSource: SKCollectionViewDataSource?
    var isLoaded = false
    var version2 = false
    var isFlagUs:Bool?
    
    var arrayItems : [ServiceType] = [] {
        didSet {
//            let cabsArr: [ServiceType] = [ServiceType(staticImage: UIImage(named: "cab")!, name: "Cab Booking"), ServiceType(staticImage: UIImage(named: "ambulance")!, name: "Ambulance"), ServiceType(staticImage: UIImage(named: "ic_pickup_2")!, name: "Pick Up")]
//            arrayItems.insert(contentsOf: cabsArr, at: 0)
            parseData()
            self.collectionView.reloadData()
            NotificationCenter.default.post(name: Notification.Name("ReloadMixedHomeHeader"), object: nil)

            isLoaded = true
        }
    }
    var parsedArr: [Any] = []
    
    var titleArray = ["Essentials, delivered at your door steps".localized(),"Health and medicine just a click away.".localized(),"Distance is no longer a problem.".localized()]
    
    
    //MARK:- Set first page data
    func parseData() {
        parsedArr = []
        
        
        var health = arrayItems.filter({ $0.type == 1 && !(/$0.name?.contains("food".localizedString, compareOption: .caseInsensitive) || /$0.name?.contains("grocer".localizedString, compareOption: .caseInsensitive)) })
        
        var cab = [ServiceType(staticImage: UIImage(named: "cab_v2")!, name: APIConstants.defaultAgentCode == "wassel_0605" ? "Cab Booking wassal".localizedString: "Cab Booking".localizedString, serviceType: .cab, "cab_v2")]
        
        if let serviceX = UDSingleton.shared.appSettings?.services {
            if serviceX.count > 0 {
                cab.removeAll()
                for service1 in serviceX {
                    if let serviceNameStr = service1.serviceName {
                        if let serviceTitleStr = service1.serviceTitle {
                            
                            if (serviceNameStr.contains("Ambulance")) {
                                health.append(ServiceType(staticImage: UIImage(named: "ambulance_v2")!, name: serviceNameStr.localizedString, serviceType: .ambulance, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                                if version2 {
                                    cab.append(ServiceType(staticImage: UIImage(named: "ambulance_v2")!, name: serviceNameStr.localizedString, serviceType: .ambulance, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                                }
                                
                            } else if (serviceTitleStr.contains("Cab")) {
                                print(serviceNameStr)
                                print(/service1.image)
                                cab.append(ServiceType(staticImage: UIImage(named: "cab_v2")!, name: serviceNameStr.localizedString, serviceType: .cab, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                                
                            } else if (serviceTitleStr.contains("Pick")) {
                                print(serviceNameStr)
                                print(/service1.image)
                                cab.append(ServiceType(staticImage: UIImage(named: "delivery_v2")!, name: serviceNameStr.localizedString, serviceType: .pickup, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                            }else if (serviceTitleStr.contains("Water")) {
                                cab.append(ServiceType(staticImage: UIImage(named: "ic_services")!, name: serviceNameStr.localizedString, serviceType: .other, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                            }
                            else  {
                                cab.append(ServiceType(staticImage: UIImage(named: "ic_services")!, name: serviceTitleStr.localizedString, serviceType: .other, service1.image, "\(String(describing: service1.serviceCategoryId!))"))
                            }
                        }
                    }
                }
            }
        }
        
        let eComX = arrayItems.filter({ $0.type == 2})
        let homeX = arrayItems.filter({ $0.type == 8})
        
        let foodItems = arrayItems.filter({ $0.type == 1 })
        let rental = arrayItems.filter({ $0.type == 5 })
        
        
        let eCom = arrayItems.filter({ $0.type == 2 && $0.id == "3"})
        let eComOther = arrayItems.filter({ $0.type == 2 && $0.id != "3"})
        let home = arrayItems.filter({ $0.type == 8 && $0.id == "4"})
        let homeOther = arrayItems.filter({ $0.type == 8 && $0.id != "4" && $0.id != "60"})
        let carService = arrayItems.filter({ $0.type == 8 && $0.id == "60"})
        
        if version2 {
            parsedArr = arrayItems
            parsedArr.append(contentsOf: cab)
            let res = parsedArr.count.quotientAndRemainder(dividingBy: 4)
            if res.remainder > 0 {
                let count = res.quotient + 1
                let diff = (4*count) - parsedArr.count
                for _ in 0..<diff {
                    //to fill extra spaces
                    parsedArr.append(ServiceType())
                }
            }
            
            if let banners = GDataSingleton.arrayMixedBanners {
//                if /AppSettings.shared.appThemeData?.is_hood_app != "1" {
//                    parsedArr.append("Daily Deals".localizedString)
//                }
                if L102Language.isRTL {
                    parsedArr.append(contentsOf: banners.reversed())
                } else {
                    parsedArr.append(contentsOf: banners)
                }
            }
        }
        else {
            if APIConstants.defaultAgentCode == "wagoon_0009" {
                
                if !foodItems.isEmpty || !eCom.isEmpty || !home.isEmpty{
                    parsedArr.append("Essentials, delivered at your door steps.".localizedString)
                    parsedArr.append(contentsOf: eCom)
                    parsedArr.append(contentsOf: foodItems)
                    parsedArr.append(contentsOf: home)
                    parsedArr.append(contentsOf: eComOther)
                    parsedArr.append(contentsOf: homeOther)
                }
                
                if !health.isEmpty {
                    //parsedArr.append(contentsOf: health)
                }
                if !cab.isEmpty || !carService.isEmpty || !rental.isEmpty{
                    parsedArr.append("Distance is no longer a problem.".localizedString)
                    parsedArr.append(contentsOf: cab)
                    parsedArr.append(contentsOf: carService)
                    parsedArr.append(contentsOf: rental)
                }
                if !eComOther.isEmpty || !homeOther.isEmpty {
                    //parsedArr.append("Explore products with different brands.".localizedString)
                }
                
            } else {
                if !foodItems.isEmpty {
                    parsedArr.append(contentsOf: foodItems)
                }
                if !eComX.isEmpty {
                    parsedArr.append(contentsOf: eComX)
                    parsedArr.append(contentsOf: rental)
                }
                if !health.isEmpty {
                    //parsedArr.append(contentsOf: health)
                }
                if !cab.isEmpty {
                    parsedArr.append(contentsOf: cab)
                }
                if !homeX.isEmpty {
                    parsedArr.append(contentsOf: homeX)
                }
            }
        }
    }
    var strArea: String? {
           didSet {
               var txt = /strArea
               if txt.isEmpty {
                   txt = L11n.select.string
               }
               btnAddress?.setTitle(txt, for: .normal)
            if AppSettings.shared.appThemeData?.custom_vertical_theme == "1" {
                btnAddressCutomView?.setTitle(txt, for: .normal)
            }
                
           }
       }
    var loadData = true

    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imgFlag.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationFetched), name: NSNotification.Name("LocationFetched"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationNotFetched), name: NSNotification.Name("LocationNotFetched"), object: nil)

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if L102Language.currentAppleLanguage() == "ar"{
            
            isFlagUs = false
            imgFlag.image = #imageLiteral(resourceName: "saudi")
        }else{
            isFlagUs = true
            imgFlag.image = #imageLiteral(resourceName: "usa")
        }
      
        
        setupView()
          if APIBasePath.secretDBKey == "15159452ed37ca739abee6bbdb8ffa2f38e7bb4b6aea427c389c349adf887fcf"{
            imgLocation.tintColor = UIColor.white
            btnAddress.setTitleColor(.white, for: .normal)
            imgBg1.isHidden = true
            imgBg1.isHidden = true
            self.view.backgroundColor = UIColor(hex: "00085c")
            
        }
         if refreshControl.superview == nil {
            setupRefreshControl()
        }
        if refereshMixedHome == "refereshMixedHome"{
            self.webserviceHomeData(latitude: LocationSingleton.sharedInstance.searchedAddress?.lat ?? 0.0, longitude: LocationSingleton.sharedInstance.searchedAddress?.long ?? 0.0)
            refereshMixedHome = ""
        }
        self.collectionView.reloadData()
    }
    
    func setupView() {
        
      
        
        version2 = AppSettings.shared.appThemeData?.app_custom_domain_theme == "1"

        if version2 {
            imgBg1.isHidden = true
            imgBg2.isHidden = true
            collectionView.registerCells(nibNames: [MixedHomeV2CategoryCell.identifier, MixedHomeV2DealCell.identifier, MixedHomeV2LabelCell.identifier])
        }
        else {
            collectionView.registerCells(nibNames: [MixedHomeLabelCell.identifier, MixedHomeLabelCell.identifier])
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        if !GDataSingleton.arrayMixedItems.isEmpty {
            arrayItems = GDataSingleton.arrayMixedItems
            loadData = false
        }
        if version2 {
            if let layout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 12
                collectionView.collectionViewLayout = layout
            }

        }
        locationFetched()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        isFlagUs = /isFlagUs?.toggled
        
        
        
        if /isFlagUs{
            imgFlag.image = #imageLiteral(resourceName: "usa")
            self.changeLanguage(language: "en")
        }else{
            imgFlag.image = #imageLiteral(resourceName: "saudi")
            self.changeLanguage(language: AppSettings.shared.appThemeData?.secondary_language ?? "sq")
        }
        
        
        //imgFlag.image = #imageLiteral(resourceName: "saudi")
    }
    
    func changeLanguage(language: String){
        UserDefaults.standard.set(language, forKey: "language")
         UserDefaultsManager.languageCode = language
        L102Language.setAppleLAnguageTo(lang: language)

         L102Localizer.changeNotificationLanguage(languageId: language == Languages.English ? "14": "15")
         UserDefaultsManager.languageId = language == Languages.English ? "14": "15"
        let delegate = UtilityFunctions.sharedAppDelegateInstance()
        delegate.switchViewControllers(language: language)
        DBManager.sharedManager.cleanCart()
        refereshMixedHome = "refereshMixedHome"

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
        if loadData == false {
            loadData = true
            return
        }
        APIManager.sharedInstance.showLoader()
        let objR = API.Home(latitude: latitude ?? nil, longitude: longitude ?? nil, catId: nil)
        APIManager.sharedInstance.opertationWithRequest(refreshControl: refreshControl, withApi: objR) {
            [weak self] (response) in
            APIManager.sharedInstance.hideLoader()
            guard let self = self else { return }
            
            switch response{
            case APIResponse.Success(let object):
                guard let homeObj = object as? Home else {return}
                GDataSingleton.arrayMixedItems = homeObj.arrayServiceTypesEN ?? []
                
                var arr:[Banner] = []
                for i in 0..<min(5, homeObj.itemsBanners?.count ?? 0) {
                    arr.append(homeObj.itemsBanners![i])
                }
                GDataSingleton.arrayMixedBanners = arr
                self.arrayItems = homeObj.arrayServiceTypesEN ?? []
            default :
                break
            }
        }
    }
    
    @IBAction func actionArea(sender : UIButton) {
          self.openLocationController()
          
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
        
        let lat = AppSettings.shared.defaultAddress?.first?.latitude ?? 17.565603599999999
        let lng = AppSettings.shared.defaultAddress?.first?.longitude ?? 44.2289441
        LocationManager.sharedInstance.currentLocation?.currentLat = lat.toString
        LocationManager.sharedInstance.currentLocation?.currentLng = lng.toString
        
        let location = CLLocation(latitude: lat, longitude: lng)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            if let placeMark = placemarks?.first {
                LocationSingleton.sharedInstance.selectedAddress = placeMark
                self.locationFetched()
                //NotificationCenter.default.post(name: NSNotification.Name("LocationFetched"), object: nil)
            }
            else {
                GDataSingleton.isAskLocationDone = false
            }
        }
        
        
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

}

////MARK: - Configure CollectionView
//extension MixedHomeVC {
//
//
//    func configureCollectionView() {
//
//        let width: CGFloat = CGFloat(((UIScreen.main.bounds.width)/2.0)-8.0)
//
//        if collectionViewDataSource == nil {
//            collectionViewDataSource = SKCollectionViewDataSource(
//                items: arrayItems,
//                collectionView: collectionView,
//                cellIdentifier: MixedHomeCollectionCell.identifier,
//                cellHeight: width*0.82,
//                cellWidth: width)
//        }
//
//        collectionViewDataSource?.configureCellBlock = {
//            (index, cell, item) in
//
//            if let cell = cell as? MixedHomeCollectionCell, let item = item as? ServiceType {
//                if index.item > 2 {
//                    cell.objModel = item
//                }
//                else {
//                    cell.imgView.image = item.staticImage
//                    cell.lblTitle.text = item.name
//                }
//            }
//
//        }
//
//        collectionViewDataSource?.aRowSelectedListener = {
//            [weak self] (indexpath, cell) in
//
//        }
//
//        collectionViewDataSource?.reload(items: arrayItems)
//    }
//}
extension MixedHomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let item = parsedArr[indexPath.item] as? String {
            if version2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MixedHomeV2LabelCell", for: indexPath) as! MixedHomeV2LabelCell
                cell.lblTitle.text = item
                return cell
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MixedHomeLabelCell", for: indexPath) as! MixedHomeLabelCell
            cell.lblTitle.text = item
            return cell
        }
        if version2 {
            if let item = parsedArr[indexPath.item] as? ServiceType {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MixedHomeV2CategoryCell.identifier, for: indexPath) as UICollectionViewCell
                
                if let cell = cell as? MixedHomeV2CategoryCell {
                    if item.name == nil {
                        cell.imgView.isHidden = true
                        cell.lblTitle.isHidden = true
                        return cell
                    }
                    cell.imgView.isHidden = false
                    cell.lblTitle.isHidden = false
                    cell.backgroundColor = UIColor.clear
                    
                    
                    cell.imgView.clipsToBounds = true
                    if item.staticImage == nil {
                        cell.objModel = item
                    }
                    else {
                        DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
                            let imagePath = APIBasePath.categoryImageBasePath + (item.image ?? "")
                            if let imageUrl = URL(string:imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                                cell.imgView.kf.setImage(with: imageUrl)
                                //cell.imgView.loadImage(thumbnail: nil, original: nil, placeHolder: item.staticImage)
                                cell.imgView.contentMode = .scaleAspectFill
                                cell.lblTitle.text = item.name
                                
                                
                                cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2.0
                            }else{
                                cell.imgView.image = item.staticImage
                                cell.imgView.contentMode = .scaleAspectFit
                            }
                        }
                    }
                    
                }
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MixedHomeV2DealCell.identifier, for: indexPath) as UICollectionViewCell
                if let cell = cell as? MixedHomeV2DealCell, let banner = parsedArr[indexPath.item] as? Banner {
                    cell.banner = banner
                }
                return cell
            }
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MixedHomeCollectionCell.identifier, for: indexPath) as UICollectionViewCell
            if let cell = cell as? MixedHomeCollectionCell, let item = parsedArr[indexPath.item] as? ServiceType {
                if item.staticImage == nil {
                    cell.objModel = item
                }
                else {
                    DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
                        let imagePath = APIBasePath.categoryImageBasePath + (item.image ?? "")
                        if let imageUrl = URL(string:imagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                            cell.imgOverlay.kf.setImage(with: imageUrl)
                            cell.lblTtlVerTheme.text = item.name?.capitalizedFirst()
                            
                            
                        } else{
                            cell.imgView.image = item.staticImage
                            cell.imgView.contentMode = .scaleAspectFit
                        }
                    }
                }
            }
            return cell
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
//        if version2{
//        return 1
//        }
        return 1//titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.parsedArr.count
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let item = parsedArr[indexPath.item] as? ServiceType else {
            if let banner = parsedArr[indexPath.item] as? Banner, let supplier = banner.supplierId, let branchId = banner.supplierBranchId, let catId = banner.category_id {
                
                let appType = SKAppType(rawValue: banner.type ?? 1) ?? .food
                GDataSingleton.arrayMixedItems = [] //clear cached categorie names
                
                DBManager.sharedManager.cleanCart()
                
                AppSettings.shared.selectedCategoryId = catId
                AppSettings.shared.appType = appType.rawValue
                
                
                webServiceSupplierInfo(supplierId: supplier, supplierBranchId: branchId, categoryId: catId, appType: appType)
            }
            return
        }
        if item.staticImage == nil && item.name != nil {
            
            GDataSingleton.arrayMixedItems = [] //clear cached categorie names
            
            DBManager.sharedManager.cleanCart()
            
            AppSettings.shared.selectedCategoryId = item.id
            AppSettings.shared.orderInstructions = item.order_instructions == "1"
            AppSettings.shared.appThemeData?.terminology = item.terminology
            //AppSettings.shared.appThemeData?.is_table_booking = item.is_dine
            AppSettings.shared.appType = item.type
            
            
//            if SKAppType.type != .food {
//                AppSettings.shared.appThemeData?.show_supplier_detail = "1"
//            } else {
//                AppSettings.shared.appThemeData?.show_supplier_detail = "0"
//            }
//
            if item.is_laundary == 1 {
                
             
                
                if item.type == 8 {
                    if let obj = AppSettings.shared.arrayBookingFlow {
                        if obj.count > 0 {
                            AppSettings.shared.arrayBookingFlow?[0].vendorStatus = 0
                            AppSettings.shared.arrayBookingFlow?[0].cartFlow = 3
                        }
                    }
                }
            } else {
                if item.type == 8 {
                    if let obj = AppSettings.shared.arrayBookingFlow {
                        if obj.count > 0 {
                            AppSettings.shared.arrayBookingFlow?[0].vendorStatus = 0
                            AppSettings.shared.arrayBookingFlow?[0].cartFlow = 1
                        }
                    }
                } else {
                    if let obj = AppSettings.shared.arrayBookingFlow {
                        if obj.count > 0 {
                            AppSettings.shared.arrayBookingFlow?[0].vendorStatus = 1
                            AppSettings.shared.arrayBookingFlow?[0].cartFlow = 3
                        }
                    }
                }
                
                
            }
            AppDelegate.shared().showFoodApp()
            
        }
        else if let type = item.serviceType {
            GDataSingleton.sharedInstance.selectedServiceIndex = type
            DBManager.sharedManager.cleanCart()
            
            AppSettings.shared.selectedCategoryId = item.id
            AppSettings.shared.appType = item.type
            
            AppDelegate.shared().showCabApp()
        }
        
        
    }
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        

        if kind == UICollectionView.elementKindSectionHeader {
            
            let viewHeader =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderClcReusableView
            
            return viewHeader
        }
            else if kind == UICollectionView.elementKindSectionFooter {
               
                let viewHeader =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
                return viewHeader
            }
        else {
            return UICollectionReusableView()
        }
        
    }
}

extension MixedHomeVC: UICollectionViewDelegateFlowLayout {
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if version2 {
            
            let sectionItem = parsedArr[indexPath.section] as! [Any]
            if sectionItem[indexPath.item] is String {
                let width: CGFloat = CGFloat(UIScreen.main.bounds.width)
                return CGSize(width: width, height: 50)
            }
            if sectionItem[indexPath.item] is ServiceType {
                let width: CGFloat = min(CGFloat(UIScreen.main.bounds.width-(5*8))/4.0, 96)
                return CGSize(width: width, height: width + 40)
            }
            else {
                let width: CGFloat = CGFloat(UIScreen.main.bounds.width) - 32
                return CGSize(width: width, height: width/3.8)
            }

        }
        else {
   
            if APIBasePath.secretDBKey == "15159452ed37ca739abee6bbdb8ffa2f38e7bb4b6aea427c389c349adf887fcf"{
                
                let width: CGFloat = CGFloat(((UIScreen.main.bounds.width)/2.0)-15.0)
                return CGSize(width: width, height: width * 0.82)
            }
            if AppSettings.shared.appThemeData?.custom_vertical_theme == "1" {
                
                let width: CGFloat = CGFloat(((UIScreen.main.bounds.width)/1.0)-20.0)
                return CGSize(width: width, height: width * 0.50)
            }
            let width: CGFloat = CGFloat(((UIScreen.main.bounds.width)/2.0)-15.0)
            return CGSize(width: width, height: width * 0.82)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                
        return 20.0
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 5.0
    }
}


extension MixedHomeVC {
    
    func webServiceSupplierInfo(supplierId: String, supplierBranchId: String, categoryId: String, appType: SKAppType) {
        let objR = API.SupplierInfo(FormatAPIParameters.SupplierInfo(supplierId: supplierId, branchId: supplierBranchId, accessToken: GDataSingleton.sharedInstance.loggedInUser?.token, categoryId : categoryId).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            
            switch response{
                
            case .Success(let listing):
                if let supplier = listing as? Supplier {
                    self?.openSupplier(supplier: supplier, appType: appType)
                }
                
            default :
                break
            }
        }
    }
 
}
class MixedHomeBannerCell : UICollectionViewCell {
    @IBOutlet weak var imgVw: UIImageView!
    var banner: Banner? {
        didSet {
            DispatchQueue.main.asyncAfter(wallDeadline: .now()) {
                if let img = self.banner?.website_image {
                    self.imgVw.loadImage(thumbnail: img, original: nil, modeType: .scaleAspectFill)
                    self.imgVw.layer.cornerRadius = 5.0
                }
                else {
                    self.imgVw.image = self.banner?.staticImage
                }
            }
        }
    }
}
