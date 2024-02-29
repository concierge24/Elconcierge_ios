//
//  EditProfileVC.swift
//  Buraq24
//
//  Created by MANINDER on 11/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class EditProfileVC: BaseVCCab {
    
    //MARK:- Outlets
    @IBOutlet var imgViewUser: UIImageView!
    @IBOutlet var txtFieldFullName: UITextField!
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textfieldPhoneNumber: UITextField!
    
    @IBOutlet weak var iconVerifyEmail: UIImageView!
    @IBOutlet weak var iconVerifyPhone: UIImageView!
    
    @IBOutlet weak var btnChnage: UIButton!
    @IBOutlet var imgViewCountryCode: UIImageView!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    
    //MARK:- Properties
    var imageToChange : UIImage?
    var ISO: String?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        assignPreviousData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } */
    
    //MARK:- Actions
    
    @IBAction func actionBtnEditProfile(_ sender: UIButton) {
        self.view.endEditing(true)
        let strName = /txtFieldFullName.text?.trimmed()
        
        if Validations.sharedInstance.validateUserName(userName: strName) && Validations.sharedInstance.validateEmail(email: /textFieldEmail.text) {
            editProfile(strName: strName)
        }
    }
    
    @IBAction func actionBtnChangeProfilePressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        CameraImage.shared.captureImage(from: self, At: self.imgViewUser, mediaType: nil, captureOptions: [.camera, .photoLibrary], allowEditting: true) { [unowned self] (image) in
            
            guard let img = image else { return }
            self.imgViewUser.image = img
            self.imageToChange = img
            
        }
    }
    
    
    @IBAction func actionBtnCountryCode(_ sender: UIButton) {
        
        guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
        countryPicker.delegate = self
        self.presentVC(countryPicker)
    }
    
    //MARK:- Functions
    
    private func setUpUI() {
        
        view.layoutIfNeeded()
        self.txtFieldFullName.setAlignment()
        
        buttonSave.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnChnage.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
    }
    
    func assignPreviousData() {
        
        guard let user = UDSingleton.shared.userData?.userDetails?.user else{return}
        txtFieldFullName.text = user.name
        textFieldEmail.text = user.email
        textfieldPhoneNumber.text = String(/user.phoneNumber)
        
        lblCountryCode.text = user.countryCode
        ISO = user.iso
        
        imgViewCountryCode.image = UIImage(named: /ISO?.lowercased())
        
        if let urlImage = UDSingleton.shared.userData?.userDetails?.profilePic {
            imgViewUser.sd_setImage(with: URL(string : urlImage), placeholderImage: #imageLiteral(resourceName: "ic_user"), options: .refreshCached, progress: nil, completed: nil)
        }
    }
}

//MARK:- API
extension EditProfileVC {
    
    func editProfile(strName : String) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let objEdit = LoginEndpoint.editProfile(name: strName, email: textFieldEmail.text?.trimmed(), phone_code: lblCountryCode.text, phone_number: textfieldPhoneNumber.text?.trimmed(), iso: ISO)
        objEdit.request(isImage: true, images: [imageToChange], isLoaderNeeded: true, header: ["access_token" :  token]) {[weak self] (response) in
            switch response {
            case .success(let data):
                
                guard let updatedUser = data as? UserDetail else{return}
                
                if let userData = UDSingleton.shared.userData {
                    userData.userDetails = updatedUser
                    UDSingleton.shared.userData = userData
                    
                    self?.assignPreviousData()
                    
                }
                self?.alertBoxOk(message:"profile_updated_successfully".localizedString , title: "AppName".localizedString, ok: {
                     self?.popVC()
                    
                    let vc = self?.navigationController?.viewControllers.filter({$0 is HomeVC}).first
                    (vc as? HomeVC)?.viewSelectService.labelName.text = "Hi ".localizedString + /UDSingleton.shared.userData?.userDetails?.user?.name
                })
               
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}


//MARK: - Country Picker Delegates

extension EditProfileVC: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        ISO = /(detail["code"] as? String)

        imgViewCountryCode.image = UIImage(named: /ISO?.lowercased())
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
    }
    
    func didSuccessOnOtpVerification(){
        
    }
    
    
}
