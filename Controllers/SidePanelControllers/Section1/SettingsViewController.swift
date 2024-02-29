//
//  SettingsViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import YYWebImage

protocol LogoutDelegate : class {
    func userLoggedOut()
}

class SettingsViewController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var back_button: ThemeButton!{
        didSet {//Nitin
            back_button.imageView?.mirrorTransform()
            back_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? false : true
        }
    }
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var imageViewProfile: UIImageView! {
        didSet {
            imageViewProfile.backgroundColor = UIColor.gray
            imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width/2.0
            imageViewProfile.layer.borderWidth = 2.0
            imageViewProfile.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    
    //MARK:- Variable
    let headerHeight = ScreenSize.SCREEN_WIDTH * 0.6
    var headerView = UIView(frame: CGRect.zero)
    var delivery : Delivery?
    weak var delegate : LogoutDelegate?
    var tableDataSource = SettingsDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var arrAddress : [Address]?{
        didSet{
            configureTableView()
            tableView.reloadTableViewData(inView: view)
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkCameraPermission()
        getAllAdresses()
        setupUI()
        
    }
    
    func setupUI(){
        configureTableHeader()
        labelName.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
        labelPlace.text = GDataSingleton.sharedInstance.loggedInUser?.email
        //UtilityFunctions.appendOptionalStrings(withArray: [LocationSingleton.sharedInstance.location?.getCity()?.name,LocationSingleton.sharedInstance.location?.getCountry()?.name],separatorString: " , ")
        
        imageViewCover.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil)
        imageViewProfile.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil, placeHolder: UIImage(asset: Asset.User_placeholder))
        
        //        guard let image = GDataSingleton.sharedInstance.loggedInUser?.userImage,let imageUrl = URL(string: image) else { return }
        //            weak var weakSelf = self
        //            weakSelf?.imageViewCover.image = UIImageEffects.imageByApplyingDarkEffect(to: image)
        //        }
        //
        //        imageViewProfile.yy_setImage(with: imageUrl, options: .setImageWithFadeAnimation)
    }
}

//MARK: - Webservice Get all Adresses
extension SettingsViewController {
    func getAllAdresses(){
        APIManager.sharedInstance.showLoader()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.Addresses(FormatAPIParameters.Addresses(supplierBranchId: nil,areaId: nil).formatParameters())) { [weak self] (result) in
            APIManager.sharedInstance.hideLoader()
            switch result {
            case .Success(let object):
                guard let delivery = object as? Delivery else { return }
                self?.delivery = delivery
                self?.arrAddress = delivery.addresses
            case .Failure(let validation):
                print(validation)
            }
        }
    }
}

//MARK: - Configure tableview
extension SettingsViewController {
    
    func configureTableView(){
        weak var weakSelf : SettingsViewController? = self
        tableDataSource = SettingsDataSource(tableView: tableView, configurecell: {
            (cell, section, indexPath) in
            
            weakSelf?.configureTableCell(cell: cell, section: section, indexPath: indexPath)
            
        }, rowSelectedBlock: {
            (indexPath) in
            weakSelf?.configureCellSelection(indexPath: indexPath)
        }, scrollListener: { (scrollView) in
            weakSelf?.updateHeaderView(headerView: weakSelf?.headerView)
        })
    }
    
    func configureTableCell(cell : Any, section : SettingsSection, indexPath : IndexPath){
        (cell as? DeliveryAddressCell)?.arrAddress = arrAddress
        (cell as? DeliveryAddressCell)?.textLabel?.font = UIFont(name: Fonts.ProximaNova.SemiBold, size: Size.Large.rawValue)
        switch section {
        case .Notifications:
            
            (cell as? SettingsCell)?.textLabel?.text = indexPath.row == 0 ? L10n.Notifications.string : L10n.NotificationsLanguage.string
            
            /*-------ThemeColor------*/
            (cell as? SettingsCell)?.textLabel?.textColor = LabelThemeColor.shared.lblThemeColor
            
            if (cell as? SettingsCell)?.textLabel?.text == L10n.Notifications.string {
                
                let switchView = UISwitch(frame: CGRect.zero)
                // switchView.onTintColor = Colors.MainColor.color()
                
                /*-------ThemeColor------*/
                switchView.onTintColor = ViewThemeColor.shared.viewThemeColor
                
                switchView.isOn = delivery?.notificationStatus == "1" ? true : false
                (cell as? SettingsCell)?.accessoryView = switchView
                switchView.addTarget(self, action:  #selector(SettingsViewController.actionSwitch(sender:)), for: .valueChanged)
            }else {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, w: 24, h: 24))
                imageView.image = Localize.currentLanguage() == Languages.Arabic ? UIImage(asset: Asset.Flag_ead) : UIImage(asset: Asset.Ic_UK_flag)
                (cell as? SettingsCell)?.accessoryView = imageView
            }
        case .Other:
            (cell as? SettingsCell)?.textLabel?.textColor = LabelThemeColor.shared.lblThemeColor
            
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.fbId {
                (cell as? SettingsCell)?.textLabel?.text = L10n.Logout.string
                
            } else {
                (cell as? SettingsCell)?.textLabel?.text = indexPath.row == 0 ? L10n.ChangePassword.string : L10n.Logout.string
            }
        default :
            break
        }
    }
    
    func configureCellSelection(indexPath : IndexPath){
        
        let row = SettingsSection.allValues[indexPath.section]
        
        switch row {
        case .Other:
            if let _ = GDataSingleton.sharedInstance.loggedInUser?.fbId {
                logOut()
            }else {
                if indexPath.row == 1 {
                    logOut()
                }else {
                    showAlertChangePassword()
                }
            }
            
        case .Notifications:
            if indexPath.row == 1 {
                let cell = tableView.cellForRow(at: indexPath)
                UtilityFunctions.showActionSheet(withTitle: L10n.SelectNotificationLanguage.string, subTitle: nil, vc: self, senders: [L10n.English.string,L10n.Spanish.string], success: { (text, index) in
                    let title = text as! String
                    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, w: 24, h: 24))
                    switch title {
                    case L10n.English.string:
                        imageView.image = UIImage(asset: Asset.Ic_UK_flag)
                        self.changeNotificationLanguage(languageId: "14")
                    case L10n.Spanish.string:
                        imageView.image = UIImage(asset: Asset.Flag_ead)
                        self.changeNotificationLanguage(languageId: "15")
                    default : break
                    }
                    DBManager.sharedManager.cleanCart()
                    (cell as? SettingsCell)?.accessoryView = imageView
                    
                })
            }
        default:
            break
        }
    }
    
    func changeNotificationLanguage(languageId : String?){
        if GDataSingleton.sharedInstance.isLoggedIn {
            APIManager.sharedInstance.opertationWithRequest(withApi: API.NotificationLanguage(FormatAPIParameters.NotificationLanguage(languageId: languageId).formatParameters())) { (response) in
                
                UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.NotificationLanguageChangedSuccessfully.string, style: AlertStyle.Success, success: {}, cancel: {})
                
            }
        }
    }
}

//MARK: - Setup table Header
extension SettingsViewController {
    
    func configureTableHeader(){
        headerView = tableView.tableHeaderView!
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerHeight)
        updateHeaderView(headerView: headerView)
    }
    
    func updateHeaderView(headerView : UIView?){
        
        var headerRect = CGRect(x: 0, y: -headerHeight, width: ScreenSize.SCREEN_WIDTH, height: headerHeight )
        if (tableView.contentOffset.y < -headerHeight) {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView?.frame = headerRect
    }
}

//MARK: - Button Actions
extension SettingsViewController {
    
    @IBAction func back_buttonAction(_ sender: Any) {
        popVC()
    }
    
    @IBAction func actionToggleMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionChangeProfilePic(sender : AnyObject){
        
        if UtilityFunctions.isCameraPermission() {
            UtilityFunctions.showActionSheet(withTitle: nil, subTitle: L10n.SelectPicture.string, vc: self, senders: [L10n.Camera.string,L10n.PhotoLibrary.string]) { (text, index) in
                
                CameraGalleryPickerBlock.sharedInstance.pickerImage(type: text as! String, presentInVc: self, pickedListner: { [weak self] (image) in
                    
                    self?.changeProfileWebservice(image: image)
                }) {
                    
                    //Cancelled
                }
            }
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
        
    }
    
    @objc func actionSwitch(sender : UISwitch!){
        let status = String(sender.isOn)
        APIManager.sharedInstance.opertationWithRequest(withApi: API.NotificationSwitch(FormatAPIParameters.NotificationSwitch(status: status).formatParameters())) { (result) in
            //            weak var weakSelf = self
            
        }
    }
}

//MARK: - change profile pic & change password
extension SettingsViewController {
    
    func changeProfileWebservice(image : UIImage?){
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ChangeProfile(FormatAPIParameters.ChangeProfile.formatParameters()), image: image?.resize(toWidth:300)) {
            [weak self] (response) in
            switch response {
            case .Success(let object):
                self?.imageViewProfile.image = image
                self?.imageViewCover.image = image//UIImageEffects.imageByApplyingDarkEffect(to: image)
                let user = GDataSingleton.sharedInstance.loggedInUser
                user?.userImage = object as? String
                GDataSingleton.sharedInstance.loggedInUser = user
            default:
                break
            }
        }
    }
    func changePasswordWebservice(old : String?,new : String?){
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ChangePassword(FormatAPIParameters.ChangePassword(oldPassword: old, newPassword: new).formatParameters())) { (response) in
            
            APIManager.sharedInstance.hideLoader()
            switch response {
            case .Success(_):
                
                UtilityFunctions.showSweetAlert(title: L10n.Success.string, message: L10n.PasswordChangedSuccess.string, style: AlertStyle.Success, success: {}, cancel: {})
                
            case .Failure(let validation):
                APIManager.sharedInstance.hideLoader()
                SKToast.makeToast(validation.message)
                break
            }
            
        }
    }
}

//MARK: - ChangePassword

extension SettingsViewController {
    
    func showAlertChangePassword(msg: String = "", old: String = "", new: String = "", confirm: String = "") {
        
        let strmsg = msg.isEmpty ? L10n.EnterYourDetails.string : msg
        let alert = TYAlertView(title: L10n.ChangePassword.string , message: strmsg)
        let alertController = TYAlertController(alert: alert, preferredStyle: .alert, transitionAnimation: .scaleFade)
        
        let action = TYAlertAction(title: L10n.Save.string, style: .default) {
            [weak self] (action) in
            //            alert.hideView()
            self?.handleAlertAction(alertController: alertController ?? TYAlertController(alert: alert))
        }
        alert?.buttonDefaultBgColor = Colors.MainColor.color()
        alert?.textFieldFont = UIFont(name: Fonts.ProximaNova.Regular, size: Size.Small.rawValue)
        
        alert?.add(TYAlertAction(title: L10n.Cancel.string , style: .destructive, handler: { (action) in
            alert?.hide()
        }))
        
        alert?.add(action)
        
        let tempPlaceholderArr = [L10n.OldPassword.string,L10n.NewPassword.string,L10n.ConfirmPassword.string]
        let arrvalue = [old, new, confirm]
        for (index,element) in tempPlaceholderArr.enumerated() {
            alert?.addTextField { (textField) in
                textField?.placeholder = element
                textField?.text = arrvalue[index]
                textField?.tag = index + 1
                textField?.returnKeyType = .done
                textField?.isSecureTextEntry = true
            }
        }
        
        presentVC(alertController ?? TYAlertController(alert: alert))
    }
    
    func handleAlertAction(alertController : TYAlertController){
        alertController.view.endEditing(true)
        var old = ""
        var new = ""
        var confirm = ""
        
        var arrTextFieldText : [String] = []
        
        let arrTextfieldNames = [L10n.OldPassword.string,L10n.NewPassword.string,L10n.ConfirmPassword.string]
        for (index,_) in arrTextfieldNames.enumerated() {
            
            let text = /(alertController.alertView.viewWithTag(index + 1) as? UITextField)?.text?.trimmed()
            if index == 0 {
                old = text
            } else if index == 1 {
                new = text
            } else if index == 2 {
                confirm = text
            }
            arrTextFieldText.append(text)
        }
        
        let message = /User.validateChangePassword(passwords: arrTextFieldText)
        //        alertController.dismissViewController(animated: false)
        
        if message.isEmpty {
            changePasswordWebservice(old: old, new: new)
        }else{
            SKToast.makeToast(message)
            showAlertChangePassword(msg: message, old: old, new: new, confirm: confirm)
            
            //            alertController.view.endEditing(true)
            //            alertController.view.makeToast(message)
            
            
        }
        
    }
}
//MARK: - Utility
import AVFoundation
extension SettingsViewController {
    func logOut(){
        UtilityFunctions.showSweetAlert(title: L10n.LogOut.string, message: L10n.AreYouSureYouWantToLogout.string, success: { [weak self] in
            (UIApplication.shared.delegate as? AppDelegate)?.logout()
            self?.delegate?.userLoggedOut()
            LocationSingleton.sharedInstance.searchedAddress = nil
        }) {
        }
    }
}
