//
//  OnboardingViewController.swift
//  InTheNight
//
//  Created by Dhan Guru Nanak on 4/22/18.
//  Copyright © 2018 InTheNight. All rights reserved.
//

import UIKit

struct OnboardingModel {
    
    //Constants
    static let discover = "DISCOVER"
    static let discoverInfo = "Explore World’s top brands\nand boutique."

    static let payment = "MAKE THE PAYMENT"
    static let paymentInfo = "Choose the preferable option\nfor payment."

    static let shopping = "ENJOY YOUR SHOPPING"
    static let shoppingInfo = "Get high quality products\nfor the best prices."

    static let search = "Search"
    static let searchInfo = "Explore World’s top restaurants and food."
    static let searchInfoHome = "Explore World’s top Services."

    static let onlineOrder = "Online Order"
    static let onlineOrderInfo = "Choose the preferable option for payment."
    
    static let delivery = "Delivery"
    static let deliveryInfo = "Choose the preferable option for payment."

    static let select = "Select"
    static let selectInfo = "Choose the preferable option for service."

    static let enjoy = "Enjoy"
    static let enjoyInfo = "Get high quality service for the best price."

    
    var title: String
    var subtitle: String
    var image: UIImage
}

class OnboardingViewController: UIViewController {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var btnLetsStart: UIButton!{
        didSet{
            btnLetsStart.isHidden = false
        }
    }
    @IBOutlet weak var stackvwBtns: UIStackView!
    @IBOutlet weak var btnSkipUpper: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnPageControl: UIPageControl! {
        didSet {
            currentIndex = 0
            btnPageControl.numberOfPages = items.count
            btnPageControl.currentPageIndicatorTintColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            configureCollectionView()
        }
    }
    
    @IBOutlet weak var viewBookNow: UIView!{
        didSet{
            if APIConstants.defaultAgentCode == "zippklip_0123"{
                viewBookNow.isHidden = false
            }
        }
    }

    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var btnAlreadyMember: UIButton!{
        didSet{
            btnAlreadyMember.setTitleColor(SKAppType.type.color, for: .normal)
        }
    }
    //MARK:- ======== Properties ========
    var collectionViewDataSource: SKCollectionViewDataSource?
    
    lazy var items: [OnboardingModel] = {
        if SKAppType.type == .food || SKAppType.type.isJNJ {
            if APIConstants.defaultAgentCode == "poneeex_0049" {
                return [
                    OnboardingModel.init(title: OnboardingModel.search, subtitle: OnboardingModel.searchInfo, image: #imageLiteral(resourceName: "walk_1"))
                    , OnboardingModel.init(title: OnboardingModel.payment, subtitle: OnboardingModel.paymentInfo, image: #imageLiteral(resourceName: "walk_2"))
                    , OnboardingModel.init(title: OnboardingModel.enjoy, subtitle: OnboardingModel.enjoyInfo, image: #imageLiteral(resourceName: "walk_3"))
                ]
            }
            return [
                OnboardingModel.init(title: OnboardingModel.search, subtitle: OnboardingModel.searchInfo, image: #imageLiteral(resourceName: "search_food"))
                , OnboardingModel.init(title: OnboardingModel.payment, subtitle: OnboardingModel.paymentInfo, image: #imageLiteral(resourceName: "online_order_food"))
                , OnboardingModel.init(title: OnboardingModel.enjoy, subtitle: OnboardingModel.enjoyInfo, image: #imageLiteral(resourceName: "delivery_food"))
            ]
        } else if SKAppType.type == .home {
            if APIConstants.defaultAgentCode == "zippklip_0123"{
                return [
                    OnboardingModel.init(title: "We Are Where You Need Us To Be", subtitle: "", image: #imageLiteral(resourceName: "AppLogo"))//(title: OnboardingModel.search, subtitle: OnboardingModel.searchInfoHome, image: #imageLiteral(resourceName: "search_service_homeservices"))
                    , OnboardingModel.init(title: OnboardingModel.select, subtitle: OnboardingModel.selectInfo, image: #imageLiteral(resourceName: "select_agent_homeservices"))
                    , OnboardingModel.init(title: OnboardingModel.enjoy, subtitle: OnboardingModel.enjoyInfo, image: #imageLiteral(resourceName: "enjoy_service_homeservices"))
                ]
            }else{
            return [
                OnboardingModel.init(title: OnboardingModel.search, subtitle: OnboardingModel.searchInfoHome, image: #imageLiteral(resourceName: "search_service_homeservices"))
                , OnboardingModel.init(title: OnboardingModel.select, subtitle: OnboardingModel.selectInfo, image: #imageLiteral(resourceName: "select_agent_homeservices"))
                , OnboardingModel.init(title: OnboardingModel.enjoy, subtitle: OnboardingModel.enjoyInfo, image: #imageLiteral(resourceName: "enjoy_service_homeservices"))
            ]
            }
        }
        //Nitin
//        else if SKAppType.type == .gym {
//            return [
//                OnboardingModel.init(title: OnboardingModel.search, subtitle: OnboardingModel.searchInfoHome, image: #imageLiteral(resourceName: "search_service_mp"))
//                , OnboardingModel.init(title: OnboardingModel.select, subtitle: OnboardingModel.selectInfo, image: #imageLiteral(resourceName: "select_agent_mp"))
//                , OnboardingModel.init(title: OnboardingModel.enjoy, subtitle: OnboardingModel.enjoyInfo, image: #imageLiteral(resourceName: "enjoy_service_mp"))
//            ]
//        } else if SKAppType.type == .party {
//            return [
//                OnboardingModel.init(title: OnboardingModel.discover, subtitle: OnboardingModel.discoverInfo, image: #imageLiteral(resourceName: "discover_party"))
//                , OnboardingModel.init(title: OnboardingModel.shopping, subtitle: OnboardingModel.shoppingInfo, image: #imageLiteral(resourceName: "enjoy_shopping_party"))
//                , OnboardingModel.init(title: OnboardingModel.payment, subtitle: OnboardingModel.paymentInfo, image: #imageLiteral(resourceName: "make the payment_party"))
//            ]
//        }
        return [
            OnboardingModel.init(title: OnboardingModel.discover, subtitle: OnboardingModel.discoverInfo, image: #imageLiteral(resourceName: "discover_ecommerce"))
            , OnboardingModel.init(title: OnboardingModel.payment, subtitle: OnboardingModel.paymentInfo, image: #imageLiteral(resourceName: "make the payment_ecommerce"))
            , OnboardingModel.init(title: OnboardingModel.shopping, subtitle: OnboardingModel.shoppingInfo, image: #imageLiteral(resourceName: "enjoy_shopping_ecommerce"))
        ]
    }()

    var currentIndex = 0 {
        didSet {
           self.btnPageControl.currentPage = currentIndex
//            let isLast = currentIndex > 0//currentIndex == items.count - 1
//            btnLetsStart.isHidden = !isLast
//            btnSkip.isHidden = isLast
        }
    }
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad(){
        super.viewDidLoad()
        onLoad()
        
        if APIConstants.defaultAgentCode == "poneeex_0049" {
            btnSkipUpper.isHidden = false
            stackvwBtns.isHidden = true
        }
        
       // loadLocation(loader: false)
    }
    
    //MARK:- ======== Functions ========
    func onLoad() {
        if GDataSingleton.isOnBoardingDone {
            (UIApplication.shared.delegate as? AppDelegate)?.onload()
        }
    }
    
    @IBAction func btnBookNow(_ sender:UIButton) {
                let vc = SelectLocationVC.getVC(.moreScreen)
                self.pushVC(vc)
        }
    
    @IBAction func btnAlreadyMember(_ sender:UIButton) {
        GDataSingleton.isOnBoardingDone = true
        self.switchViewControllers(language: Localize.currentLanguage())
        }
    
    @IBAction func didTapSkip(_ sender:UIButton) {

        GDataSingleton.isOnBoardingDone = true
        (UIApplication.shared.delegate as? AppDelegate)?.onload()
//        if LocationSingleton.sharedInstance.location == nil {
//            loadLocation(loader: true) {
//                GDataSingleton.isOnBoardingDone = true
//                (UIApplication.shared.delegate as? AppDelegate)?.onload()
//            }
//        } else {
//            GDataSingleton.isOnBoardingDone = true
//            (UIApplication.shared.delegate as? AppDelegate)?.onload()
//        }
    }
    
    func loadLocation(loader: Bool, blockDone: (() -> ())? = nil) {
        (UIApplication.shared.delegate as? AppDelegate)?.onload()
//        if LocationSingleton.sharedInstance.location != nil {
//            return
//        }
//        blockDone?()

//        LocationViewController.getFirstCity(loader: loader, location: ApplicationLocation(), types: [SelectedLocation.Country, .City, .Area], lastId: nil) {
//            (location) in
//            LocationSingleton.sharedInstance.location = location
//            blockDone?()
//        }
        
    }
    
    func switchViewControllers(language: String = Localize.currentLanguage()){
        
        if !GDataSingleton.sharedInstance.isLoggedIn {
            let vc = StoryboardScene.Register.instantiateLoginViewController()
            (vc as? LoginViewController)?.delegate = self
            (vc as? SignupSelectionVC)?.delegate = self
            UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController = vc
            return
        }
        if language == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UITextField.appearance()
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        L102Language.setAppleLAnguageTo(lang: language)
        //Localize.currentLanguage() = language
        Localize.setCurrentLanguage(language: language)
        let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
        UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController = navigationVc


    }
    
}

//MARK:- ======== Handle Table View  ========
extension OnboardingViewController {
    
    func configureCollectionView() {
        
        collectionViewDataSource = SKCollectionViewDataSource(
            collectionView: collectionView,
            cellIdentifier: OnboardingCollectionViewCell.identifier,
            headerIdentifier: nil,
            cellHeight: UIScreen.main.bounds.height + 10,
            cellWidth: UIScreen.main.bounds.width)
        
        collectionViewDataSource?.configureCellBlock = {
            (index, cell, item) in
            
            guard let cell = cell as? OnboardingCollectionViewCell else { return }
            
            if let model = item as? OnboardingModel
            {
                if APIConstants.defaultAgentCode == "zippklip_0123"{
                    if index.row == 0{
                    cell.imgFull.isHidden = false
                        cell.imgFull.image = #imageLiteral(resourceName: "image5")
                        cell.imgFull.alpha = 0.5
                    }
                }
                cell.onboardingData = model
            }
        }
        
        collectionViewDataSource?.scrollViewListener = {
            [weak self] (scrollView) in // for swipe
            
            guard let self = self else { return }
            self.currentIndex = Int(scrollView.contentOffset.x/scrollView.frame.width)
        }
        
        collectionViewDataSource?.reload(items: items)
    }
}

//MARK:- LoginViewControllerDelegate
extension OnboardingViewController: LoginViewControllerDelegate {
    
    func userSuccessfullyLoggedIn(withUser user : User?) {
        DispatchQueue.main.async {
            self.switchViewControllers()
        }
    }
    
    func userFailedLoggedIn() {
        
    }
}

