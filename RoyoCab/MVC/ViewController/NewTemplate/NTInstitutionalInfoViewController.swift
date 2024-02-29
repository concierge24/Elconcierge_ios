//
//  NTInstitutionalInfoViewController.swift
//  RoyoRide
//
//  Created by Ankush on 15/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class NTInstitutionalInfoViewController: UIViewController {
    
    @IBOutlet var btnNext: UIButton!
    
    @IBOutlet weak var textFieldIdNumber: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var lblISOCode: UILabel!
    
    @IBOutlet weak var imageViewinstitution: UIImageView!
    @IBOutlet weak var buttonRemoveImage: UIButton!
    
    @IBOutlet weak var imageViewAddImage: UIImageView!
    
    var selectedNameId: Int?
    
    var pickedimage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
}


extension NTInstitutionalInfoViewController {
    
    func initialSetup() {
        setUpUI()
        setupData()
    }
    
    func setUpUI(){
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnNext.setButtonWithTintColorBtnText()
        
        imageViewAddImage.setImageTintColorSecondary()
    }
    
    func setupData() {
        
        lblCountryCode.text =  UDSingleton.shared.appSettings?.appSettings?.default_country_code ?? DefaultCountry.countryCode.rawValue
        lblISOCode.text =  UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
        
       
    }
    
}


//MARK:- Button Selectors
extension NTInstitutionalInfoViewController {
    
    // Back - 1, image -2, delIamge- 3,  next - 4 , 5- countrycode
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            debugPrint("Pick image")
            
            CameraImage.shared.captureImage(from: self, At: imageViewinstitution, mediaType: nil, captureOptions: [.camera, .photoLibrary], allowEditting: true) { [weak self] (image) in
                
                guard let img = image else { return }
                self?.imageViewinstitution.image = img
                self?.pickedimage = img
                
                self?.buttonRemoveImage.isHidden = false
            }
            
        case 3:
            debugPrint("Image Deleted")
            imageViewinstitution.image = R.image.ic_add()
            buttonRemoveImage.isHidden = true
            pickedimage = nil
            
            
        case 4:
            debugPrint("Next")
            
            if Validations.sharedInstance.validateInstitutionalSignupInfo(id: /textFieldIdNumber.text?.trimmed(), email: /textFieldEmail.text?.trimmed(), phone: /textFieldPhoneNumber.text?.trimmed(), password: /textFieldPassword.text?.trimmed(), image: pickedimage) {
                
                debugPrint("Success")
                
                privateCooperationRegForm()
            }
            
        case 5:
            
            guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
            countryPicker.delegate = self
            self.presentVC(countryPicker)
            
            
        default:
            break
        }
    }
}


//MARK: - Country Picker Delegates

extension NTInstitutionalInfoViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        lblCountryCode.text = /(detail["dial_code"] as? String)
        lblISOCode.text = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}


//MARK:- API
extension NTInstitutionalInfoViewController {
    
    func privateCooperationRegForm() {
        
        let obj = LoginEndpoint.privateCooperationRegForum(cooperation_id: selectedNameId, identification_number: textFieldIdNumber.text, email: textFieldEmail.text, phone_code: lblCountryCode.text, iso: lblISOCode.text, phone_number: textFieldPhoneNumber.text, password: textFieldPassword.text)
        obj.request(isImage: true, images: [pickedimage], isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
            case .success(let data):
                
                guard let model = data as? SendOtp else { return }
                model.countryCode = self?.lblCountryCode.text
                model.mobileNumber = self?.textFieldPhoneNumber.text
                model.iso = self?.lblISOCode.text
                
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntVerificationCodeViewController() else{return}
                vc.sendOTP = model
                vc.signup_as = .PrivateCooperative
                self?.pushVC(vc)
               
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}
