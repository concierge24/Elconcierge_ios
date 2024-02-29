//
//  MenuViewController.swift
//  Clikat
//
//  Created by Night Reaper on 15/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class DrawerMenuViewController: BaseViewController {

    //MARK:- IBOutlet
    @IBOutlet var imageViewProfilePic: UIImageView!{
        didSet{
            imageViewProfilePic.layer.borderWidth = 2.0
            imageViewProfilePic.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet weak var labelWelcome : UILabel!
    
    //MARK:- Variables
    let menuModal : MenuModal = MenuModal()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -45, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: CellIdentifiers.SideMenuCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.SideMenuCell)
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
        
        self.view.backgroundColor = ViewThemeColor.shared.viewLeftDrawerColor
        
        updateUI()
    }
    
    func updateUI(){
        labelWelcome?.text = L10n.Welcome.string
        btnLocation.setTitle(UtilityFunctions.appendOptionalStrings(withArray: [LocationSingleton.sharedInstance.location?.getArea()?.name ,LocationSingleton.sharedInstance.location?.getCity()?.name],separatorString: " , "), for: .normal)
        
        labelUserName?.text = GDataSingleton.sharedInstance.loggedInUser?.firstName ?? L10n.Guest.string
        //        guard let image = GDataSingleton.sharedInstance.loggedInUser?.userImage , let url = URL(string : image) else{
        //            imageViewProfilePic.image = UIImage(asset: Asset.User_placeholder)
        //            return
        //        }
        
        imageViewProfilePic.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil, placeHolder: UIImage(asset: Asset.User_placeholder))
        tableView.reloadData()
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
}

//MARK: - Button Actions
extension DrawerMenuViewController {
    
    @IBAction func actionProfile(sender: UIButton) {
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
        settingsVC.delegate = self
        sideMenuController()?.setContentViewController(settingsVC)
    }
    
    @IBAction func actionBtnLocation(sender: UIButton) {
        if SKAppType.type.isJNJ {
            return
        }
        
        let splashVC = ChooseLocationVC.getVC(.register)
        guard let window = UtilityFunctions.sharedAppDelegateInstance().window else { return }
        toggleSideMenuView()
        var delegateVC : HomeViewController? = HomeViewController()
        if let navVC = window.rootViewController as? LeftNavigationViewController {
            delegateVC = navVC.topViewController as? HomeViewController
        }else if let navVC = window.rootViewController as? RightNavigationViewController {
            delegateVC = navVC.topViewController as? HomeViewController
        }
        splashVC.delegate = delegateVC
        window.rootViewController?.presentVC(splashVC)
    }
    
    @IBAction func actionFb(sender: AnyObject) {
        if SKAppType.type.isJNJ {
            openWebURL(withUrlString: ApplicationWebLinks.jnjFacebookLink)
        } else {
            openWebURL(withUrlString: ApplicationWebLinks.FacebookLink)
        }
        
    }
    
    
    @IBAction func actionTwitter(sender: AnyObject) {
        if SKAppType.type.isJNJ {
            openWebURL(withUrlString: ApplicationWebLinks.jnjTwitterLink)
        } else {
            openWebURL(withUrlString: ApplicationWebLinks.TwitterLink)
        }
    }
    
    
    @IBAction func actionInsta(sender: AnyObject) {
        if SKAppType.type.isJNJ {
            openWebURL(withUrlString: ApplicationWebLinks.jnjInstagramLink)
        } else {
            openWebURL(withUrlString: ApplicationWebLinks.InstagramLink)
        }
    }
    
    @IBAction func actionYoutube(sender: UIButton) {
        if SKAppType.type.isJNJ {
            openWebURL(withUrlString: ApplicationWebLinks.jnjYoutubeLink)
        } else {
            openWebURL(withUrlString: ApplicationWebLinks.YoutubeLink)
        }
    }
    
    func openWebURL(withUrlString urlString : String?){
        guard let string = urlString , let url = URL(string: string) else{
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

extension DrawerMenuViewController : UITableViewDataSource , UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuModal.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModal.sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SideMenuCell) as! SideMenuCell
        cell.selectionStyle = .none
        cell.menuItem = menuModal.sectionData[indexPath.section][indexPath.row]
        if cell.menuItem?.getTitle() == L10n.ScheduledOrders.string{
            let badgeView = M13BadgeView(frame: CGRect(x: 0, y: MidPadding, w: 20, h: 20))
            badgeView.animateChanges = false
            badgeView.badgeBackgroundColor = UIColor.white.withAlphaComponent(0.25)
            badgeView.hidesWhenZero = true
            badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentCenter
            badgeView.font = UIFont(name: Fonts.ProximaNova.Light, size: Size.Small.rawValue)
            badgeView.shadowBadge = true
            badgeView.text = LocationSingleton.sharedInstance.scheduledOrders ?? "0"
            if let _ = GDataSingleton.sharedInstance.loggedInUser, LocationSingleton.sharedInstance.scheduledOrders != "0" {
                cell.accessoryView = badgeView
            }else {
                cell.accessoryView = nil
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == menuModal.numberOfSections - 1{
            let view = UIView(x: 0, y: 0, w: tableView.bounds.width, h: 32)
            view.backgroundColor = UIColor.clear
            let label = UILabel(x: 20, y: 0 , w: tableView.bounds.width - 40, h: 32)
            
            /*----ThemeColor--*/
            label.textColor = TableThemeColor.shared.lblSectionHeaderClr
            
            label.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: 12)
            label.text = L10n.MyAccount.string
            label.textAlignment = Localize.currentLanguage() == Languages.Arabic ? .right : .left
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: Fonts.ProximaNova.SemiBold , size: Size.Small.rawValue)
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            visualEffectView.frame = view.bounds
            view.addSubview(visualEffectView)
            view.addSubview(label)
            return view
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == menuModal.numberOfSections - 1{
            return 32
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var topVC : UIViewController?
        if topMostController() is LeftNavigationViewController {
            topVC = (topMostController() as? LeftNavigationViewController)?.topViewController
        }else if topMostController() is RightNavigationViewController {
            topVC = (topMostController() as? RightNavigationViewController)?.topViewController
        }
        
        let menu = menuModal.sectionData[indexPath.section][indexPath.row]
        guard let title = menu.getTitle() else{return}
        switch title {
        case L10n.Home.string :
            
//            if topVC is HomeViewController { toggleSideMenuView() ; return }
            
            //              let homeVC =  /GDataSingleton.sharedInstance.app_type == 1 ? StoryboardScene.Main.instantiateHomeViewController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
            
            
            
            //  sideMenuController()?.setContentViewController(contentViewController: homeVC)
            sideMenuController()?.setContentViewController(StoryboardScene.Main.instantiateEcommerceHomeViewController())
            return
        case L10n.ShareApp.string :
            
        UtilityFunctions.shareContentOnSocialMedia(withViewController: UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController, message: L10n.TheLeadingOnlineHomeServicesInUAE.string)
            return
        case L10n.ShareApp.string :
            if topVC is LiveSupportViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiateLiveSupportViewController())
        case L10n.TermsAndConditions.string,L10n.AboutUs.string:
           // let VC = StoryboardScene.Options.instantiateTermsAndConditionsController()
            //VC.type = title == L10n.AboutUs.string ? .AboutUs : .TermsAndConditions
            //sideMenuController()?.setContentViewController(VC)
            break
        default: break
        }
        
        if GDataSingleton.sharedInstance.loggedInUser == nil && title != L10n.Cart.string {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            
            ez.runThisInMainThread({
                weak var weakSelf : DrawerMenuViewController? = self
                weakSelf?.view.window?.rootViewController?.presentVC(loginVc)
            })
            return
        }
        
        
        // User Based Functionality
        switch title {
        case L10n.Cart.string:
            if topVC is CartViewController { toggleSideMenuView() ; return }
            let cartVC = StoryboardScene.Options.instantiateCartViewController()
            cartVC.FROMSIDEPANEL = true
            sideMenuController()?.setContentViewController(cartVC)
            
        case L11n.wishList.string:
            if topVC is WishListViewController { toggleSideMenuView() ; return }
            let cartVC = WishListViewController.getVC(.main)
            sideMenuController()?.setContentViewController(cartVC)
            
        case L10n.LiveSupport.string:
            toggleSideMenuView()
            AdjustEvent.LiveSupport.sendEvent()
//            ZDCChat.instance().api.trackEvent("")
//            ZDCChat.updateVisitor({ (visitor) in
//                visitor?.phone = GDataSingleton.sharedInstance.loggedInUser?.mobileNo ?? ""
//                visitor?.name = GDataSingleton.sharedInstance.loggedInUser?.firstName ?? ""
//                visitor?.email = GDataSingleton.sharedInstance.loggedInUser?.email ?? ""
//            })
//            ZDCChat.start({ (config) in
//                config?.preChatDataRequirements.name = ZDCPreChatDataRequirement.required
//                config?.preChatDataRequirements.email = ZDCPreChatDataRequirement.required
//                config?.preChatDataRequirements.phone = ZDCPreChatDataRequirement.required
//                config?.preChatDataRequirements.department = ZDCPreChatDataRequirement.required
//                config?.preChatDataRequirements.message = ZDCPreChatDataRequirement.required
//            })
            //            SKToast.makeToast("Coming Soon!")
            
        case L10n.Promotions.string:
            if topVC is PromotionsViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiatePromotionsViewController())
            
        case L10n.Notifications.string:
            if topVC is NotificationsViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiateNotificationsViewController())
            
        case L10n.MyFavorites.string :
            if topVC is MyFavoritesViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController(StoryboardScene.Options.instantiateMyFavoritesViewController())
            
        case L10n.OrderHistory.string :
            if topVC is OrderHistoryViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Order.instantiateOrderHistoryViewController())
            
        case L10n.TrackMyOrder.string :
            if topVC is TrackMyOrderViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Order.instantiateTrackMyOrderViewController())
            
        case L10n.RateMyOrder.string :
            if topVC is RateMyOrderController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Order.instantiateRateMyOrderController())
            
        case L11n.currentOrders.string :
            if topVC is UpcomingOrdersViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Order.instantiateUpcomingOrdersViewController())
            
        case L10n.ScheduledOrders.string :
            if topVC is ScheduledOrderController { toggleSideMenuView() ; return }
            
            guard let VC = UIStoryboard(name: "Order", bundle: Bundle.main).instantiateViewController(withIdentifier: "ScheduledOrderController") as? ScheduledOrderController else { return }
            sideMenuController()?.setContentViewController(VC)
            
        case L10n.LoyalityPoints.string :
            if topVC is LoyalityPointsViewController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiateLoyalityPointsViewController())
            
        case L10n.Settings.string :
            if topVC is SettingsViewController { toggleSideMenuView() ; return }
            let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
            settingsVC.delegate = self
            sideMenuController()?.setContentViewController(settingsVC)
        case L10n.CompareProducts.string :
            if topVC is CompareProductsController { toggleSideMenuView() ; return }
            sideMenuController()?.setContentViewController( StoryboardScene.Options.instantiateCompareProductsController())
        default:
            break
        }
        
    }
}

//MARK: - User Logged Out
extension DrawerMenuViewController : LogoutDelegate {
    
    func userLoggedOut() {
        updateUI()
        
        //          let homeVC =  /GDataSingleton.sharedInstance.app_type == 1 ? StoryboardScene.Main.instantiateHomeViewController() : StoryboardScene.Main.instantiateEcommerceHomeViewController()
        //
        //        sideMenuController()?.setContentViewController(contentViewController: homeVC)
        //
        sideMenuController()?.setContentViewController( StoryboardScene.Main.instantiateEcommerceHomeViewController())
        toggleSideMenuView()
    }
    
}
