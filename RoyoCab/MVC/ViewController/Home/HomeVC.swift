//
//  HomeVC.swift
//  Buraq24
//
//  Created by MANINDER on 31/07/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//


import UIKit
import GoogleMaps
import GooglePlaces
import DropDown
import SideMenu
import Crashlytics
import Fabric
import NVActivityIndicatorView
import ObjectMapper
import Razorpay

protocol BookRequestDelegate {
    
    func didSelectServiceType(_ serviceSelected : Service)
    
    func didSelectBrandProduct(_ brand : Brand ,_ product : ProductCab)
    
    func didSelectQuantity( count : Int)
    
    func didSelectNext( type : ActionType)
    
    func didSelectSchedulingDate(date : Date, minDate: Date)
    
    func didGetRequestDetails(request : ServiceRequest )
    
    func didGetRequestDetailWithScheduling(request : ServiceRequest)
    
    func didRequestTimeout()
    
     func didSelectAddTip(order : OrderCab)
    
    func didPaymentModeChanged(paymentMode: PaymentType, selectedCard: CardCab?)
    
    func didRatingSubmit(ratingValue : Int, comment : String)
    func didSkipRating()
    
    func didBuyEToken(brandId :Int, brandProductId:Int)
    
    //Selecting Freight Service Order
    
    func didSelectedFreightBrand(brand : Brand)
    func didSelectedFreightProduct(product : ProductCab, isSchedule: Bool)
    
    func didClickConfirmBooking(request: ServiceRequest)
    func didClickInvoiceInfoButton()
    
    func didClickContinueToBookforFriend(request: ServiceRequest)
    
    func didScanRoadPickUPQRCode(object: RoadPickupModal?)
    
    func optionApplyCouponCodeClicked(object: Coupon?)
    func didPayOutstanding(request: ServiceRequest)
    func didChooseAddressFromRecent(place: AddressCab?, isPickup: Bool?)
    
    func didAddLocationFrom(buttonTag: Int, isFromSearch: Bool?)
    
    func didShowCheckList(order: OrderCab?)
    
    
}

class HomeVC: UIViewController {
    //MARK:- OUTLETS
    
    @IBOutlet weak var btnGoHome: RoundShadowButton!{
        didSet{
            btnGoHome.setTitle("Go to Home".localizedString, for: .normal)
        }
    }
    //  @IBOutlet var constraintNavigationLocationBar: NSLayoutConstraint!
    @IBOutlet weak var imgHome: UIImageView!
    @IBOutlet weak var constraintYAddLocationView: NSLayoutConstraint!
    @IBOutlet weak var constraintNavigationBasicBar: NSLayoutConstraint!
    //  @IBOutlet weak var constraintHeightPickUpView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightNavigationBar: NSLayoutConstraint!
    // @IBOutlet var constraintOnlyBackButtonTop: NSLayoutConstraint!
    @IBOutlet var constraintTopSegmentedView: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightViewEnterPickDrop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomTablelocationsearch: NSLayoutConstraint!
    
    
    @IBOutlet var viewTopBarBasicHome: UIView!
    @IBOutlet weak var viewTitlePackageBooking: UIView!
    @IBOutlet var viewTopBarAddLocation: UIView!
    @IBOutlet var viewLocationTableContainer: UIView!
    //  @IBOutlet var viewPickUpLocation: UIView!
    @IBOutlet weak var viewStop1: UIView!
    @IBOutlet weak var viewStop2: UIView!
    @IBOutlet var viewMapContainer: UIView!
    @IBOutlet var viewBottom: UIView!
    @IBOutlet weak var ViewEnterPickUpDropOff: RoundShadowButton!
    @IBOutlet weak var ViewForfriend: RoundShadowButton!
    @IBOutlet weak var viewStoppageDesc: UIView!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewStatusBar: UIView!
    @IBOutlet weak var viewOnMApNavigation: UIView!
    
    
    //view Enter Order Details
    
    @IBOutlet var viewSelectService: SelectServiceView!
    @IBOutlet var viewGasService: GasServiceView!
    @IBOutlet var viewScheduler: SchedulerView!
    @IBOutlet var viewDrinkingWaterService: DrinkingWaterView!
    @IBOutlet var viewOrderPricing: OrderPricing!
    // @IBOutlet var viewConfirmPickUp: ConfirmPickupView?
    @IBOutlet var viewUnderProcess: UnderProcessingView!
    @IBOutlet var viewDriverAccepted: RequestAcceptedView!
    @IBOutlet var viewInvoice: InvoiceView!
    @IBOutlet var viewDriverRating: DriverRatingView!
    @IBOutlet var viewNewInvoice: NewInvoiceView!
    @IBOutlet var viewChooseAddress: ChooseAddress!
    @IBOutlet var viewAddLocationFrom: AddLocationFrom!
    
    ///Freight Modeule
    @IBOutlet var viewFreightBrand: SelectBrandView!
    @IBOutlet var viewFreightProduct: SelectProductView!
    @IBOutlet var viewFreightOrder: FreightView!
    @IBOutlet var bottomViewBookforFriend: BookForFriendView!
    
    @IBOutlet var tblLocationSearch: UITableView!
    @IBOutlet var collectionSavedPlaces: UICollectionView?
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var segmentedMapType: UISegmentedControl!
    @IBOutlet var stackViewLocation: UIStackView?
    @IBOutlet weak var lblBookTaxi: UILabel!
    
    @IBOutlet weak var btnRoadPickup: RoundShadowButton!
    
    
    // @IBOutlet var btnLocationNext: UIButton!
    //  @IBOutlet var btnLocationBack: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnOnlyBack: UIButton!
    @IBOutlet weak var buttonAddStop: UIButton!
    @IBOutlet var btnRightNavigationBar: UIButton!
    @IBOutlet var btnLeftNavigationBar: UIButton!
    @IBOutlet var lblTitleNavigationBar: UILabel!
    @IBOutlet var btnCurrentLocation: UIButton!
    @IBOutlet weak var buttonContinue: UIButton!
    @IBOutlet var addSavedPlaces: UIButton?
    @IBOutlet weak var buttonHeaderBookingFor: UIButton!
    @IBOutlet weak var buttonEditHomeAddress: UIButton!
    @IBOutlet weak var buttonEditWorkAddress: UIButton!
    @IBOutlet weak var buttonNewSideMenu: UIButton!
    @IBOutlet weak var buttonNewCurrentLocation: UIButton!
    @IBOutlet weak var buttonNewSelectLocation: UIButton!
    @IBOutlet weak var buttonNewBack: UIButton!
    @IBOutlet weak var buttonlNavigationTitle: UIButton!
    
    
    @IBOutlet var txtStop1: UITextField!
    @IBOutlet var txtStop2: UITextField!
    @IBOutlet var txtPickUpLocation: UITextField!
    @IBOutlet var txtDropOffLocation: UITextField!
    
    @IBOutlet weak var labelHomeLocationNickName: UILabel!
    @IBOutlet weak var labelHomeLocationName: UILabel!
    @IBOutlet weak var labelWorkLocationNickName: UILabel!
    @IBOutlet weak var labelWorkLocationName: UILabel!
    
    @IBOutlet var imgViewPickingLocation: UIImageView!
    @IBOutlet weak var imageViewHeaderProfilePic: UIImageView!
    @IBOutlet weak var workLocationView: UIView!
    @IBOutlet weak var imgStaticHome: UIImageView!
    @IBOutlet weak var imgStaticWork: UIImageView!
    @IBOutlet weak var lblRecentLocation: UILabel!
    @IBOutlet weak var imgPickUp: UIImageView!
    @IBOutlet weak var imgDropOff: UIImageView!
    @IBOutlet weak var imgSpacer: UIImageView!
    
    @IBOutlet weak var imgDropIcon: UIImageView!
    @IBOutlet weak var forMeView: UIView!
    @IBOutlet weak var stackForMe: UIStackView!
    @IBOutlet weak var btnWatchEarn: UIButton!
    
    
    
    //MARK:- PROPERTIES
    
    var mapDataSource:GoogleMapsDataSource?
    
    var collectionViewWaterDataSource : CollectionViewDataSourceCab?
    var collectionViewPlacesDataSource : CollectionViewDataSourceCab? {
        didSet {
            collectionSavedPlaces?.delegate = collectionViewPlacesDataSource
            collectionSavedPlaces?.dataSource = collectionViewPlacesDataSource
            collectionSavedPlaces?.reloadData()
            
        }
    }
    
    var isCurrentLocationUpdated : Bool = false
    
    var change : Float = 0.05
    
    ///Searching Location TableView
    lazy var movingDrivers : [MovingVehicle] = [MovingVehicle]()
    var drivers: [HomeDriver]?
    var currentService : Int = 7 // Change here for service
    var tableDataSource : TableViewDataSourceCab?
    var googlePickupLocation : GooglePlaceDataSource?
    var googleDropOffLocation : GooglePlaceDataSource?
    var googleStop1Location : GooglePlaceDataSource?
    var googleStop2Location : GooglePlaceDataSource?
    var updateMapLocation = false
    
    var locationEdit : LocationEditing = .DropOff {
        didSet {
            imgViewPickingLocation.image = locationEdit == .DropOff ? #imageLiteral(resourceName: "DropMarker") : #imageLiteral(resourceName: "PickUpMarker")
        }
    }
    
    lazy var recentLocations = [AddressCab]()
    
    /* var results = [GMSAutocompletePrediction]() {
     didSet {
     // Ankush viewLocationTableContainer.alpha = results.count == 0 ? 0 : 1
     tblLocationSearch.reloadData()
     }
     } */
    
    let user = UDSingleton.shared.userData
    
    var arraySaveName = ["Home", "Work", "Others"]
    var dataItems : [String] = []
    
    var currentLocation : CLLocation?
    
    var isMapLoaded : Bool = false
    var timerMovingVehicle : Timer?
    var currentSeconds: Float  = 0
    
    var polyPath : GMSMutablePath?
    var polyline : GMSPolyline?
    
    var timer: Timer!
    var i: UInt = 0
    var animationPath = GMSMutablePath()
    var animationPolyline = GMSPolyline()
    
    
    lazy var driverMarker = GMSMarker()
    lazy  var userMarker  = GMSMarker()
    
    var durationLeft : String = ""
    
    
    var destination : CLLocationCoordinate2D?
    var source : CLLocationCoordinate2D?
    
    var isDoneCurrentPolyline : Bool = true
    var isStopsShownAfterStartRide : Bool = false
    
    var isCurrent : Bool = false
    var isFocus  : Bool = false
    var lastPoints : String = ""
    var driverBearing : Double?
    var isSearching : Bool = false
    
    
    var locationLatest : String = ""
    var latitudeLatest : Double?
    var longitudeLatest : Double?
    var isCheck = false
    
    //MENU Navigation Controller
   //MENU Navigation Controller
    var  menuLeftNavigationController : UISideMenuNavigationController?
    var  menuRightNavigationController : UISideMenuNavigationController?
    var markerPickUpLocation : GMSMarker?
    var markerDropOffLocation : GMSMarker?    
    
    var tempPickUp : String = ""
    var tempDropOff : String = ""
    // var tempStop1 : String = ""
    // var tempStop2 : String = ""
    
    var serviceRequest : ServiceRequest = ServiceRequest()
    var homeAPI : HomeCab?
    var currentOrder : OrderCab?
    var isFromPackage: Bool = false
    var modalPackages: TravelPackages?
    
    var dic = [String:TrackingModel]()
    
    var isSwitchRiderViewOpened: Bool = false
    var reasonPopupType : ReasonPopuptype?
    var isTransferRequestPopUpShown : Bool = false
    var isLongDistancePopUpShown : Bool = false
    
    var razorpay: RazorpayCheckout?
    var razorpayTestKey = /UDSingleton.shared.appSettings?.appSettings?.razorpaytestkey
    var razorPayment = false
    var order_id = String()
    
    var screenType : ScreenType = ScreenType(mapMode: .ZeroMode, entryType: .Forward) {
        
        didSet {
            
            let entryType = screenType.entryType
            let mode = screenType.mapMode
            
            switch mode {
            case .ZeroMode:
                showBasicNavigation(updateType: .NormalMode)
                
            case .NormalMode:
                showBasicNavigation(updateType: .NormalMode)
                
                startMovingVehicleTimer()
                
                if entryType == .Backward {
                    moveToCurrentLocation()
                    clearServiceRequestData()
                    setupInitialUI()
                }
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                case .Moby?:
                   break
            
                default:
                    showSelectServiceView()
                }
                
            case .SelectingLocationMode:
                clearMovingVehicles()
                showBasicNavigation(updateType: .SelectingLocationMode)
                
            case .OrderDetail: // FrightImages  pop uo treated as
                showBasicNavigation(updateType: .OrderDetail)
                showParticularAddOrderView(type: entryType)
                
            case .ScheduleMode :
                
                showBasicNavigation(updateType: .OrderDetail)
                showSchedulerView(moveType: entryType)
                
            case .OrderPricingMode:
                
                serviceRequest.cancellation_charges = nil // click on pay to next driver and cancel on underprocessing view
                apiGetCreditpoints()
                showPricingView(moveType: entryType)
                showBasicNavigation(updateType: .OrderPricingMode)
                
                /* case .ConfirmPickup:
                 debugPrint("Need to handle")
                 showConfirmPickUpView(moveType: entryType)
                 clearMovingVehicles()
                 configureConfirmPickUpMapView() */
                
            case .UnderProcessingMode:
                showProcessingView(moveType: .Forward)
                
            case .RequestAcceptedMode , .OnTrackMode:
                clearMovingVehicles()
                showBasicNavigation(updateType: .RequestAcceptedMode)
                showDriverView()
                
            case .ServiceDoneMode:
                
                viewUnderProcess.minimizeProcessingView()
                
                //showNewInvoiceView()
               
                showBasicNavigation(updateType: .ServiceDoneMode)
                
                 let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
                if paymentGateway == PaymentGateway.paystack || paymentGateway == PaymentGateway.payku || paymentGateway == PaymentGateway.razorpay{
                    
                    if paymentGateway == PaymentGateway.razorpay {
                        
                        NotificationCenter.default.addObserver(self, selector: #selector(self.methodRazorpay(notification:)), name: Notification.Name("RazorPaySucccess"), object: nil)

                        guard let razorPayWaiting = R.storyboard.bookService.razorPayWaitingVC() else { return }
                        razorPayWaiting.order = currentOrder
                        self.pushVC(razorPayWaiting)
                                                
                    } else {
                         showUrlPaymentView()
                    }
                    
                }
                else if  paymentGateway == PaymentGateway.braintree && currentOrder?.payment?.paymentType == .Card {
                                  
                                  self.payViaPayPal()
                        }
                else{
                 
                     showNewInvoiceView()
                }
                
                // Ankush need to handle  showInvoiceView()
                
            case .ServiceFeedBackMode:
                break;
                
            case .SelectingFreightBrand:
                
                showBasicNavigation(updateType: .SelectingFreightBrand)
                
                let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
                
                switch template {
                    
                case .Default?:
                    dropPickUpAndDropOffPins(pickLat: /serviceRequest.latitudeDest, pickLong: /serviceRequest.longitudeDest, dropLat: /serviceRequest.latitude, dropLong: /serviceRequest.longitude)
                    
                default:
                    break
                    
                }
                
                showFreightBrandView(moveType: entryType)
                
                
            case .SelectingFreightProduct:
                
                showFreightProductView(moveType: entryType)
            }
        }
    }
    
    var locationType : LocationTypeCab = .OnlyDropOff {
        didSet {
            //  viewPickUpLocation.alpha  = locationType == .PickUpDropOff  ? 1 : 0
            //            constraintHeightPickUpView.constant = locationType == .PickUpDropOff  ? 55 : 0
        }
    }
    
    
    
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        razorpay = RazorpayCheckout.initWithKey(razorpayTestKey, andDelegate: self)
        btnWatchEarn.isHidden = true
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
              switch template {
              case .DeliverSome:
                   buttonEditHomeAddress.setButtonWithTintColorSecondary()
                   buttonEditWorkAddress.setButtonWithTintColorSecondary()
                   buttonAddStop.isHidden = true
                   imgStaticHome.setImageTintColorSecondary()
                   imgStaticWork.image = #imageLiteral(resourceName: "ic_new_Work")
                   imgStaticWork.setImageTintColorSecondary()
                   lblRecentLocation.text = "Home.Recent_Locations".localizedString
                   lblRecentLocation.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                   imgPickUp.setImageTintColorSecondary()
                   imgDropIcon.image = #imageLiteral(resourceName: "ic_nav")
                   forMeView.isHidden = true
                   btnRoadPickup.isHidden = true
                   lblBookTaxi.text = "Home.Book_a_delivery".localizedString
                   stackForMe.isHidden = true
                   
                   
                  break
                
              case .GoMove:
                lblBookTaxi.text = "Home.Book_a_service".localizedString
                btnRoadPickup.isHidden = true
               
                break
              default:
                    buttonEditHomeAddress.setButtonWithTintColorSecondary()
                    buttonEditWorkAddress.setButtonWithTintColorSecondary()
                    btnWatchEarn.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
                    buttonAddStop.isHidden = false
                lblBookTaxi.text = "Home.Book_a_service".localizedString
                lblRecentLocation.text = "Home.Recent_Locations".localizedString
              }
        
        
        if !isFromPackage {
            setUpSideMenuPanels()
        }
        
        SocketIOManagerCab.shared.initialiseSocketManager()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.nCancelFromBookinScreen(notifcation:)), name: Notification.Name(rawValue: LocalNotifications.nCancelFromBookinScreen.rawValue), object: nil)
        
        /* if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
         statusBar.backgroundColor = UIColor.clear
         } */
        
        // self.listeningEvent()
        
        // configureSavePlacesCollectionView()
        
        
    }
    
    
    @objc func methodRazorpay(notification: Notification) {
        showNewInvoiceView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMapLocation = true
        
        checkForLocationPermissoion()
        
        collectionViewPlacesDataSource?.items = dataItems
        collectionSavedPlaces?.reloadData()
        showCollectionView()
        if !isMapLoaded {
            configureMapView()
            getCoronaAreas()
            setUpBasicSettings()
            isMapLoaded = !isMapLoaded
            getUpdatedData()
        }
        
        addForgroundObserver()
        addKeyBoardObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeKeyBoardObserver()
       // imgHome.setImageTintColorSecondary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateData()
        
        self.listeningEvent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if screenType.mapMode == .NormalMode {
            clearMovingVehicles()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .Moby?:
            return .lightContent
            
        default:
            return .default
        }
}
    
    //MARK:-  ACTIONS
    
    @IBAction func logoCLicked(_ sender: Any) {
        AppDelegate.shared().switchViewControllers()
    }
    
    /// Setting action for left and right navigation bar button
    @IBAction func actionBtnMenuPressed(_ sender: UIButton) {
        presentMenu(type: .Left)
    }
    
    @IBAction func btnWatchEarnAction(_ sender: Any) {
        
        guard let vc = R.storyboard.bookService.storyVC() else{return}
        self.pushVC(vc)
        
    }
    
    
    @IBAction func actionBtnChangeMaptype(_ sender: UISegmentedControl) {
        
        if let mapType = UserDefaultsManager.shared.mapType {
            guard let mapEnum = BuraqMapType(rawValue: mapType) else { return }
            mapView.mapType = mapEnum == .Hybrid ? .hybrid : .normal
            UserDefaultsManager.shared.mapType = mapEnum == .Hybrid ? BuraqMapType.Satellite.rawValue : BuraqMapType.Hybrid.rawValue
            guard let polylin = self.polyline else{return}
            // Ankush polylin.strokeColor  = mapEnum == .Hybrid ? .white : .darkGray
            
            let color = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
            polylin.strokeColor = color

        }
    }
    
    @IBAction func actionBtnCurrentLocation(_ sender: UIButton) {
        
        if sender.isSelected{
            btnCurrentLocation.isSelected = false
            
            let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
                                                           longitude: /mapView.myLocation?.coordinate.longitude,
                                                           zoom: 14)
            mapView.animate(to: currentLocation)
            return
        }
        
        if  screenType.mapMode == .RequestAcceptedMode{
            
            guard let path = GMSMutablePath(fromEncodedPath: PolylineCab.points) else { return }
            let bounds = GMSCoordinateBounds(path: path)
            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            btnCurrentLocation.isSelected = true
            
        }
        else{
            
            let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
                                                           longitude: /mapView.myLocation?.coordinate.longitude,
                                                           zoom: 14)
            mapView.animate(to: currentLocation)
            
        }
        
        
        //        if !(self.btnCurrentLocation.isSelected){
        //
        //            guard let path = GMSMutablePath(fromEncodedPath: Polyline.points) else { return }
        //            let bounds = GMSCoordinateBounds(path: path)
        //            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        //            self.btnCurrentLocation.isSelected = true
        //
        //        }
        //        else{
        //                    let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
        //                                                                   longitude: /mapView.myLocation?.coordinate.longitude,
        //                                                                   zoom: 14)
        //                    mapView.animate(to: currentLocation)
        //              self.btnCurrentLocation.isSelected = false
        //        }
        
    }
    
    @IBAction func actionBtnSettingsPressed(_ sender: UIButton) {
        presentMenu(type: .Right)
    }
    
    ///Function to move backward
    
    @IBAction func actionBtnMapBackPressed(_ sender: UIButton) {
        
        let mode = screenType.mapMode
        
        switch mode {
            
        case .SelectingLocationMode:
            
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
                
            case .Default?:
                
                bottomViewBookforFriend.minimizeBookForFriendView()
                // results.removeAll()
                changeLocationType(move: .Backward)
                screenType = ScreenType(mapMode: .NormalMode, entryType: .Backward)
                // moveToCurrentLocation()
                
                viewTitlePackageBooking.isHidden = !isFromPackage
                
                /* if serviceRequest.booking_type == "RoadPickup" {
                 clearRoadPickUpdata() // To clear road pick updata
                 } */
                
            case .Mover?:
                screenType = ScreenType(mapMode: .OrderDetail, entryType: .Backward)
                
            default:
                break
                
            }
            
        case .SelectingFreightBrand:
            
            viewFreightBrand.minimizeSelectBrandView()
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
                
            case .Default?:
                screenType = ScreenType(mapMode: .SelectingLocationMode, entryType: .Backward)
                
            case .Mover?:
                screenType = ScreenType(mapMode: .NormalMode, entryType: .Backward)
                
            default:
                break
                
            }
            
            
            
            
        case .SelectingFreightProduct:
            
            //Hide Frieght Product View and show
            viewFreightProduct.minimizeProductView()
            screenType = ScreenType(mapMode: .SelectingFreightBrand, entryType: .Backward)
            
        case .OrderDetail:
            
            hideParticularOrderView()
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
                
            case .Default?:
                guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{ return }
                var modeType : MapMode  = serviceID > 3 ? .SelectingFreightProduct : .SelectingLocationMode
                if serviceID == 4 {
                    modeType =  .SelectingFreightProduct
                }
                screenType = ScreenType(mapMode: modeType, entryType: .Backward)
                
            case .Mover?:
                guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{ return }
                var modeType : MapMode  = serviceID > 3 ? .SelectingFreightProduct : .SelectingLocationMode
                if serviceID == 4 {
                    modeType =  .SelectingFreightBrand
                }
                screenType = ScreenType(mapMode: modeType, entryType: .Backward)
                
            default:
                break
                
            }
            
            
        case .ScheduleMode:
            
            viewScheduler.minimizeSchedulerView()
            screenType = ScreenType(mapMode: .SelectingFreightProduct, entryType: .Backward)
            
            // Ankush screenType = ScreenType(mapMode: .OrderDetail, entryType: .Backward)
            
        case .OrderPricingMode:
            
            viewOrderPricing.minimizeOrderPricingView()
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
                
            case .Default?:
                
                guard let serviceID = serviceRequest.booking_type == "RoadPickup" ? serviceRequest.category_id : serviceRequest.serviceSelected?.serviceCategoryId else{ return }
                
                if serviceID == 7 || serviceID == 10{
                    
                    if serviceRequest.booking_type == "RoadPickup" {
                        screenType = ScreenType(mapMode: .SelectingLocationMode, entryType: .Backward)
                    } else {
                        viewFreightProduct.minimizeProductView()
                        if serviceRequest.requestType == .Future {
                            screenType = ScreenType(mapMode: .ScheduleMode, entryType: .Backward)
                        } else {
                            screenType = ScreenType(mapMode: .SelectingFreightProduct, entryType: .Backward)
                        }
                    }
                    
                    /* if brandID == 18 || brandID == 19 {
                     screenType = ScreenType(mapMode: .SelectingFreightBrand, entryType: .Backward)
                     } else {
                     screenType = ScreenType(mapMode: .SelectingFreightProduct, entryType: .Backward)
                     } */
                    
                    
                    return
                } else{
                    let mapmode : MapMode  = serviceRequest.requestType == .Present  ? .OrderDetail : .ScheduleMode
                    screenType = ScreenType(mapMode: mapmode, entryType: .Backward)
                }
                
            case .Mover?:
                let mapmode : MapMode  = serviceRequest.requestType == .Present  ? .SelectingLocationMode : .ScheduleMode
                screenType = ScreenType(mapMode: mapmode, entryType: .Backward)
                
            default:
                break
                
            }
            
                    
            
            /* case .ConfirmPickup:
             
             viewConfirmPickUp.minimizeConfirmPickUPView()
             dropPickUpAndDropOffPins(pickLat: /serviceRequest.latitudeDest, pickLong: /serviceRequest.longitudeDest, dropLat: /serviceRequest.latitude, dropLong: /serviceRequest.longitude)
             screenType = ScreenType(mapMode: .OrderPricingMode, entryType: .Backward) */
            
        default :
            
            if isFromPackage {
                popVC()
            }
            break;
        }
    }
    
    
    
    @IBAction func addSavedPlaces(_sender : UIButton){
        //        guard let vc = R.storyboard.bookService.saveAddressVC() else {return}
        //        self.pushVC(vc)
        addSavedPlaces?.isSelected = true
        dataItems = arraySaveName
        collectionViewPlacesDataSource?.items = dataItems
        collectionSavedPlaces?.reloadData()
        showCollectionView()
        
    }
    
    func changeLocationType(move : MoveType) {
        
        guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{return}
        
        if move == .Forward {
            serviceRequest.locationNameDest =     serviceID > 3 ?   locationLatest : nil
            serviceRequest.latitudeDest =  serviceID > 3 ?   latitudeLatest : nil
            serviceRequest.longitudeDest = serviceID > 3 ?   longitudeLatest : nil
            
            txtPickUpLocation.text =    serviceID > 3 ?  locationLatest : ""
            txtDropOffLocation.text =    serviceID > 3 ?  "" : locationLatest
            tempDropOff =  /txtDropOffLocation.text
            tempPickUp =  /txtPickUpLocation.text
            
            serviceRequest.locationName =     serviceID > 3 ?   nil : locationLatest
            serviceRequest.latitude =   serviceID > 3 ?   nil : latitudeLatest
            serviceRequest.longitude = serviceID > 3 ?   nil : longitudeLatest
            
        } else {
            locationEdit = serviceID > 3 ? .PickUp : .DropOff
            viewSelectService.lblLocationName.text = locationLatest
        }
    }
    
    func getCoronaAreas(){
        
        return
           let token = /UDSingleton.shared.userData?.userDetails?.accessToken
           BookServiceEndPoint.getCoronaAreas.request(header:["language_id" : LanguageFile.shared.getLanguage(), "access_token" : token]) {  [weak self] (response) in
                      
                      switch response {
                          
                      case .success(let data):
                       guard let mData = data as? CoronaAreas else { return }
                       self?.drawCircleOnCoronaEffectedAreas(data:mData)
                      case .failure(let err):
                       print(/err)
               }
           }
           
          
       }
    
    
    func drawCircleOnCoronaEffectedAreas(data:CoronaAreas){
        for area in data.coronaArea ?? []{
            print("long",/area.city_longitude)
            print("latitude",/area.city_latitude)
           
            let circleCenter = CLLocationCoordinate2D(latitude: /area.city_latitude, longitude:  /area.city_longitude)
            let circ = GMSCircle(position: circleCenter, radius: CLLocationDistance( /data.maximumDistance))

            circ.fillColor = UIColor.red.withAlphaComponent(0.5)
            circ.strokeColor = .red
            circ.strokeWidth = 1
            circ.map = mapView
            
            let marker = GMSMarker(position: circleCenter)
            marker.icon = UIImage(named:"redPin")
            marker.snippet = "Corona Positive Area"
            marker.map = mapView
         }
        
        for area in data.quarantineArea ?? []{
           print("long",/area.city_longitude)
           print("latitude",/area.city_latitude)
          
           let circleCenter = CLLocationCoordinate2D(latitude: /area.city_latitude, longitude:  /area.city_longitude)
           let circ = GMSCircle(position: circleCenter, radius: CLLocationDistance( /data.maximumDistance))

           circ.fillColor = UIColor.blue.withAlphaComponent(0.5)
           circ.strokeColor = .blue
           circ.strokeWidth = 1
           circ.map = mapView
            let marker = GMSMarker(position: circleCenter)
            marker.icon = UIImage(named:"bluePin")
            marker.snippet = "Quarantine Area"
            marker.map = mapView
        }
    }
    
    func moveToCurrentLocation() {
        
        let currentLocation = GMSCameraPosition.camera(withLatitude: /mapView.myLocation?.coordinate.latitude,
                                                       longitude: /mapView.myLocation?.coordinate.longitude,
                                                       zoom: 14)
        mapView.animate(to: currentLocation)
        
    }
    
    @IBAction func buttonAddLocationclicked(_ sender: UIButton) {
        
        // pickup- 1, Stop1- 2, Stop2- 3, drop- 4, 5- add Home, 6- Add Work, 7- Edit Home, 8- Edit Work
        
        switch sender.tag {
            
        case 1, 2, 3, 4, 7, 8 :
            
            let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                         switch template {
                         case .GoMove:
                           self.didAddLocationFrom(buttonTag: sender.tag, isFromSearch: true)
                           break
                             
                         default:
                             viewAddLocationFrom.showView(locationButtonTag: sender.tag)
                         }
            
        case 5:
            
            if homeAPI?.addresses?.home?.address == nil || /homeAPI?.addresses?.home?.address?.isEmpty {
                viewAddLocationFrom.showView(locationButtonTag: sender.tag)
            } else {
                viewChooseAddress.showView(address: homeAPI?.addresses?.home)
            }
            
        case 6:
            
            if homeAPI?.addresses?.work?.address == nil || /homeAPI?.addresses?.work?.address?.isEmpty {
                viewAddLocationFrom.showView(locationButtonTag: sender.tag)
            } else {
                viewChooseAddress.showView(address: homeAPI?.addresses?.work)
            }
            
            
        default:
            break
        }
        
        
        /*  switch sender.tag {
         case 1:
         
         
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         self?.txtPickUpLocation.text = place?.formattedAddress
         self?.serviceRequest.locationNameDest = place?.formattedAddress
         self?.serviceRequest.latitudeDest =  /place?.coordinate.latitude
         self?.serviceRequest.longitudeDest =  /place?.coordinate.longitude
         
         //  self?.setCameraGoogleMap(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude)
         
         self?.callLocationSelected()
         }
         
         case 2:
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         
         if let object = self?.serviceRequest.stops.filter({$0.priority == 1}).first {
         self?.serviceRequest.stops.remove(object: object)
         }
         
         self?.txtStop1.text = place?.formattedAddress
         
         let modal = Stops(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude, priority: 1, address: place?.formattedAddress)
         self?.serviceRequest.stops.append(modal)
         
         
         debugPrint(self?.serviceRequest.stops as Any)
         }
         
         case 3:
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         if let object = self?.serviceRequest.stops.filter({$0.priority == 2}).first {
         self?.serviceRequest.stops.remove(object: object)
         }
         
         self?.txtStop2.text = place?.formattedAddress
         let modal = Stops(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude, priority: 2, address: place?.formattedAddress)
         self?.serviceRequest.stops.append(modal)
         
         debugPrint(self?.serviceRequest.stops as Any)
         }
         
         case 4:
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         self?.txtDropOffLocation.text = place?.formattedAddress
         self?.serviceRequest.locationNickName = place?.name
         self?.serviceRequest.locationName = place?.formattedAddress
         self?.serviceRequest.latitude =  /place?.coordinate.latitude
         self?.serviceRequest.longitude =  /place?.coordinate.longitude
         
         //  self?.setCameraGoogleMap(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude)
         
         self?.callLocationSelected()
         }
         
         case 5:
         
         if homeAPI?.addresses?.home?.address == nil || /homeAPI?.addresses?.home?.address?.isEmpty {
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         debugPrint("Home")
         self?.apiAddAddress(place: place, category: "HOME")
         }
         
         } else {
         
         viewChooseAddress.showView(address: homeAPI?.addresses?.home)
         
         }
         
         case 6:
         
         if homeAPI?.addresses?.work?.address == nil || /homeAPI?.addresses?.work?.address?.isEmpty {
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         debugPrint("Work")
         self?.apiAddAddress(place: place, category: "WORK")
         }
         } else {
         viewChooseAddress.showView(address: homeAPI?.addresses?.work)
         }
         
         case 7:
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         debugPrint("Home")
         self?.apiEditAddress(place: place, category: "HOME")
         }
         
         case 8:
         
         GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
         
         debugPrint("WORK")
         self?.apiEditAddress(place: place, category: "WORK")
         }
         
         default:
         break
         } */
        
    }
    
    
    func callLocationSelected() {
        
        if (/viewStop1.isHidden && /viewStop2.isHidden) {
            
            if !(/txtDropOffLocation.text?.isEmpty) && txtDropOffLocation.text != nil {
                locationsSelected()
            }
        }
    }
    
    @IBAction func buttonOptionForMeClicked(_ sender: UIButton) {
        
        /* isSwitchRiderViewOpened = false
         ViewForfriend.isHidden = true
         
         ViewEnterPickUpDropOff.isHidden = false
         imageViewHeaderProfilePic.isHidden = false
         
         buttonHeaderBookingFor.setTitle("For me", for: .normal) */
        
        
        bottomViewBookforFriend.minimizeBookForFriendView()
        isSwitchRiderViewOpened = false
        setupBookForInitialUI(isSwitchRiderViewOpened : isSwitchRiderViewOpened) // No need to Clear serviceReq data as already clear on 'buttonBookingForClicked'
        
    }
    
    @IBAction func buttonBookForFriendClicked(_ sender: Any) {
        debugPrint("Open New UI")
        
        bottomViewBookforFriend.showBookForFriendView(superView: view, requestPara: serviceRequest)
    }
    
    @IBAction func buttonBookingForClicked(_ sender: UIButton) {
        
        view.endEditing(true)
        
        isSwitchRiderViewOpened = !isSwitchRiderViewOpened
        
        bottomViewBookforFriend.minimizeBookForFriendView()
        clearServiceRequestData()
        setupBookForInitialUI(isSwitchRiderViewOpened : isSwitchRiderViewOpened)
        
        /*  serviceRequest.booking_type = nil
         serviceRequest.friend_name = nil
         serviceRequest.friend_phone_number = nil
         serviceRequest.friend_phone_code = nil
         
         bottomViewBookforFriend.clearTextfields()
         
         
         
         let title = isSwitchRiderViewOpened ? "Switch Rider" : "For me"
         buttonHeaderBookingFor.setTitle(title, for: .normal)
         
         ViewForfriend.isHidden = !isSwitchRiderViewOpened
         ViewEnterPickUpDropOff.isHidden = isSwitchRiderViewOpened
         imageViewHeaderProfilePic.isHidden = isSwitchRiderViewOpened */
        
    }
    
    @IBAction func buttonRoadPickUp(_ sender: Any) {
        
        guard let vc = R.storyboard.bookService.scannerViewController() else {return}
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        presentVC(vc)
    }
    
    @IBAction func buttonBookByCall(_ sender: Any) {
        callToNumber(number: "+94760111154")
        
    }
    
    @IBAction func buttonAddStopClicked(_ sender: Any) {
        
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            if /self?.viewStop1.isHidden {
                self?.viewStop1.isHidden = false
                
            } else {
                
                if /self?.txtStop1.text?.isEmpty {
                    return
                } else {
                    self?.viewStop2.isHidden = false
                }
            }
            
            self?.constraintHeightViewEnterPickDrop.constant += 48
            self?.constraintYAddLocationView.constant -= 48
            self?.view.layoutIfNeeded()
            self?.viewStoppageDesc.isHidden = /self?.viewStop1.isHidden && /self?.viewStop2.isHidden
            self?.buttonAddStop.isHidden = !(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)
            
        }
    }
    
    @IBAction func buttonRemoveStopClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            if sender.tag == 1 {
                self?.viewStop1.isHidden = true
                self?.txtStop1.text = ""
                // self?.tempStop1 = ""
                
                if /self?.serviceRequest.stops.count > 0 {
                    self?.serviceRequest.stops.remove(at: 0)
                }
                
            } else {
                self?.viewStop2.isHidden = true
                self?.txtStop2.text = ""
                // self?.tempStop2 = ""
                
                if /self?.serviceRequest.stops.count > 1 {
                    self?.serviceRequest.stops.remove(at: 1)
                } else {
                    if /self?.serviceRequest.stops.count > 0 {
                        self?.serviceRequest.stops.remove(at: 0)
                    }
                }
            }
            
            self?.constraintHeightViewEnterPickDrop.constant -= 48
            self?.constraintYAddLocationView.constant += 48
            self?.view.layoutIfNeeded()
            self?.viewStoppageDesc.isHidden = /self?.viewStop1.isHidden && /self?.viewStop2.isHidden
            self?.buttonAddStop.isHidden = !(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)
            
        }
    }
    
    @IBAction func buttonContinueWithStoppageClicked(_ sender: UIButton) {
        
        locationsSelected()
    }
    
    
    
    //MARK:- FUNCTIONS
    //MARK:-
    
    
    func addKeyBoardObserver() {
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillhide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyBoardObserver() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            animateTableLocationSearch(true, height: keyboardHeight)
        }
    }
    
    @objc func keyboardWillhide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateTableLocationSearch(false, height: keyboardHeight)
        }
    }
    
    func animateTableLocationSearch(_ isToShown : Bool , height : CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.constraintBottomTablelocationsearch?.constant =  isToShown ?  (height) :  0
            self?.view.layoutIfNeeded()
        }
    }
    
    func setGradientBackground() {
        
        let colorTop =  UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.05).cgColor
        let colorBottom = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = viewBottom.bounds
        //        viewBottom.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func setUpBasicSettings() {
        
        constraintNavigationBasicBar.constant = BookingPopUpFrames.navigationBarHeight + 10
        //   constraintNavigationLocationBar.constant = BookingPopUpFrames.navigationBarHeight
        
        constraintTopSegmentedView.constant = BookingPopUpFrames.paddingX
        
        //  viewPickUpLocation.alpha  = 0  //To SetUP for Only Drop Location
        //        constraintHeightPickUpView.constant = 0
        
        print("Services ===>", UDSingleton.shared.userData?.services)
        
        //DELIVERSOME let selectedService = services.filter({$0.serviceCategoryId == 7}).first
       /*  --- Rohit ---
        if let services = UDSingleton.shared.userData?.services,
            let selectedService = services.filter({$0.serviceCategoryId == 7}).first {
            
            // Change here for service
            // serviceRequest.serviceSelected = services[5] //Ankush services[0]
            serviceRequest.serviceSelected = selectedService
            
            // call terminology API
            getTerminologyData(serviceId: /selectedService.serviceCategoryId)
        }
     */
        
        
        if let services = UDSingleton.shared.userData?.services,
            let selectedService = services.first {
            
            // Change here for service
            // serviceRequest.serviceSelected = services[5] //Ankush services[0]
            serviceRequest.serviceSelected = selectedService
            
            // call terminology API
            getTerminologyData(serviceId: /selectedService.serviceCategoryId)
        }
        
        
        
        
        //constraintOnlyBackButtonTop.constant = BookingPopUpFrames.statusBarHeight
        screenType = ScreenType(mapMode: .ZeroMode, entryType: .Forward)
        
        self.txtDropOffLocation.delegate = self
        self.txtPickUpLocation.delegate = self
        txtStop1.delegate = self
        txtStop2.delegate = self
        
        assignDelegates()
        setGradientBackground()
        
        // btnLocationNext.setImage(#imageLiteral(resourceName: "NextMaterial").setLocalizedImage(), for: .normal)
        //  btnLocationBack.setImage(#imageLiteral(resourceName: "Back").setLocalizedImage(), for: .normal)
        btnOnlyBack.setImage(#imageLiteral(resourceName: "ic_back_arrow_black.png").setLocalizedImage(), for: .normal)
        txtDropOffLocation.setAlignment()
        txtPickUpLocation.setAlignment()
        
        viewTopBarBasicHome.isHidden = isFromPackage
        viewTitlePackageBooking.isHidden = !isFromPackage
        
        viewTitlePackageBooking.setViewBackgroundColorTheme()
        buttonContinue.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .Moby?:
            viewTopBarBasicHome.isHidden = true
            viewNavigation.isHidden = false
            buttonNewCurrentLocation.isHidden = false
            buttonNewSelectLocation.isHidden = false
            btnCurrentLocation.isHidden = true
            viewStatusBar.setViewBackgroundColorHeader()
            
        case .DeliverSome?:
            viewTopBarBasicHome.isHidden = true
            viewNavigation.isHidden = false
            buttonNewCurrentLocation.isHidden = true
            buttonNewSelectLocation.isHidden = true
            btnCurrentLocation.isHidden = true
            viewStatusBar.setViewBackgroundColorHeader()
            
        case .GoMove?:
            viewStatusBar.backgroundColor = UIColor.clear
            
        
            
        default:
            viewNavigation.isHidden = true
            //buttonNewCurrentLocation.isHidden = true
            buttonNewSelectLocation.isHidden = true
            btnCurrentLocation.isHidden = false
            viewStatusBar.isHidden = true
            
        }
        
        viewOnMApNavigation.isHidden = true
        viewNavigation.setViewBackgroundColorHeader()
       
        viewOnMApNavigation.setViewBackgroundColorHeader()
        
        buttonNewSideMenu.setButtonWithTintColorHeaderText()
        buttonNewBack.setButtonWithTintColorHeaderText()
        
        buttonlNavigationTitle.setButtonWithTitleColorHeaderText()
    }
    
    func getUpdatedData() {
        var id = Int()
        
        if isFromPackage{
            
            id = /modalPackages?.package?.pricingData?.categories?.first?.categoryId
        }
        
        /*  ------ Rohit -----
        // Change here for service
        guard let services = UDSingleton.shared.userData?.services,
            let selectedService =  services.filter({$0.serviceCategoryId == id}).first else { return }
        
        getLocalDriverForParticularService(service: selectedService)
        */
        
        guard let services = UDSingleton.shared.userData?.services,
            let selectedService =  services.first else { return }
        
        getLocalDriverForParticularService(service: selectedService)
        
        
        
    }
    
    func assignDelegates() {
        
        viewSelectService.delegate = self
        viewGasService.delegate = self
        viewDrinkingWaterService.delegate = self
        viewOrderPricing.delegate = self
        viewUnderProcess.delegate = self
        viewDriverAccepted.delegate = self
        viewInvoice.delegate = self
        viewScheduler.delegate = self
        viewDriverRating.delegate = self
        viewFreightBrand.delegate = self
        viewFreightProduct.delegate = self
        viewFreightOrder.delegate = self
        // viewConfirmPickUp.delegate = self
        viewNewInvoice.delegate = self
        bottomViewBookforFriend.delegate = self
        viewChooseAddress.delegate = self
        viewAddLocationFrom.delegate = self
    }
    
    
    func showBasicNavigation(updateType: MapMode) {
        self.view.endEditing(true)
        if updateType == .SelectingLocationMode  {
            
            configureRecentLocationTableView()
        }
        
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            
            if updateType == .NormalMode {
                
                self?.viewLocationTableContainer.alpha = 0 // Ankush
                
                self?.constraintNavigationBasicBar.constant = -(BookingPopUpFrames.navigationBarHeight)
                self?.constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(55) + 10) // 55 - Height for navigation View (Book a taxi)
                self?.imgViewPickingLocation.isHidden =  true // false
                self?.mapView.isUserInteractionEnabled = true
                // self?.btnOnlyBack.alpha = 0
                
                self?.btnOnlyBack.alpha = /self?.isFromPackage ? 1 : 0
                
                
                self?.segmentedMapType.isHidden = true
                self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingX
               // self?.btnCurrentLocation.isHidden = false
                self?.viewStoppageDesc.isHidden = true
                
                self?.viewOnMApNavigation.isHidden = true
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                case .Moby?:
                    self?.viewTopBarBasicHome.isHidden = true
                    self?.viewNavigation.isHidden = false
                    self?.buttonNewCurrentLocation.isHidden = false
                    self?.buttonNewSelectLocation.isHidden = false
                    self?.btnCurrentLocation.isHidden = true
                    
                    
                case .DeliverSome?:
                    self?.viewTopBarBasicHome.isHidden = true
                    self?.viewNavigation.isHidden = false
                    self?.buttonNewCurrentLocation.isHidden = true
                    self?.buttonNewSelectLocation.isHidden = true
                    self?.btnCurrentLocation.isHidden = true
                    
                default:
                    self?.viewNavigation.isHidden = true
                    self?.buttonNewCurrentLocation.isHidden = true
                    self?.buttonNewSelectLocation.isHidden = true
                    self?.btnCurrentLocation.isHidden = false
                }
                
                
                
                
            } else if updateType == .SelectingLocationMode {
                
                self?.txtDropOffLocation.becomeFirstResponder()
                self?.viewLocationTableContainer.alpha = 1 // Ankush
                
                self?.segmentedMapType.isHidden = true
                self?.btnCurrentLocation.isHidden = false
                self?.constraintNavigationBasicBar.constant = BookingPopUpFrames.navigationBarHeight + BookingPopUpFrames.navigationTopPadding
                
                self?.imgViewPickingLocation.isHidden = true //false
                
                self?.mapView.isUserInteractionEnabled = true
                self?.btnOnlyBack.alpha = 0
                self?.viewTitlePackageBooking.isHidden = true
                
                guard let selectedService  = self?.serviceRequest.serviceSelected else{return}
                
                if  /selectedService.serviceCategoryId > 3 {
                    self?.locationType = .PickUpDropOff
                    self?.imgViewPickingLocation.image = #imageLiteral(resourceName: "PickUpMarker")
                    
                    // Ankush self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(115) )
                    
                    // 96 - Pick up and dropoff View size
                    let locationViewHeight = (!(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)) ? (96 + 96) : (!(/self?.viewStop1.isHidden) || !(/self?.viewStop2.isHidden)) ? (96 + 48) : 96
                    self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(locationViewHeight ))
                    self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingXPickUpLocation
                    self?.viewStoppageDesc.isHidden = ((/self?.viewStop1.isHidden) && (/self?.viewStop2.isHidden))
                } else{
                    
                    self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(55)) // 55 - Height for navigation View (Book a taxi)
                    self?.locationType = .OnlyDropOff
                    self?.imgViewPickingLocation.image = #imageLiteral(resourceName: "DropMarker")
                    self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingXDropOffLocation
                }
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                case .Moby?:
                    self?.viewTopBarBasicHome.isHidden = true
                    self?.viewNavigation.isHidden = true
                    self?.buttonNewCurrentLocation.isHidden = true
                    self?.buttonNewSelectLocation.isHidden = true
                    self?.btnCurrentLocation.isHidden = true
                    self?.viewOnMApNavigation.isHidden = false
                    self?.buttonlNavigationTitle.setTitle("Address", for: .normal)
                    break
                    
                    
                case .DeliverSome?:
                   self?.viewTopBarBasicHome.isHidden = true
                   self?.viewNavigation.isHidden = true
                   self?.buttonNewCurrentLocation.isHidden = true
                   self?.buttonNewSelectLocation.isHidden = true
                   self?.btnCurrentLocation.isHidden = true
                   self?.viewOnMApNavigation.isHidden = false
                   self?.buttonlNavigationTitle.setTitle("Address", for: .normal)
                
                    
                default:
                    debugPrint("default")
                }
                
                
                
            }else if updateType == .OrderDetail || updateType == .SelectingFreightBrand {
                
                self?.buttonlNavigationTitle.setTitle("", for: .normal)
                
                let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
                
                switch template {
                    
                case .Mover?:
                    self?.viewLocationTableContainer.alpha = 0 // Ankush
                    
                    self?.constraintNavigationBasicBar.constant = -(BookingPopUpFrames.navigationBarHeight)
                    self?.constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(55) + 10) // 55 - Height for navigation View (Book a taxi)
                    self?.imgViewPickingLocation.isHidden =  true // false
                    self?.mapView.isUserInteractionEnabled = true
                    self?.btnOnlyBack.alpha = 0
                    
                    self?.segmentedMapType.isHidden = true
                    self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingX
                    self?.btnCurrentLocation.isHidden = false
                    self?.viewStoppageDesc.isHidden = true
                    
                default:
                    break
                    
                }
                
                
                self?.mapView.isUserInteractionEnabled = true
                self?.btnOnlyBack.alpha = 1
                self?.segmentedMapType.isHidden = true
                self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingX
                self?.btnCurrentLocation.isHidden = true
                self?.constraintNavigationBasicBar.constant = BookingPopUpFrames.navigationBarHeight + BookingPopUpFrames.navigationTopPadding
                
                // self?.serviceRequest.isBookingFromPackage = self?.isFromPackage
                guard let service  = self?.serviceRequest.serviceSelected else{return}
                
                // Ankush self?.imgViewPickingLocation.isHidden  = /service.serviceCategoryId > 3
                
                // Ankush self?.constraintYAddLocationView.constant =  /service.serviceCategoryId > 3 ? (BookingPopUpFrames.navigationBarHeight + CGFloat(115)) : BookingPopUpFrames.navigationBarHeight + CGFloat(55)
                
                // 96 - Pick up and dropoff View size, 55 - Height for navigation View (Book a taxi)
                let locationViewHeight = (!(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)) ? (96 + 96) : (/self?.viewStop1.isHidden || /self?.viewStop2.isHidden) ? (96 + 48) : 96
                self?.constraintYAddLocationView.constant =  /service.serviceCategoryId > 3 ? (BookingPopUpFrames.navigationBarHeight + CGFloat(locationViewHeight)) : BookingPopUpFrames.navigationBarHeight + CGFloat(55)
                
                
            }else if updateType == .RequestAcceptedMode || updateType == .OnTrackMode {
                
                self?.constraintNavigationBasicBar.constant = -(BookingPopUpFrames.navigationBarHeight)
                
                self?.imgViewPickingLocation.isHidden = true
                self?.mapView.isUserInteractionEnabled = true
                self?.btnOnlyBack.alpha = 0
                self?.segmentedMapType.isHidden = true
                self?.btnCurrentLocation.isHidden = false
                
                guard let currOrder = self?.currentOrder else {return}
                
                if /currOrder.serviceId > 3 {
                    // Ankush self?.constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(115) + 10)
                    
                    // 96 - Pick up and dropoff View size
                    let locationViewHeight = (!(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)) ? (96 + 96) : (!(/self?.viewStop1.isHidden) || !(/self?.viewStop2.isHidden)) ? (96 + 48) : 96
                    self?.constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(locationViewHeight) + 10)
                }else{
                    self?.constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(55) + 10) //  55 - Height for navigation View (Book a taxi)
                }
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                    
                case .Moby?:
                    self?.viewOnMApNavigation.isHidden = true
                    self?.viewNavigation.isHidden = true
                    self?.viewOnMApNavigation.isHidden = true
                    self?.buttonNewSelectLocation.isHidden = true
                    self?.buttonNewCurrentLocation.isHidden = true
                    
                default :
                    break
                }
                
                
            } else if updateType == .ServiceDoneMode {
                // To Hide Top View Containing menu button
                self?.constraintNavigationBasicBar.constant =  BookingPopUpFrames.navigationBarHeight + BookingPopUpFrames.navigationTopPadding
                
            } else if updateType == .OrderPricingMode {
                
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                    
                case .Mover?:
                    self?.mapView.isUserInteractionEnabled = true
                    self?.btnOnlyBack.alpha = 1
                    self?.segmentedMapType.isHidden = true
                    self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingX
                    self?.btnCurrentLocation.isHidden = true
                    self?.constraintNavigationBasicBar.constant = BookingPopUpFrames.navigationBarHeight + BookingPopUpFrames.navigationTopPadding
                    
                    // self?.serviceRequest.isBookingFromPackage = self?.isFromPackage
                    guard let service  = self?.serviceRequest.serviceSelected else{return}
                    
                    // Ankush self?.imgViewPickingLocation.isHidden  = /service.serviceCategoryId > 3
                    
                    // Ankush self?.constraintYAddLocationView.constant =  /service.serviceCategoryId > 3 ? (BookingPopUpFrames.navigationBarHeight + CGFloat(115)) : BookingPopUpFrames.navigationBarHeight + CGFloat(55)
                    
                    // 96 - Pick up and dropoff View size, 55 - Height for navigation View (Book a taxi)
                    let locationViewHeight = (!(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)) ? (96 + 96) : (/self?.viewStop1.isHidden || /self?.viewStop2.isHidden) ? (96 + 48) : 96
                    self?.constraintYAddLocationView.constant =  /service.serviceCategoryId > 3 ? (BookingPopUpFrames.navigationBarHeight + CGFloat(locationViewHeight)) : BookingPopUpFrames.navigationBarHeight + CGFloat(55)
                    
                case .Moby?:
                    self?.viewOnMApNavigation.isHidden = false
                    
                default:
                    break
                    
                }
                
                
                
            }
            self?.view.layoutIfNeeded()
            }, completion: { (done) in
        })
    }
    
    func clearSelectedLocation() {
        view.endEditing(true)
        // results.removeAll()
        // tblLocationSearch.reloadData()
        // viewLocationTableContainer.alpha = 0
    }
    
    
    func showSelectServiceView(moveType : MoveType = .Forward) {
        isSearching = false
        
        //Rohit-----
        guard let services = UDSingleton.shared.userData?.services else {return}
        //guard let services = UDSingleton.shared.appSettings?.services else {return}
        var selectedServices = [Service]()
        if /self.isFromPackage {
            let brands = self.modalPackages?.package?.pricingData?.categoryBrands
            var categoryIds = [Int]()
            for brand in brands ?? []{
                categoryIds.append(brand.categoryId ?? 0)
            }
            for service in services{
                let sBrands = service.brands
                for sBrand in sBrands ?? []{
                    if categoryIds.contains(sBrand.categoryId ?? 0){
                        selectedServices.append(service)
                    }
                }
            }
            viewSelectService.showSelectServiceView(superView: viewMapContainer, moveType: moveType, requestPara: self.serviceRequest, service: selectedServices,fromPackage : true)
        }else{
            
            viewSelectService.showSelectServiceView(superView: viewMapContainer, moveType: moveType, requestPara: self.serviceRequest, service: services)
        }
    }
    
    func showParticularAddOrderView(type : MoveType) {
        guard let serviceId = serviceRequest.serviceSelected?.serviceCategoryId else {return}
        switch serviceId {
            
        case 1,3:
            viewGasService.showGasServiceView(superView: viewMapContainer, moveType: type, requestPara: serviceRequest)
        case 2:
            viewDrinkingWaterService.showDrinkingWaterServiceView(superView: viewMapContainer, moveType: type, requestPara: serviceRequest)
        case 4, 7,10:
            
            viewFreightOrder.showFreightOrderView(supView: viewMapContainer, moveType: type, requestPara: serviceRequest)
            
        default:
            break
        }
    }
    
    
    func hideParticularOrderView() {
        
        guard let serviceId = serviceRequest.serviceSelected?.serviceCategoryId else {return}
        
        switch serviceId {
        case 1,3:
            viewGasService.minimizeGasServiceView()
        case 2:
            viewDrinkingWaterService.minimizeDrinkingWaterView()
        case 4, 7,10:
            viewFreightOrder.minimizeFreightOrderView()
        default:
            break
        }
    }
    
    
    func showFreightBrandView(moveType : MoveType) {
        
        viewFreightBrand.showBrandView(superView: viewMapContainer, moveType: moveType, requestPara: serviceRequest, drivers: drivers)
    }
    
    func showFreightProductView(moveType : MoveType) {
        viewFreightProduct.showProductView(superView: viewMapContainer, moveType: moveType, requestPara: serviceRequest, modalPackages: modalPackages)
    }
    
    func showSchedulerView(moveType : MoveType) {
        self.btnOnlyBack.alpha = 1
        viewScheduler.showSchedulerView(superView: viewMapContainer, moveType: moveType, requestPara: serviceRequest)
    }
    
    
    func showPricingView(moveType : MoveType ) {
        self.btnOnlyBack.alpha = 1
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
            
        case .Moby?, .DeliverSome?:
            viewOnMApNavigation.isHidden = false

        default:
            break
        }
        
        viewOrderPricing.showOrderPricingView(superView: viewMapContainer, moveType: moveType, requestPara: serviceRequest, modalPackages: modalPackages)
    }
    
    /* func showConfirmPickUpView(moveType : MoveType ) {
     self.btnOnlyBack.alpha = 1
     // viewConfirmPickUp.showConfirmPickUPView(superView: viewMapContainer, moveType: moveType, requestPara: serviceRequest)
     } */
    
    func showConfirmPickUpController() {
        
        guard let vc = R.storyboard.bookService.confirmPickUpViewController() else{return}
        vc.modalPresentationStyle = .overFullScreen
        vc.request = serviceRequest
        vc.delegate = self
        presentVC(vc, false)
    }
    
    func showAddLocationFromMapController(buttonTag: Int) {
        
        guard let vc = R.storyboard.bookService.addLocationFromMapViewController() else{return}
        vc.modalPresentationStyle = .overFullScreen
        vc.request = serviceRequest
        vc.locationType = buttonTag
        vc.delegate = self
        presentVC(vc, false)
    }
    
    func showProcessingView( moveType : MoveType, isHalfWayStop: Bool = false,  isVehicleBreakdown: Bool = false) {
        self.btnOnlyBack.alpha = 0
        viewOnMApNavigation.isHidden = true
        
        guard let current = currentOrder else{return}
        viewUnderProcess.showWaitingView(superView: viewMapContainer , order: current, isHalfWayStop: isHalfWayStop, isVehicleBreakdown: isVehicleBreakdown,  serviceRequest: serviceRequest)
    }
    
    func showDriverView() {
        guard let current = currentOrder else{return}
        viewDriverAccepted.showDriverAcceptedView(superView: viewMapContainer, order: current)
    }
    
    func showInvoiceView() {
        guard let current = currentOrder else{return}
        viewInvoice.showInvoiceView(superView: viewMapContainer, order: current)
    }
    
    func showNewInvoiceView() {
        guard let current = currentOrder else{return}
        viewNewInvoice.showNewInvoiceView(superView: viewMapContainer, order: current)
    }
    
    func showUrlPaymentView(){
        
        if ez.topMostVC?.isKind(of: AddCardViewControllerCab.self) ?? false{
            
            return
        }
         guard let current = currentOrder else{return}
        guard  let vc = R.storyboard.sideMenu.addCardViewController() else{return}
        vc.url = current.payment?.paymentBody
        vc.webPayment = {
            DispatchQueue.main.async {
                self.showNewInvoiceView()
            }
        }
        self.pushVC(vc)
    }
    
    
    func showDriverRatingView() {
        guard let current = currentOrder else{return}
        viewDriverRating.showDriverRatingView(superView: viewMapContainer, order: current)
    }
    
    func moveToNormalMode() {
        
        self.cleanPath()
        imgViewPickingLocation.isHidden = true //false
        mapView.isUserInteractionEnabled = true
        self.mapView.clear()
         self.getCoronaAreas()
        self.cleanPath()
         self.getCoronaAreas()
        self.screenType = ScreenType(mapMode: .NormalMode, entryType: .Backward)
    }
    
    func driverAcceptedMode(order : OrderCab) {
        
        self.cleanPath()
        
        mapView.clear()
        self.getCoronaAreas()
        // listeningEvent()
        currentOrder = order
        viewUnderProcess.minimizeProcessingView()
        viewOrderPricing.minimizeOrderPricingView()
        imgViewPickingLocation.isHidden = true
        mapView.isUserInteractionEnabled = true
        screenType = ScreenType(mapMode: .RequestAcceptedMode, entryType: .Forward)
        
        // Set
        if /order.serviceId > 3 &&  (order.orderStatus == .Confirmed || order.orderStatus == .reached) {
            destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.pickUpLatitude) , longitude: CLLocationDegrees(/order.pickUpLongitude))
        }else{
            destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.dropOffLatitude) , longitude: CLLocationDegrees(/order.dropOffLongitude))
        }
        
        source = CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.driverAssigned?.driverLatitude) , longitude: CLLocationDegrees(/order.driverAssigned?.driverLongitude))
        
        let stops = order.orderStatus == .Ongoing ? order.ride_stops : nil
        getPolylineRoute(source: source, destination: destination, stops: stops, model: nil)
        
        
        getTerminologyData(serviceId: /order.serviceId)
    }
    
    ///To set final price to pricing pop up
    
    
    func calculateImageSize() {
        
        if /mapView.camera.zoom >= minimumZoom {
            
            if previousZoom == /mapView.camera.zoom {return}
            
            previousZoom  = /mapView.camera.zoom
            let widthVal = (Float(vehicleSize.width)*(/mapView.camera.zoom).getZoomPercentage)/100
            let heightVal = (Float(vehicleSize.height)*(/mapView.camera.zoom).getZoomPercentage)/100
            vehicleCurrentSize =  CGSize(width: Double(widthVal), height: Double(heightVal))
            
            for item in movingDrivers {
                
                let marker = item.driverMarker
                let mgVehicle = UIImage().getDriverImage(type: /item.driver.driverServiceId)
                marker.icon = mgVehicle.imageWithImage(scaledToSize: vehicleCurrentSize)
                
                /* let marker = item.driverMarker
                 let imageView = UIImageView(image: R.image.dropMarker())
                 imageView.kf.setImage(with: URL(string: /item.driver.icon_image_url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
                 marker.iconView = imageView */
            }
        }
    }
    
    func configureMapView() {
        
        let didUpdateCurrentLocation : DidUpdatecurrentLocation = {[weak self] (manager,locations) in  //current location closure
            let currentLocation = GMSCameraPosition.camera(withLatitude: /manager.location?.coordinate.latitude,
                                                           longitude: /manager.location?.coordinate.longitude,
                                                           zoom: 14.0)
            self?.currentLocation =   CLLocation(latitude: /manager.location?.coordinate.latitude, longitude: /manager.location?.coordinate.longitude )
            // if !(/self?.isCurrentLocationUpdated) {
            
            if /self?.updateMapLocation {
                self?.updateMapLocation = false
                 self?.mapView.camera = currentLocation
            }
           
            self?.isCurrentLocationUpdated = true
            
            let widthVal = (Float(vehicleSize.width)*(/self?.mapView.camera.zoom).getZoomPercentage)/100
            let heightVal = (Float(vehicleSize.height)*(/self?.mapView.camera.zoom).getZoomPercentage)/100
            vehicleCurrentSize =  CGSize(width: Double(widthVal), height: Double(heightVal))
            
            self?.mapDataSource?.getAddressFromlatLong(lat: /manager.location?.coordinate.latitude, long: /manager.location?.coordinate.longitude, completion: {  [weak self](strLocationName, country, name) in
                
                UDSingleton.shared.userData?.userDetails?.user?.currentCountry = country
                UDSingleton.shared.userData?.userDetails?.user?.currentCountryCode = country?.locale()
                self?.setUpdatedAddress(location: strLocationName, coordinate: manager.location?.coordinate)
            })
            // }
        }
        
        
        let didChangePosition : DidChangePosition = { [weak self] in
            if self?.screenType.mapMode == .NormalMode {
                self?.calculateImageSize()
            }
        }
        
        let didStopPosition : MapsDidStopMoving = { [weak self]  (position) in
            
            // let newLocation = CLLocation(latitude: /position.latitude, longitude: /position.longitude)
            
            /* if  let currentLocation = self?.currentLocation {
             if let distance = GoogleMapsDataSource.getDistance(newPosition: currentLocation , previous:  newLocation) {
             //                    self?.btnCurrentLocation.isSelected = !(distance > Float(2))
             }
             } */
            
            if self?.screenType.mapMode == .SelectingLocationMode {
                // Ankush self?.viewLocationTableContainer.alpha = 0
                
                // self?.results.removeAll()
                // self?.tblLocationSearch.reloadData()
                
                let newLocation = CLLocation(latitude: /position.latitude, longitude: /position.longitude)
                
                /* self?.mapDataSource?.getAddressFromlatLong(lat: /position.latitude, long: /position.longitude, completion: { (address, country, name) in
                 self?.setUpdatedAddress(location: address, coordinate: position)
                 }) */
            }
        }
        
        mapDataSource = GoogleMapsDataSource.init(mapStyleJSON: "MapStyle", mapView: mapView)
        mapView.delegate = mapDataSource
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.settings.tiltGestures = false
        mapView.isBuildingsEnabled = false
        mapView.setMinZoom(2, maxZoom: 20)
        mapView.animate(toZoom: 6)
        mapDataSource?.didUpdateCurrentLocation = didUpdateCurrentLocation
        mapDataSource?.didChangePosition = didChangePosition
        mapDataSource?.mapStopScroll = didStopPosition
        
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                debugPrint("Unable to find style.json")
            }
        } catch {
            debugPrint("One or more of the map styles failed to load. \(error)")
        }
        
        if let mapType = UserDefaultsManager.shared.mapType {
            
            guard let mapEnum = BuraqMapType(rawValue: mapType) else { return }
            mapView.mapType = mapEnum == .Hybrid ? .normal : .hybrid
            segmentedMapType.selectedSegmentIndex = mapEnum == .Hybrid ? 0 : 1
            
        }
    }
    
    
    func setUpdatedAddress(location : String , coordinate : CLLocationCoordinate2D?) {
        
        viewSelectService.lblLocationName.text = location
        
        CouponSelectedLocation.latitude = /coordinate?.latitude
        CouponSelectedLocation.longitude = /coordinate?.longitude
        CouponSelectedLocation.selectedAddress = location
        
        locationLatest = location
        latitudeLatest = Double(/coordinate?.latitude)
        longitudeLatest =  Double(/coordinate?.longitude)
        
        if screenType.mapMode == .SelectingLocationMode {
            
            /*  switch locationAddEdit {
             
             case .PickUp:
             
             txtPickUpLocation.text = location
             serviceRequest.locationNameDest = location
             serviceRequest.latitudeDest =  /coordinate?.latitude
             serviceRequest.longitudeDest =  /coordinate?.longitude
             
             case .DropOff:
             
             txtDropOffLocation.text = location
             serviceRequest.locationNickName = location
             serviceRequest.locationName = location
             serviceRequest.latitude =  /coordinate?.latitude
             serviceRequest.longitude =  /coordinate?.longitude
             
             case .Stop1:
             debugPrint("Stop1")
             
             if let object = serviceRequest.stops.filter({$0.priority == 1}).first {
             serviceRequest.stops.remove(object: object)
             }
             
             txtStop1.text = location
             
             let modal = Stops(latitude: /coordinate?.latitude, longitude: /coordinate?.longitude, priority: 1, address: location)
             serviceRequest.stops.append(modal)
             
             case .Stop2:
             debugPrint("Stop2")
             
             if let object = serviceRequest.stops.filter({$0.priority == 2}).first {
             serviceRequest.stops.remove(object: object)
             }
             
             txtStop2.text = location
             let modal = Stops(latitude: /coordinate?.latitude, longitude: /coordinate?.longitude, priority: 2, address: location)
             serviceRequest.stops.append(modal)
             
             debugPrint(serviceRequest.stops as Any)
             
             
             case .Home:
             debugPrint("Home")
             
             
             case .Work:
             debugPrint("Work")
             
             } */
            
            
            
            
            
            
            
            
            /* if txtDropOffLocation.isEditing == true  ||  locationEdit  == .DropOff {
             
             // Ankush Experimental - to not fill out Drop off automatically
             /* txtDropOffLocation.text = location
             serviceRequest.locationName = location
             serviceRequest.longitude =  Double(/coordinate?.longitude)
             serviceRequest.latitude =  Double(/coordinate?.latitude)
             tempDropOff = location */
             
             } else if txtPickUpLocation.isEditing == true ||  locationEdit  == .PickUp {
             
             serviceRequest.locationNameDest = location
             serviceRequest.longitudeDest =  Double(/coordinate?.longitude)
             serviceRequest.latitudeDest =  Double(/coordinate?.latitude)
             txtPickUpLocation.text = location
             tempPickUp = location
             } */
        }
    }
    
    func clearServiceRequestData() {
        
        serviceRequest.booking_type = nil
        serviceRequest.category_id = nil
        serviceRequest.category_brand_id = nil
        serviceRequest.selectedProduct = nil
        serviceRequest.driver_id = nil
        serviceRequest.friend_name = nil
        serviceRequest.friend_phone_number = nil
        serviceRequest.friend_phone_code = nil
        serviceRequest.coupon_id = nil
        serviceRequest.cancellation_charges = nil
        serviceRequest.selectedCard = nil
        serviceRequest.stops = []
        
        // transfer request popup after breakdown
        isTransferRequestPopUpShown = false
        isLongDistancePopUpShown = false
        isStopsShownAfterStartRide = false
        isDoneCurrentPolyline = true
        
        isCurrentLocationUpdated = false
    }
    
    func setupInitialUI() {
        
        viewStop1.isHidden = true
        txtStop1.text = ""
        
        viewStop2.isHidden = true
        txtStop2.text = ""
        
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
           switch template {
           case .DeliverSome:
                buttonAddStop.isHidden = true
               break
           default:
                 buttonAddStop.isHidden = false
               
           }
        
     
        
        constraintYAddLocationView.constant = (BookingPopUpFrames.navigationBarHeight + CGFloat(55) + 10)
        constraintHeightViewEnterPickDrop.constant = 189
        view.layoutIfNeeded()
        
        setupBookForInitialUI(isSwitchRiderViewOpened: false)
    }
    
    func setupBookForInitialUI(isSwitchRiderViewOpened : Bool) {
        
        // isSwitchRiderViewOpened = false
        let title = isSwitchRiderViewOpened ? "Home.Switch_Rider".localizedString : "Home.For_me".localizedString
        buttonHeaderBookingFor.setTitle(title, for: .normal)
        
        ViewForfriend.isHidden = !isSwitchRiderViewOpened
        ViewEnterPickUpDropOff.isHidden = isSwitchRiderViewOpened
        imageViewHeaderProfilePic.isHidden = isSwitchRiderViewOpened
        
        /* let heightIfSwitchriderIsNotopened = ( (/viewStop1.isHidden && /viewStop2.isHidden) ? 189 :  ((/viewStop1.isHidden || /viewStop2.isHidden) ? 189 + 48 : 189 + 48 + 48) )
         constraintHeightViewEnterPickDrop.constant = CGFloat(isSwitchRiderViewOpened ? 189 : heightIfSwitchriderIsNotopened)
         
         
         constraintYAddLocationView.constant = ( (/viewStop1.isHidden && /viewStop2.isHidden) ? 189 :  ((/viewStop1.isHidden || /viewStop2.isHidden) ? 189 + 48 : 189 + 48 + 48) ) */
        
        
        bottomViewBookforFriend.clearTextfields()
    }
    
    func setupHomeWorkLocations() {
        
        let home = homeAPI?.addresses?.home
        let work = homeAPI?.addresses?.work
        
        labelHomeLocationNickName.text = home?.addressName == nil || /home?.addressName?.isEmpty ? "Home.Add_Home_Address".localizedString : /home?.addressName
        labelHomeLocationName.text = home?.address == nil || /home?.address?.isEmpty ? "" : /home?.address
        labelHomeLocationName.isHidden = labelHomeLocationName.text == ""
        buttonEditHomeAddress.isHidden = home?.address == nil || /home?.address?.isEmpty
        
        labelWorkLocationNickName.text = work?.addressName == nil || /work?.addressName?.isEmpty ? "Home.Add_Work_Address".localizedString : /work?.addressName
        labelWorkLocationName.text = work?.address == nil || /work?.address?.isEmpty ? "" : /work?.address
        labelWorkLocationName.isHidden = labelWorkLocationName.text == ""
        buttonEditWorkAddress.isHidden = work?.address == nil || /work?.address?.isEmpty
    }
    
    func locationsSelected() {
        
        self.view.endEditing(true)
        
        guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{return}
        guard let addressDropOff = txtDropOffLocation.text else{return}
        
        if serviceID > 3 {
            
            guard let addressPicUp = txtPickUpLocation.text else{return}
            
            if addressPicUp.isEmpty  {
                Alerts.shared.show(alert: "AppName".localizedString, message: "pickup_address_validation_message".localizedString , type: .error )
                return
            }
            
            if (addressDropOff.isEmpty || addressPicUp == addressDropOff) {
                
                if (/txtStop1.text).isEmpty && (/txtStop2.text).isEmpty {
                    Alerts.shared.show(alert: "AppName".localizedString, message: "dropoff_address_validation_message".localizedString , type: .error )
                    return
                } else {
                    
                    let lastStop = serviceRequest.stops.last
                    serviceRequest.locationName = lastStop?.address
                    serviceRequest.latitude =  lastStop?.latitude
                    serviceRequest.longitude =  lastStop?.longitude
                    
                    serviceRequest.stops.removeLast()
                }
                
            }
        } else {
            
            if addressDropOff != tempDropOff  ||  addressDropOff.isEmpty  {
                Alerts.shared.show(alert: "AppName".localizedString, message: "dropoff_address_validation_message".localizedString , type: .error )
                return
            }
        }
        
        // results.removeAll()
        
        viewLocationTableContainer.alpha = 0 // Ankush
        viewStoppageDesc.isHidden = true
        
        
        let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
        
        switch template {
            
        case .Default?:
            var modeType : MapMode!
            
            if serviceRequest.booking_type == "RoadPickup" {
                
                showBasicNavigation(updateType: .SelectingFreightBrand)
                dropPickUpAndDropOffPins(pickLat: /serviceRequest.latitudeDest, pickLong: /serviceRequest.longitudeDest, dropLat: /serviceRequest.latitude, dropLong: /serviceRequest.longitude)
                modeType = .OrderPricingMode
            } else {
                modeType = serviceID > 3 ? .SelectingFreightBrand : .OrderDetail
            }
            
            screenType = ScreenType(mapMode: modeType, entryType: .Forward)
            locationEdit  = serviceID > 3 ? .PickUp : .DropOff
            
        case .Mover?:
            screenType = ScreenType(mapMode: .OrderPricingMode, entryType: .Forward)
            dropPickUpAndDropOffPins(pickLat: /serviceRequest.latitudeDest, pickLong: /serviceRequest.longitudeDest, dropLat: /serviceRequest.latitude, dropLong: /serviceRequest.longitude)
            
        default:
            break
            
        }
        
        
        
    }
}

//MARK:- API
extension HomeVC {
    
    func orderEventFire() { // WHEN SEARCH REQUEST TIMED OUT. ELSE CASE IN UNDERPROCESSING VIEW
        
        guard let order = currentOrder else{return}
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let dict : [String : Any] = [EmitterParams.EmitterType.rawValue : CommonEventType.ParticularOrder.rawValue ,EmitterParams.AccessToken.rawValue  :  token ,EmitterParams.OrderToken.rawValue :   /order.orderToken]
        SocketIOManagerCab.shared.getParticularOrder(dict) { [weak self] (response) in
            
            if let order = response as? OrderCab {
                
                if order.orderStatus == .Confirmed || order.orderStatus == .reached || order.orderStatus == .Ongoing {
                    self?.driverAcceptedMode(order: order)
                    
                } else if order.orderStatus == .ServiceTimeout {
                    self?.viewUnderProcess.minimizeProcessingView()
                    if self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown {
                        self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Forward)
                    }else{
                        self?.screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
                    }
                } else if order.orderStatus == .CustomerCancel {
                    
                    
                } else if order.orderStatus == .Searching {
                    
                    //  self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Forward)
                }
            }
        }
    }
    
    func checkFinalStatus() {
        
        guard let orderRequested = currentOrder else{return}
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let dict : [String : Any] = [
            EmitterParams.EmitterType.rawValue : CommonEventType.ParticularOrder.rawValue ,
            EmitterParams.AccessToken.rawValue  :  token ,
            EmitterParams.OrderToken.rawValue :   /orderRequested.orderToken
        ]
        
        SocketIOManagerCab.shared.getParticularOrder(dict) { [weak self] (response) in
            
            if let order = response as? OrderCab {
                
                if order.orderStatus ==  .CustomerCancel {
                    //  self?.currentOrder?.orderStatus = order.orderStatus
                    if self?.screenType.mapMode == .RequestAcceptedMode {
                        
                        //                    ez.runThisInMainThread {
                        //
                        //                    self?.driverMarker.map = nil
                        //                    self?.polyline?.map = nil
                        //                    self?.userMarker.map = nil
                        //                    self?.viewDriverAccepted.minimizeDriverView()
                        //                   }
                    }
                }
            }
        }
    }
    
    func listeningEvent() {
    
        SocketIOManagerCab.shared.listenOrderEventConnected { [weak self]( data ,socketType) in
            
            guard let socketType = socketType as? OrderEventType else {return}
            print("Socket data addded", data)
            
            switch socketType {
                
            case .ServiceAccepted:
                guard let model = data as? OrderCab else { return }
                if model.bookingType == .Present {
                    if self?.currentOrder?.orderStatus == .CustomerCancel {return}
                }
                
                if self?.serviceRequest.requestType == .Future {
                    self?.viewOrderPricing.minimizeOrderPricingView()
                    self?.viewUnderProcess.minimizeProcessingView()
                    self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Forward)
                    if  self?.isCheck == false {
                        self?.isCheck = true
                        self?.mapView.clear()
                        self?.getCoronaAreas()
                        self?.cleanPath()
                        self?.getCoronaAreas()
                        self?.alertBoxOk(message:"service_booked_successfully".localizedString , title: "congratulations".localizedString, ok: {
                            self?.isCheck = false
                            
                            // To move to Home in case of Package
                            if /self?.isFromPackage {
                                self?.navigationController?.popToRootViewController(animated: true)
                            }
                        })
                    }
                } else {
                    self?.driverAcceptedMode(order: model)
                    //  self?.checkFinalStatus()
                }
                
            case .SerLongDistance:
                
                if !(/self?.isLongDistancePopUpShown) {
                    self?.alertBoxOption(message: "long_distance_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: {}, cancel: { [weak self] in
                        
                        self?.viewDriverAccepted.cancelOngoingOrder()
                    })
                    
                    self?.isLongDistancePopUpShown = true
                }
                
            case .ServiceCurrentOrder: // Again and Again
                
                //if self?.currentOrder?.bookingType == .Future {return}
                
                guard let model = data as? TrackingModel else { return }
                
                AllOrdersOngoing.ordersOngoing["\(/model.orderId)"] = model
                AllOrdersOngoing.order = model
                
                self?.dic["\(/model.orderId)"] = model
                AllOrdersOngoing.ordersOngoing = /self?.dic
                
                print("\(LocalNotifications.ETokenTrackingRefresh.rawValue)\(/model.orderId)")
                
                NotificationCenter.default.post(name: Notification.Name("\(LocalNotifications.ETokenTrackingRefresh.rawValue)\(/model.orderId)"), object: nil, userInfo: nil)
                
                //Driver Updated Lat and Long
                let updatedDriver = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model.driverLatitude) , longitude: CLLocationDegrees(/model.driverLongitude))
                debugPrint(updatedDriver)
                
                
                if (model.orderStatus != .Ongoing && model.orderStatus != .Confirmed) {return}
                self?.currentOrder?.orderStatus = model.orderStatus
                self?.driverBearing = model.bearing
                
               if let order = self?.currentOrder {
                    
                    /*  if /order.serviceId > 3 && (model.orderStatus == .Ongoing || model.orderStatus == .Confirmed) {
                     self?.destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.dropOffLatitude) , longitude: CLLocationDegrees(/order.dropOffLongitude))
                     } */
                    
                    // Ankush - Moby
                    if /order.serviceId > 3 {
                        if (model.orderStatus == .Ongoing) {
                            self?.destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.dropOffLatitude) , longitude: CLLocationDegrees(/order.dropOffLongitude))
                        } else if (model.orderStatus == .Confirmed) {
                            self?.destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.pickUpLatitude) , longitude: CLLocationDegrees(/order.pickUpLongitude))
                        }
                    }
                }
                
                self?.source = updatedDriver
                
                if /self?.btnCurrentLocation.isSelected{
                    guard let path = GMSMutablePath(fromEncodedPath: /model.polyline) else { return }
                    
                    let bounds = GMSCoordinateBounds(path: path)
                    self?.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                }
                
                if self?.currentOrder?.myTurn == OrderTurn.MyTurn{
                    
                    PolylineCab.points = /model.polyline
                    
                    let stops = self?.currentOrder?.orderStatus == .Ongoing ? self?.currentOrder?.ride_stops : nil
                    self?.getPolylineRoute(source: updatedDriver , destination: self?.destination, stops: stops, model: model)
                }
                else {
                    //Experimental
                    PolylineCab.points = /model.polyline
                    
                    let stops = self?.currentOrder?.orderStatus == .Ongoing ? self?.currentOrder?.ride_stops : nil
                    self?.getPolylineRoute(source: updatedDriver , destination: self?.destination, stops: stops, model: model)
                }
                
                DispatchQueue.main.async {[weak self] in
                    self?.viewDriverAccepted.setOrderStatus(tracking: model)
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.setOrderStatus(tracking: model)
                }
                
            case .ServiceCompletedByDriver:
                
                guard let model = data as? OrderCab else { return }
                self?.checkCancellationPopUp()
                
                //if model.bookingType == .Future {return }
                self?.currentOrder = model
                self?.viewDriverAccepted.minimizeDriverView()
                (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                self?.screenType = ScreenType(mapMode: .ServiceDoneMode , entryType: .Forward)
                
            case .ServiceBreakdown, .ServiceBreakDownAccepted:
                
                guard let model = data as? OrderCab else { return }
                self?.checkCancellationPopUp()
                
                //if model.bookingType == .Future {return }
                self?.currentOrder = model
                self?.viewDriverAccepted.minimizeDriverView()
                
                if (ez.topMostVC is OngoingRideDetailsViewController) {
                    
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: {[weak self] in
                        if !(/self?.isTransferRequestPopUpShown) {
                            self?.alertBoxOk(message: "transferRequest".localizedString, title: "AppName".localizedString, ok: {})
                            self?.isTransferRequestPopUpShown = true
                        }
                    })
                } else {
                    if !(/self?.isTransferRequestPopUpShown) {
                        self?.alertBoxOk(message: "transferRequest".localizedString, title: "AppName".localizedString, ok: {})
                        self?.isTransferRequestPopUpShown = true
                    }
                }
                
                // self?.homeAPI?.orders.append(model)
                model.isContinueFromBreakdown = true
                self?.currentOrder = model
                self?.screenType = ScreenType(mapMode: .UnderProcessingMode , entryType: .Forward)
                
                
            case .SerHalfWayStopRejected, .ServiceBreakDownRejected:
                debugPrint("SerHalfWayStopRejected")
                
                guard let model = data as? OrderCab else { return }
                
                self?.currentOrder = model
                self?.viewUnderProcess.minimizeProcessingView()
                self?.showDriverView()
                
            case .DriverCancelrequest:
                self?.checkCancellationPopUp()
                let mode = self?.screenType.mapMode
                if mode == .RequestAcceptedMode || mode == .OnTrackMode  {
                    
                    self?.mapView.clear()
                    self?.getCoronaAreas()
                    self?.cleanPath()
                    self?.getCoronaAreas()
                    self?.viewDriverAccepted.minimizeDriverView()
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                    self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Forward)
                    
                    // To move to Home in case of Package
                    if /self?.isFromPackage {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    
                }else if mode == .UnderProcessingMode   {
                    
                    self?.viewUnderProcess.minimizeProcessingView()
                    self?.screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
                }

                case  .ServiceTimeOut  :
                    let template = AppTemplate(rawValue: /UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt())
                      switch template {
                      case .GoMove:
                        
                        if UIApplication.topViewController()!.isKind(of: UIAlertController.self) {
                            print("Alert already presented by socket....")
                        } else {
                            self?.alertBoxOk(message: "We're sorry, there is no driver around you at the moment available to help you out! Call us at +1 (514) 416-6606 and we'll make sure to appoint someone right away!".localizedString, title: "AppName".localizedString) {
                                self?.viewUnderProcess.minimizeProcessingView()
                                
                                var mapMode : MapMode! = (self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown) ? .NormalMode : .OrderPricingMode
                                self?.screenType = ScreenType(mapMode: mapMode , entryType: .Forward)
                            }
                        }
                        
                      default:
                        
                        self?.viewUnderProcess.minimizeProcessingView()
                        
                        var mapMode : MapMode! = (self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown) ? .NormalMode : .OrderPricingMode
                        self?.screenType = ScreenType(mapMode: mapMode , entryType: .Forward)
                        
                    }
                
            case .ServiceRejectedByAllDriver  :
                
                self?.viewUnderProcess.minimizeProcessingView()
                
                var mapMode : MapMode! = (self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown) ? .NormalMode : .OrderPricingMode
                self?.screenType = ScreenType(mapMode: mapMode , entryType: .Forward)
            case .serReached:
                break
            case .ServiceOngoing , .DriverRatedCustomer : // - ServiceOngoing - When driver start ride
                
                //if self?.currentOrder?.bookingType == .Future {return}
                
                if let model = data as? OrderCab {
                    
                    //  let source = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model.pickUpLatitude) , longitude: CLLocationDegrees(/model.pickUpLongitude))
                    //  let destination = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model.dropOffLatitude) , longitude: CLLocationDegrees(/model.dropOffLongitude))
                    
                    //  let stops = model.orderStatus == .Ongoing ? model.ride_stops : nil
                    //  self?.getPolylineRoute(source: source , destination: destination, stops: stops, model: nil)
                    
                    self?.currentOrder = model
                    DispatchQueue.main.async {[weak self] in
                        self?.viewDriverAccepted.setOrderStatus(modal: model)
                        (ez.topMostVC as? OngoingRideDetailsViewController)?.setOrderStatus(modal: model)
                    }
                }
                
                guard let model = data as? TrackingModel else { return }
                
                //Driver Updated Lat and Long
                
                let updatedDriver = CLLocationCoordinate2D(latitude: CLLocationDegrees(/model.driverLatitude) , longitude: CLLocationDegrees(/model.driverLongitude))
                
                if model.orderStatus != .Ongoing {return}
                self?.currentOrder?.orderStatus = model.orderStatus
                self?.driverBearing = model.bearing
                if let order = self?.currentOrder {
                    
                    if /order.serviceId > 3 && model.orderStatus == .Ongoing {
                        self?.destination =   CLLocationCoordinate2D(latitude: CLLocationDegrees(/order.dropOffLatitude) , longitude: CLLocationDegrees(/order.dropOffLongitude))
                    }
                }
                self?.source = updatedDriver
                
                if /self?.btnCurrentLocation.isSelected{
                    guard let path = GMSMutablePath(fromEncodedPath: /model.polyline) else { return }
                    
                    let bounds = GMSCoordinateBounds(path: path)
                    self?.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                }
                
                
                if self?.currentOrder?.myTurn == OrderTurn.MyTurn{
                    
                    PolylineCab.points = /model.polyline
                    
                    let stops = self?.currentOrder?.orderStatus == .Ongoing ? self?.currentOrder?.ride_stops : nil
                    self?.getPolylineRoute(source: updatedDriver , destination: self?.destination, stops: stops, model: model)
                }
                else{
                    
                }
                
                DispatchQueue.main.async {[weak self] in
                    self?.viewDriverAccepted.setOrderStatus(tracking: model)
                    (ez.topMostVC as? OngoingRideDetailsViewController)?.setOrderStatus(tracking: model)
                }
                
                
                //  guard let model = data as? Order else { return }
                break
                
            case .EtokenStart:
                
                print("start")
            case .EtokenConfirmed:
                
                print("etoken confirmed")
                
            case .EtokenSerCustPending:
                print("gerg")
                
            case .EtokenCTimeout:
                print("timedout")
                
            case .CardAdded:
                (ez.topMostVC as? AddCardViewControllerCab)?.popVC()
                
            case .SerCheckList:
                print("Checklist data <===")
                
                guard let dataValue = data as? [String: Any] else { return }
                guard  let orderModel = dataValue["order"] as? [String: Any] else{return}
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel)
                self?.currentOrder?.check_lists = order?.check_lists
                UDSingleton.shared.userData?.order?.first?.check_lists = order?.check_lists
                
                
            case .Pending:
                
               if UIApplication.topViewController()!.isKind(of: UIAlertController.self) {
                    print("Alert already presented by socket....")
                } else {
                    self?.alertBoxOk(message: "Your_ride_has_been_accepted_and_its_pending_from_approval.".localizedString, title: "AppName".localizedString) {
                         self?.viewUnderProcess.minimizeProcessingView()
                         self?.screenType = ScreenType(mapMode: .NormalMode, entryType: .Backward)
                    }
                }
                
            case .DApproved:
                // Hit Dashboard API:
                self?.getUpdatedData()
                break
                
                
                
            }
            
            
           
            
        }
    }
    
    func getLocalDriverForParticularService(service: Service,isScanCode:Bool=false,object: RoadPickupModal?=nil) {
        
        if APIManagerCab.shared.isConnectedToNetwork() == false {
            alertBoxOk(message:"Validation.InternetNotWorking".localizedString , title: "AppName".localizedString, ok: { [weak self] in
                self?.getUpdatedData()
            })
            return
        }
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let homeAPI =  BookServiceEndPoint.homeApi(categoryID: service.serviceCategoryId)
        homeAPI.request(isLoaderNeeded: false, header: ["language_id" : LanguageFile.shared.getLanguage(), "access_token" :  token]) {
            [weak self] (response) in
            
            switch response {
                
            case .success(let data):
                
                guard let model = data as? HomeCab else { return }
                self?.homeAPI = model
                
                
                self?.setupHomeWorkLocations()
                self?.recentLocations = model.addresses?.recent ?? []
                
                guard let orders = self?.homeAPI?.orders else {return}
                
                guard let lastCompletedOrder = self?.homeAPI?.orderLastCompleted else {return}
                
                if orders.count > 0 {
                    
                    let latestOrder = orders[0]
                    
                    if latestOrder.orderStatus == .reached || latestOrder.orderStatus == .Confirmed || latestOrder.orderStatus == .Ongoing {
                        
                        self?.currentOrder =  latestOrder
                        
                        if self?.currentOrder?.bookingType == .Present ||  self?.currentOrder?.bookingType == .Future {
                            self?.driverAcceptedMode(order: latestOrder)
                        }else{
                            self?.screenType = ScreenType(mapMode: .NormalMode, entryType: .Forward)
                            
                        }
                        
                    }else if latestOrder.orderStatus == .Searching {
                        
                        if  /latestOrder.orderId != /self?.currentOrder?.orderId  { //coming after killing the app
                            self?.currentOrder =  latestOrder
                            self?.isSearching = true
                            self?.showBasicNavigation(updateType: .OrderDetail)
                            self?.screenType = ScreenType(mapMode: .UnderProcessingMode, entryType: .Forward)
                        }
                    }else {
                        self?.screenType = ScreenType(mapMode: .NormalMode, entryType: .Forward)
                    }
                    
                }else  if lastCompletedOrder.count > 0 {
                    
                    //User need to gice rating to Driver
                    
                    //Added new code by rohit kumar
                    if self?.screenType.mapMode == .RequestAcceptedMode ||  self?.screenType.mapMode == .OnTrackMode {
                        self?.viewDriverAccepted.minimizeDriverView()
                        (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                    }
                    
                    self?.checkCancellationPopUp()
                    self?.currentOrder = lastCompletedOrder[0]
                    self?.imgViewPickingLocation.isHidden = true
                    self?.viewSelectService.minimizeSelectServiceView()
                    self?.screenType = ScreenType(mapMode: .NormalMode, entryType: .Backward)
                    
                    
                    
                    
                    /*
                     //Commented by rohit kumar
                     if self?.screenType.mapMode == .RequestAcceptedMode ||  self?.screenType.mapMode == .OnTrackMode {
                     self?.viewDriverAccepted.minimizeDriverView()
                     (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                     }
                     
                     self?.checkCancellationPopUp()
                     self?.currentOrder = lastCompletedOrder[0]
                     self?.imgViewPickingLocation.isHidden = true
                     self?.viewSelectService.minimizeSelectServiceView()
                     
                     self?.showNewInvoiceView()
                     self?.showBasicNavigation(updateType: .ServiceDoneMode) */
                    
                    // self?.screenType = ScreenType(mapMode: .ServiceDoneMode, entryType: .Forward)
                    // self?.viewDriverRating.showDriverRatingView(superView: self?.viewMapContainer ?? UIView(), order: self?.currentOrder, showSkipButton: false)
                    
                    // Ankush self?.showNewInvoiceView()
                    
                    // Ankush need to handle self?.showInvoiceView()
                    
                } else{
                    
                    if self?.screenType.mapMode == .UnderProcessingMode{
                        
                        self?.viewUnderProcess.minimizeProcessingView()
                        if self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown {
                            self?.screenType = ScreenType(mapMode:  .NormalMode , entryType: .Backward)
                            return
                        }
                        self?.screenType = ScreenType(mapMode:  .OrderPricingMode , entryType: .Backward)
                        
                    } else if  self?.screenType.mapMode == .NormalMode || self?.screenType.mapMode == .ZeroMode {
                        
                        
                        if !isScanCode{
                            
                            self?.viewSelectService.minimizeSelectServiceView()
                            self?.screenType = ScreenType(mapMode: .NormalMode, entryType: .Forward)
                        }
                        
                    }else if self?.screenType.mapMode == .RequestAcceptedMode || self?.screenType.mapMode == .RequestAcceptedMode  {
                        
                        self?.viewDriverAccepted.minimizeDriverView()
                        (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
                        self?.screenType = ScreenType(mapMode:  .NormalMode , entryType: .Backward)
                        
                        self?.moveToNormalMode()
                        self?.getNearByDrivers()
                        
                    }
                    
                }
                
                
                if /self?.isFromPackage {
                    
                    self?.serviceRequest.serviceSelected?.brands = []
                    
                    self?.modalPackages?.package?.pricingData?.categoryBrands?.forEach({ (packageBrand) in
                        
                        guard let filteredObject = self?.homeAPI?.brands?.filter({$0.categoryBrandId == packageBrand.categoryBrandId}).first else {return}
                        self?.serviceRequest.serviceSelected?.brands?.append(filteredObject)
                        
                    })
                } else {
                    self?.serviceRequest.serviceSelected?.brands = self?.homeAPI?.brands
                    
                }
                
                if  self?.screenType.mapMode == .NormalMode || self?.screenType.mapMode == .ZeroMode {
                    
                    
                    if isScanCode{
                        
                        self?.displayScannedService(object:object)
                    }
                    
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func getTerminologyData(serviceId: Int) {
        
        if APIManagerCab.shared.isConnectedToNetwork() == false {
            alertBoxOk(message:"Validation.InternetNotWorking".localizedString , title: "AppName".localizedString, ok: { [weak self] in
                self?.getUpdatedData()
            })
            return
        }
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let terminologyAPI =  BookServiceEndPoint.terminologyAPI(categoryID: serviceId)
        terminologyAPI.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage(), "access_token" :  token]) {
            (response) in
            
            switch response {
                
            case .success(let data):
                
                guard let model = data as? AppTerminologyModel else { return }
                UDSingleton.shared.appTerminology = model
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func bookService() {
        self.isSearching = false
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        // listeningEvent()
        
        print("Check List Item ",serviceRequest.check_lists?.toJson())
        
        ///
        
        let objRequest = BookServiceEndPoint.requestApi(objRequest: serviceRequest,
                                                        categoryId: /serviceRequest.booking_type == "RoadPickup" ? /serviceRequest.category_id : /serviceRequest.serviceSelected?.serviceCategoryId,
                                                        categoryBrandId: /serviceRequest.booking_type == "RoadPickup" ? /serviceRequest.category_brand_id : /serviceRequest.selectedBrand?.categoryBrandId,
                                                        categoryBrandProductId: serviceRequest.selectedProduct?.productBrandId,
                                                        productQuantity: serviceRequest.quantity,
                                                        dropOffAddress:  /serviceRequest.locationName,
                                                        dropOffLatitude: /serviceRequest.latitude ,
                                                        dropOffLongitude:  /serviceRequest.longitude,
                                                        pickupAddress: /serviceRequest.locationNameDest,
                                                        pickupLatitude: /serviceRequest.latitudeDest,
                                                        pickupLongitude: /serviceRequest.longitudeDest,
                                                        orderTimings:  /serviceRequest.orderDateTime.toFormattedDateString(),
                                                        future: /serviceRequest.requestType.rawValue,
                                                        paymentType: /serviceRequest.paymentMode.rawValue,
                                                        distance: 2000,
                                                        organisationCouponUserId: /serviceRequest.eToken?.organisationCouponUserId,
                                                        materialType: /serviceRequest.materialType,
                                                        productWeight: /serviceRequest.weight,
                                                        productDetail:  /serviceRequest.additionalInfo ,
                                                        orderDistance: serviceRequest.distance,
                                                        finalCharge: serviceRequest.finalPrice,
                                                        package_id: modalPackages?.packageId,
                                                        distance_price_fixed: serviceRequest.distance_price_fixed,
                                                        price_per_min: serviceRequest.price_per_min,
                                                        time_fixed_price: serviceRequest.time_fixed_price,
                                                        price_per_km: serviceRequest.price_per_km,
                                                        booking_type: serviceRequest.booking_type,
                                                        friend_name: serviceRequest.friend_name,
                                                        friend_phone_number: serviceRequest.friend_phone_number,
                                                        friend_phone_code: serviceRequest.friend_phone_code,
                                                        driver_id: serviceRequest.driver_id,
                                                        coupon_code: serviceRequest.coupon_code,
                                                        cancellation_charges: serviceRequest.cancellation_charges,
                                                        stops: serviceRequest.stops.toJSONString(),
                                                        address_name: serviceRequest.locationNickName,
                                                        user_card_id: serviceRequest.selectedCard?.userCardId,
                                                        credit_point_used: serviceRequest.credit_point_used,
                                                        description: serviceRequest.description,
                                                        elevator_pickup: serviceRequest.elevator_pickup,
                                                        elevator_dropoff: serviceRequest.elevator_dropoff,
                                                        pickup_level: serviceRequest.pickup_level,
                                                        dropoff_level: serviceRequest.dropoff_level,
                                                        fragile: serviceRequest.fragile,
                                                        check_lists: serviceRequest.check_lists?.toJson(),
                                                        gender: serviceRequest.gender,
                                                        order_time: serviceRequest.duration,numberOfRiders:
            /serviceRequest.numberOfRiders)
        
        objRequest.request(isImage: true, images: serviceRequest.orderImages , isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? OrderCab else { return }
                UDSingleton.shared.userData?.order = [model]
                if /model.orderId == /self?.currentOrder?.orderId && model.orderId != nil && self?.currentOrder?.orderId != nil { //Accepted socket recieved frist
                    return
                } else if model.statusCode == 301 {
                    
                    guard let vc = R.storyboard.bookService.outstandingViewcontroller() else {return}
                    let navigation = UINavigationController(rootViewController: vc)
                    navigation.setNavigationBarHidden(true, animated: false)
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.request = self?.serviceRequest
                    vc.currentOrder = model
                    vc.delegate = self
                    self?.presentVC(navigation)
                    
                } else {
                    self?.viewOrderPricing.minimizeOrderPricingView()
                    self?.homeAPI?.orders.append(model)
                    self?.currentOrder = model
                    self?.screenType = ScreenType(mapMode: .UnderProcessingMode , entryType: .Forward)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
            
        }
    }
    
    func cancelRequest(strReason : String , orderID : Int?) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let objCancel = BookServiceEndPoint.cancelRequest(orderId: /orderID, cancelReason: strReason)
        objCancel.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            if self?.isSearching == true || /self?.currentOrder?.isContinueFromBreakdown {
                self?.viewUnderProcess.minimizeProcessingView()
                
                self?.mapView.clear()
                self?.getCoronaAreas()
                self?.cleanPath()
                self?.getCoronaAreas()
                self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Backward)
                return
            }
            
            switch response {
            case .success(_):
                
                self?.cancelDoneOrder()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    @objc func nCancelFromBookinScreen(notifcation : Notification) {
        if let orderId = notifcation.object as? String, orderId.toInt() == self.currentOrder?.orderId {
            cancelDoneOrder()
        }
    }
    
    func cancelDoneOrder() {
        self.viewUnderProcess.minimizeProcessingView()
        // viewConfirmPickUp.minimizeConfirmPickUPView()
        
        if self.currentOrder?.orderStatus == .Confirmed || self.currentOrder?.orderStatus == .Ongoing {
            self.mapView.clear()
            self.getCoronaAreas()
            self.cleanPath()
            self.getCoronaAreas()
            self.viewDriverAccepted.minimizeDriverView()
            (ez.topMostVC as? OngoingRideDetailsViewController)?.dismissVC(completion: nil)
            self.currentOrder?.orderStatus = .CustomerCancel
            self.screenType = ScreenType(mapMode: .NormalMode , entryType: .Backward)
            
        } else {
            
            self.currentOrder?.orderStatus = .CustomerCancel
            self.screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Backward)
        }
    }
    
    func submitRating(rateValue : Int , comment : String) {
        
        guard let orderId = currentOrder?.orderId else{return}
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let rating = BookServiceEndPoint.rateDriver(orderId: orderId, rating: rateValue, comment: comment)
        
        rating.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {[weak self] (response) in
            switch response {
                
            case .success(_):
                
                self?.viewDriverRating.minimizeDriverRatingView()
                self?.viewNewInvoice.minimizeNewInvoiceView()
                self?.mapView.clear()
                self?.getCoronaAreas()
                self?.cleanPath()
                self?.getCoronaAreas()
                self?.screenType = ScreenType(mapMode: .NormalMode , entryType: .Backward)
                
                // To move to Home in case of Package
                if /self?.isFromPackage {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func updateData() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let updateDataVC = LoginEndpoint.updateData(fcmID: UserDefaultsManager.fcmId)
        updateDataVC.request(isLoaderNeeded: false, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? HomeCab else { return }
                
                if let userData = UDSingleton.shared.userData {
                    userData.userDetails = model.userDetail
                    userData.services = model.services
                    userData.support = model.support
                    userData.order = model.orders
                    UDSingleton.shared.userData = userData
                }
                
                guard let version = model.version  else { return }
                guard  let forceVersion = version.iOSVersion?.user?.forceVersion  else { return }
                
                self?.checkUpdate(strForce: forceVersion)
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func cancelHalfWayStop() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let cancelHalfWayStopObject = BookServiceEndPoint.cancelHalfWayStop(orderId: currentOrder?.orderId)
        cancelHalfWayStopObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let modal = data as? OrderCab else {return}
                
                self?.currentOrder = modal
                self?.viewUnderProcess.minimizeProcessingView()
                self?.showDriverView()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func cancelVehicleBreakdown() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let cancelVehicleBreakdownObject = BookServiceEndPoint.cancelVehicleBreakDown(orderId: currentOrder?.orderId)
        cancelVehicleBreakdownObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let modal = data as? OrderCab else {return}
                
                self?.currentOrder = modal
                self?.viewUnderProcess.minimizeProcessingView()
                self?.showDriverView()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func apiGetCreditpoints() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let getCreditPointsObject = BookServiceEndPoint.getCreditPoints
        let getWalletBalance = BookServiceEndPoint.getWalletBalance
        
        if  Bool(/UDSingleton.shared.appSettings?.appSettings?.is_wallet) ?? false {
            getWalletBalance.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
                switch response {
                    
                case .success(let data):
                    
                    let walletData = data as? WalletDetails
                    self?.viewOrderPricing.setWalletData(wallet: walletData)
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
            
        } else {
            getCreditPointsObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
                switch response {
                    
                case .success(let data):
                    
                    guard let modal = data as? UserDetail else {return}
                    self?.viewOrderPricing.setCreditPoints(points: modal.credit_points)
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        }
        
    }
    
    func apiAddAddress(address: String?, name: String?, latitude: Double?, longitude: Double?, category: String) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let addAddressObject = BookServiceEndPoint.addAddress(address: address, address_latitude: /latitude, address_longitude:  /longitude, category: category, address_name: name)
        addAddressObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                debugPrint(data as Any)
                
                guard let modal = data as? AddressCab else {return}
                
                if /modal.category == "HOME" {
                    
                    self?.labelHomeLocationNickName.text = modal.addressName
                    self?.labelHomeLocationName.text = modal.address
                    self?.labelHomeLocationName.isHidden = false
                    self?.buttonEditHomeAddress.isHidden = false
                    
                    self?.homeAPI?.addresses?.home = modal
                    
                } else {
                    
                    self?.labelWorkLocationNickName.text =  modal.addressName
                    self?.labelWorkLocationName.text = modal.address
                    self?.labelWorkLocationName.isHidden = false
                    self?.buttonEditWorkAddress.isHidden = false
                    
                    self?.homeAPI?.addresses?.work = modal
                    
                }
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func apiEditAddress(address: String?, name: String?, latitude: Double?, longitude: Double?, category: String) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let addressID = category == "HOME" ? homeAPI?.addresses?.home?.userAddressId : homeAPI?.addresses?.work?.userAddressId
        
        let editAddress = BookServiceEndPoint.editAddress(address: address, address_latitude: latitude, address_longitude: longitude, user_address_id: addressID, category: category, address_name: name)
        
        editAddress.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                debugPrint(data as Any)
                
                guard let modal = data as? AddressCab else {return}
                
                if /modal.category == "HOME" {
                    
                    self?.labelHomeLocationNickName.text = modal.addressName
                    self?.labelHomeLocationName.text = modal.address
                    self?.labelHomeLocationName.isHidden = false
                    self?.buttonEditHomeAddress.isHidden = false
                    
                    self?.homeAPI?.addresses?.home = modal
                    
                } else {
                    
                    self?.labelWorkLocationNickName.text =  modal.addressName
                    self?.labelWorkLocationName.text = modal.address
                    self?.labelWorkLocationName.isHidden = false
                    self?.buttonEditWorkAddress.isHidden = false
                    
                    self?.homeAPI?.addresses?.work = modal
                    
                }
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}

extension HomeVC: GMSMapViewDelegate {
    
    func  getPolylineRoute(source: CLLocationCoordinate2D? , destination: CLLocationCoordinate2D?, stops: [Stops]? = nil,  model: TrackingModel? ){
        
        if isDoneCurrentPolyline {
            
            isDoneCurrentPolyline = false
            
            // driver giving direction data, and time
            
            if model != nil && model?.polyline != "" {
                if self.currentOrder?.orderStatus == .CustomerCancel  {return}
                self.durationLeft = /model?.etaTime
                // self.updateDriverCustomerMarker(driverLocation: self.source, customerLocation: self.destination , trackString: model?.polyline, stops: stops)
                
                
                if model?.orderStatus == .Ongoing && /stops?.count > 0 && !isStopsShownAfterStartRide {
                    
                } else {
                    self.updateDriverCustomerMarker(driverLocation: source, customerLocation: destination , trackString: model?.polyline, stops: stops)
                    self.isDoneCurrentPolyline = true
                    return
                }
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            var urlString  = "https://maps.googleapis.com/maps/api/directions/json?origin=\(/source?.latitude),\(/source?.longitude)&destination=\(/destination?.latitude),\(/destination?.longitude)&sensor=true&mode=driving&key=\(/UDSingleton.shared.appSettings?.appSettings?.ios_google_key)"
            
            if /stops?.count == 1 {
                urlString = urlString + "&waypoints=via:\(/stops?.first?.latitude),\(/stops?.first?.longitude)"
                
            } else if /stops?.count == 2 {
                urlString = urlString + "&waypoints=via:\(/stops?.first?.latitude),\(/stops?.first?.longitude)|via:\(/stops?[1].latitude),\(/stops?[1].longitude)"
                
            } else if /stops?.count == 3 {
                urlString = urlString + "&waypoints=via:\(/stops?.first?.latitude),\(/stops?.first?.longitude)|via:\(/stops?[1].latitude),\(/stops?[1].longitude)|via:\(/stops?[2].latitude),\(/stops?[2].longitude)"
                
            } else if /stops?.count == 4 {
                urlString = urlString + "&waypoints=via:\(/stops?.first?.latitude),\(/stops?.first?.longitude)|via:\(/stops?[1].latitude),\(/stops?[1].longitude)|via:\(/stops?[2].latitude),\(/stops?[2].longitude)|via:\(/stops?[3].latitude),\(/stops?[3].longitude)"
                
            } 
            
            guard let nsString  = NSString.init(string: urlString).addingPercentEscapes(using: String.Encoding.utf8.rawValue),
                let url = URL(string: nsString) else {return}
            
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    
                    self.isDoneCurrentPolyline = true
                    debugPrint(error!.localizedDescription)
                    
                } else {
                    do {
                        
                        if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                                guard let routes = json["routes"] as? NSArray else {return}
                                
                                if (routes.count > 0) {
                                    
                                    let overview_polyline = routes[0] as? NSDictionary
                                    let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
                                    
                                    guard let points = dictPolyline?.object(forKey: "points") as? String else { return }
                                    
                                    guard let legs  = routes[0] as? NSDictionary , let legsJ = legs["legs"] as? NSArray , let lg = legsJ[0] as? NSDictionary else { return }
                                    let duration = lg["duration"] as? NSDictionary
                                    let durationLeft1 = duration?.object(forKey: "text") as? String
                                    
                                    if self?.currentOrder?.orderStatus == .CustomerCancel  {return}
                                    
                                    self?.durationLeft = /durationLeft1
                                    // self?.updateDriverCustomerMarker(driverLocation: self?.source, customerLocation: self?.destination , trackString: points, stops: stops)
                                    self?.updateDriverCustomerMarker(driverLocation: source, customerLocation: destination , trackString: points, stops: stops)
                                    self?.isDoneCurrentPolyline = true
                                    
                                    if model?.orderStatus == .Ongoing {
                                        self?.isStopsShownAfterStartRide = true
                                    }
                                } else {
                                    
                                    self?.isDoneCurrentPolyline = true
                                }
                            }
                        }
                    }catch {
                        debugPrint("error in JSONSerialization")
                    }
                }
            })
            task.resume()
        }
    }
    
    func showPath(polyStr :String){
        
        ez.runThisInMainThread { [weak self] in
            guard let self = self else { return }
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            
            guard let path = GMSMutablePath(fromEncodedPath: /polyStr) else { return }
            let bounds = GMSCoordinateBounds(path: path)
            self.mapView?.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            CATransaction.commit()
            
            
            // let path = GMSMutablePath(fromEncodedPath: polyStr) // Path
            self.polyPath = path
            self.polyline = GMSPolyline(path: path)
            self.polyline?.geodesic = true
            self.polyline?.strokeWidth = 2
            
            if let mapType = UserDefaultsManager.shared.mapType {
                guard let mapEnum = BuraqMapType(rawValue: mapType) else { return }
                // Ankush self.polyline?.strokeColor  = mapEnum == .Hybrid ? .darkGray : .white
                let color = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
                self.polyline?.strokeColor = color
            }
            self.polyline?.map = self.mapView
            
            self.cleanPath()
            self.timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
            
            
        }
    }
    
    func cleanPath() {
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
    }
    
    @objc func animatePolylinePath() {
        guard let path = polyPath else { return }
        if (self.i < path.count()) {
            self.animationPath.add(path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = .lightGray //R.color.appNewRedBorder()?.withAlphaComponent(0.5) ?? .black
            self.animationPolyline.strokeWidth = 2
            self.animationPolyline.map = self.mapView
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    
    
    
    func updateDriverCustomerMarker( driverLocation : CLLocationCoordinate2D? , customerLocation  : CLLocationCoordinate2D? , trackString : String?, stops: [Stops]?) {
        
        self.cleanPath()
        
        ez.runThisInMainThread { [weak self] in
            
            guard let source = driverLocation , let destination = customerLocation  else { return }
            guard let currOrder = self?.currentOrder else {return}
            
            self?.viewDriverAccepted.lblTimeEstimation.text = self?.durationLeft
            (ez.topMostVC as? OngoingRideDetailsViewController)?.lblTimeEstimation.text = self?.durationLeft // to update data
            
            if /currOrder.serviceId > 3 {
                self?.userMarker.icon = nil // Ankush currOrder.orderStatus == .Ongoing ? #imageLiteral(resourceName: "DropMarker") : #imageLiteral(resourceName: "PickUpMarker")
            }else{
                self?.userMarker.icon = nil // Ankush #imageLiteral(resourceName: "DropMarker")
            }
            
            self?.mapView.clear()
            self?.getCoronaAreas()
            self?.cleanPath()
            self?.getCoronaAreas()
            self?.userMarker.isFlat = false
            self?.userMarker.map = self?.mapView
            self?.userMarker.position = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
            
            self?.driverMarker.icon = UIImage().getDriverImage(type: /currOrder.serviceId)
            self?.driverMarker.isFlat = false
            self?.driverMarker.map = self?.mapView
            
            /* let imageView = UIImageView(image: R.image.dropMarker())
             imageView.kf.setImage(with: URL(string: /self?.currentOrder?.driverAssigned?.icon_image_url), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
             self?.driverMarker.iconView = imageView */
            
            self?.driverMarker.isFlat = false
            self?.driverMarker.map = self?.mapView
            
            stops?.forEachEnumerated {[weak self] (index, stop) in
                let markerStoppage = GMSMarker()
                markerStoppage.position = CLLocationCoordinate2D(latitude: /stop.latitude, longitude:  /stop.longitude)
                markerStoppage.icon  = R.image.ic_pick_location()
                markerStoppage.map = self?.mapView
            }
            
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(2.5)
            
            self?.driverMarker.position = CLLocationCoordinate2D(latitude: source.latitude, longitude: source.longitude)
            self?.driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            if let degrees = self?.driverBearing  {
                self?.driverMarker.rotation = /CLLocationDegrees(degrees)
            }
            CATransaction.commit()
            guard let lineTrack = trackString  else { return }
            self?.showPath(polyStr: lineTrack)
        }
    }
}

//MARK:- Custom Delegates
//MARK:-

extension HomeVC : BookRequestDelegate {
    func didShowCheckList(order: OrderCab?) {
        guard let fullOrderDetails = R.storyboard.bookService.fullOrderDetails() else { return }
        self.presentVC(fullOrderDetails)
    }
    

    
    func didBuyEToken(brandId :Int, brandProductId:Int) {
        
        guard let etoken = R.storyboard.drinkingWater.tokenListingVC() else{return}
        
        print(brandId)
        
        CouponSelectedLocation.categoryId = brandId
        CouponSelectedLocation.categoryBrandId = brandProductId
        CouponSelectedLocation.selectedAddress = /serviceRequest.locationName
        CouponSelectedLocation.Brands = serviceRequest.serviceSelected?.brands
        CouponSelectedLocation.latitude = /serviceRequest.latitude
        CouponSelectedLocation.longitude = /serviceRequest.longitude
        
        self.pushVC(etoken)
        
    }
    
    func didPaymentModeChanged(paymentMode: PaymentType, selectedCard: CardCab?) {
        
        serviceRequest.paymentMode = paymentMode
        serviceRequest.selectedCard = selectedCard
        viewOrderPricing.updatePaymentMode(service: serviceRequest)
    }
    
    func didGetRequestDetails(request: ServiceRequest) {
        
        self.serviceRequest = request
        // serviceRequest.isBookingFromPackage = isFromPackage
        
        let mapmode : MapMode  = serviceRequest.requestType == .Present  ? .OrderPricingMode : .ScheduleMode
        screenType = ScreenType(mapMode: mapmode , entryType: .Forward)
    }
    
    func didGetRequestDetailWithScheduling(request: ServiceRequest) {
        self.serviceRequest = request
        // serviceRequest.isBookingFromPackage = isFromPackage
        
        screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
    }
    
    func didRequestTimeout() {
        orderEventFire()
    }
    
    func didSelectServiceType(_ serviceSelected: Service) {
        
        // no need to select service
        //3April
        if serviceSelected.serviceName == "Cab Booking"{
            btnRoadPickup.isHidden = false
        }else{
            btnRoadPickup.isHidden = true
        }
        serviceRequest.serviceSelected = serviceSelected
        currentService = /serviceSelected.serviceCategoryId
        getLocalDriverForParticularService(service: serviceSelected)
        locationEdit = currentService > 3 ? .PickUp : .DropOff
        
        // call terminology API
        getTerminologyData(serviceId: /serviceSelected.serviceCategoryId)
    }
    
    func didSelectBrandProduct(_ brand: Brand, _ product: ProductCab) {
        serviceRequest.selectedBrand = brand
        serviceRequest.selectedProduct = product
    }
    
    func didSelectQuantity(count: Int) {
        
        serviceRequest.quantity = count
        
    }
    
    
    func didSelectNext(type: ActionType) {
        
        if type == .SelectLocation {
            
            guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{return}
            
            self.locationEdit =    serviceID > 3  ?  .PickUp : .DropOff
            screenType = ScreenType(mapMode: .SelectingLocationMode , entryType: .Forward)
            changeLocationType(move: .Forward)
            
        }else if type == .NextGasType {
            
            screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
        }else if type == .SubmitOrder {
            
            guard let serviceID = serviceRequest.serviceSelected?.serviceCategoryId else{return}
            
            if serviceID == 1 || serviceID == 4 || serviceID == 3 || serviceID == 2 || serviceID == 7 || serviceID == 10 || serviceID == 11 {
                bookService()
            } else {
                showWorkingProgressVC()
            }
            
        }else if type == .CancelOrderOnSearch {
            
            cancelRequest(strReason: reasonString, orderID: /currentOrder?.orderId)
            
        } else if  type == .CancelHalfwayStop {
            cancelHalfWayStop()
        } else if  type == .CancelVehiclebreakdown {
            cancelVehicleBreakdown()
        } else if type == .Payment {
            
            //let notification = NotificationCenter.default
            NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.etokenNotification(notifcation:)), name: Notification.Name(rawValue: LocalNotifications.eTokenSelected.rawValue), object: nil)
            
            guard let paymentVC = R.storyboard.bookService.paymentVC() else{return}
            paymentVC.categoryId = self.serviceRequest.serviceSelected?.serviceCategoryId
            paymentVC.paymentType = serviceRequest.paymentMode
            paymentVC.delegate = self
            
            pushVC(paymentVC)
            
        }else if type == .DoneInvoice {
            showDriverRatingView()
            
        }else if type == .CancelTrackingOrder {
            showCancellationFormVC()
        } else if type == .BackFromFreightBrand {
            //back pressed on freight Brand View
            screenType = ScreenType(mapMode: .SelectingLocationMode, entryType: .Backward)
            
        } else if type == .BackFromFreightProduct {
            //back pressed on freight product View
            screenType = ScreenType(mapMode: .SelectingFreightBrand, entryType: .Backward)
        } else if type == .SelectingFreightBrand {
            screenType = ScreenType(mapMode: .SelectingFreightBrand, entryType: .Forward)
        }
    }
    
    func didRatingSubmit(ratingValue: Int, comment: String) {
        submitRating(rateValue: ratingValue, comment: comment)
    }
    
    func didSkipRating() {
        
        viewDriverRating.minimizeDriverRatingView()
        viewNewInvoice.minimizeNewInvoiceView()
        mapView.clear()
        
        cleanPath()
      
        self.getCoronaAreas()
        screenType = ScreenType(mapMode: .NormalMode , entryType: .Backward)
        
        // To move to Home in case of Package
        if /isFromPackage {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func didSelectSchedulingDate(date: Date, minDate:Date) {
        showSchedular(date: date, minDate: minDate)
    }
    
    func didSelectedFreightBrand(brand : Brand)  {
        
        serviceRequest.selectedBrand = brand
        
        if brand.categoryId == 7 ||  brand.categoryId == 4 || brand.categoryId == 10 || brand.categoryId == 13 ||  brand.categoryId == 11, let product = brand.products?.first { // to show first object selected
            
            serviceRequest.selectedProduct = product
            serviceRequest.selectedBrand = brand // Ankush
            serviceRequest.requestType = .Present
            serviceRequest.orderDateTime = Date()
            
            
            let template = AppTemplate(rawValue: /UDSingleton.shared.appTerminology?.key_value?.template?.toInt())
            
            switch template {
                
            case .Default?:
                screenType = ScreenType(mapMode: .SelectingFreightProduct , entryType: .Forward)
                
            case .Mover?:
                serviceRequest.requestType = .Present
                if serviceRequest.selectedBrand?.categoryId == 4 {
                    screenType = ScreenType(mapMode: .OrderDetail , entryType: .Forward)
                } else{
                    screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
                }
                
            default:
                break
                
            }
            
            
            
            
            /*  if brand.categoryBrandId == 18 || brand.categoryBrandId == 19 {
             didGetRequestDetails(request: serviceRequest)
             } else {
             screenType = ScreenType(mapMode: .SelectingFreightProduct , entryType: .Forward)
             } */
            
            // Ankush didGetRequestDetails(request: serviceRequest)
            //            didSelectedFreightProduct(product: product)
        }
        
        //        else if  brand.categoryId == 4 , let product = brand.products?.first {
        //          //  screenType = ScreenType(mapMode: .SelectingFreightProduct , entryType: .Forward)
        //            serviceRequest.selectedProduct = product
        //            serviceRequest.selectedBrand = brand // Ankush
        //            serviceRequest.requestType = .Present
        //            serviceRequest.orderDateTime = Date()
        //            screenType = ScreenType(mapMode: .OrderDetail , entryType: .Forward)
        //        }
        
    }
    
    func didSelectedFreightProduct(product : ProductCab, isSchedule: Bool) {
        
        serviceRequest.selectedProduct = product
        
        if isSchedule {
            
            serviceRequest.requestType = .Future
            
            screenType = ScreenType(mapMode: .ScheduleMode , entryType: .Forward)
        } else {
            
            // ANkush  screenType = ScreenType(mapMode: (product.productBrandId == 32) ? .OrderPricingMode  : .OrderDetail , entryType: .Forward) //  . OrderPricingMode for booking cab
            
            serviceRequest.requestType = .Present
            if serviceRequest.selectedBrand?.categoryId == 4{
                screenType = ScreenType(mapMode: .OrderDetail , entryType: .Forward)
            } else{
                screenType = ScreenType(mapMode: .OrderPricingMode , entryType: .Forward)
            }
        }
    }
    
    func didClickConfirmBooking(request: ServiceRequest) {
        debugPrint("Need to handle")
        
        serviceRequest = request
        
        /* serviceRequest.finalPrice = finalPrice
         serviceRequest.distance_price_fixed = String(/selectedPackageProduct?.distance_price_fixed)
         serviceRequest.price_per_min = String(/selectedPackageProduct?.price_per_min)
         serviceRequest.time_fixed_price = String(/selectedPackageProduct?.time_fixed_price)
         serviceRequest.price_per_km = String(/selectedPackageProduct?.price_per_km) */
        
        if serviceRequest.booking_type == "RoadPickup" {
            didSelectNext(type: .SubmitOrder)
        } else {
            showConfirmPickUpController()
        }
        
        
        
        // Ankush screenType = ScreenType(mapMode: .ConfirmPickup , entryType: .Forward) // For confirm pickup
    }
    
    func didClickInvoiceInfoButton() {
        showInvoiceView()
    }
    
    func didClickContinueToBookforFriend(request: ServiceRequest) {
        
        bottomViewBookforFriend.minimizeBookForFriendView()
        
        isSwitchRiderViewOpened = false
        ViewForfriend.isHidden = true
        
        ViewEnterPickUpDropOff.isHidden = false
        imageViewHeaderProfilePic.isHidden = true
        
        buttonHeaderBookingFor.setTitle("Home.For_Friend".localizedString, for: .normal)
        
        self.serviceRequest = request
    }
    
    
    
    func displayScannedService(object: RoadPickupModal?){
        print(serviceRequest.category_brand_id)
        
        guard let filteredBrand = homeAPI?.brands?.filter({$0.categoryBrandId == serviceRequest.category_brand_id}).first else {return}
        let scannedProduct = filteredBrand.products?.first
        
        serviceRequest.selectedProduct = scannedProduct
        
        // Open enter location popup
        self.locationEdit =    /object?.categoryId > 3  ?  .PickUp : .DropOff
        screenType = ScreenType(mapMode: .SelectingLocationMode , entryType: .Forward)
        changeLocationType(move: .Forward)
    }
    
    
    func didScanRoadPickUPQRCode(object: RoadPickupModal?) {
        
        debugPrint(object as Any)
        
        serviceRequest.booking_type = "RoadPickup"
        serviceRequest.category_id = object?.categoryId
        serviceRequest.category_brand_id = object?.categoryBrandId
        serviceRequest.requestType = .Present
        serviceRequest.orderDateTime = Date()
        serviceRequest.driver_id = object?.userId
        if  self.viewSelectService.serviceLocal.count > 0{
            
            if let index = self.viewSelectService.getServiceIndex(id: /object?.categoryId){
                let serviceSelected = self.viewSelectService.serviceLocal[index].objService
                serviceRequest.serviceSelected = serviceSelected
                currentService = /serviceSelected.serviceCategoryId
                getLocalDriverForParticularService(service: serviceSelected)
                locationEdit = currentService > 3 ? .PickUp : .DropOff
            }else{
                
                
                return
            }
        }
        
        
        
        
        if let filteredBrand = homeAPI?.brands?.filter({$0.categoryBrandId == serviceRequest.category_brand_id}).first{
            
            let scannedProduct = filteredBrand.products?.first
            
            serviceRequest.selectedProduct = scannedProduct
            
            // Open enter location popup
            self.locationEdit =    /object?.categoryId > 3  ?  .PickUp : .DropOff
            screenType = ScreenType(mapMode: .SelectingLocationMode , entryType: .Forward)
            changeLocationType(move: .Forward)
            
        } else {
            
            getLocalDriverForParticularService(service:  serviceRequest.serviceSelected!,isScanCode: true,object: object)
        }
        
        
    }
    
    func optionApplyCouponCodeClicked(object: Coupon?) {
        viewOrderPricing.setupDataAfterPromoApplied(object: object)
    }
    
    func didPayOutstanding(request: ServiceRequest) {
        debugPrint("Make another request using outstanding price")
        
        self.serviceRequest = request
        bookService()
    }
    
    func didChooseAddressFromRecent(place: AddressCab?, isPickup: Bool?) {
        
        if /isPickup {
            
            txtPickUpLocation.text = place?.address
            serviceRequest.locationNameDest = place?.address
            serviceRequest.latitudeDest =  /place?.addressLatitude
            serviceRequest.longitudeDest =  /place?.addressLongitude
            
        } else {
            
            txtDropOffLocation.text = place?.address
            serviceRequest.locationNickName = place?.addressName
            serviceRequest.locationName = place?.address
            serviceRequest.latitude =  /place?.addressLatitude
            serviceRequest.longitude =  /place?.addressLongitude
        }
        
        callLocationSelected()
        
    }
    
    func didAddLocationFrom(buttonTag: Int, isFromSearch: Bool?) {
        
        if /isFromSearch {
            
            
            /*  viewLocationTableContainer.alpha = 1 // Ankush
             btnCurrentLocation.isHidden = true
             imgViewPickingLocation.isHidden = true
             
             viewStoppageDesc.isHidden = !(buttonTag == 2 || buttonTag == 3) */
            
            // pickup- 1, Stop1- 2, Stop2- 3, drop- 4, 5- add Home, 6- Add Work, 7- Edit Home, 8- Edit Work
            
            switch buttonTag {
            case 1:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    self?.txtPickUpLocation.text = place?.formattedAddress
                    self?.serviceRequest.locationNameDest = place?.formattedAddress
                    self?.serviceRequest.latitudeDest =  /place?.coordinate.latitude
                    self?.serviceRequest.longitudeDest =  /place?.coordinate.longitude
                    
                    //  self?.setCameraGoogleMap(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude)
                    
                    self?.callLocationSelected()
                }
                
            case 2:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    
                    if let object = self?.serviceRequest.stops.filter({$0.priority == 1}).first {
                        self?.serviceRequest.stops.remove(object: object)
                    }
                    
                    self?.txtStop1.text = place?.formattedAddress
                    
                    let modal = Stops(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude, priority: 1, address: place?.formattedAddress)
                    self?.serviceRequest.stops.append(modal)
                    
                    
                    debugPrint(self?.serviceRequest.stops as Any)
                }
                
            case 3:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    if let object = self?.serviceRequest.stops.filter({$0.priority == 2}).first {
                        self?.serviceRequest.stops.remove(object: object)
                    }
                    
                    self?.txtStop2.text = place?.formattedAddress
                    let modal = Stops(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude, priority: 2, address: place?.formattedAddress)
                    self?.serviceRequest.stops.append(modal)
                    
                    debugPrint(self?.serviceRequest.stops as Any)
                }
                
            case 4:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    self?.txtDropOffLocation.text = place?.formattedAddress
                    self?.serviceRequest.locationNickName = place?.name
                    self?.serviceRequest.locationName = place?.formattedAddress
                    self?.serviceRequest.latitude =  /place?.coordinate.latitude
                    self?.serviceRequest.longitude =  /place?.coordinate.longitude
                    
                    //  self?.setCameraGoogleMap(latitude: /place?.coordinate.latitude, longitude: /place?.coordinate.longitude)
                    
                    self?.callLocationSelected()
                }
                
            case 5:
                
                if homeAPI?.addresses?.home?.address == nil || /homeAPI?.addresses?.home?.address?.isEmpty {
                    
                    GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                        
                        debugPrint("Home")
                        self?.apiAddAddress(address: place?.formattedAddress, name: place?.name, latitude: place?.coordinate.latitude, longitude: place?.coordinate.longitude, category: "HOME")
                    }
                    
                } else {
                    
                    viewChooseAddress.showView(address: homeAPI?.addresses?.home)
                    
                }
                
            case 6:
                
                if homeAPI?.addresses?.work?.address == nil || /homeAPI?.addresses?.work?.address?.isEmpty {
                    
                    GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                        
                        debugPrint("Work")
                        self?.apiAddAddress(address: place?.formattedAddress, name: place?.name, latitude: place?.coordinate.latitude, longitude: place?.coordinate.longitude, category: "WORK")
                    }
                } else {
                    viewChooseAddress.showView(address: homeAPI?.addresses?.work)
                }
                
            case 7:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    debugPrint("Home")
                    self?.apiEditAddress(address: place?.formattedAddress, name: place?.name, latitude: place?.coordinate.latitude, longitude: place?.coordinate.longitude, category: "HOME")
                }
                
            case 8:
                
                GooglePlaceDataSource.sharedInstance.showAutocomplete {[weak self] (place) in
                    
                    debugPrint("WORK")
                    self?.apiEditAddress(address: place?.formattedAddress, name: place?.name, latitude: place?.coordinate.latitude, longitude: place?.coordinate.longitude, category: "WORK")
                }
                
            default:
                break
            }
            
        } else {
            
            /* viewLocationTableContainer.alpha = 0 // Ankush
             btnCurrentLocation.isHidden = false
             imgViewPickingLocation.isHidden = false
             viewStoppageDesc.isHidden = true
             */
            
            // pickup- 1, Stop1- 2, Stop2- 3, drop- 4, 5- add Home, 6- Add Work, 7- Edit Home, 8- Edit Work
            
            showAddLocationFromMapController(buttonTag: buttonTag)
            
            /*  switch buttonTag {
             
             case 1:
             locationAddEdit = .PickUp
             
             case 2:
             locationAddEdit = .Stop1
             
             case 3:
             locationAddEdit = .Stop2
             
             case 4:
             locationAddEdit = .DropOff
             
             case 5, 7:
             locationAddEdit = .Home
             
             case 6,8:
             locationAddEdit = .Work
             
             default:
             break
             } */
            
            
            // viewTitlePackageBooking.isHidden = true
            // self?.txtDropOffLocation.becomeFirstResponder()
            
            // self?.segmentedMapType.isHidden = true
            // self?.constraintNavigationBasicBar.constant = BookingPopUpFrames.navigationBarHeight + BookingPopUpFrames.navigationTopPadding
            
            // btnOnlyBack.alpha = 0
            //  mapView.isUserInteractionEnabled = true
            
            /*  guard let selectedService  = self?.serviceRequest.serviceSelected else{return}
             
             if  /selectedService.serviceCategoryId > 3 {
             self?.locationType = .PickUpDropOff
             self?.imgViewPickingLocation.image = #imageLiteral(resourceName: "PickUpMarker")
             
             // Ankush self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(115) )
             
             // 96 - Pick up and dropoff View size
             let locationViewHeight = (!(/self?.viewStop1.isHidden) && !(/self?.viewStop2.isHidden)) ? (96 + 96) : (!(/self?.viewStop1.isHidden) || !(/self?.viewStop2.isHidden)) ? (96 + 48) : 96
             self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(locationViewHeight ))
             self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingXPickUpLocation
             self?.viewStoppageDesc.isHidden = ((/self?.viewStop1.isHidden) && (/self?.viewStop2.isHidden))
             } else{
             
             self?.constraintYAddLocationView.constant = -(BookingPopUpFrames.navigationBarHeight + CGFloat(55)) // 55 - Height for navigation View (Book a taxi)
             self?.locationType = .OnlyDropOff
             self?.imgViewPickingLocation.image = #imageLiteral(resourceName: "DropMarker")
             self?.constraintTopSegmentedView.constant = BookingPopUpFrames.paddingXDropOffLocation
             } */
            
        }
    }
    
    
    func didSelectAddTip(order : OrderCab) {
        
        guard let vc = R.storyboard.bookService.tipScreen() else{return}
        vc.amountAdded = { amount in
            
            guard amount > 0 else { return }
            
            var order = self.viewInvoice.orderDone
            order?.payment!.tipCharge = String(describing: amount)
            
            self.viewInvoice.orderDone = order
            
        }
        
        vc.orderId = order.orderId
        vc.modalPresentationStyle = .overCurrentContext
        self.presentVC(vc)
    }
    
    
}

//MARK:- TextField Delegates
//MARK:-

extension HomeVC :UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtDropOffLocation {
            
            locationEdit = .DropOff
            
            if let latitude =   serviceRequest.latitude , let longitude = serviceRequest.longitude  , let previousSelected = serviceRequest.locationName {
                
                txtDropOffLocation.text = previousSelected
                // textField.text = previousSelected
                self.setCameraGoogleMap(latitude: latitude, longitude: longitude)
            }
            
        } else if textField == txtPickUpLocation {
            
            locationEdit = .PickUp
            if let latitude =   serviceRequest.latitudeDest , let longitude = serviceRequest.longitudeDest  , let previousSelected = serviceRequest.locationNameDest {
                
                txtPickUpLocation.text = previousSelected
                // textField.text = previousSelected
                self.setCameraGoogleMap(latitude: latitude, longitude: longitude)
                
            }
        }
    }
}

//MARK:- Confirm

extension HomeVC: ConfirmPickUpViewControllerDelegate {
    
    func confirmedPickupandSubmitedOrder(request: ServiceRequest?) {
        
        serviceRequest = request ?? ServiceRequest()
        
        // to clear path
        self.cleanPath()
        polyPath = GMSMutablePath()
        polyline?.map = nil
        
        self.animationPath = GMSMutablePath()
        self.animationPolyline.map = nil
        
        dropPickUpAndDropOffPins(pickLat: /serviceRequest.latitudeDest, pickLong: /serviceRequest.longitudeDest, dropLat: /serviceRequest.latitude, dropLong: /serviceRequest.longitude, isConfirmedPickUp: true)
        
        didSelectNext(type: .SubmitOrder)
    }
}

//MARK:- AddLocationFromMapViewControllerDelegate
extension HomeVC: AddLocationFromMapViewControllerDelegate {
    
    func locationSelectedFromMap(address: String?, name: String?, latitude: Double?, longitude: Double?, locationType: Int) {
        
        // pickup- 1, Stop1- 2, Stop2- 3, drop- 4, 5- add Home, 6- Add Work, 7- Edit Home, 8- Edit Work
        
        switch locationType {
            
        case 1:
            txtPickUpLocation.text = /address
            serviceRequest.locationNameDest = /address
            serviceRequest.latitudeDest =  /latitude
            serviceRequest.longitudeDest =  /longitude
            
            callLocationSelected()
            
        case 2:
            
            
            
            if let object = serviceRequest.stops.filter({$0.priority == 1}).first {
                serviceRequest.stops.remove(object: object)
            }
            
            txtStop1.text = /address
            
            let modal = Stops(latitude: /latitude, longitude: /longitude, priority: 1, address: /address)
            serviceRequest.stops.append(modal)
            
            
            debugPrint(serviceRequest.stops as Any)
            
        case 3:
            
            
            if let object = serviceRequest.stops.filter({$0.priority == 2}).first {
                serviceRequest.stops.remove(object: object)
            }
            
            txtStop2.text = /address
            let modal = Stops(latitude: /latitude, longitude: /longitude, priority: 2, address: /address)
            serviceRequest.stops.append(modal)
            
            debugPrint(serviceRequest.stops as Any)
            
            
        case 4:
            
            txtDropOffLocation.text = /address
            serviceRequest.locationNickName = /name
            serviceRequest.locationName = address
            serviceRequest.latitude =  /latitude
            serviceRequest.longitude =  /longitude
            
            callLocationSelected()
            
        case 5:
            apiAddAddress(address: address, name: name,  latitude: latitude, longitude: longitude, category: "HOME")
            
        case 6:
            apiAddAddress(address: address, name: name, latitude: latitude, longitude: longitude, category: "WORK")
            
        case 7:
            apiEditAddress(address: address, name: name, latitude: latitude, longitude: longitude, category: "HOME")
            
        case 8:
            apiEditAddress(address: address, name: name, latitude: latitude, longitude: longitude, category: "WORK")
            
        default:
            break
            
            
        }
        
    }
}


//MARK:- RazorPay
extension HomeVC {
    
    internal func showPaymentForm(order: OrderCab?) {
      
        let options: [String:Any] = [
            "amount": /order?.finalCharge, //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": /UDSingleton.shared.appSettings?.appSettings?.currency,//We support more that 92 international currencies.
            "description": "Your Ride Payment charges",
            "image": "https://url-to-image.png",
            "name": "Royo",
            "prefill": [
                "contact": /UDSingleton.shared.userData?.userDetails?.user?.phoneNumber,
                "email": /UDSingleton.shared.userData?.userDetails?.user?.email
            ],
            "theme": [
                "color": /UDSingleton.shared.appSettings?.appSettings?.app_color_code
            ]
        ]
       
        ez.runThisInMainThread {
            self.razorpay?.open(options)
        }
        
    }
}

extension HomeVC: RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      //  self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      // self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        razorPaymentAPI(order_id: String(/currentOrder?.orderId), payment_id: payment_id)
    }
    
    
    func razorPaymentAPI(order_id: String, payment_id: String) {
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let walletBalance = BookServiceEndPoint.razorPayReturnUrl(order_id: order_id, payment_id: payment_id)
        walletBalance.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            
            switch response {
            case .success(let data):
                break
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}


extension HomeVC{
    
    //MARK: - Paypal Payment
       func payViaPayPal() {
        
           BrainTreeManagerCab.sharedInstance.payViaPayPal( success: { [unowned self] (nonce) in
               debugPrint(nonce)
               print(nonce.description)
            //   self.returnPaymentDetail?(nonce,"Paypal","")
            
              self.makePaypalCheckout(nonce: nonce)
           },cancelled: {
               self.showNewInvoiceView()
           }) { [weak self] (error) in
               print(error?.localizedDescription)
              // SKToast.makeToast(error?.localizedDescription)
              // self?.handleError(error)
            
            self?.showNewInvoiceView()
           }
       }
    
    
    func makePaypalCheckout(nonce:String){
        
        let amount = Double(/currentOrder?.payment?.finalCharge)?.rounded(toPlaces: 2) ?? 0.0
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let brainTreeToken = BookServiceEndPoint.braintreeCheckout(amount: "\(amount)", nonce: nonce, orderId: /currentOrder?.orderId)
        
        
        brainTreeToken.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            
            switch response {
                
            case .success(let data):
               
                self.showNewInvoiceView()
                
                
                
                
            case .failure(let strError):
                self.showNewInvoiceView()
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}
