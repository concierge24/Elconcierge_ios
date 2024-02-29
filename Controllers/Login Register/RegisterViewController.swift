//
//  RegisterViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import EZSwiftExtensions

class RegisterViewController: LoginRegisterBaseViewController {
    
    var user : User?
    weak var delegate : LoginViewControllerDelegate?
    var appleLogin = false
    @IBOutlet var tfEmail: TextField!
    
    //MARK:- IBOutlet
    @IBOutlet var btnFinish: Button!{
        didSet{
            self.btnFinish.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnFinish.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var btnProfilePic: Button!
    
    @IBOutlet weak var imageViewProfilePic: UIImageView!{
        didSet{
            imageViewProfilePic.layer.cornerRadius = 3.0
        }
    }
    @IBOutlet weak var tfName: TextField!{
        didSet{
            tfName.setThemeTextField()
//            tfName.textColor = TextFieldTheme.shared.txtFldThemeColor
//            tfName.dividerColor = TextFieldTheme.shared.txtDividerColor
        }
    }
    
    @IBAction func passwordChangedAction(_ sender: UITextField) {
        if  (/sender.text).trimmingCharacters(in: NSCharacterSet.whitespaces).count == 0 {
            sender.text = nil
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tfName?.text = GDataSingleton.sharedInstance.loggedInUser?.firstName
        
        imageViewProfilePic.loadImage(thumbnail: GDataSingleton.sharedInstance.loggedInUser?.userImage, original: nil, placeHolder: Asset.ic_dummy_user.image)
        btnProfilePic.setImage(nil, for: .normal)
        
        tfEmail.isHidden = true
        if appleLogin {
            tfEmail.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
}


//MARK: - Button Actions
import Adjust
extension  RegisterViewController{
    
    @IBAction func actionFinishSignUp(sender: AnyObject) {
        
        let message = validateCredentials()
        if message.isEmpty {

            APIManager.sharedInstance.showLoader()
            let objR = API.RegisterLastStep(FormatAPIParameters.RegisterLastStep(accessToken : user?.token, name: tfName.text ?? "", email: appleLogin ? (tfEmail.text ?? "") : nil).formatParameters())
            APIManager.sharedInstance.opertationWithRequest(withApi: objR, image: imageViewProfilePic.image?.resizeWith(width: 200, height: 200)) {
                [weak self] (response) in
                APIManager.sharedInstance.hideLoader()
                guard let `self` = self else { return }
                switch response {
                case .Success(let object):
                    
                    let userNew = object as? User
                    userNew?.fbId = self.user?.fbId
                    GDataSingleton.sharedInstance.loggedInUser = userNew

                    AdjustEvent.SignUp.sendEvent()
                    ez.runThisInMainThread({
                        var VC = self.presentingViewController
                        while ((VC?.presentingViewController) != nil) {
                            VC = VC?.presentingViewController
                        }
                        if  let vc = VC?.presentingViewController as? SignupSelectionVC {
                            (UIApplication.shared.delegate as? AppDelegate)?.userSuccessfullyLoggedIn(withUser: nil)
                            GDataSingleton.isProfilePicDone = true
                            if let presentingVC = vc.presentingViewController {
                                presentingVC.dismissVC(completion: nil)
                            }
                            else {
                                vc.dismissVC(completion: nil)
                            }
                        }
                        else if VC is LoginViewController && VC?.presentingViewController == nil {
                            (UIApplication.shared.delegate as? AppDelegate)?.userSuccessfullyLoggedIn(withUser: nil)
                            GDataSingleton.isProfilePicDone = true
                            VC?.dismissVC{}
                        }
                        else {
                            self.delegate?.userSuccessfullyLoggedIn(withUser: nil)
                            GDataSingleton.isProfilePicDone = true
                            VC?.dismissVC{}
                        }
                    })
                default:
                    break
                }
            }
        }else {
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionAddDP(sender: UIButton) {
        
        if UtilityFunctions.isCameraPermission() {
        UtilityFunctions.showActionSheet(withTitle: nil, subTitle: L10n.SelectPicture.string, vc: self, senders: [L10n.Camera.string,L10n.PhotoLibrary.string]) { (text, index) in
            
            CameraGalleryPickerBlock.sharedInstance.pickerImage(type: text as! String, presentInVc: self, pickedListner: {[weak self] (image) in
                self?.imageViewProfilePic.image = image
                sender.setImage(nil, for: .normal)
            }) {
                
                //Cancelled
            }
        }
        }else {
            UtilityFunctions.alertToEncourageCameraAccessWhenApplicationStarts(viewController: self)
        }
    }
    
}

extension RegisterViewController {
    
    func validateCredentials() -> String{
        guard let name = tfName.text, name.trim().count != 0 else {
            
            return L10n.PleaseEnterYourName.string
        }
        guard let _ = imageViewProfilePic.image else {
            return L10n.PleaseSelectYourProfilePicture.string
        }
        if appleLogin {
            guard let email = tfEmail.text, name.trim().count != 0 else {
                
                return L10n.PleaseEnterYourEmailAddress.string
            }
            if !Register.isValidEmail(testStr: email){
                return L10n.PleaseEnterAValidEmailAddress.string
            }
        }
        
        return ""
    }
}

