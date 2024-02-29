//
//  MenuViewController.swift
//  SideMenuExample
//


//  Created by kukushi on 11/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit
import HCSStarRatingView


class MenuViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var imgViewUser: UIImageView!
    @IBOutlet var lblRatingCount: UILabel!
    @IBOutlet var viewUserInfo: UIView!
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var labelCustomerId: UILabel!
    @IBOutlet weak var leadingImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstriant: NSLayoutConstraint!
    
    @IBOutlet weak var viewStarRating: HCSStarRatingView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var selectionTableViewHeader: UILabel!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var icSheet: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var versionLable: UILabel!
    @IBOutlet weak var leadingConstaint: NSLayoutConstraint!
    
    
    //MARK:- Properties
    //let arrOptions : [SideMenuOptions] =   [ .Bookings ,.ETokens, .Promotions , .Payments , .Referral , .EmergencyContacts , .Settings , .Contactus , .SignOut]
    
    // let arrOptions : [SideMenuOptions] =   [ .Bookings , .Payments , .Settings , .Contactus , .SignOut]
    
   // let arrOptions : [SideMenuOptions] =   [ .BookTaxi , .PackageDelivery  , .Home , .MyBookings, .Notifications ,.Payments, .Packages, .EmergencyContact, .Settings, .Help]
//    let arrOptions : [SideMenuOptions] =   [ .Home , .MyBookings, .Notifications ,.Payments, .Packages, .EmergencyContact, .Settings, .Help]
    

    //var arrOptions : [SideMenuOptions] =   [ .Home , .MyBookings, .Notifications , .Packages, .wallet, .EmergencyContact, .Settings, .Help]
    
    var arrOptions : [SideMenuOptions] =   [ .Home , .MyBookings, .Notifications , .wallet ,.Packages, .EmergencyContact, .Settings, .Help, .referral]
    
    let arrayTemplate1: [SideMenuOptions] = [
    .Home,
    .PaymentHistory,
    .SavedCard,
    .DeliveryHistory,
    .Promotions,
    .Contactus,
    .Settings,
    .SignOut
    ]
    
    
    let arrayGoMoveArray: [SideMenuOptions] = [
    .Home,
    .getDiscount,
    .MyBookings,
    .Payments,
    .EmergencyContact,
    .Notifications,
    .Settings,
    .Help,
    .deliverWithUs
    ]
    
    let arrayMobyArray: [SideMenuOptions] = [
    .BookAService,
    .MyBookings,
    .Notifications,
    .Payments,
    .EmergencyContact,
    .Settings,
    .Help,
    ]
    
    
    let arrayCorsa: [SideMenuOptions] = [
       .Home,
       .MyBookings,
       .Payments,
       .wallet,
       .EmergencyContact,
       .Notifications,
       .Settings,
       .Help
       ]

    var tableDataSource : TableViewDataSourceCab?

    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            arrOptions = arrayTemplate1
            
            //Wallet
            let isWallet = /UDSingleton.shared.appSettings?.appSettings?.is_wallet
            if !(Bool(isWallet) ?? false) {
                arrOptions.remove(at: 3)
            }
            
            //Refer & Earn
            let isRefer = /UDSingleton.shared.appSettings?.appSettings?.is_refer_and_earn
            if !(Bool(isRefer) ?? false) {
                
            }
            
            leadingImageConstraint.constant = -60
            leadingConstaint.constant = -20
            viewUserInfo.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblUserName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblRatingCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            //lblPhoneNumber.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            labelCustomerId.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            icSheet.isHidden = true 
            bgView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            signoutBtn.isHidden = true
            versionLable.isHidden = true
            bottomConstriant.constant = -56
            break
            
        case .GoMove:
             labelCustomerId.isHidden = true
             arrOptions = arrayGoMoveArray
             
            //Wallet
             let isWallet = /UDSingleton.shared.appSettings?.appSettings?.is_wallet
             if !(Bool(isWallet) ?? false) {
                 arrOptions.remove(at: 3)
             }
             
             bottomConstriant.constant = 0
             viewUserInfo.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
            break
        
       case .Moby?:
            arrOptions = arrayMobyArray
            
            //Wallet
            let isWallet = /UDSingleton.shared.appSettings?.appSettings?.is_wallet
            if !(Bool(isWallet) ?? false) {
                arrOptions.remove(at: 3)
            }
            
            viewUserInfo.setViewBackgroundColorSecondary()
            break
            
        case .Corsa:
             
            arrOptions = arrayCorsa
                         
             //Wallet
             let isWallet = /UDSingleton.shared.appSettings?.appSettings?.is_wallet
             if !(Bool(isWallet) ?? false) {
                 arrOptions.remove(at: 3)
             }
             
             let isRefer = /UDSingleton.shared.appSettings?.appSettings?.is_refer_and_earn
             if !(Bool(isRefer) ?? false) {
                 
             }
            
             bottomConstriant.constant = 0
             viewUserInfo.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
            break
            
        default:
                
            //Wallet
            let isWallet = /UDSingleton.shared.appSettings?.appSettings?.is_wallet
            if !(Bool(isWallet) ?? false) {
                arrOptions.remove(at: 3)
            }
            
            let isRefer = /UDSingleton.shared.appSettings?.appSettings?.is_refer_and_earn
            if !(Bool(isRefer) ?? false) {
                
                if let index = arrOptions.firstIndex(of: .referral){
                arrOptions.remove(at: index)
                }
            }
            
            viewUserInfo.setViewBackgroundColorTheme()
                
            
            
        }
        
        configureView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         setUpUI()
        assignUserInfo()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpUI()
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnEditProfile(_ sender: UIButton) {
        guard let editVC = R.storyboard.sideMenu.editProfileVC() else{return}
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
   //MARK:- Functions
    
    private func configureView() {
//        self.perform(#selector(createGradient), with: nil, afterDelay: 0.0)
    
        
        configureTableView()
    }
    
//    @objc func createGradient() {
//
//        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
//
//        switch template {
//        case .Moby?:
//            viewUserInfo.setViewBackgroundColorSecondary()
//
//        default:
//            viewUserInfo.setViewBackgroundColorTheme()
//
//        }
//    }
    
    func setUpUI() {
        imgViewUser.cornerRadius(radius: imgViewUser.frame.size.width/2)
    }
    
    func assignUserInfo() {
        
        guard let userName = UDSingleton.shared.userData?.userDetails?.user?.name else{return}
        lblUserName.text = userName
        labelCustomerId.text = "\(/UDSingleton.shared.userData?.userDetails?.user?.userId) (Customer id)"
        if let urlImage = UDSingleton.shared.userData?.userDetails?.profilePic {
            imgViewUser.sd_setImage(with: URL(string : urlImage), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
        }
       // let strCountryCode = String(/UDSingleton.shared.userData?.userDetails?.user?.countryCode)
       // let strPhNo = String(/UDSingleton.shared.userData?.userDetails?.user?.phoneNumber)
       // lblPhoneNumber.text = strCountryCode + "-" + strPhNo
        guard let myRating = UDSingleton.shared.userData?.userDetails?.myRatingCount else{return}
        guard let myAverageRating = UDSingleton.shared.userData?.userDetails?.myRatingAverage else{return}
        
         //   viewStarRating.isHidden = myAverageRating == 0
         //   lblRatingCount.isHidden = myAverageRating == 0
            lblRatingCount.text = "\(myAverageRating)"
        
            viewStarRating.value = CGFloat(myAverageRating)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let showPlaceTableOnLeft = (SideMenuController.preferences.basic.position == .under) != (SideMenuController.preferences.basic.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
    func didSelectRowPressed(index: Int) {
        
        let option = arrOptions[index]
        tableView.reloadData()
        
        // Commented Temporary
        switch option {
            
        case .BookTaxi :
            debugPrint("BookTaxi")
            
        case .PackageDelivery :
            debugPrint("PackageDelivery")
            
       /* case .SchoolRides :
            debugPrint("SchoolRides") */
            
        case .Home :
            debugPrint("Home")
//            guard let selectMainCategoryViewController = R.storyboard.main.selectMainCategoryViewController() else{return}
//            selectMainCategoryViewController.isFromSideMenu = true
//            self.navigationController?.pushViewController(selectMainCategoryViewController, animated: true)
            
             dismiss(animated: true, completion: nil)
            
        case .MyBookings:
            
            debugPrint("My Bookings")
            guard let bookingVC = R.storyboard.sideMenu.bookingsVC() else{return}
            bookingVC.isRightToLeft = LanguageFile.shared.isLanguageRightSemantic()
            self.navigationController?.pushViewController(bookingVC, animated: true)
            
        case .Payments:
            
            debugPrint("Payment")
            
            guard let paymentVC = R.storyboard.sideMenu.cardListViewController() else{return}
            paymentVC.isFromSideMenu = true
            self.navigationController?.pushViewController(paymentVC, animated: true)
            
        case .Packages:
            debugPrint("Packages")
            guard let travelVC = R.storyboard.sideMenu.travelPackagesViewController() else{return}
           // travelVC.isRightToLeft = LanguageFile.shared.isLanguageRightSemantic()
            self.navigationController?.pushViewController(travelVC, animated: true)
            
        case .EmergencyContact:
            debugPrint("EmergencyContact")
            guard let emerContactVC = R.storyboard.sideMenu.emergencyContactVC() else{return}
            navigationController?.pushViewController(emerContactVC, animated: true)

        case .Notifications:
            guard let emerContactVC = R.storyboard.sideMenu.noticeboardController() else{return}
            navigationController?.pushViewController(emerContactVC, animated: true)
            
        case .Settings:
            
            debugPrint("Settings")
            guard let setting = R.storyboard.sideMenu.settingsVC() else{return}
            navigationController?.pushViewController(setting, animated: true)
            
        case .Help:
            debugPrint("Help")
            guard let contactusVC = R.storyboard.sideMenu.contactUsVC() else{return}
            navigationController?.pushViewController(contactusVC, animated: true)
            
        case .PaymentHistory:
            debugPrint("PaymentHistory")
            
        case .SavedCard:
            debugPrint("SavedCard")
            
        case .DeliveryHistory:
            debugPrint("DeliveryHistory")
            guard let bookingVC = R.storyboard.sideMenu.bookingsVC() else{return}
            bookingVC.isRightToLeft = LanguageFile.shared.isLanguageRightSemantic()
            self.navigationController?.pushViewController(bookingVC, animated: true)
            
        case .Promotions:
            debugPrint("Promotions")
            
        case .Contactus:
             debugPrint("Contactus")
            
        case .SignOut:
            debugPrint("SignOut")
            self.alertBoxOption(message: "logout_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
                       
                self?.logOut()
                       
            }, cancel: {})
            
        case .getDiscount:
            print("get discount")
            dismiss(animated: true) {

            let textToShare = "Install \("AppName".localizedString)"
            if let appUrl = NSURL(string: APIBasePath.AppStoreURL) {
                let objectsToShare = [textToShare, appUrl] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                ez.topMostVC?.present(activityVC, animated: true, completion: nil)
            }
                        
            }
            
            
        case .deliverWithUs:
            print("Deliver with us")
            let urlStr = "itms-apps://itunes.apple.com/app/apple-store/id375380948?mt=8"
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(URL(string: urlStr)!, options: [:], completionHandler: nil)
             } else {
                 UIApplication.shared.openURL(URL(string: urlStr)!)
             }
            
            
        case .BookAService:
             dismiss(animated: true, completion: nil)
            
        case .EditProfile:
             guard let editVC = R.storyboard.sideMenu.editProfileVC() else{return}
             self.navigationController?.pushViewController(editVC, animated: true)
            
        case .wallet:
            guard let walletVC = R.storyboard.sideMenu.walletVCViewController() else {return}
            self.navigationController?.pushViewController(walletVC, animated: true)
            
        case .referral :
            guard let referralVC = R.storyboard.sideMenu.referralVC() else{return}
            self.navigationController?.pushViewController(referralVC, animated: true)
        }
        
       /* switch option {
        case .Bookings :
            
             guard let bookingVC = R.storyboard.sideMenu.bookingsVC() else{return}
             bookingVC.isRightToLeft = LanguageFile.shared.isLanguageRightSemantic()
            self.navigationController?.pushViewController(bookingVC, animated: true)
            
        case .ETokens :
            
            guard let bookingVC = R.storyboard.drinkingWater.tokenListingVC() else{return}
            if let userData = UDSingleton.shared.userData {
                // only passed drinking water service category id
                let brands =  userData.services?.filter({$0.serviceCategoryId == 2}).first?.brands
                CouponSelectedLocation.categoryId = 3
                CouponSelectedLocation.categoryBrandId = 0
                CouponSelectedLocation.Brands = brands
                CouponSelectedLocation.brandSelected = brands?.first
            }
           
            bookingVC.isRightToLeft = LanguageFile.shared.isLanguageRightSemantic()
            self.navigationController?.pushViewController(bookingVC, animated: true)
            
        case .Promotions :
            Alerts.shared.show(alert: "AppName".localizedString, message: "coming_soon".localizedString , type: .error )
            break
        case .Payments :
            guard let paymentVC = R.storyboard.bookService.paymentVC() else{return}
            paymentVC.mode = .SideMenu
            self.navigationController?.pushViewController(paymentVC, animated: true)
            break
        case .Referral :
            guard let referralVC = R.storyboard.sideMenu.referralVC() else{return}
            self.navigationController?.pushViewController(referralVC, animated: true)
            break;
        case .EmergencyContacts :
            guard let emerContactVC = R.storyboard.sideMenu.emergencyContactVC() else{return}
            self.navigationController?.pushViewController(emerContactVC, animated: true)
            break
        case .Settings :
            
            guard let setting = R.storyboard.sideMenu.settingsVC() else{return}
            self.navigationController?.pushViewController(setting, animated: true)

            break
        case .Contactus :
            guard let contactusVC = R.storyboard.sideMenu.contactUsVC() else{return}
            self.navigationController?.pushViewController(contactusVC, animated: true)
            break
        case .SignOut :
      
            self.alertBoxOption(message: "logout_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
                
                self?.logOut()
                
            })
        } */
    }
    
    func logOut() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let obj = LoginEndpoint.logOut
        
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self](response) in
            
            switch response {
                
            case .success(_):
                
                self?.dismissVC(completion: nil)
                UDSingleton.shared.removeAppData()
                
                break;
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message:/strError , type: .error )
                
                // Toast.show(text: strError, type: .error)
           }
        }
    }
 
}

//MARK:- Button Selector
extension MenuViewController {
    
    @IBAction func buttonSignOutClicked(_ sender: Any) {
        
        self.alertBoxOption(message: "logout_confirmation".localizedString  , title: "AppName".localizedString , leftAction: "no".localizedString , rightAction: "yes".localizedString , ok: { [weak self] in
            
            self?.logOut()
            
            }, cancel: {})
    }
}

//MARK:- Side Menu Delegates

extension MenuViewController {
    
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? SelectionCell {
                 cell.titleLabel.text = (self?.arrOptions[indexpath.row].rawValue)?.localizedString
                
              let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
                
                if template == .DeliverSome {
                    cell.iconImg.isHidden = false
                    cell.iconImg.image = UIImage(named: self?.arrOptions[indexpath.row].rawValue ?? "")
                } else {
                    cell.iconImg.isHidden = true 
                }
                
                
                
                  
                cell.selectionStyle = .gray
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if let cell = cell as? SelectionCell {
                self?.didSelectRowPressed(index: indexPath.row)
                cell.setSelected(true, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrOptions, tableView: tableView, cellIdentifier: R.reuseIdentifier.selectionCell.identifier, cellHeight: 47)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
  

}

class SelectionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    
}

