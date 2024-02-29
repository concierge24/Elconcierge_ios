//
//  EmergencyContactVC.swift
//  Buraq24
//
//  Created by MANINDER on 01/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import EPContactsPicker

class EmergencyContactVC: BaseVCCab {
    
    //MARK:- Outlets
    @IBOutlet var tblContacts: UITableView!
    @IBOutlet weak var btnAddContact: UIButton!
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var arrContacts : [EmergencyContact]?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // getEmergencyContacts()
        lblTitle?.text = "Emergency contacts".localizedString
         btnAddContact.setViewBorderColorSecondary()
        btnAddContact.setButtonWithTitleColorSecondary()
        btnAddContact.setTitle("AddTrustedContact".localizedString, for: .normal)
        getUserEmergencyContacts()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } */
    
    //MARK:- Functions
    
    @IBAction func btnAddTrustedContactAction(_ sender: Any) {
        

        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.phoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        navigationController.modalPresentationStyle = .overCurrentContext
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { ( cell , item , indexpath) in
            if let cell = cell as? ContactCell , let model = item as? EmergencyContact{
                cell.assignCellData(model: model)
                cell.callBackBtn = { model in
                    if let contactNumber = model.phoneNumber {
                        contactNumber.showCallOption()
                    }
                }
                cell.deleteContact = {[weak self] model in
               
                    
                    
                    
                    self?.alertBoxOption(message: "Do you want to remove this contact?", title:  "AppName".localizedString, leftAction: "No".localizedString, rightAction: "Yes".localizedString, ok: {
                        
                        self?.removeEmergencyContacts(id: "\(/model.contactId)")
                        
                    }) {
                        
                        
                    }
                    
                    
                }
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrContacts, tableView: tblContacts, cellIdentifier: R.reuseIdentifier.contactCell.identifier, cellHeight: 80)
        tableDataSource?.configureCellBlock = configureCellBlock
        
        tblContacts.delegate = tableDataSource
        tblContacts.dataSource = tableDataSource
        
        tblContacts.reloadData()
    }
    
    
    //MARK:- API
    
    func getUserEmergencyContacts() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let contactsVC = LoginEndpoint.userEmergencyContact
        contactsVC.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                
                if let contacts = data as? [EmergencyContact] {
                    self?.arrContacts = contacts
                    self?.configureTableView()
                }
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
    func getEmergencyContacts() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let contactsVC = LoginEndpoint.eContacts(phone_code:/UDSingleton.shared.userData?.userDetails?.user?.countryCode)
        contactsVC.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                
                if let contacts = data as? [EmergencyContact] {
                    self?.arrContacts = contacts
                    self?.configureTableView()
                }
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
    func addEmergencyContacts(array:[[String:Any]]){
        
        if array.count == 0{
            
            return
        }
        
        guard let jsonStr = convertIntoJSONString(arrayObject:array) else{return}
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let contactsVC = LoginEndpoint.addEmergencyContact(contacts: jsonStr)
        contactsVC.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            
            self?.getUserEmergencyContacts()
//            switch response {
//            case .success(let data):
//
//                if let contacts = data as? [EmergencyContact] {
//                    self?.arrContacts = contacts
//                    self?.configureTableView()
//                }
//            case .failure(let strError):
//                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
//            }
        }
        
    }
    
    func removeEmergencyContacts(id:String){
        
     
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let contactsVC = LoginEndpoint.removeEmergencyContact(contactId: id)
        contactsVC.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                
                self?.getUserEmergencyContacts()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
        
    }
    
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {
        
        

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
}



//MARK::- PICKER
extension EmergencyContactVC : EPPickerDelegate {
    
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
        
       // arrayContacts = []
        
        var array = [[String:Any]]()
        
        contacts.forEachEnumerated {[weak self] (index, contact) in
            
            // 0- ISO Code, 1- Country code
            let codes = contact.phoneNumbers.first?.phoneNumber.getISOAndCountryCode()
            let iso = (/codes?.0).isEmpty ?  DefaultCountry.ISO.rawValue : codes?.0
            var countryCode =  ((/codes?.1).isEmpty ?  DefaultCountry.countryCode.rawValue : /codes?.1)
            
            
            
            let pureNumber = contact.phoneNumbers.first?.phoneNumber.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            let numberWithoutContryCode = pureNumber?.components(separatedBy: /countryCode).last
            
            let modal = ContactNumberModal(contactNumber: numberWithoutContryCode, name: contact.displayName(), ISO: iso, countryCode: countryCode)
            
            let dict = ["phone_number":numberWithoutContryCode,"phone_code":countryCode]
            
            array.append(dict)
            
            
           // self?.addContactToServerData(contact: modal)
            //self?.arrayContacts.append(modal)
        }
        
        self.addEmergencyContacts(array: array)
        
       
    }
}
