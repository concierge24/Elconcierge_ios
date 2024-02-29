//
//  MoreViewController.swift
//  Sneni
//
//  Created by Apple on 20/08/19.
//  Copyright © 2019 Taran. All rights reserved.
//


import UIKit
import EZSwiftExtensions
var refereshMixedHome = ""
class MoreViewController: UIViewController {
    
    let languageArry : [String] = ["LanguageName.English".localizedString  ,"LanguageName.Chinese".localizedString,"LanguageName.Spanish".localizedString,"LanguageName.French".localizedString,"LanguageName.Dutch".localizedString,"LanguageName.Italian".localizedString,"LanguageName.Japanese".localizedString,"LanguageName.German".localizedString,"LanguageName.Arabic".localizedString]

    
    //MARK:- IBOutlet
    @IBOutlet weak var title_label: ThemeLabel!
    @IBOutlet weak var navigation_view: NavigationView!
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            self.tableView.tableFooterView = UIView(frame: CGRect.zero)
            self.tableView.register(UINib(nibName: CellIdentifiers.MoreTableCell, bundle: nil), forCellReuseIdentifier: CellIdentifiers.MoreTableCell)
        }
    }
    @IBOutlet weak var login_and_sign_up_view: UIView!
    @IBOutlet weak var login_signup_btn: UIButton! {
        didSet {
            login_signup_btn.setAlignmentWithOffset(space: 15)
        }
    }
    @IBOutlet weak var profile_view: UIView!
    @IBOutlet weak var profile_btn: UIButton!
    @IBOutlet weak var profile_image: UIImageView! {
           didSet {
                profile_image.layer.cornerRadius = profile_image.frame.width/2.0
                profile_image.layer.borderWidth = 1.0
                profile_image.layer.borderColor = UIColor.groupTableViewBackground.cgColor
            }
       }
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
   
    @IBOutlet weak var imgArrow1: UIImageView! {
        didSet {
            imgArrow1.mirrorTransform()
        }
    }
    @IBOutlet weak var imgArrow: UIImageView! {
        didSet {
            imgArrow.mirrorTransform()
        }
    }
    @IBOutlet var btnBecomepatient: ThemeButton! {
        didSet {
            btnBecomepatient.isHidden = APIConstants.defaultAgentCode != "cannadash_0180"
        }
    }

    //MARK:- Variables
    var iconArray = [#imageLiteral(resourceName: "shareAppIcon"),#imageLiteral(resourceName: "myFavourites"),#imageLiteral(resourceName: "ic_referal_menu"),#imageLiteral(resourceName: "ic_req"),#imageLiteral(resourceName: "aboutUs"),#imageLiteral(resourceName: "termsAndConditions"),#imageLiteral(resourceName: "privacy_policy"),#imageLiteral(resourceName: "ic_language"),#imageLiteral(resourceName: "logoutIcon")]
    var wishlistTerm = "My Wishlist"
    
    var titleArray : [String] = []
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let term = TerminologyKeys.wishlist.localizedValue() as? String, !term.isEmpty {
            wishlistTerm = term
        }
        titleArray = ["Share App", wishlistTerm, "Referral", "Requests", "About Us", "Terms and Conditions", "Privacy Policy", "change_language".localized(), "Logout"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
        self.title_label.textColor = .white
        setUPUI()
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
    
    func setUPUI() {
        configureUIElements()
        self.name_label.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
        self.email_label.text = GDataSingleton.sharedInstance.loggedInUser?.email
         profile_image.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil, placeHolder: UIImage(asset: Asset.User_placeholder))
    }
    
    func configureUIElements() {
       if GDataSingleton.sharedInstance.isLoggedIn == false {
        self.login_and_sign_up_view.isHidden = false
        self.profile_view.isHidden = true
                }
       else{
         self.login_and_sign_up_view.isHidden = true
         self.profile_view.isHidden = false
        }
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    
    @IBAction func loginSignUpBtnAction(_ sender: UIButton) {
        let vc = StoryboardScene.Register.instantiateLoginViewController()
        (vc as? LoginViewController)?.delegate = self
        (vc as? SignupSelectionVC)?.delegate = self
        UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(vc)
        
    }

     
    @IBAction func profileBtnAction(_ sender: UIButton) {
        let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
        pushVC(settingsVC)
    }
    
    @IBAction func becomePatient(_ sender: Any) {
    let vc = StoryboardScene.Options.instantiateTermsAndConditionsController()
              vc.titleStr = ""
              vc.urlStr = "https://www.facebook.com/CannaDash-106835007601737/"
              self.pushVC(vc)
    }
    
    func logOut(){
        UtilityFunctions.showSweetAlert(title: L10n.LogOut.string, message: L10n.AreYouSureYouWantToLogout.string, success: { [weak self] in
            guard let self = self else {return}
            GDataSingleton.sharedInstance.clearAllSavedData()
            UDSingleton.shared.removeAppData()
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.switchViewControllers()
        }) {
        }
    }
    
}

//MARK:-  UITableViewDelegate,UITableViewDataSource
extension MoreViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
        // return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        
        cell.title_label.text = titleArray[indexPath.row].localized()
        cell.titleIcon_imageView.image = iconArray[indexPath.row]
        cell.titleIcon_imageView.tintColor = SKAppType.type.color
        cell.selectionStyle = .none
        return cell
    }
    
    //mark row height 0 where you dont wan to show
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = titleArray[indexPath.row]

        if !AppSettings.shared.showReferral && title == "Referral" {
            return 0
        }
        if !AppSettings.shared.showChangeLanguage && title == "change_language".localized() {
            return 0
        }
        if !AppSettings.shared.showPrescriptionRequests && indexPath.row == 3 {
            return 0
        }
        if !GDataSingleton.sharedInstance.isLoggedIn {
            if title == wishlistTerm || title == "Logout" || title == "Referral" ||  indexPath.row == 3 {
                return 0
            }
        }
        if (/AppSettings.shared.appThemeData?.is_supplier_wishlist != "1" && /AppSettings.shared.appThemeData?.is_product_wishlist != "1") && title == wishlistTerm {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titleArray[indexPath.row]
        let languageId = GDataSingleton.sharedInstance.languageId
        
        let terms = GDataSingleton.sharedInstance.termsAndConditions?.first(where: {$0.languageId == languageId})
        switch indexPath.row {
            
//        case 0:
//
//            guard GDataSingleton.sharedInstance.isLoggedIn else{
//                let vc = StoryboardScene.Register.instantiateLoginViewController()
//                vc.delegate = self
//                UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(vc)
//                return
//            }
//            let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
//            pushVC(settingsVC)
        case 0:
            var shareMessage : String?
            if AppSettings.shared.appThemeData?.is_app_sharing_message == "1"{
                if let message = AppSettings.shared.appThemeData?.app_sharing_message{
                   shareMessage = message
                }else{
                    shareMessage = L10n.ShareAppYummy.string
                }
            }else{
                shareMessage = L10n.ShareAppYummy.string
            }
            UtilityFunctions.shareContentOnSocialMedia(withViewController: UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController, message: shareMessage)//L10n.TheLeadingOnlineHomeServicesInUAE.string)
        case 1:
                  if title == wishlistTerm {
                      let cartVC = WishListViewController.getVC(.main)
                      self.pushVC(cartVC)
                  }
                  else {
                      self.logOut()
                  }

        case 2:
            let storyboard = UIStoryboard(name: "Referal", bundle: nil)
            guard let vc =
                storyboard.instantiateViewController(withIdentifier: "ReferalDetailViewController") as? ReferalDetailViewController else { return }
            self.pushVC(vc)
        case 3:
            let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
            guard let vc =
                storyboard.instantiateViewController(withIdentifier: "PrescriptionRequestsVC") as? PrescriptionRequestsVC else { return }
            self.pushVC(vc)
        case 4:
            let vc = StoryboardScene.Options.instantiateTermsAndConditionsController()
            vc.titleStr = L10n.AboutUs.string
            vc.htmlStr = terms?.aboutUs ?? "No data found".localized()
            self.pushVC(vc)
        case 5:
            let vc = StoryboardScene.Options.instantiateTermsAndConditionsController()
            vc.titleStr = L10n.TermsAndConditions.string
            vc.htmlStr = terms?.terms ?? "No data found".localized()
            self.pushVC(vc)
        case 6:
            let vc = StoryboardScene.Options.instantiateTermsAndConditionsController()
            vc.titleStr = L10n.PrivacyPolicy.string
            vc.htmlStr = terms?.privacyPolicy ?? "No data found".localized()
            self.pushVC(vc)
        case 7:
            actionLanguage()
        case 8:
            self.logOut()
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    
    func actionLanguage() {
           
           if DBManager.sharedManager.isCartEmpty() {
            
            if APIConstants.defaultAgentCode == "brownstowncorporation_0776"{
                chooseLanguageAlert1()
            } else{
               chooseLanguageAlert()
            }
           } else {
               UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.ChangingTheLanguageWillClearYourCart.string, style: AlertStyle.Warning, success: { [weak self] in
                if APIConstants.defaultAgentCode == "brownstowncorporation_0776"{
                    self?.chooseLanguageAlert1()
                } else{
                self?.chooseLanguageAlert()
                }
               }) {
               }
           }
       }
    
    func chooseLanguageAlert() {
//        let secLang = AppSettings.shared.appThemeData?.secondary_language == "es" ? "Spanish" : "Arabic"
       // let secLang = AppSettings.shared.appThemeData?.secondary_language == "es" ? "Spanish" : AppSettings.shared.appThemeData?.secondary_language == "SQ" ? "Albania" : "Arabic"
          let secLang = AppSettings.shared.appThemeData?.secondary_language == "es" ? "Spanish" : AppSettings.shared.appThemeData?.secondary_language == "sq" ? "Albania" : "Arabic"

        UtilityFunctions.show(nativeActionSheet: "change_language".localized(), subTitle: nil, vc: self, senders: ["English", secLang]) { [weak self] (lang, index) in
            if index == 0 {
                self?.changeLanguage(language: "en")
            }
            else {
                self?.changeLanguage(language: AppSettings.shared.appThemeData?.secondary_language ?? "sq")
                //self?.changeLanguage(language: "sq")
            }
        }
    }
    
    func chooseLanguageAlert1() {
        let secLang = AppSettings.shared.appThemeData?.secondary_language == "es" ? "Spanish" : "Arabic"
        UtilityFunctions.show(nativeActionSheet: "change_language".localized(), subTitle: nil, vc: self, senders: languageArry) { [weak self] (lang, index) in
            if index == 0  {
                self?.changeLanguage(language: "en")
            }else  if index == 1 {
                self?.changeLanguage(language: "zh")
            }
            else  if index == 2 {
                self?.changeLanguage(language: "es")
            }
            else if index == 3  {
                self?.changeLanguage(language: "fr")
            }else  if index == 4 {
                self?.changeLanguage(language: "nl")
            }
            else  if index == 5 {
                self?.changeLanguage(language: "it")
            }
            else  if index == 6 {
                self?.changeLanguage(language: "ja")
            }
            else  if index == 7{
                self?.changeLanguage(language: "de")
            }
            else{
                self?.changeLanguage(language: "ar")
            }
        }
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
}

//MARK:- LoginViewControllerDelegate
extension MoreViewController: LoginViewControllerDelegate {
    
    func userSuccessfullyLoggedIn(withUser user : User?) {
        DispatchQueue.main.async {
            self.setUPUI()
            self.tableView.reloadData()
        }
    }
    
    func userFailedLoggedIn() {
        
    }
}
