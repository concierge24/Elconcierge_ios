//
//  NTSignupInstitutionViewController.swift
//  RoyoRide
//
//  Created by Ankush on 15/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class NTSignupInstitutionViewController: UIViewController {
    
    enum ApiRequestType: String {
        case type = "Type"
        case name = "Name"
    }
    
    enum DropDownType {
        case type
        case name
    }
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var labelTitle: UILabel!

    @IBOutlet weak var textFieldInstitutiontype: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var buttonInstituteType: UIButton!
    @IBOutlet weak var buttonInstituteName: UIButton!
        
    
    var arrayType: [InstitutionsModel]?
    var arrayName: [InstitutionsModel]?
    var selectedNameId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        
        
    }
}

extension NTSignupInstitutionViewController {
    
    func initialSetup() {
        setUpUI()
        getPrivateCooperationListing(item: ApiRequestType.type.rawValue, cooperationType: nil)
    }
    
    func setUpUI(){
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnNext.setButtonWithTintColorBtnText()
        
        labelTitle.text = "signup_for".localizedString + " " + "AppName".localizedString + "\n" + "institution_account".localizedString
    }
        
    func showDropDown(view : UIView, datasource: [String], type: DropDownType) {
        
        Utility.shared.showDropDown(anchorView: view, dataSource: datasource , width: 250, handler: {[weak self] (index, strValu) in
            
            switch type {
            case .type:
                self?.textFieldInstitutiontype.text = strValu
                self?.textFieldName.text = ""
                self?.getPrivateCooperationListing(item: ApiRequestType.name.rawValue, cooperationType: strValu)
                
            case .name:
                self?.textFieldName.text = strValu
                self?.selectedNameId = self?.arrayName?[index].cooperation_id
            }
        })
    }
}


//MARK:- Button Selectors
extension NTSignupInstitutionViewController {
    
    // Back - 1, InstitutionType -2, Institution Name - 3, Next- 4
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            
            let array = arrayType?.map({/$0.type})
            showDropDown(view: sender, datasource: array ?? [], type: .type)
            
        case 3:
            let array = arrayName?.map({/$0.name})
            showDropDown(view: sender, datasource: array ?? [], type: .name)
            
        case 4:
            debugPrint("Next")
            
            if Validations.sharedInstance.validateInstitutionalSignup(type:  /textFieldInstitutiontype.text?.trimmed(), name:  /textFieldName.text?.trimmed()) {
                
                debugPrint("Success")
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntInstitutionalInfoViewController() else {return}
                vc.selectedNameId = selectedNameId
                pushVC(vc)
            }
            
            
            
        default:
            break
        }
    }
}


extension NTSignupInstitutionViewController {
    
    func getPrivateCooperationListing(item: String?, cooperationType: String?) {
        
        let privateCoop = LoginEndpoint.privateCooperationListing(items: item, cooperation_type: cooperationType)
        
        privateCoop.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                debugPrint(data as Any)
                
                guard let model = data as? [InstitutionsModel] else { return }
                
                if item == ApiRequestType.type.rawValue {
                    self?.arrayType = model
                } else {
                    self?.arrayName = model
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
}
