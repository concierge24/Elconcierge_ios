//
//  ShareRideViewController.swift
//  Trava
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import EPContactsPicker

protocol ShareRideViewControllerDelegate {
    func rideShared(order: OrderCab?)
}

class ShareRideViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var buttonShareRide: UIButton!
    @IBOutlet var viewOuter: UIView!
    @IBOutlet weak var textfieldPhoneNumber: UITextField!
    @IBOutlet var imgViewCountryCode: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var buttonAddFromContacts: UIButton!
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var arrayContacts = [ContactNumberModal]()
    var arrayContactsServer = [[String: Any]]()
    var ISO: String?
    var currentOrder: OrderCab?
    var delegate: ShareRideViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            if hitView === viewOuter {
                 cancelPopUp()
            }
        }
    }
}

//MARK:- Function
extension ShareRideViewController {
    
    func initialSetup() {
        setupUI()
        configureTableView()
    }
    
    func setupUI() {
        view.layoutIfNeeded()
        buttonShareRide.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? PhoneNumberTableViewCell {
                cell.assignData(item: item as? ContactNumberModal, indexPath: indexpath)
                cell.delegate = self
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if let cell = cell as? PhoneNumberTableViewCell {
               // self?.didSelectRowPressed(index: indexPath.row)
                cell.setSelected(true, animated: true)
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayContacts, tableView: tableView, cellIdentifier: R.reuseIdentifier.phoneNumberTableViewCell.identifier, cellHeight: 50)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
    
    func cancelPopUp() {
         DispatchQueue.main.async {[weak self] in
            self?.removeChildViewController()
        }
    }
    
    func addContactToServerData(contact: ContactNumberModal?) {
        
        let object = ["phone_code": /contact?.countryCode,
                      "phone_number": /contact?.contactNumber as Any,
                      "name": contact?.name ?? "Anonymous"  ] as [String: Any]
        arrayContactsServer.append(object)
    }
    
    func validateFields() {
        
        if arrayContactsServer.isEmpty {
            if Validations.sharedInstance.validatePhoneNumber(phone: /textfieldPhoneNumber.text) {
                
                let contact = ContactNumberModal(contactNumber: textfieldPhoneNumber.text, name: nil, ISO: nil, countryCode: lblCountryCode.text)
                addContactToServerData(contact: contact)
                arrayContacts.append(contact)
                
                shareRide()
            }
        } else {
            shareRide()
        }
    }
}


//MARK:- Button Selector

extension ShareRideViewController {
    
    @IBAction func buttonShareRideClicked(_ sender: Any) {
        validateFields()
    }
    
    @IBAction func actionBtnCountryCode(_ sender: UIButton) {
           
           guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
           countryPicker.delegate = self
           ez.topMostVC?.presentVC(countryPicker)
       }
    
    @IBAction func buttonAddClicked(_ sender: Any) {
        
       // if /textfieldPhoneNumber.text?.trimmed().isEmpty {

            let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.phoneNumber)
            let navigationController = UINavigationController(rootViewController: contactPickerScene)
            navigationController.modalPresentationStyle = .overCurrentContext
            self.present(navigationController, animated: true, completion: nil)
       /* } else {
            
            let contact = ContactNumberModal(contactNumber: textfieldPhoneNumber.text, name: nil, ISO: nil, countryCode: lblCountryCode.text?.components(separatedBy: "+").last)
            addContactToServerData(contact: contact)
            arrayContacts.append(contact)
            
            tableDataSource?.items = arrayContacts
            tableView.reloadData()
            
            textfieldPhoneNumber.text = ""
            textfieldPhoneNumber.sendActions(for: .editingChanged)
        } */
        
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
       // let image = /textfieldPhoneNumber.text?.trimmed().isEmpty ? R.image.ic_add_new_Icon() : R.image.ic_verify()
       // buttonAddFromContacts.setImage(image, for: .normal)
        
        buttonAddFromContacts.isHidden = !(/textfieldPhoneNumber.text?.trimmed().isEmpty)
    }
}


//MARK::- PICKER
extension ShareRideViewController : EPPickerDelegate {
    
    //MARK: EPContactsPicker
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError){
        debugPrint("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact) {
        
       /* tfName?.text  = contact.displayName()
        tfEmail?.text = contact.emails[safe : 0]?.email
      
        let importedContact = (contact.phoneNumbers[safe : 0]?.phoneNumber)
        
        // ISO Code
        var isoCode = (importedContact?.getISOCode() ?? "")
        isoCode     = isoCode.isEmpty ?  DefaultCountry.ISO.rawValue : isoCode
        
        // set up country code field value
        let country = getCountry(isoCode: isoCode)
        setCountryData(country: country)
        
        tfPhone?.text = importedContact?.components(separatedBy: "+" + /countryCodeServer).last
        tfPhone.sendActions(for: .editingChanged)
        
        labelSelectHere?.text = StaticStrings.selectHere.rawValue
        
        buttonMobile.isHidden = contact.phoneNumbers.count <= 1
        buttonEmail.isHidden  = (contact.emails.count == 1 || contact.emails.count == 0)
        
        if contact.phoneNumbers.count > 1 {
            
            arrayMobileNumber = []
            contact.phoneNumbers.forEach { (contact) in
                arrayMobileNumber.append(contact.phoneNumber)
            }
            debugPrint(arrayMobileNumber)
        }
        
        if contact.emails.count > 1 {
            arrayEmail = []
            contact.emails.forEach { (contact) in
                arrayEmail.append(contact.email)
            }
            debugPrint(arrayEmail)
        } */
        
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError){
        debugPrint("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        debugPrint("The following contacts are selected")
        
        arrayContacts = []
        
        contacts.forEachEnumerated {[weak self] (index, contact) in
            
            // 0- ISO Code, 1- Country code
            let codes = contact.phoneNumbers.first?.phoneNumber.getISOAndCountryCode()
            let iso = (/codes?.0).isEmpty ?  DefaultCountry.ISO.rawValue : codes?.0
            let countryCode = "+" + ((/codes?.1).isEmpty ?  DefaultCountry.countryCode.rawValue : /codes?.1)
            
            let pureNumber = contact.phoneNumbers.first?.phoneNumber.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            let numberWithoutContryCode = pureNumber?.components(separatedBy: /countryCode).last
            
            let modal = ContactNumberModal(contactNumber: numberWithoutContryCode, name: contact.displayName(), ISO: iso, countryCode: countryCode)
            
            self?.addContactToServerData(contact: modal)
            self?.arrayContacts.append(modal)
        }
        
        tableDataSource?.items = arrayContacts
        tableView.reloadData()
        
        textfieldPhoneNumber.isUserInteractionEnabled = false
    }
}

//MARK:- API
extension ShareRideViewController {
    
    func shareRide() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.shareRide(shareWith: arrayContactsServer.toJson(), orderId: currentOrder?.orderId)
        
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(let data):
                debugPrint("Successs")
                guard let modal = data as? OrderCab else {return}
                
                DispatchQueue.main.async {[weak self] in
                    self?.removeChildViewController()
                    self?.currentOrder?.shareWith = modal.shareWith
                    self?.delegate?.rideShared(order: self?.currentOrder)
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
}

//MARK:- PhoneNumberTableViewCellDelegate
extension ShareRideViewController: PhoneNumberTableViewCellDelegate {
    
    func crossClicked(indexPath: IndexPath?) {
        
        arrayContacts.remove(at: /indexPath?.row)
        arrayContactsServer.remove(at: /indexPath?.row)
        
        tableDataSource?.items = arrayContacts
        tableView.reloadData()
        
        textfieldPhoneNumber.isUserInteractionEnabled = /arrayContacts.isEmpty
        
    }
}


//MARK: - Country Picker Delegates

extension ShareRideViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        ISO = /(detail["code"] as? String)
        
        imgViewCountryCode.image = UIImage(named: /ISO?.lowercased())
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}
