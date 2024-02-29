//
//  ProfileVC.swift
//  Sneni
//
//  Created by admin on 15/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    //MARK::- Outlets
    @IBOutlet weak var btnLoginSignup: UIButton?
    @IBOutlet weak var lblName: UILabel?
    
    @IBOutlet weak var tableViewProfile: UITableView?
    
    
    //MARK::- Properties
    
    var titleArray = [["Address","Orders","My Wallet","Payment","Profile","Language"],["Help","Contact Us"]]
    
    let headerTitles = ["My Account","Reach Out As"]
    
    //MARK::- ViewCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableViewProfile?.reloadData()
        setUPUI()
    }
    
    //MARK::- Actions
    @IBAction func actionLoginSignup(_ sender: UIButton){
        let vc = StoryboardScene.Register.instantiateLoginViewController()
        (vc as? LoginViewController)?.delegate = self
        (vc as? SignupSelectionVC)?.delegate = self
        UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(vc)
    }
    
    @IBAction func actionOrder(_ sender: UIButton){
        let vc = StoryboardScene.Order.instantiateOrderHistoryViewController()
        vc.isHiddenBack = false
        pushVC(vc)
    }
    
    @IBAction func actionReturn(_ sender: UIButton){
        SKToast.makeToast("Coming Soon")
    }
    
    //MARK::- Functions
    
    func setUPUI() {
        configureUIElements()
        self.lblName?.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
    }
    
    func configureUIElements() {
        if GDataSingleton.sharedInstance.isLoggedIn == false {
            self.btnLoginSignup?.isHidden = false
            self.lblName?.isHidden = true
        }
        else{
            self.btnLoginSignup?.isHidden = true
            self.lblName?.isHidden = false
        }
    }
    
    func actionLanguage() {
           
           if DBManager.sharedManager.isCartEmpty() {
               chooseLanguageAlert()
           } else {
               UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.ChangingTheLanguageWillClearYourCart.string, style: AlertStyle.Success, success: { [weak self] in
                self?.chooseLanguageAlert()
               }) {
               }
           }
       }
    
    func chooseLanguageAlert() {
        let secLang = AppSettings.shared.appThemeData?.secondary_language == "es" ? "Spanish" : "Arabic"
        UtilityFunctions.show(nativeActionSheet: "change_language".localized(), subTitle: nil, vc: self, senders: ["English", secLang]) { [weak self] (lang, index) in
            if index == 0 {
                self?.changeLanguage(language: "en")
            }
            else {
                self?.changeLanguage(language: AppSettings.shared.appThemeData?.secondary_language ?? "en")
            }
        }
    }
      
    func changeLanguage(language: String){
        let delegate = UtilityFunctions.sharedAppDelegateInstance()
        delegate.switchViewControllers(language: language)
        DBManager.sharedManager.cleanCart()
    }
}

//MARK::- TableView Delegate
extension ProfileVC: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        // Text Color
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor(hex: "1A1A1A")
        header.textLabel?.frame = CGRect(x: 32, y: 0, width: tableView.frame.bounds.width, height: 48)
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = titleArray[indexPath.section][indexPath.row]
        if !AppSettings.shared.showChangeLanguage && title == "change_language".localized() {
            return 0
        }
        if !GDataSingleton.sharedInstance.isLoggedIn {
            if title == "Profile" || title == "Logout" {
                return 0
            }
        }
        return 48.0//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewCell", for: indexPath) as? ProfileViewCell else{return UITableViewCell()}
        cell.lblOptName?.text = titleArray[indexPath.section][indexPath.row]
        if titleArray[indexPath.section][indexPath.row] == "Payment" {
            cell.imageView?.isHidden = true
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0:
                SKToast.makeToast("Coming Soon")
            case 1:
                let vc = StoryboardScene.Order.instantiateOrderHistoryViewController()
                vc.isHiddenBack = false
                pushVC(vc)
            case 2:
                SKToast.makeToast("Coming Soon")
            case 3:
                SKToast.makeToast("Coming Soon")
            case 4:
                let settingsVC = StoryboardScene.Options.instantiateSettingsViewController()
                pushVC(settingsVC)
            case 5:
                actionLanguage()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                SKToast.makeToast("Coming Soon")
            case 1:
                SKToast.makeToast("Coming Soon")
            default:
                break
            }
        default:
            break
        }
    }
    
    
}

//Login Delegate
extension ProfileVC: LoginViewControllerDelegate {
    
    func userSuccessfullyLoggedIn(withUser user : User?) {
        DispatchQueue.main.async {
            self.setUPUI()
            self.tableViewProfile?.reloadData()
        }
    }
    
    func userFailedLoggedIn() {
        
    }
}
