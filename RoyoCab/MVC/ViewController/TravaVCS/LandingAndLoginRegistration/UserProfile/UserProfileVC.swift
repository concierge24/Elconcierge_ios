//
//  UserProfileVC.swift
//  Buraq24
//
//  Created by MANINDER on 13/08/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import IBAnimatable

enum ENUM_GENDER:String{
    
    case male = "Male"
    case female = "Female"
    case other = "Other"
}




class UserProfileVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var textViewAddress: UITextView!
    @IBOutlet weak var btnOthers: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet var txtFieldFullName: UITextField!
    @IBOutlet var constraintBottomButton: NSLayoutConstraint!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var txfReferral: UITextField!
    
    @IBOutlet weak var stackViewGender: UIStackView!
    @IBOutlet weak var stackViewEmail: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var nationalIDStack: UIStackView!
    @IBOutlet weak var referalStack: UIStackView!
    @IBOutlet weak var txfNationalID: UITextField!
    @IBOutlet weak var btnOfficialIDFront: UIButton!
    @IBOutlet weak var btnOfficailIDBack: UIButton!
    @IBOutlet weak var btnRemoveOfficialIDBack: UIButton!
    @IBOutlet weak var btnRemoveOfficialIDFront: UIButton!
    @IBOutlet weak var btnAddressProofImage: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var officialImagesStack: UIStackView!
    @IBOutlet weak var addressProofImages: UIStackView!
    
    
    //MARK:- PROPERTIES
    var gender:String = "Male"
    var address:String?
    var firstName:String?
    var lastName:String?
    var email: String?
    var isaddress = true
    var loginDetail : LoginDetail?
    var nationalId : String?
    var isOfficialIDFrontImageAdded: Bool?
    var isOfficialIDBackImageAdded: Bool?
    var addressImages = [UIImage]()
    var officialIDRequire = false
    var addressProofImage = false
    

    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        addKeyBoardObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeKeyBoardObserver()
    }
    
    
    
    func setUpUI() {
        
        addressTableView.register(UINib(nibName: "UploadedDocCell", bundle: nil), forCellReuseIdentifier: "UploadedDocCell")
        
        addressTableView.delegate = self
        addressTableView.dataSource = self
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        imageView.setViewBackgroundColorTheme()
                
        textFieldFirstName.setPadding(10)
        textFieldFirstName.setBorderColorSecondary()
        textFieldFirstName.addShadowToTextFieldColorSecondary()
        textFieldFirstName.setAlignment()
        
        textFieldLastName.setPadding(10)
        textFieldLastName.setBorderColorSecondary()
        textFieldLastName.addShadowToTextFieldColorSecondary()
        textFieldLastName.setAlignment()
        
        txfReferral.setPadding(10)
        txfReferral.setBorderColorSecondary()
        txfReferral.addShadowToTextFieldColorSecondary()
        txfReferral.setAlignment()
        
        textFieldEmail.setPadding(10)
        textFieldEmail.setBorderColorSecondary()
        textFieldEmail.addShadowToTextFieldColorSecondary()
        textFieldEmail.setAlignment()
               
        textViewAddress.setBorderColorSecondary()
        textViewAddress.addShadowToTextViewColorSecondary()

        textViewAddress.setAlignment()
        
        lblSubtitle.setAlignment()
        
        txfReferral.placeholder = "UserProfileVC.ReferalCode".localizedString
        btnNext.setTitle("UserProfileVC.Submit".localizedString, for: .normal)
        lblSubtitle.text = "UserProfileVC.JustSomeMore".localizedString

        txfNationalID.setBorderColorSecondary()
        txfNationalID.addShadowToTextFieldColorSecondary()
        txfNationalID.setLeftPaddingPoints(10)
        
        
        if officialIDRequire {
            officialImagesStack.isHidden = false
        } else {
            officialImagesStack.isHidden = true
        }

        if addressProofImage {
            addressProofImages.isHidden = false
        } else {
            addressProofImages.isHidden = true
        }
        
        

        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            addressStack.isHidden = true
            break
            
        case .GoMove:
            lblSubtitle.text = "We are almost there!"
            lblOther.text = "Non binary"
            addressStack.isHidden = true
            isaddress = false
            break
            
        case .Corsa:
            referalStack.isHidden = true
            lblOther.text = "Prefer not to say".localizedString
            stackViewGender.axis = .vertical
            break
            
        default:
            nationalIDStack.isHidden = true
            addressStack.isHidden = false
        }
       
        
        btnFemale.setButtonWithTintColorSecondary()
        btnMale.setButtonWithTintColorSecondary()
        btnOthers.setButtonWithTintColorSecondary()
        
        stackViewGender.isHidden = UDSingleton.shared.appSettings?.registration_forum?.gender == "0"
       // stackViewEmail.isHidden = UDSingleton.shared.appSettings?.registration_forum?.email == "0"
        
        
        guard let formDetailArray = UDSingleton.shared.appSettings?.registration_forum?.form_details else { return }
        let form = formDetailArray.filter({/$0.key_name == "official_id_back_photo"}).first
        
        let  official_id_back_photo = /form?.required
        
        if official_id_back_photo == "0" {
            officialIDRequire = false
        } else {
            officialIDRequire = true
        }
        
        
        let form2 = formDetailArray.filter({/$0.key_name == "photo_proof_address"}).first
        let  photo_proof_address = /form2?.required
        
        if photo_proof_address == "0" {
            addressProofImage = false
        } else {
            addressProofImage = true
        }
        
    }
    
    //MARK:- ACTIONS
    
    //back aciton
    @IBAction func actionBtnBackPressed(_ sender: UIButton) {
       // self.popVC(to: LandingAndPhoneInputVC.self)
        self.navigationController?.popViewController(animated: true)
    }
    
    //next button
    @IBAction func actionBtnNextPressed(_ sender: UIButton) {
        
        let strName = /txtFieldFullName?.text?.trimmed()
        let firstName = /textFieldFirstName.text?.trimmed()
        let lastName = /textFieldLastName.text?.trimmed()
        let address = /textViewAddress.text?.trimmed()
        let email = /textFieldEmail.text?.trimmed()
        
        if Validations.sharedInstance.validateProfileSetup(firstName: firstName, lastName: lastName, address: isaddress ? address : "-", email: email, officialIDRequire: officialIDRequire,  isOfficialIDFrontImageAdded: /isOfficialIDFrontImageAdded, isOfficialIDBackImageAdded: /isOfficialIDBackImageAdded, addressProofImage: addressProofImage, addressImages: addressImages ) {
            
            if !stackViewEmail.isHidden {
               if Validations.sharedInstance.validateEmail(email: email) {
                    saveName(strName: strName)
                }
            } else {
                saveName(strName: strName)
            }
        }
    }
    
    //select gender action
    @IBAction func didSwitchGender(_ sender: UIButton) {
        
        btnMale.isSelected = sender == btnMale
        btnFemale.isSelected = sender == btnFemale
        btnOthers.isSelected = sender == btnOthers
        
        gender = btnMale.isSelected ? ENUM_GENDER.male.rawValue : btnFemale.isSelected ? ENUM_GENDER.female.rawValue : ENUM_GENDER.other.rawValue
    }
    
    @IBAction func btnActionAddPhotos(_ sender: UIButton) {
        
        switch sender {
        case btnOfficialIDFront:
            openPhotoOptionsActionSheet(buttonType: sender)
            break
            
        case btnOfficailIDBack:
            openPhotoOptionsActionSheet(buttonType: sender)
            break
            
        case btnRemoveOfficialIDFront:
            btnOfficialIDFront.setImage(#imageLiteral(resourceName: "ic_add_bg-g"), for: .normal)
            btnRemoveOfficialIDFront.isHidden = true
            isOfficialIDFrontImageAdded = false
            break
            
        case btnRemoveOfficialIDBack:
            btnOfficailIDBack.setImage(#imageLiteral(resourceName: "ic_add_bg-g"), for: .normal)
            btnRemoveOfficialIDBack.isHidden = true
            isOfficialIDBackImageAdded = false
            break
            
        case btnAddressProofImage:
            openPhotoOptionsActionSheet(buttonType: sender)
            break
            
        default:
            break
        }
        
    }
    
    
    
}

//MARK:- API

extension UserProfileVC {
    
    //api to update profile
    func openPhotoOptionsActionSheet(buttonType: UIButton) {
         self.view.endEditing(true)
        
        
        CameraImage.shared.captureImage(from: self, At: self , mediaType: nil, captureOptions: [.camera, .photoLibrary], allowEditting: true) { [unowned self] (image) in
            guard let img = image else { return }
                   
            switch buttonType {
                case self.btnOfficialIDFront:
                    self.btnOfficialIDFront.setImage(img, for: .normal)
                    self.btnRemoveOfficialIDFront.isHidden = false
                    self.isOfficialIDFrontImageAdded = true
                    break
                   
                case self.btnOfficailIDBack:
                    self.btnOfficailIDBack.setImage(img, for: .normal)
                    self.btnRemoveOfficialIDBack.isHidden = false
                    self.isOfficialIDBackImageAdded = true
                    break
                
                case self.btnAddressProofImage:
                    self.addressImages.append(img)
                    self.tableHeightConstraint.constant = CGFloat(84 * /self.addressImages.count)
                    self.addressTableView.reloadData()
                    break
                   
               default:
                   break
               }
            }
        }
    
    
    func saveName(strName : String) {
        
        self.view.endEditing(true)
        self.address = textViewAddress.text
        self.firstName = textFieldFirstName.text
        self.lastName = textFieldLastName.text
        self.email = textFieldEmail.text
        self.nationalId = txfNationalID.text
        
        let objR = LoginEndpoint.addName(name: [self.firstName!,self.lastName!].joined(separator: " "), firstName: self.firstName, lastName: self.lastName, gender: self.gender, address: self.address, email: self.email, referral_code: txfReferral.text, nationalId: self.nationalId)
        
        objR.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" : /loginDetail?.userDetails?.accessToken, "secretdbkey": APIBasePath.secretDBKey ]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? UserDetail else { return }
                self?.loginDetail?.userDetails = model
                self?.saveUserInfo()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message:/strError , type: .error )
            }
        }
    }
    
    
    func saveUserInfo() {
        
        UDSingleton.shared.userData = self.loginDetail
        
        //        guard let vc = R.storyboard.main.selectMainCategoryViewController() else {return}
        //        pushVC(vc)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.setHomeAsRootVC()
    }
}

//MARK:- Common functions

extension UserProfileVC {
    
    func addKeyBoardObserver() {
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillhide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyBoardObserver() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateBottomView(true, height: keyboardHeight)
        }
    }
    
    @objc func keyboardWillhide(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateBottomView(false, height: keyboardHeight)
        }
    }
    
    
    func animateBottomView(_ isToShown : Bool , height : CGFloat) {
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            if isToShown {
                self?.constraintBottomButton?.constant = (height + CGFloat(20))
            }else {
                self?.constraintBottomButton?.constant =  CGFloat(40)
            }
            self?.view.layoutIfNeeded()
        }
    }
    
}

extension UserProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadedDocCell", for: indexPath) as! UploadedDocTableViewCell
        cell.uploadedImageView.image = addressImages[indexPath.row]
        cell.fileNameLabel.text = "Address Image\(indexPath.row + 1)"
        return cell
    }
    
    
}
